import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Bottom sheet showing a restaurant's full rating breakdown.
///
/// Displays:
///   • Average score + star visual
///   • 5→1 star distribution bars
///   • Weekly average trend line chart (last 7 days)
///   • Recent individual reviews
///
/// Usage:
///   showModalBottomSheet(
///     context: context,
///     isScrollControlled: true,
///     backgroundColor: Colors.transparent,
///     builder: (_) => RatingSheet(
///       restaurantID: id,
///       restaurantName: name,
///       logoUrl: logoUrl,
///     ),
///   );
class RatingSheet extends StatefulWidget {
  final String restaurantID;
  final String restaurantName;
  final String logoUrl;

  const RatingSheet({
    super.key,
    required this.restaurantID,
    required this.restaurantName,
    required this.logoUrl,
  });

  @override
  State<RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<RatingSheet> {
  //  Data loaded once
  bool _loading = true;
  double _avgRating = 0;
  int _totalRatings = 0;
  Map<int, int> _distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
  List<Map<String, dynamic>> _recentReviews = [];

  // Weekly buckets: index 0 = 6 days ago, index 6 = today
  List<double> _weeklyAvg = List.filled(7, 0);
  List<String> _weeklyLabels = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      // 1. Restaurant aggregates
      final restDoc = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.restaurantID)
          .get();
      final restData = restDoc.data() ?? {};
      _avgRating = ((restData['avgRating'] as num?) ?? 0).toDouble();
      _totalRatings = (restData['totalRatings'] as int?) ?? 0;

      // 2. Individual ratings from orders (last 100)
      final orderSnap = await FirebaseFirestore.instance
          .collection('orders')
          .where('restaurantID', isEqualTo: widget.restaurantID)
          .where('status', isEqualTo: 'Delivered')
          .orderBy('ratedAt', descending: true)
          .limit(100)
          .get();

      final Map<int, int> dist = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
      final List<Map<String, dynamic>> reviews = [];

      // 7-day buckets
      final now = DateTime.now();
      final Map<int, List<double>> buckets = {};
      for (int i = 0; i < 7; i++) buckets[i] = [];

      for (final doc in orderSnap.docs) {
        final data = doc.data();
        final int? r = (data['rating'] as num?)?.toInt();
        if (r == null || r < 1 || r > 5) continue;

        dist[r] = (dist[r] ?? 0) + 1;

        // Recent reviews (with comment)
        final String comment = (data['ratingComment'] as String?) ?? '';
        if (reviews.length < 5) {
          reviews.add({
            'rating': r,
            'comment': comment,
            'ratedAt': data['ratedAt'],
            'userName': data['customerName'] ?? 'Customer',
          });
        }

        // Weekly bucket
        final ratedAt = data['ratedAt'];
        if (ratedAt is Timestamp) {
          final dt = ratedAt.toDate();
          final diff = now.difference(dt).inDays;
          if (diff < 7) {
            final bucketIndex = 6 - diff;
            buckets[bucketIndex]!.add(r.toDouble());
          }
        }
      }

      // Compute weekly averages
      final List<double> weekly = [];
      final List<String> labels = [];
      for (int i = 0; i < 7; i++) {
        final day = now.subtract(Duration(days: 6 - i));
        labels.add(_dayLabel(day));
        final vals = buckets[i]!;
        weekly
            .add(vals.isEmpty ? 0 : vals.reduce((a, b) => a + b) / vals.length);
      }

