import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_app/services/auth_service.dart';
import 'package:rider_app/services/rider_service.dart';
import 'package:rider_app/models/delivery_model.dart';

// --- MODELE DANYCH ---

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
      name: d['name'] as String? ?? 'Rider',
      phone: d['phone'] as String? ?? '',
      photoUrl: d['photoUrl'] as String? ?? '',
      vehicleType: d['vehicleType'] as String? ?? 'SCOOTER',
      isOnline: d['isOnline'] as bool? ?? false,
      hasActiveOrder: d['hasActiveOrder'] as bool? ?? false,
      currentOrderID: d['currentOrderID'] as String?,
      totalDeliveries: (d['totalDeliveries'] as num?)?.toInt() ?? 0,
      totalEarnings: (d['totalEarnings'] as num?)?.toDouble() ?? 0,
      rating: (d['rating'] as num?)?.toDouble() ?? 5.0,
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
  final String orderType;
  final String paymentMethod;
  final List<OrderItem> items;
  final bool collectPayment;

  const DispatchJob({
    required this.id,
    required this.orderID,
    this.restaurantName = '',
    this.restaurantAddress = '',
    this.customerName,
    this.customerAddress,
    this.totalAmount = 0,
    this.deliveryFee = 0,
    this.orderType = 'delivery',
    this.paymentMethod = 'cash',
    this.items = const [],
    this.collectPayment = false,
  });

  factory DispatchJob.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};
    return DispatchJob(
      id: doc.id,
      orderID: d['orderID'] as String? ?? '',
      restaurantName: d['restaurantName'] as String? ?? '',
      restaurantAddress: d['restaurantAddress'] as String? ?? '',
      customerName: d['customerName'] as String?,
      customerAddress: d['customerAddress'] as String?,
      totalAmount: (d['totalAmount'] as num?)?.toDouble() ?? 0,
      deliveryFee: (d['deliveryFee'] as num?)?.toDouble() ?? 0,
      orderType: d['orderType'] as String? ?? 'delivery',
      paymentMethod: d['paymentMethod'] as String? ?? 'cash',
      collectPayment: d['collectPayment'] as bool? ?? false,
      items: (d['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItem.fromMap((e as Map).cast<String, dynamic>()))
          .toList(),
    );
  }

  String get storeName => restaurantName;
  String? get storeAddress => restaurantAddress.isEmpty ? null : restaurantAddress;
}

// --- PROVIDER ---

enum RiderAppState { loading, unauthenticated, needsProfile, idle, onJob }

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
        await _setupRiderStream(user.uid);
      }
    });
  }

  /// Główny stream słuchający zmian w profilu Kuriera
  Future<void> _setupRiderStream(String uid) async {
    _appState = RiderAppState.loading;
    notifyListeners();

    _riderSub?.cancel();
    _riderSub = _service.streamRider(uid).listen((snap) {
      if (!snap.exists) {
        _appState = RiderAppState.needsProfile;
        notifyListeners();
        return;
      }

      _rider = RiderModel.fromDoc(snap);
      _isOnline = _rider!.isOnline;

      // REAKTYWNE PRZEŁĄCZANIE STANÓW
      if (_rider!.hasActiveOrder && _rider!.currentOrderID != null) {
        // Jeśli kurier ma aktywne zamówienie, a apka jeszcze o tym nie wie
        if (_appState != RiderAppState.onJob) {
          _appState = RiderAppState.onJob;
          _subscribeToOrder(_rider!.currentOrderID!);
          _jobsSub?.cancel(); // Przestań szukać nowych zleceń
          _pendingJob = null;
        }
      } else {
        // Jeśli kurier nie ma zamówienia
        if (_appState != RiderAppState.idle) {
          _appState = RiderAppState.idle;
          _activeOrder = null;
          _orderSub?.cancel();
          _subscribeToJobs(uid); // Zacznij szukać zleceń
        }
      }
      notifyListeners();
    }, onError: (e) {
      _errorMessage = 'Stream Error: $e';
      notifyListeners();
    });
  }

  void _subscribeToJobs(String riderUID) {
    _jobsSub?.cancel();
    _jobsSub = _service.streamPendingJobs(riderUID).listen((snap) {
      _pendingJob = snap.docs.isNotEmpty ? DispatchJob.fromDoc(snap.docs.first) : null;
      notifyListeners();
    });
  }

  void _subscribeToOrder(String orderID) {
    _orderSub?.cancel();
    _orderSub = _service.streamOrder(orderID).listen((snap) {
      if (snap.exists) {
        _activeOrder = snap.data() as Map<String, dynamic>?;
        _activeOrder?['orderID'] = snap.id;
        notifyListeners();
      }
    });
  }

  // --- AKCJE PUBLICZNE ---

  Future<void> toggleOnline() async {
    if (_rider == null) return;
    _setLoading(true);
    try {
      await _service.setOnlineStatus(_rider!.uid, !_isOnline);
    } catch (e) {
      _errorMessage = 'Could not update status';
    }
    _setLoading(false);
  }

  Future<void> acceptJob(String jobID) async {
    if (_rider == null) return;
    _setLoading(true);
    try {
      // Tylko wysyłamy sygnał do Firestore. 
      // Cloud Function 'onDispatchAccepted' zrobi resztę.
      await _service.acceptJob(jobID, _rider!.uid);
      _pendingJob = null; 
      // Loader wyłączy się automatycznie, gdy streamRider wykryje hasActiveOrder = true
    } catch (e) {
      _errorMessage = 'Failed to accept job: $e';
      _setLoading(false);
    }
  }

  Future<void> rejectJob(String jobID) async {
    _pendingJob = null;
    notifyListeners();
    await _service.rejectJob(jobID);
  }

  Future<void> updateOrderStatus(String orderID, String newStatus) async {
    if (_rider == null) return;
    _setLoading(true);
    try {
      await _service.updateOrderStatus(orderID, newStatus);
      
      // Jeśli to dostarczenie, czyścimy lokalny stan zamówienia
      if (newStatus == 'Delivered') {
        _activeOrder = null;
        _orderSub?.cancel();
        // Cloud Function 'onOrderUpdated' ustawi hasActiveOrder na false u kuriera,
        // co sprawi, że streamRider sam przełączy apkę w tryb 'idle'.
      }
    } catch (e) {
      _errorMessage = 'Failed to update order: $e';
    }
    _setLoading(false);
  }

  Future<void> reload() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _setupRiderStream(uid);
  }

  Future<void> signOut() async {
    _cleanup();
    await _auth.signOut();
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