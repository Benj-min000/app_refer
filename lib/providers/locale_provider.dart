import 'dart:ui';
import 'package:flutter/material.dart';
import "package:rider_app/models/language_model.dart";
import "package:rider_app/global/global.dart";

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    final isSupported =
        Language.languageList.any((lang) => lang.code == locale.languageCode);

    if (!isSupported) return;

    _locale = locale;
    notifyListeners();

    await saveRiderPref<String>('language_code', locale.languageCode);
  }

  Future<void> loadLocale() async {
    String? languageCode = getRiderPref<String>('language_code');

    if (languageCode == null) {
      final String deviceCode = PlatformDispatcher.instance.locale.languageCode;

      final isSupported =
          Language.languageList.any((lang) => lang.code == deviceCode);

      languageCode = isSupported ? deviceCode : 'en';
    }

    _locale = Locale(languageCode);
    notifyListeners();
  }

  void reset() {
    _locale = Locale('en');
    notifyListeners();
  }
}
