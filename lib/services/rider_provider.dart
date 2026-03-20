// lib/services/rider_provider.dart  (FULL REPLACEMENT)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/delivery_model.dart';
import 'auth_service.dart';
import 'rider_service.dart';
import 'location_service.dart';
import 'fcm_service.dart';
import '../utils/app_theme.dart';

enum RiderAppState { loading, unauthenticated, needsProfile, idle, onJob }

class RiderProvider extends ChangeNotifier {
  final AuthService     _authService     = AuthService();
  final RiderService    _riderService    = RiderService();
  final LocationService _locationService = LocationService();
  final FcmService      _fcmService      = FcmService();

  RiderAppState  _appState      = RiderAppState.loading;
  RiderModel?    _riderModel;
  DeliveryModel? _activeDelivery;
  OrderModel?    _activeOrder;
  DispatchJob?   _pendingJob;       // ← now typed DispatchJob (not raw map)
  bool           _isOnline         = false;
  bool           _isLoading        = false;
  String?        _errorMessage;

  StreamSubscription? _riderSub;
  StreamSubscription? _deliverySub;
  StreamSubscription? _jobsSub;

  RiderAppState  get appState       => _appState;
  RiderModel?    get rider          => _riderModel;
  DeliveryModel? get activeDelivery => _activeDelivery;
  OrderModel?    get activeOrder    => _activeOrder;
  DispatchJob?   get pendingJob     => _pendingJob;
  bool           get isOnline       => _isOnline;
  bool           get isLoading      => _isLoading;
  String?        get errorMessage   => _errorMessage;

  bool get hasActiveJob =>
      _activeDelivery != null &&
      ['ASSIGNED', 'AT_STORE', 'PICKED_UP', 'DELIVERING']
          .contains(_activeDelivery?.status);

  // ── Bootstrap ──────────────────────────────────────────────────────────────
  void init() {
    // Wire FCM callback — called when DISPATCH_JOB push arrives
    _fcmService.onDispatchJob = (data) async {
      final jobId = data['jobId'];
      if (jobId == null) return;
      // Load full job from Firestore (richer than FCM payload)
      final doc = await FirebaseFirestore.instance
          .collection(AppConstants.colDispatchJobs)
          .doc(jobId)
          .get();
      if (doc.exists) {
        _pendingJob = DispatchJob.fromDoc(doc);
        notifyListeners();
      }
    };

    _authService.authStateChanges.listen((User? user) async {
      if (user == null) {
        _cleanup();
        _appState = RiderAppState.unauthenticated;
        notifyListeners();
      } else {
        // Init FCM after auth so token save has a valid uid
        await _fcmService.init();
        await _loadRiderProfile(user.uid);
      }
    });
  }

  Future<void> _loadRiderProfile(String uid) async {
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

      _riderModel = RiderModel.fromDoc(doc);
      _isOnline   = _riderModel!.isOnline;

      _riderSub?.cancel();
      _riderSub = _riderService.streamRider(uid).listen((snap) {
        if (snap.exists) {
          _riderModel = RiderModel.fromDoc(snap);
          _isOnline   = _riderModel!.isOnline;
          notifyListeners();
        }
      });

      if (_riderModel!.hasActiveDelivery &&
          _riderModel!.currentDeliveryId != null) {
        await _subscribeToDelivery(_riderModel!.currentDeliveryId!);
        _appState = RiderAppState.onJob;
      } else {
        _appState = RiderAppState.idle;
        _subscribeToJobs(uid);
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load profile: $e';
      _appState     = RiderAppState.idle;
      notifyListeners();
    }
  }

  void _subscribeToJobs(String riderId) {
    _jobsSub?.cancel();
    _jobsSub = _riderService.streamPendingJobs(riderId).listen((snap) {
      if (snap.docs.isNotEmpty) {
        _pendingJob = DispatchJob.fromDoc(snap.docs.first);
      } else {
        _pendingJob = null;
      }
      notifyListeners();
    });
  }

  Future<void> _subscribeToDelivery(String deliveryId) async {
    _deliverySub?.cancel();
    _deliverySub = _riderService
        .streamActiveDelivery(deliveryId)
        .listen((snap) async {
      if (snap != null && snap.exists) {
        _activeDelivery = DeliveryModel.fromDoc(snap);
        if (_activeOrder == null ||
            _activeOrder!.id != _activeDelivery!.orderId) {
          await _loadOrder(_activeDelivery!.orderId);
        }
        notifyListeners();
      }
    });
    await _locationService.startTracking(deliveryId);
  }

  Future<void> _loadOrder(String orderId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(AppConstants.colOrders)
          .doc(orderId)
          .get();
      if (doc.exists) _activeOrder = OrderModel.fromDoc(doc);
    } catch (e) {
      debugPrint('Failed to load order: $e');
    }
  }

  // ── Public actions ─────────────────────────────────────────────────────────
  Future<void> toggleOnline() async {
    if (_riderModel == null) return;
    _setLoading(true);
    try {
      await _riderService.setOnlineStatus(_riderModel!.uid, !_isOnline);
    } catch (_) {
      _errorMessage = 'Could not update status';
    }
    _setLoading(false);
  }

  Future<void> acceptJob(String jobId) async {
    if (_riderModel == null) return;
    _setLoading(true);
    try {
      await _riderService.acceptJob(jobId, _riderModel!.uid);
      _pendingJob = null;
      await Future.delayed(const Duration(seconds: 2));
      await _loadRiderProfile(_riderModel!.uid);
    } catch (_) {
      _errorMessage = 'Failed to accept job';
    }
    _setLoading(false);
  }

  Future<void> rejectJob(String jobId) async {
    _pendingJob = null;
    notifyListeners();
    await _riderService.rejectJob(jobId);
  }

  Future<void> updateStatus(String newStatus) async {
    if (_activeDelivery == null) return;
    _setLoading(true);
    try {
      if (newStatus == AppConstants.statusDelivered) {
        await _riderService.completeDelivery(
          riderId:    _riderModel!.uid,
          deliveryId: _activeDelivery!.id,
          earnings:   _activeOrder?.riderEarnings ??
                      _activeOrder?.deliveryFee   ?? 5.0,
        );
        await _locationService.stopTracking();
        _activeDelivery = null;
        _activeOrder    = null;
        _deliverySub?.cancel();
        _appState = RiderAppState.idle;
        _subscribeToJobs(_riderModel!.uid);
      } else {
        await _riderService.updateDeliveryStatus(
            _activeDelivery!.id, newStatus);
      }
    } catch (e) {
      _errorMessage = 'Failed to update: $e';
    }
    _setLoading(false);
  }

  Future<void> signOut() async {
    _cleanup();
    await _authService.signOut();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _cleanup() {
    _riderSub?.cancel();
    _deliverySub?.cancel();
    _jobsSub?.cancel();
    _locationService.stopTracking();
    _riderModel     = null;
    _activeDelivery = null;
    _activeOrder    = null;
    _pendingJob     = null;
  }
}
