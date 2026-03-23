import 'package:flutter/material.dart';

class AppTheme {
  // ── Brand colours (mirror customer app) ────────────────────────────────────
  static const Color primary = Color(0xFFEF5350);       // redAccent
  static const Color primaryDark = Color(0xFFB71C1C);
  static const Color accent = Color(0xFF00C48C);        // accentGreen
  static const Color danger = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFFAA00);
  static const Color info = Color(0xFF3D7EFF);

  // ── Dark surface palette ────────────────────────────────────────────────────
  static const Color background = Color(0xFF0F1117);
  static const Color surface = Color(0xFF1A1D27);
  static const Color surfaceLight = Color(0xFF242838);
  static const Color cardBg = Color(0xFF1E2235);
  static const Color divider = Color(0xFF2A2F42);

  // ── Text ────────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9BA3BC);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: surface,
        error: danger,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme:
          const DividerThemeData(color: divider, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
      ),
    );
  }
}

// ── App-wide constants — stay in sync with customer app ──────────────────────

class AppConstants {
  static const String appName = 'Freequick Rider';

  // ── Firestore collections ────────────────────────────────────────────────
  static const String colOrders = 'orders';
  static const String colRiders = 'riders';
  static const String colUsers = 'users';
  static const String colRestaurants = 'restaurants';
  static const String colDispatchJobs = 'dispatch_jobs';

  // ── Order status strings ─────────────────────────────────────────────────
  // These MUST exactly match the customer app and restaurant dashboard.
  // Customer app statuses: Pending → In Progress → Ready → Delivered
  //
  // Rider app maps its actions to these statuses:
  //   Rider accepts job      → keeps "In Progress" (restaurant already set this)
  //   Rider picks up order   → sets "Ready"
  //   Rider delivers order   → sets "Delivered"
  static const String statusPending = 'Pending';
  static const String statusInProgress = 'In Progress';
  static const String statusReady = 'Ready';
  static const String statusDelivered = 'Delivered';

  // ── Dispatch job statuses (internal to rider app) ────────────────────────
  static const String jobPending = 'pending';
  static const String jobAccepted = 'accepted';
  static const String jobRejected = 'rejected';
  static const String jobCompleted = 'completed';

  // ── Rider online status ──────────────────────────────────────────────────
  static const String riderOnline = 'online';
  static const String riderOffline = 'offline';
  static const String riderBusy = 'busy';

  // ── Location config ──────────────────────────────────────────────────────
  static const int locationIntervalSeconds = 8;
  static const double locationDistanceMeters = 20.0;
  static const double maxAccuracyMeters = 50.0;
  static const double defaultSpeedKmh = 22.0;
}