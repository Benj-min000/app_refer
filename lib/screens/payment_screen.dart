import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:user_app/screens/home_screen.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/widgets/accepted_payment.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/assistant_methods/total_amount.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;
  final double amount;

  const PaymentScreen({
    super.key,
    required this.orderData,
    required this.amount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  String _selectedPayment = '';

  Future<void> _writeOrder() async {
    final updatedOrder = {
      ...widget.orderData,
      'isSuccess': true,
      'paymentDetails': _selectedPayment,
    };
    final orderID = updatedOrder['orderID'];

    await Future.wait([
      FirebaseFirestore.instance
          .collection("orders")
          .doc(orderID)
          .set(updatedOrder),
      FirebaseFirestore.instance
          .collection("users")
          .doc(currentUid)
          .collection("orders")
          .doc(orderID)
          .set(updatedOrder),
    ]);
  }

  Future<void> _onOrderSuccess() async {
    await _writeOrder();

    if (!mounted) return;
    await clearCartNow(context);
    Provider.of<TotalAmount>(context, listen: false).reset();

    if (!mounted) return;
    Fluttertoast.showToast(msg: "Order placed successfully!", backgroundColor: Colors.green);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  Future<void> _handleCash() async {
    setState(() => _isLoading = true);
    try {
      await _onOrderSuccess();
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to place order: $e", backgroundColor: Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleStripePayment() async {
    setState(() => _isLoading = true);
    try {
      // 1. Create PaymentIntent via Cloud Function
      final result = await FirebaseFunctions.instanceFor(region: 'europe-west1')
          .httpsCallable('createPaymentIntent')
          .call({'amount': widget.amount});

      final clientSecret = result.data['clientSecret'] as String;

      // 2. Initialize Stripe payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Your App Name",
          style: ThemeMode.light,
        ),
      );

      // 3. Present Stripe's built-in payment UI
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Your App Name",
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
        await _onOrderSuccess();
      } else {
        Fluttertoast.showToast(
          msg: "Payment was not completed",
          backgroundColor: Colors.orange,
        );
      }
    } on StripeException catch (e) {
      Fluttertoast.showToast(
        msg: e.error.message ?? "Payment cancelled",
        backgroundColor: Colors.red,
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Payment failed: $e", backgroundColor: Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _confirmPayment() {
    if (_selectedPayment.isEmpty) {
      Fluttertoast.showToast(msg: "Please select a payment method");
      return;
    }

    switch (_selectedPayment.toLowerCase()) {
      case 'cash':
        _handleCash();
        break;
      case 'card':
      case 'blik':
        _handleStripePayment();
        break;
      default:
        _handleStripePayment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UnifiedAppBar(
        title: "Payment",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order total summary
                  Card(
                    color: Colors.grey[50],
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Amount to Pay:",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Text(
                            "₹${widget.amount.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Payment method selection
                  AcceptedPaymentsWidget(
                    restaurantID: widget.orderData['restaurantID'],
                    selectedPayment: _selectedPayment,
                    onPaymentSelected: (value) => setState(() => _selectedPayment = value),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _confirmPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _selectedPayment.toLowerCase() == 'cash'
                            ? "Place Order"
                            : "Pay ₹${widget.amount.toStringAsFixed(2)}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}