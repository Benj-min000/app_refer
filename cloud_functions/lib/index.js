"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.saveFcmToken = exports.onRiderLocationUpdate = exports.onDispatchJobAccepted = exports.stripeWebhook = exports.createPaymentIntent = void 0;
// cloud_functions/src/index.ts
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const stripe_1 = require("stripe");
const axios_1 = require("axios");
admin.initializeApp();
const db = admin.firestore();
const stripe = new stripe_1.default(functions.config().stripe?.secret_key || "dummy_stripe_key", {
    apiVersion: "2023-10-16",
});
const GOOGLE_MAPS_KEY = functions.config().googlemaps?.key || "dummy_maps_key";
// ─────────────────────────────────────────────────────────────────────────────
// HELPER: Haversine distance (km)
// ─────────────────────────────────────────────────────────────────────────────
function haversineKm(lat1, lng1, lat2, lng2) {
    const R = 6371;
    const dLat = ((lat2 - lat1) * Math.PI) / 180;
    const dLng = ((lng2 - lng1) * Math.PI) / 180;
    const a = Math.sin(dLat / 2) ** 2 +
        Math.cos((lat1 * Math.PI) / 180) *
            Math.cos((lat2 * Math.PI) / 180) *
            Math.sin(dLng / 2) ** 2;
    return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}
