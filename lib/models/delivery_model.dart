// lib/models/delivery_model.dart  (FULL REPLACEMENT)
import 'package:cloud_firestore/cloud_firestore.dart';

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

class RiderLocation {
  final double lat;
  final double lng;
  final double? heading;
  final double? speed;
  final double? accuracy;
  final DateTime updatedAt;
  const RiderLocation({
    required this.lat, required this.lng,
    this.heading, this.speed, this.accuracy,
    required this.updatedAt,
  });
  Map<String, dynamic> toMap() => {
    'lat': lat, 'lng': lng,
    'heading': heading, 'speed': speed, 'accuracy': accuracy,
    'updatedAt': FieldValue.serverTimestamp(),
  };
}

class EtaData {
  final int minMinutes;
  final int maxMinutes;
  final String source; // GOOGLE_DIRECTIONS | FALLBACK
  final DateTime? updatedAt;
  const EtaData({
    required this.minMinutes, required this.maxMinutes,
    this.source = 'FALLBACK', this.updatedAt,
  });
  factory EtaData.fromMap(Map<String, dynamic> m) => EtaData(
        minMinutes: m['minMinutes'] ?? 0,
        maxMinutes: m['maxMinutes'] ?? 0,
        source:     m['source']     ?? 'FALLBACK',
        updatedAt:  (m['updatedAt'] as Timestamp?)?.toDate(),
      );
}

// Route data written by Cloud Function after calling Google Directions API
class RouteData {
  final String encodedPolyline; // Google's encoded polyline format
  final String phase;           // TO_PICKUP | TO_DROPOFF
  final DateTime? updatedAt;
  const RouteData({
    required this.encodedPolyline,
    required this.phase,
    this.updatedAt,
  });
  factory RouteData.fromMap(Map<String, dynamic> m) => RouteData(
        encodedPolyline: m['encodedPolyline'] ?? '',
        phase:           m['phase']           ?? 'TO_PICKUP',
        updatedAt:       (m['updatedAt'] as Timestamp?)?.toDate(),
      );
}

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
  final RouteData? route;       // ← NEW: polyline from Google Directions
  final bool trackingEnabled;
  final String? storeAddress;
  final String? customerAddress;
  final DateTime? lastUpdateAt;

  const DeliveryModel({
    required this.id, required this.orderId,
    required this.storeId, required this.customerId,
    this.riderId, required this.status, required this.routePhase,
    required this.pickup, required this.dropoff,
    this.riderLocation, this.eta, this.route,
    required this.trackingEnabled,
    this.storeAddress, this.customerAddress, this.lastUpdateAt,
  });

  factory DeliveryModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return DeliveryModel(
      id:              doc.id,
      orderId:         d['orderId']   ?? '',
      storeId:         d['storeId']   ?? '',
      customerId:      d['customerId'] ?? '',
      riderId:         d['riderId'],
      status:          d['status']    ?? 'ASSIGNING',
      routePhase:      d['routePhase'] ?? 'TO_PICKUP',
      pickup:          LatLngData.fromMap(d['pickup']  ?? {}),
      dropoff:         LatLngData.fromMap(d['dropoff'] ?? {}),
      trackingEnabled: d['trackingEnabled'] ?? true,
      storeAddress:    d['storeAddress'],
      customerAddress: d['customerAddress'],
      lastUpdateAt:    (d['lastUpdateAt'] as Timestamp?)?.toDate(),
      riderLocation: d['riderLocation'] != null
          ? RiderLocation(
              lat:       (d['riderLocation']['lat']      ?? 0.0).toDouble(),
              lng:       (d['riderLocation']['lng']      ?? 0.0).toDouble(),
              heading:   d['riderLocation']['heading']?.toDouble(),
              speed:     d['riderLocation']['speed']?.toDouble(),
              accuracy:  d['riderLocation']['accuracy']?.toDouble(),
              updatedAt: (d['riderLocation']['updatedAt'] as Timestamp?)
                           ?.toDate() ?? DateTime.now(),
            )
          : null,
      eta: d['eta'] != null ? EtaData.fromMap(d['eta']) : null,
      route: d['route'] != null ? RouteData.fromMap(d['route']) : null,
    );
  }
}

// Order item — matches user app cart structure
class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String? options;
  const OrderItem({
    required this.name, required this.quantity,
    required this.price, this.options,
  });
  factory OrderItem.fromMap(Map<String, dynamic> m) => OrderItem(
        name:     m['name']     ?? '',
        quantity: (m['quantity'] ?? 1) as int,
        price:    (m['price']   ?? 0.0).toDouble(),
        options:  m['options'],
      );
  String get displayOptions => options != null && options!.isNotEmpty
      ? options!
      : '';
}

