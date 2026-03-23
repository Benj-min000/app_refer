// lib/providers/rider_stats_provider.dart
//
// Real-time stats for a single rider, computed from orders/{id}
// where driverUID == riderUID and status == 'Delivered'.
//
// Mount above HomeScreen once the rider is authenticated:
//
//   ChangeNotifierProvider(
//     create: (_) => RiderStatsProvider(riderUID),
//     child: ...,
//   )
//
//   final stats = context.watch<RiderStatsProvider>();

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RiderStatsProvider extends ChangeNotifier {
  final String riderUID;

  RiderStatsProvider(this.riderUID) {
    _subscribe();
  }

  // ── Loading ────────────────────────────────────────────────────────────────

  bool _loading = true;
  bool get isLoading => _loading;

  // ── Today ──────────────────────────────────────────────────────────────────

  int    todayDeliveries = 0;
  double todayEarnings   = 0;

  // ── This week (Mon–Sun) ────────────────────────────────────────────────────

  int    weekDeliveries = 0;
  double weekEarnings   = 0;

  // ── This month ─────────────────────────────────────────────────────────────

  int    monthDeliveries = 0;
  double monthEarnings   = 0;

  // ── All time ───────────────────────────────────────────────────────────────

  int    totalDeliveries = 0;
  double totalEarnings   = 0;
  double avgEarningsPerDelivery = 0;

  // ── Earnings by day — last 7 days ──────────────────────────────────────────
  // Key: 'Mon', 'Tue' … 'Sun'  Value: earnings that day

  Map<String, double> earningsByDay   = {};
  Map<String, int>    deliveriesByDay = {};

  // ── Ratings ────────────────────────────────────────────────────────────────

  double avgDriverRating = 0;
  int    totalRatings    = 0;

  // ── Subscription ───────────────────────────────────────────────────────────

  StreamSubscription? _sub;

  void _subscribe() {
    // Stream all delivered orders for this rider.
    // Firestore index needed: orders on driverUID ASC + status ASC + deliveredAt DESC
    _sub = FirebaseFirestore.instance
        .collection('orders')
        .where('driverUID', isEqualTo: riderUID)
        .where('status', isEqualTo: 'Delivered')
        .orderBy('deliveredAt', descending: true)
        .snapshots()
        .listen((snap) {
      _compute(snap.docs);
    }, onError: (e) {
      debugPrint('RiderStatsProvider error: $e');
      _loading = false;
      notifyListeners();
    });
  }

  void _compute(List<QueryDocumentSnapshot> docs) {
    final now        = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    // Start of current week (Monday)
    final weekStart = todayStart.subtract(
        Duration(days: now.weekday - 1));

    // Start of current month
    final monthStart = DateTime(now.year, now.month, 1);

    // 7-day buckets — index 0 = 6 days ago, index 6 = today
    final List<double> dayEarnings   = List.filled(7, 0);
    final List<int>    dayDeliveries = List.filled(7, 0);

    int    _totalDeliveries = 0;
    double _totalEarnings   = 0;
    int    _todayDeliveries = 0;
    double _todayEarnings   = 0;
    int    _weekDeliveries  = 0;
    double _weekEarnings    = 0;
    int    _monthDeliveries = 0;
    double _monthEarnings   = 0;
    double ratingSum        = 0;
    int    ratingCount      = 0;

    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;

      // Parse delivery fee as rider's earning per trip
      final fee = double.tryParse(
              data['deliveryFee']?.toString() ?? '0') ??
          0.0;

      // Parse delivered timestamp
      DateTime? deliveredAt;
      final ts = data['deliveredAt'];
      if (ts is Timestamp) deliveredAt = ts.toDate();

      _totalDeliveries++;
      _totalEarnings += fee;

      if (deliveredAt != null) {
        if (!deliveredAt.isBefore(todayStart)) {
          _todayDeliveries++;
          _todayEarnings += fee;
        }
        if (!deliveredAt.isBefore(weekStart)) {
          _weekDeliveries++;
          _weekEarnings += fee;
        }
        if (!deliveredAt.isBefore(monthStart)) {
          _monthDeliveries++;
          _monthEarnings += fee;
        }

        // 7-day bucket
        final diff = now.difference(deliveredAt).inDays;
        if (diff >= 0 && diff < 7) {
          final bucketIndex = 6 - diff;
          dayEarnings[bucketIndex]   += fee;
          dayDeliveries[bucketIndex] += 1;
        }
      }

      // Driver rating
      final dr = (data['driverRating'] as num?)?.toDouble();
      if (dr != null && dr > 0) {
        ratingSum  += dr;
        ratingCount++;
      }
    }

    // Build day-label maps
    final Map<String, double> byDay        = {};
    final Map<String, int>    byDayCount   = {};
    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: 6 - i));
      final label = dayLabels[day.weekday - 1];
      byDay[label]      = dayEarnings[i];
      byDayCount[label] = dayDeliveries[i];
    }

    // Commit
    todayDeliveries       = _todayDeliveries;
    todayEarnings         = _round(_todayEarnings);
    weekDeliveries        = _weekDeliveries;
    weekEarnings          = _round(_weekEarnings);
    monthDeliveries       = _monthDeliveries;
    monthEarnings         = _round(_monthEarnings);
    totalDeliveries       = _totalDeliveries;
    totalEarnings         = _round(_totalEarnings);
    avgEarningsPerDelivery = _totalDeliveries > 0
        ? _round(_totalEarnings / _totalDeliveries)
        : 0;
    earningsByDay         = byDay;
    deliveriesByDay       = byDayCount;
    avgDriverRating       = ratingCount > 0
        ? double.parse(
            (ratingSum / ratingCount).toStringAsFixed(1))
        : 0;
    totalRatings          = ratingCount;
    _loading              = false;

    notifyListeners();
  }

  double _round(double v) =>
      double.parse(v.toStringAsFixed(2));

  // ── Convenience getters ────────────────────────────────────────────────────

  /// Formatted earnings string e.g. "42.50 zł"
  String get todayEarningsFormatted =>
      '${todayEarnings.toStringAsFixed(2)} zł';
  String get weekEarningsFormatted =>
      '${weekEarnings.toStringAsFixed(2)} zł';
  String get monthEarningsFormatted =>
      '${monthEarnings.toStringAsFixed(2)} zł';
  String get totalEarningsFormatted =>
      '${totalEarnings.toStringAsFixed(2)} zł';

  /// Sorted list of [day, earnings] for the chart
  List<MapEntry<String, double>> get earningsByDayEntries =>
      earningsByDay.entries.toList();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}