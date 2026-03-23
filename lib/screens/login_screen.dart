import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../utils/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final List<FocusNode> _otpFocus =
      List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _otpBoxes =
      List.generate(6, (_) => TextEditingController());

  bool _otpSent = false;
  bool _isLoading = false;
  String? _verificationId;
  String? _error;
  int _resendSeconds = 0;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    for (final f in _otpFocus) {
      f.dispose();
    }
    for (final c in _otpBoxes) {
      c.dispose();
    }
    super.dispose();
  }

  // ── OTP send ───────────────────────────────────────────────────────────────

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

    final formatted =
        phone.startsWith('+') ? phone : '+48$phone';

    await _authService.sendOtp(
      phoneNumber: formatted,
      onCodeSent: (verificationId) {
        setState(() {
          _verificationId = verificationId;
          _otpSent = true;
          _isLoading = false;
          _resendSeconds = 60;
        });
        _startResendTimer();
      },
      onError: (error) {
        setState(() {
          _error = error;
          _isLoading = false;
        });
      },
    );
  }

  void _startResendTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _resendSeconds--);
      return _resendSeconds > 0;
    });
  }

  // ── OTP verify ─────────────────────────────────────────────────────────────

  Future<void> _verifyOtp() async {
    if (_verificationId == null) return;
    final code =
        _otpBoxes.map((c) => c.text).join();
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
      // RiderProvider auth listener handles navigation
    } catch (e) {
      setState(() {
        _error = 'Invalid code. Please try again.';
        _isLoading = false;
      });
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delivery_dining_rounded,
                    color: AppTheme.primary, size: 32),
              ),
              const SizedBox(height: 28),

              // Title
              Text(
                _otpSent ? 'Verify Phone' : 'Rider Portal',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _otpSent
                    ? 'Enter the 6-digit code sent to your phone'
                    : 'Sign in to start delivering for Freequick',
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14),
              ),

              const SizedBox(height: 40),

              // Form
              if (!_otpSent) _buildPhoneStep(),
              if (_otpSent) _buildOtpStep(),

              // Error
              if (_error != null) ...[
                const SizedBox(height: 16),
                _buildError(),
              ],

              const SizedBox(height: 48),

              // Footer
              Center(
                child: Text(
                  'Freequick · Rider Edition · Poland',
                  style: TextStyle(
                      color: AppTheme.textSecondary.withValues(alpha: 0.6),
                      fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Phone step ─────────────────────────────────────────────────────────────

  Widget _buildPhoneStep() {
    return Column(
      children: [
        // Phone field
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              // Country prefix
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                        color: AppTheme.divider, width: 1),
                  ),
                ),
                child: const Text(
                  '🇵🇱 +48',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                      color: AppTheme.textPrimary, fontSize: 16),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                  ],
                  decoration: const InputDecoration(
                    hintText: '555 123 456',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onSubmitted: (_) => _sendOtp(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _sendOtp,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Text('Send Code'),
          ),
        ),
      ],
    );
  }

  // ── OTP step ───────────────────────────────────────────────────────────────

  Widget _buildOtpStep() {
    return Column(
      children: [
        // 6 boxes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (i) {
            return SizedBox(
              width: 46,
              height: 56,
              child: TextField(
                controller: _otpBoxes[i],
                focusNode: _otpFocus[i],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: AppTheme.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppTheme.primary, width: 2),
                  ),
                ),
                onChanged: (v) {
                  if (v.isNotEmpty && i < 5) {
                    _otpFocus[i + 1].requestFocus();
                  } else if (v.isEmpty && i > 0) {
                    _otpFocus[i - 1].requestFocus();
                  }
                  // Auto-submit when all 6 filled
                  final full =
                      _otpBoxes.map((c) => c.text).join();
                  if (full.length == 6) _verifyOtp();
                },
              ),
            );
          }),
        ),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _verifyOtp,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Text('Verify & Sign In'),
          ),
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => setState(() {
                _otpSent = false;
                for (final c in _otpBoxes) {
                  c.clear();
                }
                _error = null;
              }),
              child: const Text('Change number',
                  style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13)),
            ),
            const Text('·',
                style: TextStyle(
                    color: AppTheme.textSecondary)),
            TextButton(
              onPressed: _resendSeconds > 0 ? null : _sendOtp,
              child: Text(
                _resendSeconds > 0
                    ? 'Resend in ${_resendSeconds}s'
                    : 'Resend code',
                style: TextStyle(
                  color: _resendSeconds > 0
                      ? AppTheme.textSecondary
                      : AppTheme.primary,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Error banner ───────────────────────────────────────────────────────────

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.danger.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: AppTheme.danger.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppTheme.danger, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(_error!,
                style: const TextStyle(
                    color: AppTheme.danger, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}