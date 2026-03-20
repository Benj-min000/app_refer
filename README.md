# 🛵 Rider App — Poland Delivery Platform

Flutter driver app, paired with the Consumer (user) app and Firebase backend.

---

## 📁 Project Structure

```
lib/
├── main.dart                    # Entry point, router, bottom nav shell
├── utils/
│   └── app_theme.dart           # Theme, colors, constants
├── models/
│   └── delivery_model.dart      # DeliveryModel, OrderModel, RiderModel, LatLngData
├── services/
│   ├── auth_service.dart        # Firebase Auth (phone OTP)
│   ├── rider_service.dart       # Firestore CRUD for rider/delivery
│   ├── location_service.dart    # GPS tracking + ETA calculation
│   └── rider_provider.dart      # ChangeNotifier state (app-wide)
├── screens/
│   ├── login_screen.dart        # Phone OTP login
│   ├── profile_setup_screen.dart# First-time rider profile creation
│   ├── home_screen.dart         # Idle dashboard (online toggle, stats)
│   ├── active_delivery_screen.dart # Live job: map + status stepper
│   └── profile_screen.dart      # Rider profile & settings
└── widgets/
    ├── common_widgets.dart      # Shared UI components
    └── job_request_sheet.dart   # Incoming job bottom sheet (30s timer)
```

---

## 🔥 Firebase Collections Used

| Collection | Purpose |
|---|---|
| `riders/{uid}` | Rider profile, online status, stats |
| `deliveries/{deliveryId}` | Live delivery tracking doc |
| `orders/{orderId}` | Order details + status (shared with user app) |
| `dispatch_jobs/{jobId}` | Incoming dispatch request to rider |

### Delivery status flow (matches user app)
```
ASSIGNING → ASSIGNED → AT_STORE → PICKED_UP → DELIVERING → DELIVERED
```

### Rider location update path
```
deliveries/{deliveryId}.riderLocation  ← Rider app writes here
                                        → User app listens here (real-time)
```

---

## 🔗 Integration Points with User App

### 1. Shared Firestore Security Rules
The rider app needs these rules in `firestore.rules`:
```
match /deliveries/{deliveryId} {
  allow read: if request.auth.uid == resource.data.customerId
               || request.auth.uid == resource.data.riderId;
  allow update: if request.auth.uid == resource.data.riderId
                && request.resource.data.diff(resource.data).affectedKeys()
                   .hasOnly(['riderLocation', 'status', 'lastUpdateAt', ...]);
}
```

### 2. Dispatch job creation
Your Cloud Function should create a `dispatch_jobs` doc when assigning a rider:
```js
await db.collection('dispatch_jobs').add({
  riderId: assignedRiderId,
  deliveryId: deliveryId,
  orderId: orderId,
  storeName: store.name,
  storeAddress: store.address,
  customerAddress: delivery.dropoff.address,
  distanceKm: calculatedDistance,
  riderEarnings: deliveryFee * 0.8,  // example
  status: 'PENDING',
  createdAt: FieldValue.serverTimestamp(),
});
```

### 3. After rider accepts, Cloud Function should:
```js
// Update delivery
await db.collection('deliveries').doc(deliveryId).update({
  riderId: riderId,
  status: 'ASSIGNED',
  routePhase: 'TO_PICKUP',
});
// Update rider
await db.collection('riders').doc(riderId).update({
  hasActiveDelivery: true,
  currentDeliveryId: deliveryId,
});
// Notify customer via FCM
```

---

## ⚙️ Setup

### 1. Add `google-services.json` to `android/app/`

### 2. Add API key to `android/app/src/main/AndroidManifest.xml`
```xml
<meta-data
  android:name="com.google.android.geo.API_KEY"
  android:value="YOUR_GOOGLE_MAPS_KEY"/>
```

### 3. Enable background location in `AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
```

### 4. iOS `Info.plist`
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to track your delivery.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Background location is needed while on an active delivery.</string>
```

---

## 🚀 App Flow

```
Launch
  └─ Firebase Auth check
       ├─ Not logged in → LoginScreen (Phone OTP)
       ├─ Logged in, no Firestore doc → ProfileSetupScreen
       ├─ Logged in, has active delivery → ActiveDeliveryScreen
       └─ Logged in, idle → HomeScreen (MainShell)
                              └─ Pending dispatch job → JobRequestSheet (30s timer)
                                   ├─ Accept → ActiveDeliveryScreen
                                   └─ Reject → back to idle
```

---

## 📦 Key Dependencies

```yaml
firebase_core, firebase_auth, cloud_firestore, firebase_messaging
google_maps_flutter
geolocator, permission_handler
provider
url_launcher
```

---

## 🗺️ ETA Calculation (MVP)

Located in `LocationService.calculateEta()`:
- Uses **Haversine distance** (no paid routing API needed)
- Defaults to **22 km/h** city speed
- Returns `{min, max}` range with buffer
- Upgrade path: swap for Google Directions API in Cloud Function

---

## 🌍 Multi-language

App strings are in English (MVP). To add PL/KO/UK:
1. Create `lib/l10n/` with `.arb` files
2. Add `flutter_localizations` dependency
3. The `Accept-Language` header or locale param should be passed when reading dynamic content from Firestore (matches user app pattern)
