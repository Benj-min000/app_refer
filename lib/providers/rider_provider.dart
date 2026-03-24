import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_app/services/auth_service.dart';
import 'package:rider_app/services/rider_service.dart';
import 'package:rider_app/models/delivery_model.dart';
import '../utils/app_theme.dart';

class RiderModel {
  final String uid;
  final String name;
  final String phone;
  final String photoUrl;
  final String vehicleType;
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
      name: d['name'] ?? 'Rider',
      phone: d['phone'] ?? '',
      photoUrl: d['photoUrl'] ?? '',
      vehicleType: d['vehicleType'] ?? 'SCOOTER',
      isOnline: d['isOnline'] ?? false,
      hasActiveOrder: d['hasActiveOrder'] ?? false,
      currentOrderID: d['currentOrderID'],
      totalDeliveries: (d['totalDeliveries'] ?? 0),
      totalEarnings: (d['totalEarnings'] ?? 0).toDouble(),
      rating: (d['rating'] ?? 5.0).toDouble(),
    );
  }
}

class DispatchJob {
  final String id;
  final String orderID;
  final String restaurantName;
  final String restaurantAddress;
  final String? customerName;
  final String? customerAddress;
  final double totalAmount;
  final double deliveryFee;
  final double? distanceKm;
  final String paymentMethod;
  final List<OrderItem> items;

  const DispatchJob({
    required this.id,
    required this.orderID,
    required this.restaurantName,
    required this.restaurantAddress,
    this.customerName,
    this.customerAddress,
    required this.totalAmount,
    required this.deliveryFee,
    this.distanceKm,
    required this.paymentMethod,
    required this.items,
  });

  factory DispatchJob.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};

    double parse(dynamic v) {
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0;
      return 0;
    }

    return DispatchJob(
      id: doc.id,
      orderID: d['orderID'] ?? '',
      restaurantName: d['restaurantName'] ?? '',
      restaurantAddress: d['restaurantAddress'] ?? '',
      customerName: d['customerName'],
      customerAddress: d['customerAddress'],
      totalAmount: parse(d['totalAmount']),
      deliveryFee: parse(d['deliveryFee']),
      distanceKm: parse(d['distanceKm']),
      paymentMethod: d['paymentMethod'] ?? 'cash',
      items: (d['items'] as List<dynamic>? ?? [])
          .map((e) =>
              OrderItem.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
    );
  }

  String get storeName => restaurantName;
  String? get storeAddress =>
      restaurantAddress.isEmpty ? null : restaurantAddress;
}

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

  RiderAppState _appState = RiderAppState.loading;
  RiderModel? _rider;
  Map<String, dynamic>? _activeOrder;
  DispatchJob? _pendingJob;
  bool _isOnline = false;
  bool _isLoading = false;
  String? _errorMessage;

  StreamSubscription? _riderSub;
  StreamSubscription? _orderSub;
  StreamSubscription? _jobsSub;

  String? _lastJobId;

  RiderAppState get appState => _appState;
  RiderModel? get rider => _rider;
  Map<String, dynamic>? get activeOrder => _activeOrder;
  DispatchJob? get pendingJob => _pendingJob;
  bool get isOnline => _isOnline;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
  }

  void _subscribeToJobs(String riderUID) {
    _jobsSub?.cancel();
    _jobsSub =
        _service.streamPendingJobs(riderUID).listen((snap) {
      if (snap.docs.isEmpty) {
        _pendingJob = null;
        notifyListeners();
        return;
      }

      final job = DispatchJob.fromDoc(snap.docs.first);

      if (_lastJobId != job.id) {
        _pendingJob = job;
        _lastJobId = job.id;
        notifyListeners();
      }
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

  Future<void> acceptJob(String jobID) async {
    if (_rider == null) return;
    _setLoading(true);

    await _service.acceptJob(jobID, _rider!.uid);

    _pendingJob = null;
    _jobsSub?.cancel();

    await Future.delayed(const Duration(seconds: 1));
    await _loadProfile(_rider!.uid);

    _setLoading(false);
  }

  Future<void> rejectJob(String jobID) async {
    await _service.rejectJob(jobID);
    _pendingJob = null;
    notifyListeners();
  }

  Future<void> updateOrderStatus(
      String orderID, String newStatus) async {
    if (_rider == null) return;
    _setLoading(true);

    if (newStatus == AppConstants.statusDelivered) {
      final orderedByUID =
          _activeOrder?['userID'] ?? '';
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

    _setLoading(false);
  }

  Future<void> toggleOnline() async {
    if (_rider == null) return;
    _setLoading(true);
    await _service.setOnlineStatus(
        _rider!.uid, !_isOnline);
    _setLoading(false);
  }

  Future<void> signOut() async {
    _cleanup();
    await _auth.signOut();
  }

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