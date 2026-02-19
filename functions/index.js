const { onInit } = require("firebase-functions/v2/core");
const { onCall } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");

const stripeSecretKey = defineSecret("STRIPE_SECRET_KEY");

let stripe;

onInit(() => {
  const Stripe = require("stripe");
  stripe = Stripe(stripeSecretKey.value());
});

exports.createPaymentIntent = onCall(
  { secrets: ["STRIPE_SECRET_KEY"], region: "europe-west1"  },
  async (request) => {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(request.data.amount * 100),
      currency: "pln",
      automatic_payment_methods: { enabled: true },
    });
    return { clientSecret: paymentIntent.client_secret };
  }
);