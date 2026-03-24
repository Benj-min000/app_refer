const { onInit } = require("firebase-functions/v2/core");
const { onCall, onRequest } = require("firebase-functions/v2/https");
const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const Stripe = require("stripe");
const axios = require("axios");
const fs = require("fs");
const path = require("path");

// 1. Initialize Admin SDK
admin.initializeApp();
const db = admin.firestore();

// 2. Load Secrets from secrets.json
function loadSecrets() {
  const secretsPath = path.join(__dirname, "secrets.json");
  if (!fs.existsSync(secretsPath)) {
    // Fallback for different folder structures
    const altPath = path.join(__dirname, "..", "secrets.json");
    if (fs.existsSync(altPath)) return JSON.parse(fs.readFileSync(altPath, "utf-8"));
    throw new Error("secrets.json not found. Ensure it is in the functions folder.");
  }
  return JSON.parse(fs.readFileSync(secretsPath, "utf-8"));
}

const secrets = loadSecrets();
const stripe = new Stripe(secrets.STRIPE_SECRET_KEY, { apiVersion: "2023-10-16" });
const GOOGLE_MAPS_KEY = secrets.MAPS_API_KEY || secrets.GOOGLE || "";

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

function haversineKm(lat1, lng1, lat2, lng2) {
  const R = 6371;
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLng = ((lng2 - lng1) * Math.PI) / 180;
  const a = Math.sin(dLat / 2) ** 2 +
            Math.cos((lat1 * Math.PI) / 180) * Math.cos((lat2 * Math.PI) / 180) * Math.sin(dLng / 2) ** 2;
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

async function getDirections(fLat, fLng, tLat, tLng) {
  try {
    const url = "https://maps.googleapis.com/maps/api/directions/json";
    const { data } = await axios.get(url, {
      params: { origin: `${fLat},${fLng}`, destination: `${tLat},${tLng}`, key: GOOGLE_MAPS_KEY },
    });
    if (data.status !== "OK") return null;
    return {
      durationSeconds: data.routes[0].legs[0].duration.value,
      polyline: data.routes[0].overview_polyline.points,
    };
  } catch (err) { return null; }
}

// ─────────────────────────────────────────────────────────────────────────────
// HTTPS FUNCTIONS (v2) - Region: europe-west1
// ─────────────────────────────────────────────────────────────────────────────

exports.createPaymentIntent = onCall({ region: "europe-west1" }, async (request) => {
  if (!request.auth) throw new Error("unauthenticated");
  if (secrets.STRIPE_SECRET_KEY === "MISSING") throw new Error("Configuration error: Secret key missing");

  const { quoteId } = request.data;
  const quoteDoc = await db.collection("quotes").doc(quoteId).get();
  
  if (!quoteDoc.exists) throw new Error("not-found");
  const quote = quoteDoc.data();

  const paymentIntent = await stripe.paymentIntents.create({
    amount: Math.round(quote.finalTotal * 100),
    currency: "pln",
    metadata: { quoteId, userId: request.auth.uid, storeId: quote.storeId },
    automatic_payment_methods: { enabled: true },
  });

  await quoteDoc.ref.update({ 
    stripePaymentIntentId: paymentIntent.id, 
    paymentStatus: "PENDING" 
  });

  return { 
    clientSecret: paymentIntent.client_secret, 
    publishableKey: secrets.STRIPE_PUBLISHABLE_KEY 
  };
});

exports.stripeWebhook = onRequest({ region: "europe-west1" }, async (req, res) => {
  const sig = req.headers["stripe-signature"];
  try {
    const event = stripe.webhooks.constructEvent(req.rawBody, sig, secrets.STRIPE_WEBHOOK_SECRET || "");
    if (event.type === "payment_intent.succeeded") {
      await handlePaymentSuccess(event.data.object);
    }
    res.json({ received: true });
  } catch (err) {
    console.error("Webhook Error:", err.message);
    res.status(400).send(`Webhook Error: ${err.message}`);
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// FIRESTORE TRIGGERS - Region: europe-west1
// ─────────────────────────────────────────────────────────────────────────────

exports.onRiderLocationUpdate = onDocumentUpdated({
  document: "deliveries/{deliveryId}",
  region: "europe-west1"
}, async (event) => {
  const after = event.data.after.data();
  if (!after || !after.riderLocation || after.status === "DELIVERED") return;

  const target = after.routePhase === "TO_PICKUP" ? after.pickup : after.dropoff;
  const directions = await getDirections(after.riderLocation.lat, after.riderLocation.lng, target.lat, target.lng);

  if (directions) {
    await event.data.after.ref.update({
      eta: { minutes: Math.ceil(directions.durationSeconds / 60) },
      "route.encodedPolyline": directions.polyline,
    });
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// CORE LOGIC: Post-Payment Processing
// ─────────────────────────────────────────────────────────────────────────────

async function handlePaymentSuccess(pi) {
  const { quoteId, userId, storeId } = pi.metadata;
  const [quoteDoc, storeDoc] = await Promise.all([
    db.collection("quotes").doc(quoteId).get(),
    db.collection("restaurants").doc(storeId).get(),
  ]);

  if (!quoteDoc.exists) return;
  const quote = quoteDoc.data();
  const store = storeDoc.data();

  const batch = db.batch();
  const orderRef = db.collection("orders").doc();
  const deliveryRef = db.collection("deliveries").doc();

  batch.set(orderRef, {
    ...quote,
    status: "CONFIRMED",
    stripePaymentIntentId: pi.id,
    deliveryId: deliveryRef.id,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  batch.set(deliveryRef, {
    orderId: orderRef.id,
    storeId,
    customerId: userId,
    status: "ASSIGNING",
    routePhase: "TO_PICKUP",
    pickup: { lat: store.location?.lat ?? 0, lng: store.location?.lng ?? 0 },
    dropoff: { lat: quote.dropoffLat ?? 0, lng: quote.dropoffLng ?? 0 },
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  batch.update(quoteDoc.ref, { status: "USED", paymentStatus: "PAID" });
  await batch.commit();

  await dispatchToRider(orderRef.id, deliveryRef.id, { 
    ...quote, 
    storeName: store.name, 
    pickup: { lat: store.location?.lat ?? 0, lng: store.location?.lng ?? 0 } 
  });
}

async function dispatchToRider(orderId, deliveryId, orderData) {
  const ridersSnap = await db.collection("riders")
    .where("isOnline", "==", true)
    .where("hasActiveDelivery", "==", false)
    .limit(1)
    .get();

  if (ridersSnap.empty) return;

  const riderDoc = ridersSnap.docs[0];
  const jobRef = db.collection("dispatch_jobs").doc();
  const riderEarnings = parseFloat(Math.max(3.5, (orderData.deliveryFee ?? 5) * 0.75).toFixed(2));

  await jobRef.set({
    riderId: riderDoc.id,
    deliveryId,
    orderId,
    status: "PENDING",
    riderEarnings,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });
}