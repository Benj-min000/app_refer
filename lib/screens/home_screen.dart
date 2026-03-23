import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rider_provider.dart';
import '../providers/rider_stats_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/job_request_sheet.dart';

/// Rider home screen.
///
/// Firestore reads:
///   orders/{orderID}
///     status: 'Pending' | 'In Progress' | 'Ready' | 'Delivered'
///     restaurantID, restaurantName, totalAmount, orderType, address
///
///   riders/{uid}
///     isOnline, totalDeliveries, rating, vehicleType, name
///
/// Status flow the rider controls:
///   Restaurant sets: Pending → In Progress
///   Rider picks up:  In Progress → Ready      (order at rider)
///   Rider delivers:  Ready → Delivered        (order complete)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer<RiderProvider>(
        builder: (context, provider, _) {
          // Show job request sheet if there's a pending dispatch
          if (provider.pendingJob != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showJobRequest(context, provider);
            });
          }

          return CustomScrollView(
            slivers: [
              _buildAppBar(context, provider),
              SliverPadding(
                padding:
                    const EdgeInsets.fromLTRB(20, 8, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _OnlineToggle(provider: provider),
                    const SizedBox(height: 20),
                    _EarningsCard(
                      provider: provider,
                      stats: context.watch<RiderStatsProvider>(),
                    ),
                    const SizedBox(height: 20),
                    _StatsRow(provider: provider),
                    const SizedBox(height: 20),
                    if (provider.activeOrder != null) ...[
                      _ActiveOrderCard(
                          provider: provider,
                          order: provider.activeOrder!),
                      const SizedBox(height: 20),
                    ],
                    _RecentDeliveries(provider: provider),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── App bar ────────────────────────────────────────────────────────────────

  SliverAppBar _buildAppBar(
      BuildContext context, RiderProvider provider) {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppTheme.surface,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.delivery_dining_rounded,
                color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.rider?.name ?? 'Rider',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: provider.isOnline
                          ? AppTheme.accent
                          : AppTheme.textSecondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    provider.isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: provider.isOnline
                          ? AppTheme.accent
                          : AppTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [],
    );
  }

  // ── Job request sheet ──────────────────────────────────────────────────────

  void _showJobRequest(
      BuildContext context, RiderProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => JobRequestSheet(
        job: provider.pendingJob!,
        onAccept: () {
          Navigator.pop(context);
          provider.acceptJob(provider.pendingJob!.id);
        },
        onReject: () {
          Navigator.pop(context);
          provider.rejectJob(provider.pendingJob!.id);
        },
      ),
    );
  }
}

// ── Online / offline toggle ───────────────────────────────────────────────────

class _OnlineToggle extends StatelessWidget {
  final RiderProvider provider;
  const _OnlineToggle({required this.provider});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: provider.isOnline
            ? AppTheme.accent.withValues(alpha: 0.08)
            : AppTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: provider.isOnline
              ? AppTheme.accent.withValues(alpha: 0.3)
              : AppTheme.divider,
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.isOnline
                    ? "You're Online"
                    : "You're Offline",
                style: TextStyle(
                  color: provider.isOnline
                      ? AppTheme.accent
                      : AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                provider.isOnline
                    ? 'Ready to receive orders'
                    : 'Go online to receive orders',
                style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13),
              ),
            ],
          ),
          const Spacer(),
          Transform.scale(
            scale: 1.15,
            child: Switch.adaptive(
              value: provider.isOnline,
              onChanged: provider.isLoading
                  ? null
                  : (_) => provider.toggleOnline(),
              activeColor: AppTheme.accent,
              trackColor:
                  WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.accent
                      .withValues(alpha: 0.3);
                }
                return AppTheme.surfaceLight;
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Earnings card ─────────────────────────────────────────────────────────────

class _EarningsCard extends StatelessWidget {
  final RiderProvider provider;
  final RiderStatsProvider stats;
  const _EarningsCard({required this.provider, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary.withValues(alpha: 0.18),
            AppTheme.primary.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today's Earnings",
              style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                stats.todayEarningsFormatted,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${stats.totalDeliveries}',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text('total deliveries',
                      style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _EarningsStat(
                label: 'This week',
                value:
                    stats.weekEarningsFormatted,
              ),
              const SizedBox(width: 20),
              _EarningsStat(
                label: 'Deliveries today',
                value:
                    '${stats.todayDeliveries}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EarningsStat extends StatelessWidget {
  final String label, value;
  const _EarningsStat(
      {required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700)),
        Text(label,
            style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11)),
      ],
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final RiderProvider provider;
  const _StatsRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    final rating = provider.rider?.rating ?? 5.0;
    return Row(
      children: [
        _StatCard(
          label: 'Rating',
          value: rating.toStringAsFixed(1),
          icon: Icons.star_rounded,
          iconColor: AppTheme.warning,
        ),
        const SizedBox(width: 10),
        _StatCard(
          label: 'Vehicle',
          value: _vehicleEmoji(
              provider.rider?.vehicleType ?? 'SCOOTER'),
          icon: Icons.two_wheeler_rounded,
          iconColor: AppTheme.info,
        ),
        const SizedBox(width: 10),
        _StatCard(
          label: 'Status',
          value: provider.isOnline ? 'Active' : 'Idle',
          icon: Icons.circle,
          iconColor: provider.isOnline
              ? AppTheme.accent
              : AppTheme.textSecondary,
        ),
      ],
    );
  }

  String _vehicleEmoji(String type) {
    return switch (type) {
      'BIKE' => '🚲 Bike',
      'SCOOTER' => '🛵 Scooter',
      'CAR' => '🚗 Car',
      _ => type,
    };
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color iconColor;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// ── Active order card ─────────────────────────────────────────────────────────
// Shows when the rider has accepted an order and it's in progress.

class _ActiveOrderCard extends StatelessWidget {
  final RiderProvider provider;
  final Map<String, dynamic> order;
  const _ActiveOrderCard(
      {required this.provider, required this.order});

  @override
  Widget build(BuildContext context) {
    final String status =
        order['status']?.toString() ?? 'In Progress';
    final String restaurantName =
        order['restaurantName']?.toString() ?? 'Restaurant';
    final String total =
        '${order['totalAmount'] ?? '0.00'} zł';
    final String orderID =
        order['orderID']?.toString() ?? '';

    // What action should the rider take next?
    final bool canPickUp = status == 'In Progress';
    final bool canDeliver = status == 'Ready';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.4),
            width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                    Icons.local_shipping_rounded,
                    color: AppTheme.primary,
                    size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text('Active Order',
                        style: TextStyle(
                            color: AppTheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                    Text(restaurantName,
                        style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Text(total,
                  style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
            ],
          ),

          const SizedBox(height: 14),

          // Status pill
          _StatusPill(status: status),

          const SizedBox(height: 14),

          // Action button
          if (canPickUp)
            _ActionButton(
              label: 'Confirm Pickup',
              icon: Icons.check_circle_outline_rounded,
              color: AppTheme.warning,
              onTap: () =>
                  provider.updateOrderStatus(orderID, 'Ready'),
            )
          else if (canDeliver)
            _ActionButton(
              label: 'Mark as Delivered',
              icon: Icons.done_all_rounded,
              color: AppTheme.accent,
              onTap: () => provider.updateOrderStatus(
                  orderID, 'Delivered'),
            ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, String label) = switch (status) {
      'Pending' => (
          const Color(0xFFFEF3C7).withValues(alpha: 0.1),
          const Color(0xFFD97706),
          'Waiting for restaurant'
        ),
      'In Progress' => (
          AppTheme.primary.withValues(alpha: 0.1),
          AppTheme.primary,
          'Head to restaurant'
        ),
      'Ready' => (
          AppTheme.warning.withValues(alpha: 0.1),
          AppTheme.warning,
          'Order ready — deliver now'
        ),
      'Delivered' => (
          AppTheme.accent.withValues(alpha: 0.1),
          AppTheme.accent,
          'Delivered'
        ),
      _ => (
          AppTheme.surfaceLight,
          AppTheme.textSecondary,
          status
        ),
    };

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
                color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: fg,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        icon: Icon(icon, size: 18),
        label: Text(label,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

// ── Recent deliveries ─────────────────────────────────────────────────────────

class _RecentDeliveries extends StatelessWidget {
  final RiderProvider provider;
  const _RecentDeliveries({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Deliveries',
            style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),

        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('driverUID',
                  isEqualTo: provider.rider?.uid)
              .where('status', isEqualTo: 'Delivered')
              .orderBy('orderTime', descending: true)
              .limit(5)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return _emptyState();
            }
            if (snapshot.data!.docs.isEmpty) {
              return _emptyState();
            }

            return Column(
              children: snapshot.data!.docs.map((doc) {
                final data =
                    doc.data() as Map<String, dynamic>;
                return _DeliveryTile(data: data);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: const Column(
        children: [
          Icon(Icons.history_rounded,
              color: AppTheme.textSecondary, size: 36),
          SizedBox(height: 8),
          Text('No recent deliveries',
              style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          SizedBox(height: 4),
          Text('Go online to start receiving orders',
              style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12)),
        ],
      ),
    );
  }
}

class _DeliveryTile extends StatelessWidget {
  final Map<String, dynamic> data;
  const _DeliveryTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final String restaurant =
        (data['restaurantName'] as String?) ?? 'Restaurant';
    final String total =
        '${data['totalAmount'] ?? '0.00'} zł';
    final String orderType =
        data['orderType'] == 'pickup' ? 'Pickup' : 'Delivery';
    final ts = data['orderTime'];
    final String time = ts is Timestamp
        ? _formatTime(ts.toDate())
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check_circle_rounded,
                color: AppTheme.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(restaurant,
                    style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                Text('$orderType · $time',
                    style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11)),
              ],
            ),
          ),
          Text(total,
              style: const TextStyle(
                  color: AppTheme.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}';
  }
}