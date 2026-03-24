// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get time_just_now => '방금';

  @override
  String time_minutes(int n) {
    return '${n}m 전';
  }

  @override
  String time_hours(int n) {
    return '$n시간 전';
  }
}
