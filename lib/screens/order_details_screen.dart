import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_app/models/address.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/shipment_address_design.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/rate_order_sheet.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderID;
  const OrderDetailsScreen({super.key, this.orderID});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // Ensures the rating sheet is only shown once per screen session
  bool _ratingPrompted = false;

  void _maybeShowRatingPrompt(Map<String, dynamic> data) {
    if (_ratingPrompted) return;
    final status = data['status']?.toString() ?? '';
    final bool isDelivered = status == 'Delivered';
    final bool alreadyRated = data['rating'] != null;
    if (!isDelivered || alreadyRated) return;

    _ratingPrompted = true;

    // Delay slightly so the screen finishes building first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showRateOrderSheet(
        context,
        orderID: widget.orderID ?? '',
        restaurantID: data['restaurantID']?.toString() ?? '',
        restaurantName: data['restaurantName']?.toString() ?? 'Restaurant',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6FB),
      appBar: UnifiedAppBar(
        title: "Order Details",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUid)
            .collection("orders")
            .doc(widget.orderID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: circularProgress());
          }

          final data =
              snapshot.data!.data()! as Map<String, dynamic>;
          final status = data["status"]?.toString() ?? "Pending";

          // Check if we should prompt for rating
          _maybeShowRatingPrompt(data);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Status progress ──────────────────────────────────
                _OrderProgressCard(status: status),

                const SizedBox(height: 20),

                // ── Summary ──────────────────────────────────────────
                _SectionLabel("Order Summary"),
                const SizedBox(height: 10),
                _SummaryCard(data: data, orderID: widget.orderID),

                const SizedBox(height: 20),

                // ── Rating badge if already rated ────────────────────
                if (data['rating'] != null)
                  _RatedBadge(
                    foodRating: (data['rating'] as num).toInt(),
                    driverRating:
                        (data['driverRating'] as num?)?.toInt() ?? 0,
                  ),

                if (data['rating'] != null)
                  const SizedBox(height: 20),

                // ── Address / pickup ─────────────────────────────────
                if (data["orderType"] != "pickup") ...[
                  _SectionLabel("Delivery Address"),
                  const SizedBox(height: 10),
                  _AddressSection(data: data),
                ] else ...[
                  _SectionLabel("Pickup Location"),
                  const SizedBox(height: 10),
                  _PickupCard(),
                ],

                const SizedBox(height: 20),

                // ── Order status image ───────────────────────────────
                _StatusImage(status: status),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Order progress card ────────────────────────────────────────────────────────

class _OrderProgressCard extends StatelessWidget {
  final String status;
  const _OrderProgressCard({required this.status});

  static const List<_Step> _steps = [
    _Step(
      label: "Processing",
      sublabel: "We received your order",
      icon: Icons.receipt_long_rounded,
      value: "Pending",
    ),
    _Step(
      label: "Accepted",
      sublabel: "Restaurant confirmed",
      icon: Icons.restaurant_rounded,
      value: "In Progress",
    ),
    _Step(
      label: "On the Way",
      sublabel: "Driver is heading to you",
      icon: Icons.delivery_dining_rounded,
      value: "Ready",
    ),
    _Step(
      label: "Delivered",
      sublabel: "Enjoy your meal!",
      icon: Icons.check_circle_rounded,
      value: "Delivered",
    ),
  ];

