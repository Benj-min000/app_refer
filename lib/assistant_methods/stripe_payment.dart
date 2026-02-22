import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<String?> processStripePayment(double amount) async {
  try {
    final result = await FirebaseFunctions.instanceFor(region: 'europe-west1')
        .httpsCallable('createPaymentIntent')
        .call({'amount': amount});

    final clientSecret = result.data['clientSecret'] as String;
    final paymentIntentId = result.data['paymentIntentId'] as String;

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "Freequick",
        style: ThemeMode.light,
        appearance: PaymentSheetAppearance(
          colors: PaymentSheetAppearanceColors(
            primary: Colors.red,
            background: Colors.white,
          ),
          shapes: PaymentSheetShape(
            borderRadius: 12,
            borderWidth: 0.5,
          ),
          primaryButton: PaymentSheetPrimaryButtonAppearance(
            colors: PaymentSheetPrimaryButtonTheme(
              light: PaymentSheetPrimaryButtonThemeColors(
                background: Colors.redAccent,
                text: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    await Stripe.instance.presentPaymentSheet();

    final paymentIntent = await Stripe.instance.retrievePaymentIntent(clientSecret);

    if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
      final methodResult = await FirebaseFunctions.instanceFor(region: 'europe-west1')
          .httpsCallable('getPaymentMethodType')
          .call({'paymentIntentId': paymentIntentId});

      return methodResult.data['paymentMethodType'] as String? ?? '';
    }

    Fluttertoast.showToast(msg: "Payment was not completed", backgroundColor: Colors.orange);
    return null;
  } on StripeException catch (e) {
    Fluttertoast.showToast(
      msg: e.error.message ?? "Payment cancelled",
      backgroundColor: Colors.red,
    );
    return null;
  } catch (e) {
    Fluttertoast.showToast(msg: "Payment failed: $e", backgroundColor: Colors.red);
    return null;
  }
}