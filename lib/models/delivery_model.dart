// lib/models/delivery_model.dart
//
// Data models for the rider app.
// RiderModel and DispatchJob are defined in rider_provider.dart — not here.
// Import rider_provider.dart to access those two classes.

import 'package:cloud_firestore/cloud_firestore.dart';

// ── GPS coordinate pair ───────────────────────────────────────────────────────

class LatLngData {
  final double lat;
  final double lng;

  const LatLngData({required this.lat, required this.lng});

  factory LatLngData.fromMap(Map<String, dynamic> m) => LatLngData(
        lat: (m['lat'] ?? 0.0).toDouble(),
        lng: (m['lng'] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toMap() => {'lat': lat, 'lng': lng};
}

// ── Live rider GPS position ───────────────────────────────────────────────────

class RiderLocation {
  final double lat;
  final double lng;
  final double? heading;
  final double? speed;
  final double? accuracy;
  final DateTime updatedAt;

  const RiderLocation({
    required this.lat,
    required this.lng,
    this.heading,
    this.speed,
    this.accuracy,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'lat': lat,
        'lng': lng,
        'heading': heading,
        'speed': speed,
        'accuracy': accuracy,
        'updatedAt': FieldValue.serverTimestamp(),
      };
}

// ── ETA from Cloud Function ───────────────────────────────────────────────────

class EtaData {
  final int minMinutes;
  final int maxMinutes;
  final String source; // 'GOOGLE_DIRECTIONS' | 'FALLBACK'
  final DateTime? updatedAt;

  const EtaData({
    required this.minMinutes,
    required this.maxMinutes,
    this.source = 'FALLBACK',
    this.updatedAt,
  });

  factory EtaData.fromMap(Map<String, dynamic> m) => EtaData(
        minMinutes: (m['minMinutes'] as num?)?.toInt() ?? 0,
        maxMinutes: (m['maxMinutes'] as num?)?.toInt() ?? 0,
        source: m['source'] as String? ?? 'FALLBACK',
        updatedAt:
            (m['updatedAt'] as Timestamp?)?.toDate(),
      );
}

// ── Route polyline from Cloud Function / Google Directions ───────────────────

class RouteData {
  final String encodedPolyline;
  final String phase; // 'TO_PICKUP' | 'TO_DROPOFF'
  final DateTime? updatedAt;

  const RouteData({
    required this.encodedPolyline,
    required this.phase,
    this.updatedAt,
  });

  factory RouteData.fromMap(Map<String, dynamic> m) => RouteData(
        encodedPolyline:
            m['encodedPolyline'] as String? ?? '',
        phase: m['phase'] as String? ?? 'TO_PICKUP',
        updatedAt:
            (m['updatedAt'] as Timestamp?)?.toDate(),
      );
}

// ── Delivery document ─────────────────────────────────────────────────────────
// Future use — kept for when live map tracking is added.

class DeliveryModel {
  final String id;
  final String orderId;
  final String storeId;
  final String customerId;
  final String? riderId;
  final String status;
  final String routePhase;
  final LatLngData pickup;
  final LatLngData dropoff;
  final RiderLocation? riderLocation;
  final EtaData? eta;
  final RouteData? route;
  final bool trackingEnabled;
  final String? storeAddress;
  final String? customerAddress;
  final DateTime? lastUpdateAt;

  const DeliveryModel({
    required this.id,
    required this.orderId,
    required this.storeId,
    required this.customerId,
    this.riderId,
    required this.status,
    required this.routePhase,
    required this.pickup,
    required this.dropoff,
    this.riderLocation,
    this.eta,
    this.route,
    required this.trackingEnabled,
    this.storeAddress,
    this.customerAddress,
    this.lastUpdateAt,
  });

  factory DeliveryModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    final riderLoc = d['riderLocation'] as Map?;

    return DeliveryModel(
      id: doc.id,
      orderId: d['orderId'] as String? ?? '',
      storeId: d['storeId'] as String? ?? '',
      customerId: d['customerId'] as String? ?? '',
      riderId: d['riderId'] as String?,
      status: d['status'] as String? ?? 'ASSIGNING',
      routePhase:
          d['routePhase'] as String? ?? 'TO_PICKUP',
      pickup: LatLngData.fromMap(
          (d['pickup'] as Map?)
                  ?.cast<String, dynamic>() ??
              {}),
      dropoff: LatLngData.fromMap(
          (d['dropoff'] as Map?)
                  ?.cast<String, dynamic>() ??
              {}),
      trackingEnabled:
          d['trackingEnabled'] as bool? ?? true,
      storeAddress: d['storeAddress'] as String?,
      customerAddress: d['customerAddress'] as String?,
      lastUpdateAt:
          (d['lastUpdateAt'] as Timestamp?)?.toDate(),
      riderLocation: riderLoc != null
          ? RiderLocation(
              lat: (riderLoc['lat'] ?? 0.0).toDouble(),
              lng: (riderLoc['lng'] ?? 0.0).toDouble(),
              heading:
                  (riderLoc['heading'] as num?)?.toDouble(),
              speed:
                  (riderLoc['speed'] as num?)?.toDouble(),
              accuracy:
                  (riderLoc['accuracy'] as num?)?.toDouble(),
              updatedAt:
                  (riderLoc['updatedAt'] as Timestamp?)
                          ?.toDate() ??
                      DateTime.now(),
            )
          : null,
      eta: d['eta'] != null
          ? EtaData.fromMap(
              (d['eta'] as Map).cast<String, dynamic>())
          : null,
      route: d['route'] != null
          ? RouteData.fromMap(
              (d['route'] as Map).cast<String, dynamic>())
          : null,
    );
  }
}

// ── Order item ────────────────────────────────────────────────────────────────
// Matches the user app cart structure — used in OrderModel and DispatchJob.

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String? options;

  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    this.options,
  });

  factory OrderItem.fromMap(Map<String, dynamic> m) =>
      OrderItem(
        name: m['name'] as String? ?? '',
        quantity: (m['quantity'] as num?)?.toInt() ?? 1,
        price: (m['price'] as num?)?.toDouble() ?? 0.0,
        options: m['options'] as String?,
      );

  String get displayOptions =>
      (options != null && options!.isNotEmpty) ? options! : '';
}

