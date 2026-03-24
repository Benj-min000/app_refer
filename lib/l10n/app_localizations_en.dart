// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get time_just_now => 'Just now';

  @override
  String time_minutes(int n) {
    return '${n}m ago';
  }

  @override
  String time_hours(int n) {
    return '${n}h ago';
  }
}
