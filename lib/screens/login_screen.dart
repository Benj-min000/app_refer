// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'profile_setup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _otpSent = false;
  bool _isLoading = false;
  String? _verificationId;
  String? _error;

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
              const SizedBox(height: 60),
              _buildHeader(),
              const SizedBox(height: 48),
              _buildForm(),
              if (_error != null) ...[
                const SizedBox(height: 16),
                _buildError(),
              ],
              const Spacer(),
              _buildFooter(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.delivery_dining, color: AppTheme.primary, size: 30),
        ),
        const SizedBox(height: 24),
        Text(
          'Rider\nPortal',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            height: 1.1,
            fontSize: 36,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _otpSent
              ? 'Enter the code sent to your phone'
              : 'Sign in to start delivering',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        if (!_otpSent) ...[
          _PhoneField(controller: _phoneController),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendOtp,
              child: _isLoading
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.black))
                  : const Text('Send Code'),
            ),
          ),
        ] else ...[
          _OtpField(controller: _otpController),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              child: _isLoading
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.black))
                  : const Text('Verify & Sign In'),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => setState(() {
              _otpSent = false;
              _otpController.clear();
              _error = null;
            }),
            child: const Text('Change phone number',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
        ],
      ],
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.danger.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.danger.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.danger, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(_error!,
                style: const TextStyle(color: AppTheme.danger, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text(
        'Poland Delivery Platform · Rider Edition',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 9) {
      setState(() => _error = 'Enter a valid phone number');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Format as +48 Polish number if not starting with +
    final formattedPhone = phone.startsWith('+') ? phone : '+48$phone';

    await _authService.sendOtp(
      phoneNumber: formattedPhone,
      onCodeSent: (verificationId) {
        setState(() {
          _verificationId = verificationId;
          _otpSent = true;
          _isLoading = false;
        });
      },
      onError: (error) {
        setState(() {
          _error = error;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _verifyOtp() async {
    if (_verificationId == null) return;
    final code = _otpController.text.trim();
    if (code.length < 6) {
      setState(() => _error = 'Enter the 6-digit code');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _authService.verifyOtp(
        verificationId: _verificationId!,
        smsCode: code,
      );
      // Auth state listener in RiderProvider will handle navigation
    } catch (e) {
      setState(() {
        _error = 'Invalid code. Please try again.';
        _isLoading = false;
      });
    }
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        hintText: '48 or +48...',
        prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.textSecondary),
      ),
    );
  }
}

class _OtpField extends StatelessWidget {
  final TextEditingController controller;
  const _OtpField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 6,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 28,
        letterSpacing: 12,
        fontWeight: FontWeight.w700,
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        labelText: 'Verification Code',
        counterText: '',
      ),
    );
  }
}
