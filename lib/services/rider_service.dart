import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_app/utils/app_constants.dart';

class RiderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<DocumentSnapshot> streamRider(String riderUID) {
    return _db
        .collection(AppConstants.colRiders)
        .doc(riderUID)
        .snapshots();
  }

  Future<void> setOnlineStatus(String riderUID, bool isOnline) {
    return _db
        .collection(AppConstants.colRiders)
        .doc(riderUID)
        .update({
      'isOnline': isOnline,
      'lastSeenAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> streamPendingJobs(String riderUID) {
    return _db
        .collection(AppConstants.colDispatchJobs)
        .where('riderId', isEqualTo: riderUID)
        .where('status', isEqualTo: AppConstants.jobPending)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> acceptJob(String jobID, String riderUID) async {
    final jobRef =
        _db.collection(AppConstants.colDispatchJobs).doc(jobID);

    final jobSnap = await jobRef.get();
    if (!jobSnap.exists) return;

    final data = jobSnap.data() as Map<String, dynamic>;
    final orderID = data['orderID'] as String?;

    final batch = _db.batch();

    batch.update(jobRef, {
      'status': AppConstants.jobAccepted,
      'acceptedAt': FieldValue.serverTimestamp(),
    });

    if (orderID != null && orderID.isNotEmpty) {
      final orderRef =
          _db.collection(AppConstants.colOrders).doc(orderID);

      batch.update(orderRef, {
        'status': AppConstants.statusInProgress,
        'driverUID': riderUID,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    final riderRef =
        _db.collection(AppConstants.colRiders).doc(riderUID);

    batch.update(riderRef, {
      'hasActiveOrder': true,
      'currentOrderID': orderID,
    });

    await batch.commit();
  }

  Future<void> rejectJob(String jobID) {
    return _db
        .collection(AppConstants.colDispatchJobs)
        .doc(jobID)
        .update({
      'status': AppConstants.jobRejected,
      'rejectedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateOrderStatus(String orderID, String newStatus) async {
    final Map<String, dynamic> updates = {
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (newStatus == AppConstants.statusReady) {
      updates['pickedUpAt'] = FieldValue.serverTimestamp();
    } else if (newStatus == AppConstants.statusDelivered) {
      updates['deliveredAt'] = FieldValue.serverTimestamp();
    }

    final orderRef =
        _db.collection(AppConstants.colOrders).doc(orderID);

    await orderRef.update(updates);
  }

  Future<void> completeDelivery({
    required String riderUID,
    required String orderID,
    required String orderedByUID,
    required double earnings,
  }) async {
    final batch = _db.batch();

    final orderRef =
        _db.collection(AppConstants.colOrders).doc(orderID);

    final userOrderRef = _db
        .collection(AppConstants.colUsers)
        .doc(orderedByUID)
        .collection(AppConstants.colOrders)
        .doc(orderID);

    final riderRef =
        _db.collection(AppConstants.colRiders).doc(riderUID);

    final Map<String, dynamic> orderUpdates = {
      'status': AppConstants.statusDelivered,
      'deliveredAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    batch.update(orderRef, orderUpdates);
    batch.update(userOrderRef, orderUpdates);

    batch.update(riderRef, {
      'hasActiveOrder': false,
      'currentOrderID': null,
      'totalDeliveries': FieldValue.increment(1),
      'totalEarnings': FieldValue.increment(earnings),
    });

    await batch.commit();
  }

  Stream<DocumentSnapshot> streamOrder(String orderID) {
    return _db
        .collection(AppConstants.colOrders)
        .doc(orderID)
        .snapshots();
  }

  Future<void> updateRiderLocation(
      String riderUID, double lat, double lng) {
    return _db
        .collection(AppConstants.colRiders)
        .doc(riderUID)
        .update({
      'location': {'lat': lat, 'lng': lng},
      'locationUpdatedAt': FieldValue.serverTimestamp(),
    });
  }
}