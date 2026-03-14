import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:user_app/extensions/context_translate_ext.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/providers/cart_provider.dart';
import 'package:user_app/screens/home_screen.dart';
import 'package:user_app/widgets/error_dialog.dart';
import 'package:user_app/widgets/loading_dialog.dart';

/// All data collected on the register screen — passed here so account
/// creation only happens after the phone is verified.
class OtpScreenArgs {
  final String name;
  final String email;
  final String password;
  final String phone; // international format e.g. +48 123 456 789
  final File photo;
  final String downloadUrl; // empty until uploaded here

  const OtpScreenArgs({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.photo,
    this.downloadUrl = '',
  });
}

class OtpScreen extends StatefulWidget {
  final OtpScreenArgs args;

  const OtpScreen({super.key, required this.args});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // -- OTP boxes --------------------------------------------------------------
  final int _codeLength = 6;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  // -- Firebase ---------------------------------------------------------------
  String? _verificationId;
  int? _resendToken;
  bool _isLoading = false;
  String? _errorMsg;

  // -- Resend countdown -------------------------------------------------------
  static const int _resendSeconds = 60;
  int _secondsLeft = _resendSeconds;
  Timer? _timer;

  // -- Lifecycle --------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_codeLength, (_) => TextEditingController());
    _focusNodes = List.generate(_codeLength, (_) => FocusNode());
    _sendOtp();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  // -- OTP sending ------------------------------------------------------------

  Future<void> _sendOtp({bool resend = false}) async {
    setState(() {
      _errorMsg = null;
      _isLoading = true;
    });

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: widget.args.phone,
      forceResendingToken: resend ? _resendToken : null,
      timeout: const Duration(seconds: _resendSeconds),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-verified on Android (SMS auto-read)
        await _createAccount(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _errorMsg = e.message ?? 'Verification failed.';
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!mounted) return;
        setState(() {
          _verificationId = verificationId;
          _resendToken = resendToken;
          _isLoading = false;
        });
        _startCountdown();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (!mounted) return;
        setState(() => _verificationId = verificationId);
      },
    );
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) t.cancel();
    });
  }

  // -- Verify pressed ---------------------------------------------------------

  Future<void> _verify() async {
    final code = _controllers.map((c) => c.text.trim()).join();
    if (code.length < _codeLength) {
      setState(() => _errorMsg = 'Please enter all 6 digits.');
      return;
    }
    if (_verificationId == null) {
      setState(() => _errorMsg = 'Verification not started. Please resend.');
      return;
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: code,
    );

    await _createAccount(credential);
  }

  // -- Account creation -------------------------------------------------------

  Future<void> _createAccount(PhoneAuthCredential phoneCredential) async {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LoadingDialog(message: context.l10n.registeringAccount),
    );

    try {
      // 1. Create email/password account
      final UserCredential auth =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: widget.args.email.trim(),
        password: widget.args.password,
      );

      final User? user = auth.user;
      if (user == null) throw Exception('User creation failed.');

      // 2. Link phone credential to the new account
      await user.linkWithCredential(phoneCredential);

      // 3. Upload profile photo
      final fStorage.Reference ref = fStorage.FirebaseStorage.instance
          .ref()
          .child('users')
          .child(user.uid);

      final fStorage.TaskSnapshot snap = await ref.putFile(widget.args.photo);
      final String photoUrl = await snap.ref.getDownloadURL();

      // 4. Save to Firestore
      final DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      await userRef.set({
        'userID': user.uid,
        'name': widget.args.name.trim(),
        'email': user.email,
        'phone': widget.args.phone,
        'photoUrl': photoUrl.trim(),
        'createdAt': DateTime.now(),
        'role': 'customer',
        'status': 'approved',
      });

      if (!mounted) return;

      await userRef.collection('notifications').add({
        'userID': user.uid,
        'title': context.l10n.welcomeNotifTitle,
        'body': context.l10n.welcomeNotifBody(widget.args.name.trim()),
        'createdAt': DateTime.now(),
        'isRead': false,
      });

      // 5. Save locally
      await sharedPreferences!.setString('uid', user.uid);
      
      if (!mounted) return;
      Provider.of<CartProvider>(context).count;
      
      await saveUserPref<String>('email', user.email.toString());
      await saveUserPref<String>('name', widget.args.name.trim());
      await saveUserPref<String>('photoUrl', photoUrl.trim());
      await saveUserPref<String>('phone', widget.args.phone);

      if (!mounted) return;
      Navigator.pop(context); // dismiss loading
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      // Wrong code — clear boxes and show error
      for (final c in _controllers) {
        c.clear();
      }
      _focusNodes.first.requestFocus();
      setState(() => _errorMsg = e.message ?? 'Invalid code. Try again.');
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => ErrorDialog(message: e.toString()),
      );
    }
  }

  // -- Helpers ----------------------------------------------------------------

  void _onDigitChanged(String value, int index) {
    if (value.length == 1 && index < _codeLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    // Handle paste — distribute digits across boxes
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < _codeLength && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      final next =
          digits.length < _codeLength ? digits.length : _codeLength - 1;
      _focusNodes[next].requestFocus();
      setState(() {});
    }
    setState(() => _errorMsg = null);
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  String get _maskedPhone {
    final p = widget.args.phone;
    if (p.length < 6) return p;
    return '${p.substring(0, p.length - 4)}****';
  }

  // -- Build ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final bool canResend = _secondsLeft <= 0 && !_isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),

                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.sms_rounded,
                      size: 36, color: Colors.pink.shade300),
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Verify your number',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'We sent a 6-digit code to\n$_maskedPhone',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 36),

                // OTP boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_codeLength, (i) {
                    return _OtpBox(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      onChanged: (v) => _onDigitChanged(v, i),
                      onKeyEvent: (e) => _onKeyEvent(e, i),
                      hasError: _errorMsg != null,
                    );
                  }),
                ),
                const SizedBox(height: 16),

                // Error message
                if (_errorMsg != null)
                  Text(
                    _errorMsg!,
                    style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 32),

                // Verify button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade300,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Verify',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Resend row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive the code? ",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    canResend
                        ? GestureDetector(
                            onTap: () => _sendOtp(resend: true),
                            child: Text(
                              'Resend',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.pink.shade300,
                              ),
                            ),
                          )
                        : Text(
                            'Resend in ${_secondsLeft}s',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[400],
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -- OTP single box ------------------------------------------------------------

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyEvent> onKeyEvent;
  final bool hasError;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onKeyEvent,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: onKeyEvent,
      child: SizedBox(
        width: 44,
        height: 54,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 6, // allows paste of full code
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? Colors.redAccent : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? Colors.redAccent : Colors.pink.shade300,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: hasError ? Colors.red.shade50 : Colors.grey.shade50,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
