// lib/widgets/job_request_sheet.dart
//
// Bottom sheet shown when a DISPATCH_JOB arrives (FCM or Firestore).
// DispatchJob is defined in rider_provider.dart — import from there.
// Fields used: storeName, storeAddress, customerName, customerAddress,
//   items, riderEarnings, finalTotal, distanceKm, paymentMethod.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rider_app/providers/rider_provider.dart';
import 'package:rider_app/utils/app_theme.dart';

class JobRequestSheet extends StatefulWidget {
  final DispatchJob job;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final int timeoutSeconds;

  const JobRequestSheet({
    super.key,
    required this.job,
    required this.onAccept,
    required this.onReject,
    this.timeoutSeconds = 30,
  });

  @override
  State<JobRequestSheet> createState() =>
      _JobRequestSheetState();
}

class _JobRequestSheetState extends State<JobRequestSheet>
    with SingleTickerProviderStateMixin {
  late int _secondsLeft;
  Timer? _timer;
  late AnimationController _pulse;
  bool _showItems = false;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.timeoutSeconds;
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        t.cancel();
        widget.onReject();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final progress = _secondsLeft / widget.timeoutSeconds;
    final isLowTime = _secondsLeft <= 10;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.4),
            width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.15),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Timer bar ──────────────────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24)),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: AppTheme.divider,
              valueColor: AlwaysStoppedAnimation(
                isLowTime ? AppTheme.danger : AppTheme.primary,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                // ── Header ────────────────────────────────────────
                Row(
                  children: [
                    AnimatedBuilder(
                      animation: _pulse,
                      builder: (_, __) => Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primary.withValues(
                              alpha: 0.1 + 0.12 * _pulse.value),
                        ),
                        child: const Icon(
                            Icons.delivery_dining_rounded,
                            color: AppTheme.primary,
                            size: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text('New Delivery Request',
                              style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16)),
                          Text(
                            isLowTime
                                ? '⚠ Auto-reject in $_secondsLeft s'
                                : 'Expires in $_secondsLeft seconds',
                            style: TextStyle(
                              color: isLowTime
                                  ? AppTheme.danger
                                  : AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Earnings badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.primary
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppTheme.primary
                                .withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        'zł ${job.riderEarnings?.toStringAsFixed(2) ?? '--'}',
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Route ─────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _RouteRow(
                        icon: Icons.store_rounded,
                        iconColor: AppTheme.info,
                        label: 'Pick up at',
                        value: job.storeName,
                        sub: job.storeAddress,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 11),
                        child: Container(
                          width: 2,
                          height: 20,
                          color: AppTheme.divider,
                        ),
                      ),
                      _RouteRow(
                        icon: Icons.location_on_rounded,
                        iconColor: AppTheme.danger,
                        label: 'Deliver to',
                        value:
                            job.customerName ?? 'Customer',
                        sub: job.customerAddress,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ── Stats row ─────────────────────────────────────
                Row(
                  children: [
                    _StatChip(
                      icon: Icons.straighten_rounded,
                      label: job.distanceKm != null
                          ? '${job.distanceKm!.toStringAsFixed(1)} km'
                          : '-- km',
                      color: AppTheme.warning,
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      icon: _isCash(job.paymentMethod)
                          ? Icons.payments_outlined
                          : Icons.credit_card_rounded,
                      label: _isCash(job.paymentMethod)
                          ? 'Cash · zł${job.finalTotal?.toStringAsFixed(2) ?? '--'}'
                          : 'Card · Paid',
                      color: _isCash(job.paymentMethod)
                          ? AppTheme.warning
                          : AppTheme.primary,
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      icon: Icons.receipt_long_outlined,
                      label:
                          '${job.items.length} item${job.items.length == 1 ? '' : 's'}',
                      color: AppTheme.info,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ── Items expandable ──────────────────────────────
                GestureDetector(
                  onTap: () => setState(
                      () => _showItems = !_showItems),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.fastfood_outlined,
                            color: AppTheme.textSecondary,
                            size: 16),
                        const SizedBox(width: 8),
                        Text(
                          _showItems
                              ? 'Hide order items'
                              : 'See order items',
                          style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13),
                        ),
                        const Spacer(),
                        Icon(
                          _showItems
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons
                                  .keyboard_arrow_down_rounded,
                          color: AppTheme.textSecondary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                if (_showItems && job.items.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: job.items
                          .map((item) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                        vertical: 5),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: AppTheme.primary
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(
                                                6),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                            color:
                                                AppTheme.primary,
                                            fontWeight:
                                                FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Text(item.name,
                                              style: const TextStyle(
                                                  color: AppTheme
                                                      .textPrimary,
                                                  fontSize: 13,
                                                  fontWeight:
                                                      FontWeight
                                                          .w500)),
                                          if (item.displayOptions
                                              .isNotEmpty)
                                            Text(
                                                item.displayOptions,
                                                style: const TextStyle(
                                                    color: AppTheme
                                                        .textSecondary,
                                                    fontSize: 11)),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'zł ${(item.price * item.quantity).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color:
                                            AppTheme.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(4, 8, 4, 0),
                    child: Row(
                      children: [
                        const Text('Order total',
                            style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13)),
                        const Spacer(),
                        Text(
                          'zł ${job.finalTotal?.toStringAsFixed(2) ?? '--'}',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // ── Buttons ───────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onReject,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.danger,
                          side: const BorderSide(
                              color: AppTheme.danger),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12)),
                        ),
                        child: const Text('Reject',
                            style: TextStyle(
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: widget.onAccept,
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isCash(String method) =>
      method.toLowerCase() == 'cash';
}

// ── Route row ─────────────────────────────────────────────────────────────────

class _RouteRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? sub;

  const _RouteRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 10)),
              Text(value,
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
              if (sub != null)
                Text(sub!,
                    style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Stat chip ─────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}