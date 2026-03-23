import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/providers/rider_provider.dart';
import 'package:rider_app/providers/rider_stats_provider.dart';
import 'package:rider_app/utils/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: const Text('Sign Out',
                style: TextStyle(color: AppTheme.danger)),
          ),
        ],
      ),
      body: Consumer2<RiderProvider, RiderStatsProvider>(
        builder: (context, provider, stats, _) {
          final rider = provider.rider;
          if (rider == null) {
            return const Center(
              child: CircularProgressIndicator(
                  color: AppTheme.primary),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _ProfileHeader(rider: rider),
                const SizedBox(height: 20),
                _StatsGrid(rider: rider, stats: stats),
                const SizedBox(height: 20),
                _EarningsBreakdown(stats: stats),
                const SizedBox(height: 20),
                _SettingsSection(provider: provider),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out',
            style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style:
                    TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<RiderProvider>(context,
                      listen: false)
                  .signOut();
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                backgroundColor: AppTheme.danger),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

// ── Profile header ────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final RiderModel rider;
  const _ProfileHeader({required this.rider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                rider.name.isNotEmpty
                    ? rider.name[0].toUpperCase()
                    : 'R',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rider.name,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  rider.phone,
                  style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13),
                ),
                const SizedBox(height: 6),
                _StatusBadge(isOnline: rider.isOnline),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isOnline;
  const _StatusBadge({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isOnline ? AppTheme.accent : AppTheme.textSecondary)
            .withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isOnline
                  ? AppTheme.accent
                  : AppTheme.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              color: isOnline
                  ? AppTheme.accent
                  : AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats grid — live data from RiderStatsProvider ────────────────────────────

class _StatsGrid extends StatelessWidget {
  final RiderModel rider;
  final RiderStatsProvider stats;
  const _StatsGrid({required this.rider, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _StatTile(
          label: 'Total Deliveries',
          value: stats.totalDeliveries.toString(),
          icon: Icons.check_circle_outline_rounded,
          color: AppTheme.primary,
        ),
        _StatTile(
          label: 'Total Earnings',
          value: stats.totalEarningsFormatted,
          icon: Icons.account_balance_wallet_outlined,
          color: AppTheme.warning,
        ),
        _StatTile(
          label: 'Avg Rating',
          value: stats.totalRatings > 0
              ? '${stats.avgDriverRating.toStringAsFixed(1)} ★'
              : 'No ratings',
          icon: Icons.star_outline_rounded,
          color: AppTheme.info,
        ),
        _StatTile(
          label: 'Vehicle',
          value: _vehicleLabel(rider.vehicleType),
          icon: Icons.two_wheeler_rounded,
          color: AppTheme.danger,
        ),
      ],
    );
  }

  String _vehicleLabel(String type) {
    return switch (type) {
      'BIKE'    => 'Bicycle',
      'SCOOTER' => 'Scooter',
      'CAR'     => 'Car',
      _         => type,
    };
  }
}

class _StatTile extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  )),
              Text(label,
                  style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Earnings breakdown ────────────────────────────────────────────────────────

class _EarningsBreakdown extends StatelessWidget {
  final RiderStatsProvider stats;
  const _EarningsBreakdown({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Earnings Breakdown',
              style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _EarningsRow(
              label: 'Today',
              earnings: stats.todayEarningsFormatted,
              deliveries: stats.todayDeliveries),
          const Divider(color: AppTheme.divider, height: 20),
          _EarningsRow(
              label: 'This week',
              earnings: stats.weekEarningsFormatted,
              deliveries: stats.weekDeliveries),
          const Divider(color: AppTheme.divider, height: 20),
          _EarningsRow(
              label: 'This month',
              earnings: stats.monthEarningsFormatted,
              deliveries: stats.monthDeliveries),
          if (stats.totalDeliveries > 0) ...[
            const Divider(color: AppTheme.divider, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Avg per delivery',
                    style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13)),
                Text(
                  '${stats.avgEarningsPerDelivery.toStringAsFixed(2)} zł',
                  style: const TextStyle(
                      color: AppTheme.accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _EarningsRow extends StatelessWidget {
  final String label, earnings;
  final int deliveries;
  const _EarningsRow({
    required this.label,
    required this.earnings,
    required this.deliveries,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13)),
        ),
        Text(
          '$deliveries deliveries',
          style: const TextStyle(
              color: AppTheme.textSecondary, fontSize: 12),
        ),
        const SizedBox(width: 12),
        Text(
          earnings,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ── Settings section ──────────────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  final RiderProvider provider;
  const _SettingsSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            onTap: () {},
          ),
          const Divider(
              height: 1,
              color: AppTheme.divider,
              indent: 16,
              endIndent: 16),
          _SettingsTile(
            icon: Icons.help_outline_rounded,
            label: 'Support',
            onTap: () {},
          ),
          const Divider(
              height: 1,
              color: AppTheme.divider,
              indent: 16,
              endIndent: 16),
          const _SettingsTile(
            icon: Icons.info_outline_rounded,
            label: 'App Version',
            trailing: Text('1.0.0',
                style: TextStyle(
                    color: AppTheme.textSecondary, fontSize: 13)),
            onTap: null,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          Icon(icon, color: AppTheme.textSecondary, size: 20),
      title: Text(label,
          style: const TextStyle(
              color: AppTheme.textPrimary, fontSize: 14)),
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right_rounded,
                  color: AppTheme.textSecondary, size: 18)
              : null),
      onTap: onTap,
    );
  }
}