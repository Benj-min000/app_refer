import 'package:flutter/material.dart';
import 'package:user_app/services/payment_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false; //  show loading spinner when paying

  Future<void> _payNow() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await PaymentService.makePayment();

      // If success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(' Payment Successful!')),
      );
    } catch (e) {
      // If error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Payment failed: $e')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe Payment')),
      body: Center(
        child: _isProcessing
            ? const CircularProgressIndicator() //  show loading
            : ElevatedButton(
          onPressed: _payNow, //  call pay function
          child: const Text('Pay Now \$10'),
        ),
      ),
    );
  }
}
