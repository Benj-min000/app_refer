// lib/services/rider_service.dart
//
// All Firestore read/write for the rider app.
// Collection names come from AppConstants so they stay in sync with user app.

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/delivery_model.dart';
import '../utils/app_theme.dart';

class RiderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Online / offline ──────────────────────────────────────────────────────
  Future<void> setOnlineStatus(String riderId, bool isOnline) async {
    await _db.collection(AppConstants.colRiders).doc(riderId).update({
      'isOnline': isOnline,
      'lastSeenAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Real-time streams ─────────────────────────────────────────────────────

  /// Stream rider doc changes (isOnline, hasActiveDelivery, earnings etc.)
  Stream<DocumentSnapshot> streamRider(String riderId) =>
      _db.collection(AppConstants.colRiders).doc(riderId).snapshots();

  /// Stream pending dispatch jobs assigned to this rider
  Stream<QuerySnapshot> streamPendingJobs(String riderId) =>
      _db
          .collection(AppConstants.colDispatchJobs)
          .where('riderId', isEqualTo: riderId)
          .where('status', isEqualTo: 'PENDING')
          .orderBy('createdAt', descending: true)
          .snapshots();

  /// Stream active delivery doc.
  /// User app also subscribes to this same doc for the tracking screen.
  Stream<DocumentSnapshot?> streamActiveDelivery(String deliveryId) =>
      _db.collection(AppConstants.colDeliveries).doc(deliveryId).snapshots();

  // ── Job accept / reject ───────────────────────────────────────────────────

  /// Accept job — rider app updates the dispatch_job doc.
  /// Cloud Function then sets delivery.riderId and delivery.status = ASSIGNED.
  Future<void> acceptJob(String jobId, String riderId) async {
    await _db.collection(AppConstants.colDispatchJobs).doc(jobId).update({
      'status': 'ACCEPTED',
      'acceptedAt': FieldValue.serverTimestamp(),
    });
    // NOTE: Do NOT set delivery status here — Cloud Function owns that transition
    // to avoid race conditions with the user app's real-time listener.
  }

  /// Reject job
  Future<void> rejectJob(String jobId) async {
    await _db.collection(AppConstants.colDispatchJobs).doc(jobId).update({
      'status': 'REJECTED',
      'rejectedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Delivery status transitions ───────────────────────────────────────────
  //
  // Rider app advances the delivery status.
  // Each transition also writes the mirrored order status so that:
  //   - user app order history screen reflects the correct state
  //   - user app tracking screen gets the status update via its own listener
  //
  // State machine (matches project spec):
  //   ASSIGNED → AT_STORE → PICKED_UP → DELIVERING → DELIVERED
  //
  Future<void> updateDeliveryStatus(String deliveryId, String newStatus) async {
    final deliveryRef = _db.collection(AppConstants.colDeliveries).doc(deliveryId);

    final updates = <String, dynamic>{
      'status': newStatus,
      'lastUpdateAt': FieldValue.serverTimestamp(),
    };

    // Side effects per transition
    switch (newStatus) {
      case AppConstants.statusAtStore:
        updates['arrivedAtStoreAt'] = FieldValue.serverTimestamp();
        break;
      case AppConstants.statusPickedUp:
        // routePhase change tells user app map to switch to TO_DROPOFF polyline
        updates['routePhase'] = 'TO_DROPOFF';
        updates['pickedUpAt'] = FieldValue.serverTimestamp();
        break;
      case AppConstants.statusDelivered:
        updates['trackingEnabled'] = false;
        updates['deliveredAt'] = FieldValue.serverTimestamp();
        break;
    }

    await deliveryRef.update(updates);

    // Mirror to orders collection so user app order list/history stays in sync
    final deliverySnap = await deliveryRef.get();
    final orderId = (deliverySnap.data() as Map<String, dynamic>?)?.get('orderId');
    if (orderId != null) {
      await _db.collection(AppConstants.colOrders).doc(orderId).update({
        'status': _deliveryStatusToOrderStatus(newStatus),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Map delivery status → order status that user app understands
  String _deliveryStatusToOrderStatus(String deliveryStatus) {
    switch (deliveryStatus) {
      case AppConstants.statusAtStore:    return AppConstants.orderPreparing;
      case AppConstants.statusPickedUp:   return AppConstants.orderPickedUp;
      case AppConstants.statusDelivering: return AppConstants.orderDelivering;
      case AppConstants.statusDelivered:  return AppConstants.orderCompleted;
      default:                            return AppConstants.orderConfirmed;
    }
  }

  // ── Write rider GPS to delivery doc ──────────────────────────────────────
  // User app tracking screen subscribes to this field in real time.
  Future<void> updateRiderLocation({
    required String deliveryId,
    required RiderLocation location,
  }) async {
    await _db.collection(AppConstants.colDeliveries).doc(deliveryId).update({
      'riderLocation': location.toMap(),
      'lastUpdateAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Complete delivery (atomic batch) ─────────────────────────────────────
  Future<void> completeDelivery({
    required String riderId,
    required String deliveryId,
    required double earnings,
  }) async {
    final batch = _db.batch();

    batch.update(_db.collection(AppConstants.colDeliveries).doc(deliveryId), {
      'status': AppConstants.statusDelivered,
      'trackingEnabled': false,
      'deliveredAt': FieldValue.serverTimestamp(),
    });

    batch.update(_db.collection(AppConstants.colRiders).doc(riderId), {
      'hasActiveDelivery': false,
      'currentDeliveryId': null,
      'totalEarnings': FieldValue.increment(earnings),
      'totalDeliveries': FieldValue.increment(1),
    });

    await batch.commit();
  }
}

// Extension so map access doesn't throw on missing keys
extension _MapGet on Map<String, dynamic> {
  dynamic get(String key) => containsKey(key) ? this[key] : null;
}
