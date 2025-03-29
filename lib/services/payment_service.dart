import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  static Future<void> makePayment() async {
    try {
      // 1️⃣ Get a Payment Intent from the backend
      final response = await http.post(
        Uri.parse('https://your-backend-url.com/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': 1000, 'currency': 'USD'}),
      );

      final paymentIntentData = jsonDecode(response.body);

      // 2️⃣ Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['clientSecret'],
          merchantDisplayName: 'Your Business Name',
        ),
      );

      // 3️⃣ Show the payment sheet
      await Stripe.instance.presentPaymentSheet();

      print('Payment successful!');
    } catch (e) {
      print('Error: $e');
    }
  }
}
