import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:user_app/models/language_model.dart";

class LocaleProvider with ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {

    final isSupported = LanguageModel.languageList.any(
      (lang) => lang.code == locale.languageCode
    );

    if (!isSupported) return;

    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');

    if (languageCode == null) {
      final String deviceCode = PlatformDispatcher.instance.locale.languageCode;

      final isSupported = LanguageModel.languageList.any(
        (lang) => lang.code == deviceCode
      );

      languageCode = isSupported ? deviceCode : 'en';
    }

    _locale = Locale(languageCode);
    notifyListeners();
  }
}
