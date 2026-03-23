// lib/services/location_service.dart
//
// GPS tracking service.
// - Writes riderLocation to deliveries/{id} every 20m / 8s
// - Cloud Function reads this and calls Google Directions → writes back ETA + polyline
// - This file also reads back that ETA+polyline for the active delivery screen

import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:rider_app/models/delivery_model.dart';
import 'rider_service.dart';

class LocationService {
  static final LocationService _instance = LocationService._();
  factory LocationService() => _instance;
  LocationService._();

  final RiderService _riderService = RiderService();

  StreamSubscription<Position>? _positionSub;
  String? _activeDeliveryId;
  bool _isTracking = false;

  bool get isTracking => _isTracking;

  // ── Permissions ───────────────────────────────────────────────────────────
  Future<bool> requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (_) {
      return null;
    }
  }

  // ── Start tracking (call when rider accepts job) ──────────────────────────
  Future<void> startTracking(String deliveryId) async {
    if (_isTracking) await stopTracking();

    final hasPermission = await requestPermissions();
    if (!hasPermission) return;

    _activeDeliveryId = deliveryId;
    _isTracking = true;

    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 20, // metres — minimum movement before update
    );

    _positionSub = Geolocator.getPositionStream(locationSettings: settings)
        .listen(_onPosition, onError: (e) => _log('GPS error: $e'));

    _log('Tracking started for delivery: $deliveryId');
  }

  void _onPosition(Position pos) async {
    if (_activeDeliveryId == null) return;
    // Skip low-accuracy readings
    //if (pos.accuracy > AppConstants.maxGpsAccuracyMeters) return;
    if (pos.accuracy > 50.0) return;

    final loc = RiderLocation(
      lat: pos.latitude,
      lng: pos.longitude,
      heading: pos.heading,
      speed: pos.speed,
      accuracy: pos.accuracy,
      updatedAt: DateTime.now(),
    );

    try {
      // Write to Firestore → triggers onRiderLocationUpdate Cloud Function
      // which calls Google Directions and writes back eta + route.encodedPolyline
      await _riderService.updateRiderLocation(_activeDeliveryId!, loc.lat, loc.lng);
    } catch (e) {
      _log('Failed to update location: $e');
    }
  }

  Future<void> stopTracking() async {
    await _positionSub?.cancel();
    _positionSub = null;
    _activeDeliveryId = null;
    _isTracking = false;
    _log('Tracking stopped');
  }

  // ── Fallback ETA (Haversine) used if Cloud Function hasn't responded yet ──
  Map<String, int> calculateFallbackEta({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
    double? currentSpeedMs,
  }) {
    final distKm = _haversineKm(fromLat, fromLng, toLat, toLng);
    //double speedKmh = AppConstants.defaultCitySpeedKmh;
    double speedKmh = 30.0;
    if (currentSpeedMs != null && currentSpeedMs > 1.0) {
      speedKmh = currentSpeedMs * 3.6;
    }
    final est = (distKm / speedKmh) * 60 + 3; // +3 min buffer
    return {
      'min': max(1, (est - 2).round()),
      'max': (est + 4).round(),
    };
  }

  double _haversineKm(double lat1, double lng1, double lat2, double lng2) {
    const R = 6371.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLng = (lng2 - lng1) * pi / 180;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLng / 2) *
            sin(dLng / 2);
    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  void _log(String msg) => print('[LocationService] $msg');
}
