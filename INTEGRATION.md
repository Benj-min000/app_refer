# Rider App ↔ User App Integration Guide

## 1. Shared Firebase Project

Both apps point to the **same** Firebase project.  
Use the same `google-services.json` (Android) / `GoogleService-Info.plist` (iOS).

---

## 2. Shared Firestore Collections

| Collection | Who writes | Who reads |
|---|---|---|
| `orders/{orderId}` | User app (creates), Rider app (updates status) | Both |
| `deliveries/{deliveryId}` | Cloud Function (creates), Rider app (status + location) | Both |
| `restaurants/{storeId}` | Merchant app / Admin | Both |
| `riders/{uid}` | Rider app only | Rider app |
| `dispatch_jobs/{jobId}` | Cloud Function | Rider app |

---

## 3. Shared Field Names

These fields are read by the user app's order tracking screen.  
**Do not rename them without updating both apps.**

```
deliveries/{id}
  ├── status          : "ASSIGNING" | "ASSIGNED" | "AT_STORE" | "PICKED_UP" | "DELIVERING" | "DELIVERED"
  ├── routePhase      : "TO_PICKUP" | "TO_DROPOFF"
  ├── riderLocation   : { lat, lng, heading, speed, accuracy, updatedAt }
  ├── eta             : { minMinutes, maxMinutes, updatedAt }
  ├── pickup          : { lat, lng }
  ├── dropoff         : { lat, lng }
  ├── trackingEnabled : bool  (false after delivery complete)
  ├── riderId         : string
  ├── customerId      : string
  └── orderId         : string

orders/{id}
  ├── status          : "CONFIRMED" | "PREPARING" | "PICKED_UP" | "DELIVERING" | "COMPLETED"
  ├── deliveryId      : string  (link to deliveries collection)
  ├── riderNote       : string  (shown to rider, set by user at checkout)
  ├── storeNote       : string
  └── cutleryRequested: bool
```

---

## 4. Provider Pattern

**User app** (`main.dart`):
```dart
MultiProvider(providers: [
  ChangeNotifierProvider(create: (_) => LocaleProvider()),
  ChangeNotifierProvider(create: (_) => CartProvider()),
])
```

**Rider app** (`main.dart`):
```dart
ChangeNotifierProvider(create: (_) => RiderProvider()..init())
```

Both use the same `Provider.of<T>(context)` / `context.read<T>()` pattern.

**If you later add language switching to the rider app**, just add:
```dart
ChangeNotifierProvider(create: (_) => LocaleProvider()),
```
and import `LocaleProvider` from the user app package (if monorepo) or copy the file.

---

## 5. User App: What to Add for Tracking Screen

Your user app's order tracking screen needs to subscribe to the delivery doc:

```dart
// In your order tracking screen (user app):
StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance
      .collection('deliveries')
      .doc(order.deliveryId)  // from orders/{id}.deliveryId
      .snapshots(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return LoadingWidget();
    final data = snapshot.data!.data() as Map<String, dynamic>;
    
    final riderLat = data['riderLocation']?['lat'];
    final riderLng = data['riderLocation']?['lng'];
    final status   = data['status'];
    final etaMin   = data['eta']?['minMinutes'];
    final etaMax   = data['eta']?['maxMinutes'];
    
    // Update Google Maps marker with riderLat/riderLng
    // Update status timeline with status
    // Show "Arrives in etaMin–etaMax min"
  },
)
```

---

## 6. Cloud Function: Dispatch Job Structure

When your Cloud Function assigns a rider, create this doc so the rider app picks it up:

```javascript
// Cloud Function (Node.js)
await db.collection('dispatch_jobs').add({
  riderId:         assignedRiderId,      // rider app queries this
  deliveryId:      deliveryId,
  orderId:         orderId,
  storeName:       store.name,
  storeAddress:    store.address,
  customerAddress: order.deliveryAddress,
  distanceKm:      calculatedDistanceKm,
  riderEarnings:   deliveryFee * 0.8,   // your business rule
  status:          'PENDING',
  createdAt:       FieldValue.serverTimestamp(),
});

// After rider accepts (dispatch_jobs/{id}.status == 'ACCEPTED'):
await db.collection('deliveries').doc(deliveryId).update({
  riderId:     riderId,
  status:      'ASSIGNED',
  routePhase:  'TO_PICKUP',
});
await db.collection('riders').doc(riderId).update({
  hasActiveDelivery:  true,
  currentDeliveryId:  deliveryId,
});
// FCM: notify customer + merchant
```

---

## 7. Firestore Security Rules

Add these rules so rider app can only read/write its own delivery:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Riders can read/write their own profile
    match /riders/{riderId} {
      allow read, write: if request.auth.uid == riderId;
    }

    // Deliveries: customer reads, rider reads+updates location/status
    match /deliveries/{deliveryId} {
      allow read: if request.auth.uid == resource.data.customerId
                  || request.auth.uid == resource.data.riderId;
      allow update: if request.auth.uid == resource.data.riderId
                    && request.resource.data.diff(resource.data)
                       .affectedKeys()
                       .hasOnly(['riderLocation','status','routePhase',
                                 'lastUpdateAt','arrivedAtStoreAt',
                                 'pickedUpAt','deliveredAt','trackingEnabled']);
    }

    // Dispatch jobs: rider reads their own pending jobs
    match /dispatch_jobs/{jobId} {
      allow read:   if request.auth.uid == resource.data.riderId;
      allow update: if request.auth.uid == resource.data.riderId
                    && request.resource.data.diff(resource.data)
                       .affectedKeys().hasOnly(['status','acceptedAt','rejectedAt']);
    }

    // Orders: rider can read + update status only
    match /orders/{orderId} {
      allow read:   if request.auth.uid == resource.data.customerId
                    || request.auth.uid == resource.data.riderId;
      allow update: if request.auth.uid == resource.data.riderId
                    && request.resource.data.diff(resource.data)
                       .affectedKeys().hasOnly(['status','updatedAt']);
    }

    // Restaurants: read by anyone authenticated
    match /restaurants/{storeId} {
      allow read: if request.auth != null;
    }
  }
}
```

---

## 8. Status Flow (Both Apps Must Agree)

```
User places order
      │
      ▼
orders/{id}.status = CONFIRMED
deliveries/{id}.status = ASSIGNING
      │
Cloud Function assigns rider
      │
      ▼
dispatch_jobs/{id} created  ──► Rider app: JobRequestSheet shown (30s timer)
      │
Rider accepts
      │
      ▼
deliveries/{id}.status = ASSIGNED        ◄── User app tracking screen: "Rider on the way"
riders/{id}.hasActiveDelivery = true
      │
Rider taps "I'm Here" at restaurant
      │
      ▼
deliveries/{id}.status = AT_STORE        ◄── User app: "Rider at restaurant"
orders/{id}.status = PREPARING
      │
Rider taps "Picked Up"
      │
      ▼
deliveries/{id}.status = PICKED_UP       ◄── User app: "Order picked up"
deliveries/{id}.routePhase = TO_DROPOFF
orders/{id}.status = PICKED_UP
      │
Rider arrives at customer, taps "Delivered ✓"
      │
      ▼
deliveries/{id}.status = DELIVERED       ◄── User app: "Order delivered! 🎉"
deliveries/{id}.trackingEnabled = false
orders/{id}.status = COMPLETED
riders/{id}.totalDeliveries += 1
riders/{id}.totalEarnings += earnings
```
