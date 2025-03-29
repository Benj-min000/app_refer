import 'package:flutter/material.dart';
import 'package:user_app/services/payment_service.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe Payment')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await PaymentService.makePayment(); // Calls payment function
          },
          child: const Text('Pay Now'),
        ),
      ),
    );
  }
}
