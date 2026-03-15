import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Simple rating submission sheet.
/// Shows when an order is delivered and has not yet been rated.
///
/// Rates:
///   • Food (1–5 stars)
///   • Driver (1–5 stars)
///   • Optional comment
///
/// On submit:
///   • Writes rating/driverRating/ratingComment/ratedAt to the order doc
///   • Updates restaurants/{id} avgRating + totalRatings via transaction
void showRateOrderSheet(
  BuildContext context, {
  required String orderID,
  required String restaurantID,
  required String restaurantName,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: false,
    enableDrag: false,
    builder: (_) => _RateOrderSheet(
      orderID: orderID,
      restaurantID: restaurantID,
      restaurantName: restaurantName,
    ),
  );
}

class _RateOrderSheet extends StatefulWidget {
  final String orderID;
  final String restaurantID;
  final String restaurantName;

  const _RateOrderSheet({
    required this.orderID,
    required this.restaurantID,
    required this.restaurantName,
  });

  @override
  State<_RateOrderSheet> createState() => _RateOrderSheetState();
}

class _RateOrderSheetState extends State<_RateOrderSheet> {
  int _foodRating = 0;
  int _driverRating = 0;
  final TextEditingController _commentController =
      TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_foodRating == 0 || _driverRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please rate both food and driver.')),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      // 1. Write rating to order document
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderID)
          .update({
        'rating': _foodRating,
        'driverRating': _driverRating,
        'ratingComment': _commentController.text.trim(),
        'ratedAt': Timestamp.now(),
      });

      // 2. Update restaurant avgRating via transaction
      final restaurantRef = FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.restaurantID);

      await FirebaseFirestore.instance
          .runTransaction((tx) async {
        final snap = await tx.get(restaurantRef);
        final data = snap.data() ?? {};
        final int currentTotal =
            (data['totalRatings'] as int?) ?? 0;
        final double currentAvg =
            ((data['avgRating'] as num?) ?? 0).toDouble();

        final int newTotal = currentTotal + 1;
        final double newAvg =
            ((currentAvg * currentTotal) + _foodRating) / newTotal;

        tx.update(restaurantRef, {
          'avgRating':
              double.parse(newAvg.toStringAsFixed(1)),
          'totalRatings': newTotal,
        });
      });

      if (!mounted) return;
      Navigator.pop(context);

      // Show thank-you snack
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline_rounded,
                  color: Colors.white, size: 18),
              SizedBox(width: 10),
              Text('Thanks for your feedback!'),
            ],
          ),
          backgroundColor: const Color(0xFF00C48C),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          margin:
              const EdgeInsets.fromLTRB(16, 0, 16, 24),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.star_rounded,
                      color: Colors.redAccent, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rate your order',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        widget.restaurantName,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                // Skip button
                TextButton(
                  onPressed:
                      _submitting ? null : () => Navigator.pop(context),
                  child: Text('Skip',
                      style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 13)),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Food rating
            _RatingRow(
              icon: Icons.restaurant_rounded,
              label: 'Food Quality',
              rating: _foodRating,
              onChanged: (v) => setState(() => _foodRating = v),
            ),

            const SizedBox(height: 20),

            // Driver rating
            _RatingRow(
              icon: Icons.delivery_dining_rounded,
              label: 'Delivery Driver',
              rating: _driverRating,
              onChanged: (v) =>
                  setState(() => _driverRating = v),
            ),

            const SizedBox(height: 20),

            // Comment
            TextField(
              controller: _commentController,
              maxLines: 3,
              maxLength: 200,
              decoration: InputDecoration(
                hintText:
                    'Leave a comment (optional)...',
                hintStyle: TextStyle(
                    fontSize: 13, color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Colors.redAccent, width: 1.5),
                ),
                contentPadding: const EdgeInsets.all(14),
                counterStyle: TextStyle(
                    fontSize: 10, color: Colors.grey.shade400),
              ),
            ),

            const SizedBox(height: 20),

            // Submit
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  disabledBackgroundColor:
                      Colors.redAccent.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white),
                      )
                    : const Text(
                        'Submit Rating',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Star selector row ─────────────────────────────────────────────────────────

class _RatingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final int rating;
  final ValueChanged<int> onChanged;

  const _RatingRow({
    required this.icon,
    required this.label,
    required this.rating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child:
              Icon(icon, size: 18, color: Colors.grey.shade500),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        // 5 tappable stars
        Row(
          children: List.generate(5, (i) {
            final filled = i < rating;
            return GestureDetector(
              onTap: () => onChanged(i + 1),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    filled
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    key: ValueKey('$label-$i-$filled'),
                    size: 30,
                    color: filled
                        ? Colors.amber.shade600
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}