class AppConstants {
  static const String appName = 'Freequick Rider';

  // ── Firestore collections ────────────────────────────────────────────────
  static const String colOrders = 'orders';
  static const String colRiders = 'riders';
  static const String colUsers = 'users';
  static const String colRestaurants = 'restaurants';
  static const String colDispatchJobs = 'dispatch_jobs';

  // ── Order status strings (Synchronized with Cloud Functions) ─────────────
  static const String statusPending = 'Pending';
  static const String statusInProgress = 'In Progress'; // Restauracja zaakceptowała
  static const String statusReady = 'Ready';           // Kurier odebrał z restauracji
  static const String statusDelivered = 'Delivered';   // Kurier dostarczył

  // ── Dispatch job statuses (Firestore: dispatch_jobs/{id}/status) ──────────
  static const String jobPending = 'pending';
  static const String jobAccepted = 'accepted';
  static const String jobRejected = 'rejected';
  static const String jobExpired = 'expired';

  // ── Field Names (Zapobiega literówkom w doc['field']) ────────────────────
  static const String fieldIsOnline = 'isOnline';
  static const String fieldHasActiveOrder = 'hasActiveOrder';
  static const String fieldCurrentOrderID = 'currentOrderID';
  static const String fieldStatus = 'status';
}