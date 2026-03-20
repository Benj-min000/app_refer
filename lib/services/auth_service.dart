// lib/services/rider_service.dart
/*import '../models/delivery_model.dart';
import '../utils/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Send OTP to phone number
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
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

  /// Verify OTP code
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

  /// Ensure rider doc exists in Firestore
  Future<void> ensureRiderProfile({
    required String name,
    required String phone,
    required String vehicleType,
  }) async {
    final uid = currentUser!.uid;
    final doc = await _db.collection('riders').doc(uid).get();
    if (!doc.exists) {
      await _db.collection('riders').doc(uid).set({
        'name': name,
        'phone': phone,
        'vehicleType': vehicleType,
        'isOnline': false,
        'hasActiveDelivery': false,
        'totalEarnings': 0.0,
        'totalDeliveries': 0,
        'rating': 5.0,
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'rider',
      });
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class RiderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Set rider online/offline
  Future<void> setOnlineStatus(String riderId, bool isOnline) async {
    await _db.collection('riders').doc(riderId).update({
      'isOnline': isOnline,
      'lastSeenAt': FieldValue.serverTimestamp(),
    });
  }

  /// Stream pending dispatch jobs for this rider
  Stream<QuerySnapshot> streamPendingJobs(String riderId) {
    return _db
        .collection('dispatch_jobs')
        .where('riderId', isEqualTo: riderId)
        .where('status', isEqualTo: 'PENDING')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Stream rider's active delivery
  Stream<DocumentSnapshot?> streamActiveDelivery(String deliveryId) {
    return _db.collection('deliveries').doc(deliveryId).snapshots();
  }

  /// Stream rider doc
  Stream<DocumentSnapshot> streamRider(String riderId) {
    return _db.collection('riders').doc(riderId).snapshots();
  }

  /// Accept a dispatch job
  Future<void> acceptJob(String jobId, String riderId) async {
    final batch = _db.batch();

    // Update dispatch job
    batch.update(_db.collection('dispatch_jobs').doc(jobId), {
      'status': 'ACCEPTED',
      'acceptedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
    // Note: Cloud Function handles setting delivery status → ASSIGNED
    // and linking riderId to the delivery
  }

  /// Reject a dispatch job
  Future<void> rejectJob(String jobId) async {
    await _db.collection('dispatch_jobs').doc(jobId).update({
      'status': 'REJECTED',
      'rejectedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update delivery status
  Future<void> updateDeliveryStatus(String deliveryId, String newStatus) async {
    final updates = <String, dynamic>{
      'status': newStatus,
      'lastUpdateAt': FieldValue.serverTimestamp(),
    };

    if (newStatus == AppConstants.statusPickedUp) {
      updates['routePhase'] = 'TO_DROPOFF';
      updates['pickedUpAt'] = FieldValue.serverTimestamp();
    } else if (newStatus == AppConstants.statusAtStore) {
      updates['arrivedAtStoreAt'] = FieldValue.serverTimestamp();
    } else if (newStatus == AppConstants.statusDelivered) {
      updates['trackingEnabled'] = false;
      updates['deliveredAt'] = FieldValue.serverTimestamp();
    }

    await _db.collection('deliveries').doc(deliveryId).update(updates);

    // Also update the linked order's status
    final delivery = await _db.collection('deliveries').doc(deliveryId).get();
    final orderId = (delivery.data() as Map<String, dynamic>)['orderId'];
    if (orderId != null) {
      String orderStatus = _deliveryToOrderStatus(newStatus);
      await _db.collection('orders').doc(orderId).update({
        'status': orderStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  String _deliveryToOrderStatus(String deliveryStatus) {
    switch (deliveryStatus) {
      case AppConstants.statusAtStore:
        return 'PREPARING';
      case AppConstants.statusPickedUp:
        return 'PICKED_UP';
      case AppConstants.statusDelivering:
        return 'DELIVERING';
      case AppConstants.statusDelivered:
        return 'COMPLETED';
      default:
        return 'CONFIRMED';
    }
  }

  /// Update rider location in Firestore
  Future<void> updateRiderLocation({
    required String deliveryId,
    required RiderLocation location,
  }) async {
    await _db.collection('deliveries').doc(deliveryId).update({
      'riderLocation': location.toMap(),
      'lastUpdateAt': FieldValue.serverTimestamp(),
    });
  }

  /// Complete delivery and update rider stats
  Future<void> completeDelivery({
    required String riderId,
    required String deliveryId,
    required double earnings,
  }) async {
    final batch = _db.batch();

    batch.update(_db.collection('deliveries').doc(deliveryId), {
      'status': AppConstants.statusDelivered,
      'trackingEnabled': false,
      'deliveredAt': FieldValue.serverTimestamp(),
    });

    batch.update(_db.collection('riders').doc(riderId), {
      'hasActiveDelivery': false,
      'currentDeliveryId': null,
      'totalEarnings': FieldValue.increment(earnings),
      'totalDeliveries': FieldValue.increment(1),
    });

    await batch.commit();
  }

  /// Stream today's completed deliveries for earnings
  Stream<QuerySnapshot> streamTodayEarnings(String riderId) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return _db
        .collection('deliveries')
        .where('riderId', isEqualTo: riderId)
        .where('status', isEqualTo: AppConstants.statusDelivered)
        .where('deliveredAt', isGreaterThan: Timestamp.fromDate(startOfDay))
        .snapshots();
  }
}*/

// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Send OTP to phone number
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
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

  /// Verify OTP code
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

  /// Ensure rider doc exists in Firestore
  Future<void> ensureRiderProfile({
    required String name,
    required String phone,
    required String vehicleType,
  }) async {
    final uid = currentUser!.uid;
    final doc = await _db.collection('riders').doc(uid).get();
    if (!doc.exists) {
      await _db.collection('riders').doc(uid).set({
        'name': name,
        'phone': phone,
        'vehicleType': vehicleType,
        'isOnline': false,
        'hasActiveDelivery': false,
        'totalEarnings': 0.0,
        'totalDeliveries': 0,
        'rating': 5.0,
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'rider',
      });
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
