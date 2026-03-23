import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/providers/rider_provider.dart';
import 'package:rider_app/utils/app_theme.dart';
import 'package:rider_app/widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          TextButton(
            onPressed: () {
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
                          style: TextStyle(color: AppTheme.textSecondary)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Provider.of<RiderProvider>(context, listen: false)
                            .signOut();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.danger),
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Sign Out',
                style: TextStyle(color: AppTheme.danger)),
          ),
        ],
      ),
      body: Consumer<RiderProvider>(
        builder: (context, provider, _) {
          final rider = provider.rider;
          if (rider == null) {
            return const Center(
                child: CircularProgressIndicator(color: AppTheme.primary));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _ProfileHeader(rider: rider),
                const SizedBox(height: 24),
                _StatsGrid(rider: rider),
                const SizedBox(height: 24),
                _SettingsSection(provider: provider),
              ],
            ),
          );
        },
      ),
    );
  }
}

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
                rider.name.isNotEmpty ? rider.name[0].toUpperCase() : 'R',
                style: const TextStyle(
                  color: Colors.black,
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
                Text(rider.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 2),
                Text(rider.phone,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 13)),
                const SizedBox(height: 6),
                RiderStatusBadge(isOnline: rider.isOnline),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final RiderModel rider;
  const _StatsGrid({required this.rider});

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
          value: rider.totalDeliveries.toString(),
          icon: Icons.check_circle_outline,
          color: AppTheme.primary,
        ),
        _StatTile(
          label: 'Total Earnings',
          value: 'zł ${rider.totalEarnings.toStringAsFixed(2)}',
          icon: Icons.account_balance_wallet_outlined,
          color: AppTheme.warning,
        ),
        _StatTile(
          label: 'Rating',
          value: '${rider.rating.toStringAsFixed(1)} ★',
          icon: Icons.star_outline,
          color: AppTheme.info,
        ),
        _StatTile(
          label: 'Vehicle',
          value: _vehicleLabel(rider.vehicleType),
          icon: Icons.two_wheeler,
          color: AppTheme.danger,
        ),
      ],
    );
  }

  String _vehicleLabel(String type) {
    switch (type) {
      case 'BIKE':
        return 'Bicycle';
      case 'SCOOTER':
        return 'Scooter';
      case 'CAR':
        return 'Car';
      default:
        return type;
    }
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatTile(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
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
                      color: AppTheme.textSecondary, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final RiderProvider provider;
  const _SettingsSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            onTap: () {},
          ),
          const AppDivider(),
          _SettingsTile(
            icon: Icons.language,
            label: 'Language',
            trailing: const Text('English',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            onTap: () {},
          ),
          const AppDivider(),
          _SettingsTile(
            icon: Icons.help_outline,
            label: 'Support',
            onTap: () {},
          ),
          const AppDivider(),
          _SettingsTile(
            icon: Icons.info_outline,
            label: 'App Version',
            trailing: const Text('1.0.0',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
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
  const _SettingsTile(
      {required this.icon, required this.label, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary, size: 20),
      title: Text(label,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14)),
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right,
                  color: AppTheme.textSecondary, size: 18)
              : null),
      onTap: onTap,
    );
  }
}