// Full order — rider reads this to know what to pick up
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
    required this.id, required this.storeId, required this.storeName,
    this.storePhone, this.storeAddress,
    required this.customerId, required this.customerName,
    this.customerPhone, required this.deliveryAddress,
    required this.status, this.deliveryId,
    required this.items, required this.totalAmount,
    required this.deliveryFee, required this.finalTotal,
    this.riderEarnings, this.riderNote, this.storeNote,
    this.cutleryRequested, required this.paymentMethod,
    required this.createdAt,
  });

  factory OrderModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id:               doc.id,
      storeId:          d['storeId']         ?? '',
      storeName:        d['storeName']        ?? '',
      storePhone:       d['storePhone'],
      storeAddress:     d['storeAddress'],
      customerId:       d['customerId']       ?? '',
      customerName:     d['customerName']     ?? '',
      customerPhone:    d['customerPhone'],
      deliveryAddress:  d['deliveryAddress']  ?? '',
      status:           d['status']           ?? '',
      deliveryId:       d['deliveryId'],
      items: (d['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItem.fromMap(e as Map<String, dynamic>))
          .toList(),
      totalAmount:      (d['totalAmount']  ?? 0.0).toDouble(),
      deliveryFee:      (d['deliveryFee']  ?? 0.0).toDouble(),
      finalTotal:       (d['finalTotal']   ?? 0.0).toDouble(),
      riderEarnings:    d['riderEarnings'] != null
                          ? (d['riderEarnings']).toDouble() : null,
      riderNote:        d['riderNote'],
      storeNote:        d['storeNote'],
      cutleryRequested: d['cutleryRequested'],
      paymentMethod:    d['paymentMethod'] ?? 'CASH',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class RiderModel {
  final String uid;
  final String name;
  final String phone;
  final bool isOnline;
  final bool hasActiveDelivery;
  final String? currentDeliveryId;
  final double totalEarnings;
  final int totalDeliveries;
  final String vehicleType;
  final double rating;

  const RiderModel({
    required this.uid, required this.name, required this.phone,
    required this.isOnline, required this.hasActiveDelivery,
    this.currentDeliveryId,
    required this.totalEarnings, required this.totalDeliveries,
    required this.vehicleType, required this.rating,
  });

  factory RiderModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return RiderModel(
      uid:               doc.id,
      name:              d['name']              ?? '',
      phone:             d['phone']             ?? '',
      isOnline:          d['isOnline']          ?? false,
      hasActiveDelivery: d['hasActiveDelivery'] ?? false,
      currentDeliveryId: d['currentDeliveryId'],
      totalEarnings:     (d['totalEarnings']    ?? 0.0).toDouble(),
      totalDeliveries:   (d['totalDeliveries']  ?? 0) as int,
      vehicleType:       d['vehicleType']       ?? 'SCOOTER',
      rating:            (d['rating']           ?? 5.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name, 'phone': phone,
    'isOnline': isOnline, 'hasActiveDelivery': hasActiveDelivery,
    'currentDeliveryId': currentDeliveryId,
    'totalEarnings': totalEarnings, 'totalDeliveries': totalDeliveries,
    'vehicleType': vehicleType, 'rating': rating, 'role': 'rider',
  };
}

class DispatchJob {
  final String id;
  final String riderId;
  final String deliveryId;
  final String orderId;
  final String storeName;
  final String? storeAddress;
  final String? customerAddress;
  final String? customerName;
  final List<OrderItem> items;     // ← full item list to display
  final double? finalTotal;
  final double? distanceKm;
  final double? riderEarnings;
  final String paymentMethod;
  final String status;

  const DispatchJob({
    required this.id, required this.riderId,
    required this.deliveryId, required this.orderId,
    required this.storeName, this.storeAddress,
    this.customerAddress, this.customerName,
    required this.items, this.finalTotal,
    this.distanceKm, this.riderEarnings,
    required this.paymentMethod, required this.status,
  });

  factory DispatchJob.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return DispatchJob(
      id:              doc.id,
      riderId:         d['riderId']         ?? '',
      deliveryId:      d['deliveryId']      ?? '',
      orderId:         d['orderId']         ?? '',
      storeName:       d['storeName']       ?? '',
      storeAddress:    d['storeAddress'],
      customerAddress: d['customerAddress'],
      customerName:    d['customerName'],
      items: (d['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItem.fromMap(e as Map<String, dynamic>))
          .toList(),
      finalTotal:      d['finalTotal'] != null ? (d['finalTotal']).toDouble() : null,
      distanceKm:      d['distanceKm'] != null ? (d['distanceKm']).toDouble() : null,
      riderEarnings:   d['riderEarnings'] != null ? (d['riderEarnings']).toDouble() : null,
      paymentMethod:   d['paymentMethod'] ?? 'CASH',
      status:          d['status']        ?? 'PENDING',
    );
  }
}
