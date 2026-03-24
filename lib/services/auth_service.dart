// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── OTP flow ───────────────────────────────────────────────────────────────

  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-verified on Android — sign in immediately
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? 'Verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _auth.signInWithCredential(credential);
  }

  // ── Rider profile ──────────────────────────────────────────────────────────
  // Field names MUST match RiderModel.fromDoc() in rider_provider.dart.
  // Only creates the doc if it doesn't already exist.

  Future<void> ensureRiderProfile({
    required String name,
    required String phone,
    required String vehicleType,
  }) async {
    final uid = currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('riders')
        .doc(uid)
        .set({
      'name': name,
      'phone': phone,
      'vehicleType': vehicleType,
      'isOnline': true,
      'hasActiveOrder': false,
      'currentOrderID': null,
      'totalDeliveries': 0,
      'totalEarnings': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Sign out ───────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _auth.signOut();
  }
}