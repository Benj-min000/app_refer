// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get time_just_now => 'Soeben';

  @override
  String time_minutes(int n) {
    return '${n}m vor';
  }

  @override
  String time_hours(int n) {
    return '${n}h vor';
  }
}
