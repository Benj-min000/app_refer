import 'package:flutter/material.dart';
import 'package:user_app/global/global.dart';

/// Dedicated provider for app theme (light / dark).
/// Persists choice to SharedPreferences under key "dark_mode".
///
/// Wire up in main.dart:
///
///   ThemeProvider themeProvider = ThemeProvider();
///   await themeProvider.loadTheme();
///
///   ChangeNotifierProvider.value(value: themeProvider),
///
/// Read in MaterialApp:
///
///   theme: lightTheme,
///   darkTheme: darkTheme,
///   themeMode: themeProvider.themeMode,
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  /// Call once at startup to restore the saved preference.
  Future<void> loadTheme() async {
    final saved = getUserPref<bool>("dark_mode") ?? false;
    _themeMode = saved ? ThemeMode.dark : ThemeMode.light;
    // No notifyListeners() here — called before runApp
  }

  /// Toggle and persist.
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await saveUserPref<bool>("dark_mode", mode == ThemeMode.dark);
    notifyListeners();
  }

  /// Convenience toggle.
  Future<void> toggle() async {
    await setThemeMode(
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }

  /// Called on sign-out to reset to light.
  void reset() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }
}