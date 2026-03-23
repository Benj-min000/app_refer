// lib/providers/rider_provider.dart
//
// State management for the rider app.
// Works with orders/{orderID} directly — no separate deliveries collection.
// All status strings match customer app: Pending, In Progress, Ready, Delivered.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_app/services/auth_service.dart';
import 'package:rider_app/services/rider_service.dart';
import 'package:rider_app/models/delivery_model.dart';
import '../utils/app_theme.dart';

// ── RiderModel ────────────────────────────────────────────────────────────────

class RiderModel {
  final String uid;
  final String name;
  final String phone;
  final String photoUrl;
  final String vehicleType;     // 'SCOOTER' | 'BIKE' | 'CAR'
  final bool isOnline;
  final bool hasActiveOrder;
  final String? currentOrderID;
  final int totalDeliveries;
  final double totalEarnings;
  final double rating;

  const RiderModel({
    required this.uid,
    required this.name,
    this.phone = '',
    this.photoUrl = '',
    this.vehicleType = 'SCOOTER',
    this.isOnline = false,
    this.hasActiveOrder = false,
    this.currentOrderID,
    this.totalDeliveries = 0,
    this.totalEarnings = 0,
    this.rating = 5.0,
  });

  factory RiderModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};
    return RiderModel(
      uid: doc.id,
      name: d['name'] as String? ?? 'Rider',
      phone: d['phone'] as String? ?? '',
      photoUrl: d['photoUrl'] as String? ?? '',
      vehicleType: d['vehicleType'] as String? ?? 'SCOOTER',
      isOnline: d['isOnline'] as bool? ?? false,
      hasActiveOrder: d['hasActiveOrder'] as bool? ?? false,
      currentOrderID: d['currentOrderID'] as String?,
      totalDeliveries:
          (d['totalDeliveries'] as num?)?.toInt() ?? 0,
      totalEarnings:
          (d['totalEarnings'] as num?)?.toDouble() ?? 0,
      rating: (d['rating'] as num?)?.toDouble() ?? 5.0,
    );
  }
}

// ── DispatchJob ───────────────────────────────────────────────────────────────
// All fields required by job_request_sheet.dart.
// Firestore path: dispatch_jobs/{jobID}

class DispatchJob {
  final String id;
  final String orderID;

  // Restaurant (store)
  final String restaurantName;
  final String restaurantAddress;

  // Customer
  final String? customerName;
  final String? customerAddress;

  // Financials
  final double totalAmount;
  final double deliveryFee;
  final double? riderEarnings;   // what the rider earns for this delivery
  final double? finalTotal;      // total shown on the sheet
  final double? distanceKm;      // route distance

  // Order meta
  final String orderType;        // 'delivery' | 'pickup'
  final String paymentMethod;    // 'cash' | 'stripe' | 'CARD' | 'CASH'
  final List<OrderItem> items;   // expandable items list in the sheet

  const DispatchJob({
    required this.id,
    required this.orderID,
    this.restaurantName = '',
    this.restaurantAddress = '',
    this.customerName,
    this.customerAddress,
    this.totalAmount = 0,
    this.deliveryFee = 0,
    this.riderEarnings,
    this.finalTotal,
    this.distanceKm,
    this.orderType = 'delivery',
    this.paymentMethod = 'cash',
    this.items = const [],
  });

  factory DispatchJob.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};
    return DispatchJob(
      id: doc.id,
      orderID: d['orderID'] as String? ?? '',
      restaurantName: d['restaurantName'] as String? ?? '',
      restaurantAddress:
          d['restaurantAddress'] as String? ?? '',
      customerName: d['customerName'] as String?,
      customerAddress: d['customerAddress'] as String?,
      totalAmount:
          (d['totalAmount'] as num?)?.toDouble() ?? 0,
      deliveryFee:
          (d['deliveryFee'] as num?)?.toDouble() ?? 0,
      riderEarnings:
          (d['riderEarnings'] as num?)?.toDouble(),
      finalTotal: (d['finalTotal'] as num?)?.toDouble(),
      distanceKm: (d['distanceKm'] as num?)?.toDouble(),
      orderType: d['orderType'] as String? ?? 'delivery',
      paymentMethod:
          d['paymentMethod'] as String? ?? 'cash',
      items: (d['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItem.fromMap(
              (e as Map).cast<String, dynamic>()))
          .toList(),
    );
  }

  // Convenience getters — job_request_sheet uses these names
  String get storeName => restaurantName;
  String? get storeAddress =>
      restaurantAddress.isEmpty ? null : restaurantAddress;
}

// ── Provider ──────────────────────────────────────────────────────────────────

enum RiderAppState {
  loading,
  unauthenticated,
  needsProfile,
  idle,
  onJob,
}

class RiderProvider extends ChangeNotifier {
  final AuthService _auth = AuthService();
  final RiderService _service = RiderService();

  // ── State ──────────────────────────────────────────────────────────────────
  RiderAppState _appState = RiderAppState.loading;
  RiderModel? _rider;
  Map<String, dynamic>? _activeOrder; // raw order doc data
  DispatchJob? _pendingJob;
  bool _isOnline = false;
  bool _isLoading = false;
  String? _errorMessage;

