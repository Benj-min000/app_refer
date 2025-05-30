import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  static Future<void> makePayment() async {
    try {
      // 1️⃣ Get Payment Intent from your server
      final response = await http.post(
        Uri.parse('http://10.0.2.2:4242/create-payment-intent'), // ✅ LOCAL Android Emulator IP
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': 1000}), // No currency if your backend already sets USD
      );

      final paymentIntentData = jsonDecode(response.body);

      // 2️⃣ Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['clientSecret'],
          merchantDisplayName: 'I-Eat',
        ),
      );

      // 3️⃣ Show the payment sheet
      await Stripe.instance.presentPaymentSheet();

      print('✅ Payment successful!');
    } catch (e) {
      print('❌ Payment error: $e');
    }
  }
}
