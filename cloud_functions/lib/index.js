"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.savefcmtoken = exports.placecashorder = exports.onriderlocationupdate = exports.onorderstatuschanged = exports.restaurantmarkorderready = exports.ondispatchjobaccepted = exports.stripewebhook = exports.createpaymentintent = void 0;
const https_1 = require("firebase-functions/v2/https");
const firestore_1 = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const stripe_1 = require("stripe");
const axios_1 = require("axios");
const path = require("path");
const fs = require("fs");
admin.initializeApp();
const db = admin.firestore();
function loadSecrets() {
    const secretsPath = path.join(__dirname, "..", "secrets.json");
    if (!fs.existsSync(secretsPath)) {
        throw new Error("secrets.json not found at " + secretsPath);
    }
    return JSON.parse(fs.readFileSync(secretsPath, "utf-8"));
}
const secrets = loadSecrets();
const stripe = new stripe_1.default(secrets.STRIPE_SECRET_KEY, { apiVersion: "2023-10-16" });
const GOOGLE_MAPS_KEY = secrets.MAPS_API_KEY || secrets.GOOGLE || "";
const STRIPE_PUBLISHABLE_KEY = secrets.STRIPE_PUBLISHABLE_KEY;
const STRIPE_WEBHOOK_SECRET = secrets.STRIPE_WEBHOOK_SECRET ?? "";
// ── Helpers ──────────────────────────────────────────────────────────────────
async function getDirections(fromLat, fromLng, toLat, toLng) {
    try {
        const { data } = await axios_1.default.get("https://maps.googleapis.com/maps/api/directions/json", {
            params: { origin: `${fromLat},${fromLng}`, destination: `${toLat},${toLng}`, mode: "driving", key: GOOGLE_MAPS_KEY },
        });
        return data.status === "OK" ? { durationSeconds: data.routes[0].legs[0].duration.value, polyline: data.routes[0].overview_polyline.points } : null;
    }
    catch {
        return null;
    }
}
async function writeNotification(uid, title, body, source) {
    await db.collection("users").doc(uid).collection("notifications").add({
        title, body, source, isRead: false, createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
}
// ── 1. createPaymentIntent ──────────────────────────────────────────────────
exports.createpaymentintent = (0, https_1.onCall)({ region: "europe-west1" }, async (request) => {
    if (!request.auth)
        throw new https_1.HttpsError("unauthenticated", "Login required");
    const { quoteId } = request.data;
    const quoteDoc = await db.collection("quotes").doc(quoteId).get();
    if (!quoteDoc.exists)
        throw new https_1.HttpsError("not-found", "Quote not found");
    const quote = quoteDoc.data();
    const paymentIntent = await stripe.paymentIntents.create({
        amount: Math.round(quote.finalTotal * 100),
        currency: "pln",
        metadata: { quoteId, userId: request.auth.uid, restaurantID: quote.restaurantID },
        automatic_payment_methods: { enabled: true },
    });
    await db.collection("quotes").doc(quoteId).update({ stripePaymentIntentId: paymentIntent.id, paymentStatus: "PENDING" });
    return { clientSecret: paymentIntent.client_secret, publishableKey: STRIPE_PUBLISHABLE_KEY };
});
// ── 2. stripeWebhook (Enhanced for Rider Pop-up) ───────────────────────────
exports.stripewebhook = (0, https_1.onRequest)({ region: "europe-west1" }, async (req, res) => {
    const sig = req.headers["stripe-signature"];
    let event;
    try {
        event = stripe.webhooks.constructEvent(req.rawBody, sig, STRIPE_WEBHOOK_SECRET);
    }
    catch (err) {
        res.status(400).send("Invalid signature");
        return;
    }
    if (event.type === "payment_intent.succeeded") {
        const pi = event.data.object;
        const { quoteId, userId, restaurantID } = pi.metadata;
        const [quoteDoc, userDoc, restaurantDoc] = await Promise.all([
            db.collection("quotes").doc(quoteId).get(),
            db.collection("users").doc(userId).get(),
            db.collection("restaurants").doc(restaurantID).get(),
        ]);
        if (quoteDoc?.exists && restaurantDoc?.exists) {
            const quote = quoteDoc.data();
            const restaurant = restaurantDoc.data();
            const orderID = db.collection("orders").doc().id;
            const orderData = {
                orderID, userID: userId, restaurantID, restaurantName: restaurant.name ?? "",
                restaurantLat: restaurant.lat ?? null, restaurantLng: restaurant.lng ?? null,
                itemIDs: quote.itemIDs ?? [], address: quote.address ?? {}, orderType: quote.orderType ?? "delivery",
                paymentMethod: "stripe", totalAmount: String(quote.finalTotal ?? "0.00"), status: "Pending",
                orderTime: admin.firestore.FieldValue.serverTimestamp(), stripePaymentIntentId: pi.id,
            };
            const batch = db.batch();
            batch.set(db.collection("orders").doc(orderID), orderData);
            batch.set(db.collection("users").doc(userId).collection("orders").doc(orderID), orderData);
            batch.update(db.collection("quotes").doc(quoteId), { status: "USED", orderID, paymentStatus: "PAID" });
            await batch.commit();
            await writeNotification(userId, "Order Placed! 🎉", `Order from ${restaurant.name} received.`, "order");
            // DISPATCH TRIGGER: Send full data so the Rider App can show the job sheet
            const ridersSnap = await db.collection("riders")
                .where("isOnline", "==", true)
                .where("hasActiveOrder", "==", false)
                .limit(1)
                .get();
            if (!ridersSnap.empty) {
                const riderDoc = ridersSnap.docs[0];
                const riderId = riderDoc.id;
                const riderData = riderDoc.data();
                const jobRef = await db.collection("dispatch_jobs").add({
                    riderId,
                    orderID,
                    status: "pending",
                    restaurantName: restaurant.name ?? "",
                    restaurantAddress: restaurant.address ?? "",
                    customerName: userDoc.data()?.name ?? "Customer",
                    customerAddress: quote.address?.fullAddress ?? "",
                    totalAmount: quote.finalTotal ?? 0,
                    deliveryFee: quote.deliveryFee ?? 0,
                    orderType: quote.orderType ?? "delivery",
                    paymentMethod: "stripe",
                    items: quote.items ?? [],
                    createdAt: admin.firestore.FieldValue.serverTimestamp(),
                });
                if (riderData.fcmToken) {
                    await admin.messaging().send({
                        token: riderData.fcmToken,
                        notification: {
                            title: "New Delivery Request",
                            body: restaurant.name ?? "",
                        },
                        data: {
                            type: "DISPATCH_JOB",
                            jobId: jobRef.id,
                            orderID,
                        },
                    });
                }
            }
        }
    }
    res.json({ received: true });
});
// ── 3. onDispatchJobAccepted ────────────────────────────────────────────────
exports.ondispatchjobaccepted = (0, firestore_1.onDocumentUpdated)({ region: "europe-west1", document: "dispatch_jobs/{jobId}" }, async (event) => {
    const after = event.data?.after.data();
    const before = event.data?.before.data();
    if (!after || before?.status === after.status || after.status !== "accepted")
        return;
    const orderDoc = await db.collection("orders").doc(after.orderID).get();
    if (!orderDoc.exists)
        return;
    const update = { status: "In Progress", driverUID: after.riderId, updatedAt: admin.firestore.FieldValue.serverTimestamp() };
    const batch = db.batch();
    batch.update(db.collection("orders").doc(after.orderID), update);
    batch.update(db.collection("users").doc(orderDoc.data().userID).collection("orders").doc(after.orderID), update);
    batch.update(db.collection("riders").doc(after.riderId), { hasActiveOrder: true, currentOrderID: after.orderID });
    await batch.commit();
});
// ── 4. restaurantMarkOrderReady (New - Enables the Pickup button) ───────────
exports.restaurantmarkorderready = (0, https_1.onCall)({ region: "europe-west1" }, async (request) => {
    if (!request.auth)
        throw new https_1.HttpsError("unauthenticated", "Login required");
    const { orderID } = request.data;
    const orderRef = db.collection("orders").doc(orderID);
    const orderDoc = await orderRef.get();
    if (!orderDoc.exists)
        throw new https_1.HttpsError("not-found", "Order not found");
    const orderData = orderDoc.data();
    const update = { status: "Ready", updatedAt: admin.firestore.FieldValue.serverTimestamp() };
    const batch = db.batch();
    batch.update(orderRef, update);
    batch.update(db.collection("users").doc(orderData.userID).collection("orders").doc(orderID), update);
    await batch.commit();
    return { success: true };
});
// ── 5. onOrderStatusChanged ────────────────────────────────────────────────
exports.onorderstatuschanged = (0, firestore_1.onDocumentUpdated)({ region: "europe-west1", document: "orders/{orderID}" }, async (event) => {
    const after = event.data?.after.data();
    if (!after || event.data?.before.data().status === after.status)
        return;
    if (after.status === "Delivered" && after.driverUID) {
        await db.collection("riders").doc(after.driverUID).update({ hasActiveOrder: false, currentOrderID: null });
    }
});
// ── 6. onRiderLocationUpdate (Adaptive ETA) ─────────────────────────────────
exports.onriderlocationupdate = (0, firestore_1.onDocumentUpdated)({ region: "europe-west1", document: "riders/{riderUID}" }, async (event) => {
    const after = event.data?.after.data();
    if (!after?.location || !after.hasActiveOrder || !after.currentOrderID)
        return;
    const orderDoc = await db.collection("orders").doc(after.currentOrderID).get();
    if (!orderDoc.exists)
        return;
    const order = orderDoc.data();
    // If 'In Progress', calculate time to Restaurant. If 'Ready', calculate to Customer.
    const targetLat = order.status === "In Progress" ? order.restaurantLat : parseFloat(order.address?.lat || "0");
    const targetLng = order.status === "In Progress" ? order.restaurantLng : parseFloat(order.address?.lng || "0");
    const directions = await getDirections(after.location.lat, after.location.lng, targetLat, targetLng);
    if (directions) {
        await db.collection("orders").doc(after.currentOrderID).update({
            eta: { minMinutes: Math.max(1, Math.ceil(directions.durationSeconds / 60) - 1), updatedAt: admin.firestore.FieldValue.serverTimestamp() }
        });
    }
});
exports.placecashorder = (0, https_1.onCall)({ region: "europe-west1" }, async (request) => {
    if (!request.auth) {
        throw new https_1.HttpsError("unauthenticated", "Login required");
    }
    const { quoteId } = request.data;
    const quoteDoc = await db.collection("quotes").doc(quoteId).get();
    if (!quoteDoc.exists) {
        throw new https_1.HttpsError("not-found", "Quote not found");
    }
    const quote = quoteDoc.data();
    const userId = request.auth.uid;
    const restaurantDoc = await db.collection("restaurants")
        .doc(quote.restaurantID)
        .get();
    if (!restaurantDoc.exists) {
        throw new https_1.HttpsError("not-found", "Restaurant not found");
    }
    const restaurant = restaurantDoc.data();
    const orderID = db.collection("orders").doc().id;
    const orderData = {
        orderID,
        userID: userId,
        restaurantID: quote.restaurantID,
        restaurantName: restaurant.name ?? "",
        restaurantLat: restaurant.lat ?? null,
        restaurantLng: restaurant.lng ?? null,
        itemIDs: quote.itemIDs ?? [],
        address: quote.address ?? {},
        orderType: quote.orderType ?? "delivery",
        paymentMethod: "cash",
        totalAmount: String(quote.finalTotal ?? "0.00"),
        status: "Pending",
        orderTime: admin.firestore.FieldValue.serverTimestamp(),
    };
    const batch = db.batch();
    batch.set(db.collection("orders").doc(orderID), orderData);
    batch.set(db.collection("users").doc(userId).collection("orders").doc(orderID), orderData);
    batch.update(db.collection("quotes").doc(quoteId), {
        status: "USED",
    });
    await batch.commit();
    const ridersSnap = await db.collection("riders")
        .where("isOnline", "==", true)
        .where("hasActiveOrder", "==", false)
        .limit(1)
        .get();
    if (!ridersSnap.empty) {
        const riderDoc = ridersSnap.docs[0];
        const riderId = riderDoc.id;
        const riderData = riderDoc.data();
        const jobRef = await db.collection("dispatch_jobs").add({
            riderId,
            orderID,
            status: "pending",
            restaurantName: restaurant.name ?? "",
            restaurantAddress: restaurant.address ?? "",
            customerName: "Customer",
            customerAddress: quote.address?.fullAddress ?? "",
            totalAmount: quote.finalTotal ?? 0,
            deliveryFee: quote.deliveryFee ?? 0,
            orderType: quote.orderType ?? "delivery",
            paymentMethod: "cash",
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        if (riderData.fcmToken) {
            await admin.messaging().send({
                token: riderData.fcmToken,
                notification: {
                    title: "New Cash Order",
                    body: restaurant.name ?? "",
                },
                data: {
                    type: "DISPATCH_JOB",
                    jobId: jobRef.id,
                },
            });
        }
    }
    return { success: true, orderID };
});
// ── 7. saveFcmToken ──────────────────────────────────────────────────────────
exports.savefcmtoken = (0, https_1.onCall)({ region: "europe-west1" }, async (request) => {
    if (!request.auth)
        throw new https_1.HttpsError("unauthenticated", "Login required");
    const collection = request.data.role === "rider" ? "riders" : "users";
    await db.collection(collection).doc(request.auth.uid).update({ fcmToken: request.data.token, fcmUpdatedAt: admin.firestore.FieldValue.serverTimestamp() });
    return { success: true };
});
//# sourceMappingURL=index.js.map