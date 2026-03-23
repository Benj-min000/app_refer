// lib/services/rider_service.dart
//
// All Firestore read/write for the rider app.
// Works directly with the orders collection — no separate deliveries collection.
// Status strings MUST match the customer app exactly:
//   Pending → In Progress → Ready → Delivered

import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_theme.dart';

class RiderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Rider doc ──────────────────────────────────────────────────────────────

  Stream<DocumentSnapshot> streamRider(String riderUID) =>
      _db.collection(AppConstants.colRiders).doc(riderUID).snapshots();

  Future<void> setOnlineStatus(String riderUID, bool isOnline) =>
      _db.collection(AppConstants.colRiders).doc(riderUID).update({
        'isOnline': isOnline,
        'lastSeenAt': FieldValue.serverTimestamp(),
      });

  // ── Dispatch jobs ──────────────────────────────────────────────────────────
  // dispatch_jobs/{jobID}
  //   riderId, status ('pending'|'accepted'|'rejected'), orderID, createdAt

  Stream<QuerySnapshot> streamPendingJobs(String riderUID) =>
      _db
          .collection(AppConstants.colDispatchJobs)
          .where('riderId', isEqualTo: riderUID)
          .where('status', isEqualTo: AppConstants.jobPending)
          .orderBy('createdAt', descending: true)
          .snapshots();

  Future<void> acceptJob(String jobID, String riderUID) =>
      _db.collection(AppConstants.colDispatchJobs).doc(jobID).update({
        'status': AppConstants.jobAccepted,
        'acceptedAt': FieldValue.serverTimestamp(),
      });

  Future<void> rejectJob(String jobID) =>
      _db.collection(AppConstants.colDispatchJobs).doc(jobID).update({
        'status': AppConstants.jobRejected,
        'rejectedAt': FieldValue.serverTimestamp(),
      });

  // ── Order status transitions ───────────────────────────────────────────────
  // The rider directly updates orders/{orderID}.status.
  // The customer app OrderDetailsScreen streams this same doc,
  // so the progress timeline updates in real time.
  //
  // Flow the rider controls:
  //   In Progress → Ready      (rider arrives at restaurant, picks up order)
  //   Ready       → Delivered  (rider delivers to customer)

  Future<void> updateOrderStatus(String orderID, String newStatus) async {
    final Map<String, dynamic> updates = {
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Timestamp fields per transition
    if (newStatus == AppConstants.statusReady) {
      updates['pickedUpAt'] = FieldValue.serverTimestamp();
    } else if (newStatus == AppConstants.statusDelivered) {
      updates['deliveredAt'] = FieldValue.serverTimestamp();
    }

    // Update both order locations so customer app history + details both update
    final batch = _db.batch();
    final topLevel =
        _db.collection(AppConstants.colOrders).doc(orderID);
    batch.update(topLevel, updates);

    // Also update the user sub-collection copy if driverUID is known
    // (we handle this in completeDelivery below with a batch)
    await batch.commit();
  }

  /// Called when the rider marks an order as Delivered.
  /// Atomic batch: marks order delivered + updates rider stats.
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

  // ── Active order stream ────────────────────────────────────────────────────

  Stream<DocumentSnapshot> streamOrder(String orderID) =>
      _db.collection(AppConstants.colOrders).doc(orderID).snapshots();



  // ── Rider GPS location ─────────────────────────────────────────────────────
  // Written to riders/{uid}.location so future map tracking can use it.

  Future<void> updateRiderLocation(
      String riderUID, double lat, double lng) =>
      _db.collection(AppConstants.colRiders).doc(riderUID).update({
        'location': {'lat': lat, 'lng': lng},
        'locationUpdatedAt': FieldValue.serverTimestamp(),
      });
}