  // ── Earnings ───────────────────────────────────────────────────────────────
  double? _todayEarnings;
  double? _weekEarnings;
  int? _todayDeliveries;

  // ── Subscriptions ──────────────────────────────────────────────────────────
  StreamSubscription? _riderSub;
  StreamSubscription? _orderSub;
  StreamSubscription? _jobsSub;

  // ── Getters ────────────────────────────────────────────────────────────────
  RiderAppState get appState => _appState;
  RiderModel? get rider => _rider;
  Map<String, dynamic>? get activeOrder => _activeOrder;
  DispatchJob? get pendingJob => _pendingJob;
  bool get isOnline => _isOnline;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ── Bootstrap ──────────────────────────────────────────────────────────────

  void init() {
    _auth.authStateChanges.listen((User? user) async {
      if (user == null) {
        _cleanup();
        _appState = RiderAppState.unauthenticated;
        notifyListeners();
      } else {
        await _loadProfile(user.uid);
      }
    });
  }

  Future<void> _loadProfile(String uid) async {
    _appState = RiderAppState.loading;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance
          .collection(AppConstants.colRiders)
          .doc(uid)
          .get();

      if (!doc.exists) {
        _appState = RiderAppState.needsProfile;
        notifyListeners();
        return;
      }

      _rider = RiderModel.fromDoc(doc);
      _isOnline = _rider!.isOnline;

      _riderSub?.cancel();
      _riderSub = _service.streamRider(uid).listen((snap) {
        if (snap.exists) {
          _rider = RiderModel.fromDoc(snap);
          _isOnline = _rider!.isOnline;
          notifyListeners();
        }
      });


      if (_rider!.hasActiveOrder &&
          _rider!.currentOrderID != null) {
        _subscribeToOrder(_rider!.currentOrderID!);
        _appState = RiderAppState.onJob;
      } else {
        _appState = RiderAppState.idle;
        _subscribeToJobs(uid);
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load profile: $e';
      _appState = RiderAppState.idle;
      notifyListeners();
    }
  }

  void _subscribeToJobs(String riderUID) {
    _jobsSub?.cancel();
    _jobsSub =
        _service.streamPendingJobs(riderUID).listen((snap) {
      _pendingJob = snap.docs.isNotEmpty
          ? DispatchJob.fromDoc(snap.docs.first)
          : null;
      notifyListeners();
    });
  }

  void _subscribeToOrder(String orderID) {
    _orderSub?.cancel();
    _orderSub =
        _service.streamOrder(orderID).listen((snap) {
      if (snap.exists) {
        _activeOrder =
            snap.data() as Map<String, dynamic>?;
        _activeOrder?['orderID'] = snap.id;
        notifyListeners();
      }
    });
  }



  // ── Public actions ─────────────────────────────────────────────────────────

  Future<void> toggleOnline() async {
    if (_rider == null) return;
    _setLoading(true);
    try {
      await _service.setOnlineStatus(
          _rider!.uid, !_isOnline);
    } catch (e) {
      _errorMessage = 'Could not update status';
    }
    _setLoading(false);
  }

  Future<void> acceptJob(String jobID) async {
    if (_rider == null) return;
    _setLoading(true);
    try {
      await _service.acceptJob(jobID, _rider!.uid);
      _pendingJob = null;
      _jobsSub?.cancel();
      // Wait for Cloud Function to set hasActiveOrder + currentOrderID
      await Future.delayed(const Duration(seconds: 2));
      await _loadProfile(_rider!.uid);
    } catch (e) {
      _errorMessage = 'Failed to accept job: $e';
    }
    _setLoading(false);
  }

  Future<void> rejectJob(String jobID) async {
    _pendingJob = null;
    notifyListeners();
    await _service.rejectJob(jobID);
  }

  /// 'Ready'     = rider picked up from restaurant
  /// 'Delivered' = rider delivered to customer
  Future<void> updateOrderStatus(
      String orderID, String newStatus) async {
    if (_rider == null) return;
    _setLoading(true);
    try {
      if (newStatus == AppConstants.statusDelivered) {
        final orderedByUID =
            _activeOrder?['userID'] as String? ?? '';
        final fee = double.tryParse(
                _activeOrder?['deliveryFee']
                        ?.toString() ??
                    '0') ??
            0;

        await _service.completeDelivery(
          riderUID: _rider!.uid,
          orderID: orderID,
          orderedByUID: orderedByUID,
          earnings: fee,
        );

        _activeOrder = null;
        _orderSub?.cancel();
        _appState = RiderAppState.idle;
        _subscribeToJobs(_rider!.uid);
      } else {
        await _service.updateOrderStatus(
            orderID, newStatus);
      }
    } catch (e) {
      _errorMessage = 'Failed to update order: $e';
    }
    _setLoading(false);
  }

  /// Called after ProfileSetupScreen creates the rider doc.
  /// Re-runs _loadProfile with the current auth UID.
  Future<void> reload() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _loadProfile(uid);
  }

  Future<void> signOut() async {
    _cleanup();
    await _auth.signOut();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _cleanup() {
    _riderSub?.cancel();
    _orderSub?.cancel();
    _jobsSub?.cancel();
    _rider = null;
    _activeOrder = null;
    _pendingJob = null;
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }
}