      setState(() {
        _distribution = dist;
        _recentReviews = reviews;
        _weeklyAvg = weekly;
        _weeklyLabels = labels;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  String _dayLabel(DateTime dt) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dt.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Color(0xFFF6F6FB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          _buildHeader(context),

          // Content
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.redAccent))
                : _totalRatings == 0
                    ? _buildEmpty()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Summary + distribution
                            _buildSummaryCard(),
                            const SizedBox(height: 16),
                            // Weekly trend
                            _buildTrendCard(),
                            const SizedBox(height: 16),
                            // Recent reviews
                            if (_recentReviews.isNotEmpty) ...[
                              _buildReviewsCard(),
                            ],
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  //  Header

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          if (widget.logoUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(widget.logoUrl,
                  width: 40, height: 40, fit: BoxFit.cover),
            )
          else
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child:
                  Icon(Icons.restaurant_rounded, color: Colors.grey.shade300),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.restaurantName,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800)),
                Text('Ratings & Reviews',
                    style:
                        TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close_rounded, color: Colors.grey.shade400),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  //  Summary card

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Big number
          Column(
            children: [
              Text(
                _avgRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              _StarRow(rating: _avgRating, size: 16),
              const SizedBox(height: 4),
              Text(
                '$_totalRatings ${_totalRatings == 1 ? 'review' : 'reviews'}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),

          const SizedBox(width: 20),

          // Distribution bars
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final count = _distribution[star] ?? 0;
                final pct = _totalRatings == 0 ? 0.0 : count / _totalRatings;
                return _DistributionBar(star: star, pct: pct, count: count);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  //  Trend card

  Widget _buildTrendCard() {
    final bool hasData = _weeklyAvg.any((v) => v > 0);

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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.trending_up_rounded,
                    size: 14, color: Colors.redAccent),
              ),
              const SizedBox(width: 8),
              const Text('Rating Trend — Last 7 Days',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 20),
          if (!hasData)
            Center(
              child: Text('Not enough data yet',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
            )
          else
            SizedBox(
              height: 160,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 5,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: Colors.grey.shade100,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 24,
                        getTitlesWidget: (v, _) => Text(
                          v.toInt().toString(),
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (v, _) {
                          final i = v.toInt();
                          if (i < 0 || i >= _weeklyLabels.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            _weeklyLabels[i],
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey.shade400),
                          );
                        },
                      ),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (spots) => spots
                          .map((s) => LineTooltipItem(
                                s.y == 0 ? 'No data' : s.y.toStringAsFixed(1),
                                const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600),
                              ))
                          .toList(),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        7,
                        (i) => FlSpot(i.toDouble(),
                            _weeklyAvg[i] == 0 ? 0 : _weeklyAvg[i]),
                      ),
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: Colors.redAccent,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                          radius: spot.y == 0 ? 0 : 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.redAccent,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.redAccent.withValues(alpha: 0.06),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  //  Reviews list

  Widget _buildReviewsCard() {
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.rate_review_rounded,
                    size: 14, color: Colors.redAccent),
              ),
              const SizedBox(width: 8),
              const Text('Recent Reviews',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 16),
          ..._recentReviews.map((r) => _ReviewTile(data: r)),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_border_rounded,
              size: 56, color: Colors.grey.shade200),
          const SizedBox(height: 12),
          Text('No reviews yet',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade400)),
          const SizedBox(height: 4),
          Text('Be the first to rate this restaurant',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}

//  Sub-widgets

class _StarRow extends StatelessWidget {
  final double rating;
  final double size;
  const _StarRow({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        final half = !filled && i < rating;
        return Icon(
          filled
              ? Icons.star_rounded
              : half
                  ? Icons.star_half_rounded
                  : Icons.star_outline_rounded,
          size: size,
          color: Colors.amber.shade600,
        );
      }),
    );
  }
}

class _DistributionBar extends StatelessWidget {
  final int star, count;
  final double pct;
  const _DistributionBar(
      {required this.star, required this.pct, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$star',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          const SizedBox(width: 4),
          Icon(Icons.star_rounded, size: 10, color: Colors.amber.shade600),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 6,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(
                  star >= 4
                      ? const Color(0xFF00C48C)
                      : star == 3
                          ? Colors.amber.shade600
                          : Colors.redAccent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 20,
            child: Text('$count',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ReviewTile({required this.data});

  String _formatDate(dynamic ts) {
    if (ts == null) return '';
    try {
      final dt = ts is Timestamp ? ts.toDate() : DateTime.now();
      final diff = DateTime.now().difference(dt);
      if (diff.inDays == 0) return 'Today';
      if (diff.inDays == 1) return 'Yesterday';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final int rating = (data['rating'] as int?) ?? 0;
    final String comment = (data['comment'] as String?) ?? '';
    final String name = (data['userName'] as String?) ?? 'Customer';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.redAccent),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                    Text(_formatDate(data['ratedAt']),
                        style: TextStyle(
                            fontSize: 10, color: Colors.grey.shade400)),
                  ],
                ),
              ),
              _StarRow(rating: rating.toDouble(), size: 12),
            ],
          ),
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(comment,
                style: TextStyle(
                    fontSize: 12, color: Colors.grey.shade600, height: 1.4)),
          ],
          if (data != _ReviewTile._sentinel) ...[
            const SizedBox(height: 12),
            Divider(height: 1, color: Colors.grey.shade100),
          ],
        ],
      ),
    );
  }

  static const _sentinel = {};
}
