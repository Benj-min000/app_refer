// // lib/utils/app_theme.dart

// import 'package:flutter/material.dart';

// class AppTheme {
//   static const Color primary = Color(0xFF00C896);
//   static const Color primaryDark = Color(0xFF009E78);
//   static const Color danger = Color(0xFFFF4757);
//   static const Color warning = Color(0xFFFFAA00);
//   static const Color info = Color(0xFF3D7EFF);
//   static const Color background = Color(0xFF0F1117);
//   static const Color surface = Color(0xFF1A1D27);
//   static const Color surfaceLight = Color(0xFF242838);
//   static const Color textPrimary = Color(0xFFFFFFFF);
//   static const Color textSecondary = Color(0xFF9BA3BC);
//   static const Color divider = Color(0xFF2A2F42);
//   static const Color cardBg = Color(0xFF1E2235);

//   static ThemeData get darkTheme {
//     return ThemeData(
//       brightness: Brightness.dark,
//       scaffoldBackgroundColor: background,
//       primaryColor: primary,
//       colorScheme: const ColorScheme.dark(
//         primary: primary,
//         secondary: primary,
//         surface: surface,
//         background: background,
//         error: danger,
//       ),
//       appBarTheme: const AppBarTheme(
//         backgroundColor: surface,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: textPrimary),
//         titleTextStyle: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
//       ),
//       bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//         backgroundColor: surface,
//         selectedItemColor: primary,
//         unselectedItemColor: textSecondary,
//         type: BottomNavigationBarType.fixed,
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primary,
//           foregroundColor: Colors.black,
//           elevation: 0,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//         ),
//       ),
//       cardTheme: CardTheme(
//         color: cardBg,
//         elevation: 0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       ),
//       dividerTheme: const DividerThemeData(color: divider, thickness: 1),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: surfaceLight,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: primary, width: 1.5),
//         ),
//         labelStyle: const TextStyle(color: textSecondary),
//         hintStyle: const TextStyle(color: textSecondary),
//       ),
//     );
//   }
// }

// // ─── App-wide constants ─────────────────────────────────────────────────────
// // IMPORTANT: delivery + order status strings must stay in sync with the user app.
// class AppConstants {
//   static const String appName = 'Rider';

//   // ── Firestore collection names ──────────────────────────────────────────
//   // These MUST match the user app exactly. If user app renames a collection,
//   // update here too.
//   static const String colOrders        = 'orders';
//   static const String colDeliveries    = 'deliveries';
//   static const String colRiders        = 'riders';
//   static const String colUsers         = 'users';
//   static const String colRestaurants   = 'restaurants'; // user app uses 'restaurants'
//   static const String colDispatchJobs  = 'dispatch_jobs';

//   // ── Delivery statuses ───────────────────────────────────────────────────
//   // Written to deliveries/{id}.status by rider app.
//   // Read by user app tracking screen via real-time listener.
//   static const String statusAssigning  = 'ASSIGNING';
//   static const String statusAssigned   = 'ASSIGNED';
//   static const String statusAtStore    = 'AT_STORE';
//   static const String statusPickedUp   = 'PICKED_UP';
//   static const String statusDelivering = 'DELIVERING';
//   static const String statusDelivered  = 'DELIVERED';
//   static const String statusCanceled   = 'CANCELED';

//   // ── Order statuses (mirrored from delivery transitions) ─────────────────
//   // Written to orders/{id}.status by rider app so user app order history works.
//   static const String orderConfirmed   = 'CONFIRMED';
//   static const String orderPreparing   = 'PREPARING';
//   static const String orderPickedUp    = 'PICKED_UP';
//   static const String orderDelivering  = 'DELIVERING';
//   static const String orderCompleted   = 'COMPLETED';

//   // ── Location tracking config ────────────────────────────────────────────
//   static const int    locationIntervalSeconds   = 8;
//   static const double locationDistanceMeters    = 20.0;
//   static const double maxGpsAccuracyMeters      = 50.0;

//   // ── ETA calculation ─────────────────────────────────────────────────────
//   static const double defaultCitySpeedKmh = 22.0; // fallback when GPS speed unavailable
// }

// lib/utils/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF00C896);
  static const Color primaryDark = Color(0xFF009E78);
  static const Color danger = Color(0xFFFF4757);
  static const Color warning = Color(0xFFFFAA00);
  static const Color info = Color(0xFF3D7EFF);
  static const Color background = Color(0xFF0F1117);
  static const Color surface = Color(0xFF1A1D27);
  static const Color surfaceLight = Color(0xFF242838);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9BA3BC);
  static const Color divider = Color(0xFF2A2F42);
  static const Color cardBg = Color(0xFF1E2235);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primary,
        surface: surface,
        background: background,
        error: danger,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
            color: textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: CardThemeData(
        // Fixed class name for modern Flutter
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: const DividerThemeData(color: divider, thickness: 1),
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

// ─── App-wide constants ─────────────────────────────────────────────────────
// IMPORTANT: delivery + order status strings must stay in sync with the user app.
class AppConstants {
  static const String appName = 'Rider';

  // ── Firestore collection names ──────────────────────────────────────────
  // These MUST match the user app exactly. If user app renames a collection,
  // update here too.
  static const String colOrders = 'orders';
  static const String colDeliveries = 'deliveries';
  static const String colRiders = 'riders';
  static const String colUsers = 'users';
  static const String colRestaurants =
      'restaurants'; // user app uses 'restaurants'
  static const String colDispatchJobs = 'dispatch_jobs';

  // ── Delivery statuses ───────────────────────────────────────────────────
  // Written to deliveries/{id}.status by rider app.
  // Read by user app tracking screen via real-time listener.
  static const String statusAssigning = 'ASSIGNING';
  static const String statusAssigned = 'ASSIGNED';
  static const String statusAtStore = 'AT_STORE';
  static const String statusPickedUp = 'PICKED_UP';
  static const String statusDelivering = 'DELIVERING';
  static const String statusDelivered = 'DELIVERED';
  static const String statusCanceled = 'CANCELED';

  // ── Order statuses (mirrored from delivery transitions) ─────────────────
  // Written to orders/{id}.status by rider app so user app order history works.
  static const String orderConfirmed = 'CONFIRMED';
  static const String orderPreparing = 'PREPARING';
  static const String orderPickedUp = 'PICKED_UP';
  static const String orderDelivering = 'DELIVERING';
  static const String orderCompleted = 'COMPLETED';

  // ── Location tracking config ────────────────────────────────────────────
  static const int locationIntervalSeconds = 8;
  static const double locationDistanceMeters = 20.0;

  // Fixed variable names so LocationService can find them
  static const double maxAccuracyMeters = 50.0;
  static const double defaultSpeedKmh = 22.0;
}