  int get _currentIndex {
    for (int i = _steps.length - 1; i >= 0; i--) {
      if (status == _steps[i].value) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final int current = _currentIndex;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.local_shipping_rounded,
                    size: 16, color: Colors.redAccent),
              ),
              const SizedBox(width: 10),
              const Text(
                "Order Status",
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              _StatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 24),
          ...List.generate(_steps.length, (i) {
            final step = _steps[i];
            final isDone = i <= current;
            final isActive = i == current;
            final isLast = i == _steps.length - 1;

            return _TimelineRow(
              step: step,
              isDone: isDone,
              isActive: isActive,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }
}

class _Step {
  final String label, sublabel, value;
  final IconData icon;
  const _Step({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.value,
  });
}

class _TimelineRow extends StatelessWidget {
  final _Step step;
  final bool isDone, isActive, isLast;

  const _TimelineRow({
    required this.step,
    required this.isDone,
    required this.isActive,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Colors.redAccent;
    final Color doneColor = const Color(0xFF00C48C);
    final Color pendingColor = Colors.grey.shade200;

    final Color dotColor = isDone
        ? (isActive ? activeColor : doneColor)
        : pendingColor;
    final Color lineColor = isDone && !isActive ? doneColor : pendingColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Dot + line column ──────────────────────────────────────
        SizedBox(
          width: 36,
          child: Column(
            children: [
              // Dot
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: dotColor.withValues(alpha: isDone ? 1 : 0.3),
                  shape: BoxShape.circle,
                  border: isActive
                      ? Border.all(color: activeColor, width: 2)
                      : null,
                ),
                child: Icon(
                  step.icon,
                  size: 18,
                  color: isDone ? Colors.white : Colors.grey.shade400,
                ),
              ),
              // Connector line
              if (!isLast)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 2,
                  height: 36,
                  color: lineColor,
                ),
            ],
          ),
        ),

        const SizedBox(width: 14),

        // ── Label ──────────────────────────────────────────────────
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                top: 6, bottom: isLast ? 0 : 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive
                        ? FontWeight.w800
                        : FontWeight.w600,
                    color: isActive
                        ? Colors.black87
                        : isDone
                            ? const Color(0xFF00C48C)
                            : Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  step.sublabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive
                        ? Colors.grey.shade600
                        : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Check ──────────────────────────────────────────────────
        if (isDone && !isActive)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Icon(Icons.check_rounded,
                size: 16, color: const Color(0xFF00C48C)),
          ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (status) {
      'Pending' => (
          const Color(0xFFFEF3C7),
          const Color(0xFFD97706)
        ),
      'In Progress' => (
          Colors.redAccent.withValues(alpha: 0.1),
          Colors.redAccent
        ),
      'Ready' => (
          Colors.blue.shade50,
          Colors.blue.shade700
        ),
      'Delivered' => (
          const Color(0xFF00C48C).withValues(alpha: 0.1),
          const Color(0xFF00C48C)
        ),
      _ => (Colors.grey.shade100, Colors.grey.shade600),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}

// ── Summary card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String? orderID;
  const _SummaryCard({required this.data, required this.orderID});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total",
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey.shade500)),
              Text(
                "${data["totalAmount"] ?? '0.00'} zł",
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent),
              ),
            ],
          ),
          if ((data["deliveryFee"] ?? "0.00") != "0.00") ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delivery Fee",
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500)),
                Text("${data["deliveryFee"]} zł",
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF0F0F0)),
          ),
          _InfoRow(
            icon: Icons.receipt_long_rounded,
            label: "Order ID",
            value: "#${orderID?.substring(0, 12) ?? ''}...",
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: data["orderType"] == "pickup"
                ? Icons.storefront_rounded
                : Icons.delivery_dining_rounded,
            label: "Order Type",
            value: data["orderType"] == "pickup" ? "Pickup" : "Delivery",
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.schedule_rounded,
            label: "Ordered At",
            value: _formatTime(data["orderTime"]),
          ),
          const SizedBox(height: 10),
          _InfoRow(
            icon: Icons.payments_rounded,
            label: "Payment",
            value: _formatPayment(data["paymentDetails"]),
          ),
        ],
      ),
    );
  }

  String _formatTime(dynamic t) {
    try {
      final dt = t is Timestamp ? t.toDate() : DateTime.now();
      return DateFormat("dd MMM yyyy, hh:mm a").format(dt);
    } catch (_) {
      return "Unknown";
    }
  }

  String _formatPayment(dynamic p) {
    if (p == null) return "Unknown";
    final s = p.toString();
    if (s == "cash") return "Cash on Delivery";
    if (s.toLowerCase().contains("stripe") ||
        s.toLowerCase().contains("card")) return "Card (Stripe)";
    return s;
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade400),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade500)),
              const SizedBox(height: 1),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Address section ───────────────────────────────────────────────────────────

class _AddressSection extends StatelessWidget {
  final Map<String, dynamic> data;
  const _AddressSection({required this.data});

  @override
  Widget build(BuildContext context) {
    // New model — address embedded directly on the order
    if (data["address"] is Map) {
      final addr = Address.fromJson(
          Map<String, dynamic>.from(data["address"] as Map));
      return ShipmentAddressDesign(model: addr);
    }

    // Legacy model — address stored by ID
    final addressID = data["addressID"] as String?;
    if (addressID == null || addressID.isEmpty || addressID == "pickup") {
      return _InfoTile(
          icon: Icons.location_off_rounded, text: "Address not available");
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(currentUid)
          .collection("addresses")
          .doc(addressID)
          .get(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: circularProgress()),
          );
        }
        if (!snap.data!.exists) {
          return _InfoTile(
              icon: Icons.location_off_rounded, text: "Address not found");
        }
        return ShipmentAddressDesign(
          model: Address.fromJson(
              snap.data!.data()! as Map<String, dynamic>),
        );
      },
    );
  }
}

class _PickupCard extends StatelessWidget {
  const _PickupCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.storefront_rounded,
                color: Colors.redAccent, size: 24),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pick up from store",
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
                SizedBox(height: 2),
                Text("Show this order at the counter",
                    style: TextStyle(
                        fontSize: 12, color: Color(0xFFAAAAAA))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade400, size: 18),
          const SizedBox(width: 12),
          Text(text,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

// ── Status image ──────────────────────────────────────────────────────────────

class _StatusImage extends StatelessWidget {
  final String status;
  const _StatusImage({required this.status});

  @override
  Widget build(BuildContext context) {
    final bool delivered = status == "Delivered";
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        delivered
            ? 'assets/images/delivered.jpg'
            : 'assets/images/state.jpg',
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
      ),
    );
  }
}

// ── Rated badge — shown when order has already been rated ─────────────────────

class _RatedBadge extends StatelessWidget {
  final int foodRating;
  final int driverRating;
  const _RatedBadge(
      {required this.foodRating, required this.driverRating});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF00C48C).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF00C48C).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: Color(0xFF00C48C), size: 20),
          const SizedBox(width: 10),
          const Text('You rated this order',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00C48C))),
          const Spacer(),
          _MiniStars(label: 'Food', rating: foodRating),
          const SizedBox(width: 12),
          _MiniStars(label: 'Driver', rating: driverRating),
        ],
      ),
    );
  }
}

class _MiniStars extends StatelessWidget {
  final String label;
  final int rating;
  const _MiniStars({required this.label, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (i) => Icon(
              i < rating
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              size: 12,
              color: i < rating
                  ? Colors.amber.shade600
                  : Colors.grey.shade300,
            ),
          ),
        ),
      ],
    );
  }
}