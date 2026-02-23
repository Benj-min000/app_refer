import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcceptedPaymentsWidget extends StatefulWidget {
  final String restaurantID;
  final String selectedPayment;
  final ValueChanged<String> onPaymentSelected;

  const AcceptedPaymentsWidget({
    super.key,
    required this.restaurantID,
    required this.selectedPayment,
    required this.onPaymentSelected,
  });

  @override
  State<AcceptedPaymentsWidget> createState() => _AcceptedPaymentsWidgetState();
}

class _AcceptedPaymentsWidgetState extends State<AcceptedPaymentsWidget> {
  IconData _getPaymentIcon(String method) {
    switch (method.toLowerCase()) {
      case 'cash': return Icons.payments_outlined;
      case 'card': return Icons.credit_card;
      case 'blik': return Icons.phone_android;
      case 'paypal': return Icons.account_balance_wallet_outlined;
      default: return Icons.payment;
    }
  }

  Color _getPaymentColor(String method) {
    switch (method.toLowerCase()) {
      case 'cash': return Colors.green;
      case 'card': return Colors.blue;
      case 'blik': return Colors.deepPurple;
      case 'paypal': return Colors.indigo;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection("restaurants")
          .doc(widget.restaurantID)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        final payments = data?['acceptedPayments'] as List<dynamic>?;

        if (payments == null || payments.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.grey[50],
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: payments.map((method) {
                  final label = method.toString();
                  final color = _getPaymentColor(label);
                  final isSelected = widget.selectedPayment == label;

                  return RadioListTile<String>(
                    value: label,
                    groupValue: widget.selectedPayment,
                    onChanged: (value) => widget.onPaymentSelected(value!),
                    activeColor: color,
                    title: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(_getPaymentIcon(label), color: color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          label.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? color : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}