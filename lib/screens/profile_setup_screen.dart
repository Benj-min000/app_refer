import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/services/auth_service.dart';
import 'package:rider_app/providers/rider_provider.dart';
import 'package:rider_app/utils/app_theme.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _nameController =
      TextEditingController();
  String _vehicleType = 'SCOOTER';
  bool _isLoading = false;
  String? _error;

  final List<Map<String, dynamic>> _vehicles = [
    {'type': 'BIKE',    'label': 'Bicycle', 'icon': Icons.pedal_bike},
    {'type': 'SCOOTER', 'label': 'Scooter', 'icon': Icons.electric_scooter},
    {'type': 'CAR',     'label': 'Car',     'icon': Icons.directions_car},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Complete\nYour Profile',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(height: 1.15, fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                'Tell us a bit about yourself',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),

              // Name field
              TextField(
                controller: _nameController,
                style:
                    const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline,
                      color: AppTheme.textSecondary),
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Vehicle Type',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                        fontSize: 15,
                        color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 12),

              // Vehicle selector
              Row(
                children: _vehicles.map((v) {
                  final bool isSelected =
                      _vehicleType == v['type'];
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(
                            () => _vehicleType = v['type']),
                        child: AnimatedContainer(
                          duration:
                              const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              vertical: 18),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primary
                                    .withValues(alpha: 0.15)
                                : AppTheme.surfaceLight,
                            borderRadius:
                                BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primary
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                v['icon'] as IconData,
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.textSecondary,
                                size: 28,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                v['label'] as String,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppTheme.primary
                                      : AppTheme.textSecondary,
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: const TextStyle(
                      color: AppTheme.danger, fontSize: 13),
                ),
              ],

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white),
                        )
                      : const Text('Start Delivering'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Please enter your name');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final phone =
          _authService.currentUser?.phoneNumber ?? '';
      await _authService.ensureRiderProfile(
        name: name,
        phone: phone,
        vehicleType: _vehicleType,
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(
          () => _error = 'Failed to save profile. Try again.');
    }

    if (mounted) setState(() => _isLoading = false);
  }
}