// ─────────────────────────────────────────────────────────────────────────────
// HELPER: Google Directions API → returns { durationSeconds, polyline }
// Called server-side so API key is never exposed to client
// ─────────────────────────────────────────────────────────────────────────────
async function getDirections(fromLat, fromLng, toLat, toLng, mode = "driving") {
    try {
        const url = "https://maps.googleapis.com/maps/api/directions/json";
        const { data } = await axios_1.default.get(url, {
            params: {
                origin: `${fromLat},${fromLng}`,
                destination: `${toLat},${toLng}`,
                mode,
                key: GOOGLE_MAPS_KEY,
            },
        });
        if (data.status !== "OK")
            return null;
        const leg = data.routes[0].legs[0];
        return {
            durationSeconds: leg.duration.value,
            polyline: data.routes[0].overview_polyline.points, // encoded polyline
        };
    }
    catch {
        return null;
    }
}
// ─────────────────────────────────────────────────────────────────────────────
// 1. createPaymentIntent
//    User app calls this at checkout → gets clientSecret for Stripe SDK
//    Amount always comes from the server-side quote (never the client)
// ─────────────────────────────────────────────────────────────────────────────
exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "Login required");
    }
    const { quoteId } = data;
    if (!quoteId) {
        throw new functions.https.HttpsError("invalid-argument", "quoteId required");
    }
    const quoteDoc = await db.collection("quotes").doc(quoteId).get();
    if (!quoteDoc.exists) {
        throw new functions.https.HttpsError("not-found", "Quote not found");
    }
    const quote = quoteDoc.data();
    if (quote.userId !== context.auth.uid) {
        throw new functions.https.HttpsError("permission-denied", "Not your quote");
    }
    if (quote.expiresAt.toDate() < new Date()) {
        throw new functions.https.HttpsError("failed-precondition", "Quote expired, refresh cart");
    }
    // Convert PLN to grosze (like cents): 12.50 zł → 1250
    const amountGrosze = Math.round(quote.finalTotal * 100);
    const paymentIntent = await stripe.paymentIntents.create({
        amount: amountGrosze,
        currency: "pln",
        metadata: {
            quoteId,
            userId: context.auth.uid,
            storeId: quote.storeId,
        },
        automatic_payment_methods: { enabled: true },
    });
    // Save PI id so webhook can find this quote
    await db.collection("quotes").doc(quoteId).update({
        stripePaymentIntentId: paymentIntent.id,
        paymentStatus: "PENDING",
    });
    return {
        clientSecret: paymentIntent.client_secret,
        publishableKey: functions.config().stripe.publishable_key,
    };
});
// ─────────────────────────────────────────────────────────────────────────────
// 2. stripeWebhook
//    Stripe calls this when payment succeeds.
//    Creates order + delivery docs, then dispatches to a rider.
// ─────────────────────────────────────────────────────────────────────────────
exports.stripeWebhook = functions.region('europe-west1').https.onRequest(async (req, res) => {
    const sig = req.headers["stripe-signature"];
    let event;
    try {
        event = stripe.webhooks.constructEvent(req.rawBody, sig, functions.config().stripe.webhook_secret);
    }
    catch (err) {
        console.error("Webhook signature failed:", err);
        res.status(400).send("Invalid signature");
        return;
    }
    if (event.type === "payment_intent.succeeded") {
        const pi = event.data.object;
        await handlePaymentSuccess(pi);
    }
    res.json({ received: true });
});
async function handlePaymentSuccess(pi) {
    const { quoteId, userId, storeId } = pi.metadata;
    // Idempotency guard
    const existing = await db
        .collection("orders")
        .where("stripePaymentIntentId", "==", pi.id)
        .limit(1)
        .get();
    if (!existing.empty) {
        console.log("Order already created for PI:", pi.id);
        return;
    }
    const [quoteDoc, userDoc, storeDoc] = await Promise.all([
        db.collection("quotes").doc(quoteId).get(),
        db.collection("users").doc(userId).get(),
        db.collection("restaurants").doc(storeId).get(),
    ]);
    if (!quoteDoc.exists)
        return;
    const quote = quoteDoc.data();
    const user = userDoc.data();
    const store = storeDoc.data();
    const batch = db.batch();
    // ── Order ──────────────────────────────────────────────────────────────
    const orderRef = db.collection("orders").doc();
    batch.set(orderRef, {
        storeId,
        storeName: store.name ?? "",
        storePhone: store.phone ?? null,
        storeAddress: store.address ?? null,
        customerId: userId,
        customerName: user.name ?? "",
        customerPhone: user.phone ?? null,
        deliveryAddress: quote.deliveryAddress,
        status: "CONFIRMED",
        items: quote.items, // [{name, quantity, price, options}]
        totalAmount: quote.itemsTotal,
        deliveryFee: quote.deliveryFee,
        discounts: quote.discounts ?? [],
        finalTotal: quote.finalTotal,
        riderNote: quote.riderNote ?? null,
        storeNote: quote.storeNote ?? null,
        cutleryRequested: quote.cutleryRequested ?? false,
        paymentMethod: "CARD",
        stripePaymentIntentId: pi.id,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    // ── Delivery ────────────────────────────────────────────────────────────
    const deliveryRef = db.collection("deliveries").doc();
    batch.set(deliveryRef, {
        orderId: orderRef.id,
        storeId,
        customerId: userId,
        riderId: null,
        status: "ASSIGNING",
        routePhase: "TO_PICKUP",
        pickup: { lat: store.location?.lat ?? 0, lng: store.location?.lng ?? 0 },
        dropoff: { lat: quote.dropoffLat ?? 0, lng: quote.dropoffLng ?? 0 },
        storeAddress: store.address ?? "",
        customerAddress: quote.deliveryAddress ?? "",
        riderLocation: null,
        eta: null,
        route: null, // will be populated by onRiderLocationUpdate
        trackingEnabled: true,
        lastUpdateAt: admin.firestore.FieldValue.serverTimestamp(),
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    // Link delivery → order
    batch.update(orderRef, { deliveryId: deliveryRef.id });
    // Mark quote as used
    batch.update(db.collection("quotes").doc(quoteId), {
        status: "USED",
        orderId: orderRef.id,
        paymentStatus: "PAID",
    });
    await batch.commit();
    // Notify store
    await notifyStore(storeId, orderRef.id, orderRef.id);
    // Find rider and dispatch
    await dispatchToRider(orderRef.id, deliveryRef.id, {
        ...orderRef,
        storeName: store.name,
        storeAddress: store.address,
        deliveryAddress: quote.deliveryAddress,
        customerName: user.name,
        items: quote.items,
        finalTotal: quote.finalTotal,
        deliveryFee: quote.deliveryFee,
        pickup: { lat: store.location?.lat ?? 0, lng: store.location?.lng ?? 0 },
        dropoff: { lat: quote.dropoffLat ?? 0, lng: quote.dropoffLng ?? 0 },
    });
}
// ─────────────────────────────────────────────────────────────────────────────
// 3. dispatchToRider — find online rider, create dispatch_job, send FCM
// ─────────────────────────────────────────────────────────────────────────────
async function dispatchToRider(orderId, deliveryId, order) {
    const ridersSnap = await db
        .collection("riders")
        .where("isOnline", "==", true)
        .where("hasActiveDelivery", "==", false)
        .limit(10)
        .get();
    if (ridersSnap.empty) {
        console.warn("No riders available for:", orderId);
        return;
    }
    // MVP: pick first available rider
    // V2: sort by distance to store using riderLocation field
    const riderDoc = ridersSnap.docs[0];
    const rider = riderDoc.data();
    const distanceKm = haversineKm(order.pickup.lat, order.pickup.lng, order.dropoff.lat, order.dropoff.lng);
    const riderEarnings = parseFloat(Math.max(3.5, (order.deliveryFee ?? 5) * 0.75).toFixed(2));
    // dispatch_job doc — rider app queries this in real time
    const jobRef = db.collection("dispatch_jobs").doc();
    await jobRef.set({
        riderId: riderDoc.id,
        deliveryId,
        orderId,
        // ── What rider sees in the job request sheet ──
        storeName: order.storeName ?? "",
        storeAddress: order.storeAddress ?? "",
        customerAddress: order.deliveryAddress ?? "",
        customerName: order.customerName ?? "",
        items: order.items ?? [], // menu items list
        finalTotal: order.finalTotal ?? 0,
        paymentMethod: "CARD",
        distanceKm: Math.round(distanceKm * 10) / 10,
        riderEarnings,
        status: "PENDING",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        expiresAt: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 30000) // 30s window
        ),
    });
    // FCM push notification to rider
    if (rider.fcmToken) {
        await admin.messaging().send({
            token: rider.fcmToken,
            notification: {
                title: "🛵 New Delivery!",
                body: `${order.storeName} → ${order.deliveryAddress} · zł${riderEarnings}`,
            },
            data: {
                type: "DISPATCH_JOB",
                jobId: jobRef.id,
                deliveryId,
                orderId,
            },
            android: { priority: "high" },
            apns: { payload: { aps: { sound: "default", badge: 1 } } },
        });
    }
}
// ─────────────────────────────────────────────────────────────────────────────
// 4. onDispatchJobAccepted
//    Firestore trigger: rider sets dispatch_jobs/{id}.status = ACCEPTED
//    → links rider to delivery, notifies customer
// ─────────────────────────────────────────────────────────────────────────────
exports.onDispatchJobAccepted = functions.firestore
    .document("dispatch_jobs/{jobId}")
    .onUpdate(async (change) => {
    const before = change.before.data();
    const after = change.after.data();
    if (before.status === after.status)
        return;
    if (after.status !== "ACCEPTED")
        return;
    const { riderId, deliveryId, orderId } = after;
    const batch = db.batch();
    batch.update(db.collection("deliveries").doc(deliveryId), {
        riderId,
        status: "ASSIGNED",
        routePhase: "TO_PICKUP",
        lastUpdateAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    batch.update(db.collection("riders").doc(riderId), {
        hasActiveDelivery: true,
        currentDeliveryId: deliveryId,
    });
    await batch.commit();
    // Notify customer: rider is coming
    const orderDoc = await db.collection("orders").doc(orderId).get();
    const order = orderDoc.data();
    const userDoc = await db.collection("users").doc(order.customerId).get();
    const user = userDoc.data();
    if (user.fcmToken) {
        await admin.messaging().send({
            token: user.fcmToken,
            notification: {
                title: "Rider assigned! 🛵",
                body: "Your rider is heading to the restaurant.",
            },
            data: { type: "RIDER_ASSIGNED", orderId, deliveryId },
        });
    }
});
// ─────────────────────────────────────────────────────────────────────────────
// 5. onRiderLocationUpdate
//    Firestore trigger: rider writes new GPS position
//    → calls Google Directions API → updates ETA + encoded polyline
//    Rider app reads these back and draws the route on the map
// ─────────────────────────────────────────────────────────────────────────────
exports.onRiderLocationUpdate = functions.firestore
    .document("deliveries/{deliveryId}")
    .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    // Only run when riderLocation actually changed
    const locBefore = before.riderLocation;
    const locAfter = after.riderLocation;
    if (!locAfter)
        return;
    if (locBefore?.updatedAt?.isEqual(locAfter?.updatedAt))
        return;
    // Don't run if tracking disabled or delivery complete
    if (!after.trackingEnabled)
        return;
    if (["DELIVERED", "CANCELED"].includes(after.status))
        return;
    const { deliveryId } = context.params;
    const riderLat = locAfter.lat;
    const riderLng = locAfter.lng;
    // Target depends on current phase
    const isToPickup = after.routePhase === "TO_PICKUP";
    const target = isToPickup ? after.pickup : after.dropoff;
    // Call Google Directions API (server-side — key never exposed)
    const directions = await getDirections(riderLat, riderLng, target.lat, target.lng, "driving");
    if (!directions)
        return;
    const durationMinutes = Math.ceil(directions.durationSeconds / 60);
    const bufferMin = isToPickup ? 2 : 3; // extra buffer for pickup vs dropoff
    const minMinutes = Math.max(1, durationMinutes - 1);
    const maxMinutes = durationMinutes + bufferMin;
    await db.collection("deliveries").doc(deliveryId).update({
        eta: {
            minMinutes,
            maxMinutes,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            source: "GOOGLE_DIRECTIONS",
        },
        // Encoded polyline — rider app decodes and draws on Google Maps
        "route.encodedPolyline": directions.polyline,
        "route.phase": after.routePhase,
        "route.updatedAt": admin.firestore.FieldValue.serverTimestamp(),
    });
});
// ─────────────────────────────────────────────────────────────────────────────
// 6. saveFcmToken
//    Rider app calls this on launch to register its FCM token
// ─────────────────────────────────────────────────────────────────────────────
exports.saveFcmToken = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("unauthenticated", "Login required");
    }
    const { token } = data;
    if (!token) {
        throw new functions.https.HttpsError("invalid-argument", "token required");
    }
    await db.collection("riders").doc(context.auth.uid).update({
        fcmToken: token,
        fcmUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    return { success: true };
});
// ─────────────────────────────────────────────────────────────────────────────
// HELPER: Notify store of new order
// ─────────────────────────────────────────────────────────────────────────────
async function notifyStore(storeId, orderId, _orderRef) {
    const storeDoc = await db.collection("restaurants").doc(storeId).get();
    const store = storeDoc.data();
    if (store?.fcmToken) {
        await admin.messaging().send({
            token: store.fcmToken,
            notification: {
                title: "🔔 New Order!",
                body: `Order #${orderId.slice(0, 8)} received`,
            },
            data: { type: "NEW_ORDER", orderId },
            android: { priority: "high" },
        });
    }
}
//# sourceMappingURL=index.js.map