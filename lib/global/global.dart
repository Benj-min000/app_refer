// lib/utils/rider_global.dart
//
// Rider app equivalent of the customer app's global.dart.
// UID comes directly from FirebaseAuth — never stored in SharedPreferences.
// SharedPreferences is used only for local rider preferences (vehicle type,
// onboarding complete flag etc.).
//
// Usage in main.dart:
//   riderPrefs = await SharedPreferences.getInstance();

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? riderPrefs;
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

// UID always comes from FirebaseAuth — never stored locally
String? get currentRiderUID => firebaseAuth.currentUser?.uid;

// ── Per-rider prefixed prefs ──────────────────────────────────────────────────
// Keys are prefixed with the rider's UID so multiple riders on the same
// device don't overwrite each other's preferences.

Future<void> saveRiderPref<T>(String key, T value) async {
  if (currentRiderUID == null) return;
  final String prefixedKey = '${currentRiderUID}_$key';

  if (value is String) {
    await riderPrefs!.setString(prefixedKey, value);
  } else if (value is int) {
    await riderPrefs!.setInt(prefixedKey, value);
  } else if (value is bool) {
    await riderPrefs!.setBool(prefixedKey, value);
  } else if (value is double) {
    await riderPrefs!.setDouble(prefixedKey, value);
  } else if (value is List<String>) {
    await riderPrefs!.setStringList(prefixedKey, value);
  }
}

T? getRiderPref<T>(String key) {
  if (currentRiderUID == null) return null;
  final String prefixedKey = '${currentRiderUID}_$key';
  return riderPrefs!.get(prefixedKey) as T?;
}

// ── Session clear ─────────────────────────────────────────────────────────────
// Call on sign-out. Does NOT clear all prefs — only removes session-level keys.
// Per-rider prefixed keys survive so preferences are restored on next login.

Future<void> clearRiderSession() async {
  // Nothing session-specific to clear — UID comes from FirebaseAuth,
  // not SharedPreferences. FirebaseAuth.signOut() handles the session.
  // This is a hook for any future session keys that need clearing.
}

// ── Pref key constants ────────────────────────────────────────────────────────
// Centralised so nothing is ever mistyped across the app.

class RiderPrefKeys {
  // Set during profile setup, read in home screen stats section
  static const String vehicleType      = 'vehicleType';

  // Set in profile/settings screen
  static const String notifNewJob      = 'notif_new_job';
  static const String notifOrderUpdate = 'notif_order_update';

  // Dark mode — wired to ThemeProvider same as customer app
  static const String darkMode         = 'dark_mode';

  // Onboarding
  static const String onboardingDone   = 'onboarding_done';
}