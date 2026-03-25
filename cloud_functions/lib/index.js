"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.saveFcmToken = exports.onOrderUpdated = exports.onDispatchAccepted = exports.placeOrder = exports.getPaymentMethodType = exports.createPaymentIntent = void 0;
const https = require("firebase-functions/v2/https");
const firestore = require("firebase-functions/v2/firestore");
const params_1 = require("firebase-functions/params");
const admin = require("firebase-admin");
const stripe_1 = require("stripe");
admin.initializeApp();
const db = admin.firestore();
// Secret Manager dla Stripe
const stripeSecretKey = (0, params_1.defineSecret)("STRIPE_SECRET_KEY");
/**
 * 1. Tworzy Payment Intent dla Stripe
 */
exports.createPaymentIntent = https.onCall({
    secrets: [stripeSecretKey],
    region: "europe-west1",
    enforceAppCheck: false
}, async (req) => {
    const { amount } = req.data;
    if (!amount)
        throw new https.HttpsError("invalid-argument", "Brak kwoty (amount).");
    const stripe = new stripe_1.default(stripeSecretKey.value(), { apiVersion: "2023-10-16" });
    const amountInCents = Math.round(parseFloat(amount.toString()) * 100);
    try {
        const pi = await stripe.paymentIntents.create({
            amount: amountInCents,
            currency: "pln",
            automatic_payment_methods: { enabled: true },
        });
        return { clientSecret: pi.client_secret, paymentIntentId: pi.id };
    }
    catch (error) {
        console.error("Stripe Error:", error);
        throw new https.HttpsError("internal", error.message);
    }
});
/**
 * 2. Pobiera typ metody płatności (karta/blik) po sukcesie
 */
exports.getPaymentMethodType = https.onCall({
    secrets: [stripeSecretKey],
    region: "europe-west1",
    enforceAppCheck: false
}, async (req) => {
    const { paymentIntentId } = req.data;
    if (!paymentIntentId)
        throw new https.HttpsError("invalid-argument", "Brak paymentIntentId.");
    const stripe = new stripe_1.default(stripeSecretKey.value(), { apiVersion: "2023-10-16" });
    try {
        const pi = await stripe.paymentIntents.retrieve(paymentIntentId, {
            expand: ["payment_method"],
        });
        const paymentMethod = pi.payment_method;
        return { paymentMethodType: paymentMethod?.type ?? "card" };
    }
    catch (error) {
        throw new https.HttpsError("internal", error.message);
    }
});
/**
 * 3. Zapisuje zamówienie w Firestore
 */
exports.placeOrder = https.onCall({
    region: "europe-west1",
    enforceAppCheck: false
}, async (req) => {
    const { data, auth } = req;
    if (!auth)
        throw new https.HttpsError("unauthenticated", "Wymagane logowanie.");
    const orderID = db.collection("orders").doc().id;
    const orderData = {
        ...data,
        orderID,
        userID: auth.uid,
        status: "Pending",
        orderTime: admin.firestore.FieldValue.serverTimestamp(),
    };
    const batch = db.batch();
    batch.set(db.collection("orders").doc(orderID), orderData);
    batch.set(db.collection("users").doc(auth.uid).collection("orders").doc(orderID), orderData);
    await batch.commit();
    // Próba wysłania do kuriera
    try {
        await dispatchToRider(orderID);
    }
    catch (e) {
        console.error("Dispatch Error:", e);
    }
    return { success: true, orderID };
});
/**
 * Trigger: Gdy kurier zaakceptuje zadanie
 */
exports.onDispatchAccepted = firestore.onDocumentUpdated({
    document: "dispatch_jobs/{jobId}",
    region: "europe-west1",
}, async (event) => {
    const after = event.data?.after.data();
    if (!after || after.status !== "accepted")
        return;
    const { riderId, orderID } = after;
    await db.collection("orders").doc(orderID).update({
        status: "In Progress",
        driverUID: riderId,
    });
    await db.collection("riders").doc(riderId).update({
        hasActiveOrder: true,
        currentOrderID: orderID,
    });
});
/**
 * Trigger: Gdy status zamówienia zmieni się na Delivered
 */
exports.onOrderUpdated = firestore.onDocumentUpdated({
    document: "orders/{orderID}",
    region: "europe-west1",
}, async (event) => {
    const after = event.data?.after.data();
    if (!after)
        return;
    if (after.status === "Delivered" && after.driverUID) {
        await db.collection("riders").doc(after.driverUID).update({
            hasActiveOrder: false,
            currentOrderID: null,
        });
    }
});
/**
 * Funkcja pomocnicza: Szukanie kuriera
 */
async function dispatchToRider(orderID) {
    const riders = await db.collection("riders")
        .where("isOnline", "==", true)
        .where("hasActiveOrder", "==", false)
        .limit(1).get();
    if (riders.empty)
        return;
    const riderDoc = riders.docs[0];
    await db.collection("dispatch_jobs").add({
        riderId: riderDoc.id,
        orderID,
        status: "pending",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
}
/**
 * Zapisywanie tokena FCM
 */
exports.saveFcmToken = https.onCall({
    region: "europe-west1",
    enforceAppCheck: false
}, async (req) => {
    const { token, role } = req.data;
    if (!req.auth)
        return { success: false };
    const coll = role === "rider" ? "riders" : "users";
    await db.collection(coll).doc(req.auth.uid).set({ fcmToken: token }, { merge: true });
    return { success: true };
});
//# sourceMappingURL=index.js.map