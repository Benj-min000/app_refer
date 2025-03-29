require("dotenv").config();  // ✅ Load environment variables at the top

const express = require("express");
const cors = require("cors");

// ✅ Load the Stripe Secret Key
const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);

const app = express();
app.use(express.json());
app.use(cors());

app.post("/create-payment-intent", async (req, res) => {
    try {
        const { amount, currency } = req.body;

        const paymentIntent = await stripe.paymentIntents.create({
            amount,
            currency,
            payment_method_types: ["card"],
        });

        res.json({ clientSecret: paymentIntent.client_secret });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.listen(5000, () => console.log("✅ Server running on port 5000"));