// ── Order model ───────────────────────────────────────────────────────────────
// Full order document — rider reads this to know what to pick up.

class OrderModel {
  final String id;
  final String storeId;
  final String storeName;
  final String? storePhone;
  final String? storeAddress;
  final String customerId;
  final String customerName;
  final String? customerPhone;
  final String deliveryAddress;
  final String status;
  final String? deliveryId;
  final List<OrderItem> items;
  final double totalAmount;
  final double deliveryFee;
  final double finalTotal;
  final double? riderEarnings;
  final String? riderNote;
  final String? storeNote;
  final bool? cutleryRequested;
  final String paymentMethod;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.storeId,
    required this.storeName,
    this.storePhone,
    this.storeAddress,
    required this.customerId,
    required this.customerName,
    this.customerPhone,
    required this.deliveryAddress,
    required this.status,
    this.deliveryId,
    required this.items,
    required this.totalAmount,
    required this.deliveryFee,
    required this.finalTotal,
    this.riderEarnings,
    this.riderNote,
    this.storeNote,
    this.cutleryRequested,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory OrderModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      storeId: d['storeId'] as String? ?? '',
      storeName: d['storeName'] as String? ?? '',
      storePhone: d['storePhone'] as String?,
      storeAddress: d['storeAddress'] as String?,
      customerId: d['customerId'] as String? ?? '',
      customerName: d['customerName'] as String? ?? '',
      customerPhone: d['customerPhone'] as String?,
      deliveryAddress:
          d['deliveryAddress'] as String? ?? '',
      status: d['status'] as String? ?? '',
      deliveryId: d['deliveryId'] as String?,
      items: (d['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItem.fromMap(
              (e as Map).cast<String, dynamic>()))
          .toList(),
      totalAmount:
          (d['totalAmount'] as num?)?.toDouble() ?? 0.0,
      deliveryFee:
          (d['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      finalTotal:
          (d['finalTotal'] as num?)?.toDouble() ?? 0.0,
      riderEarnings:
          (d['riderEarnings'] as num?)?.toDouble(),
      riderNote: d['riderNote'] as String?,
      storeNote: d['storeNote'] as String?,
      cutleryRequested: d['cutleryRequested'] as bool?,
      paymentMethod:
          d['paymentMethod'] as String? ?? 'CASH',
      createdAt:
          (d['createdAt'] as Timestamp?)?.toDate() ??
              DateTime.now(),
    );
  }
}