// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get time_just_now => 'Щойно';

  @override
  String time_minutes(int n) {
    return '$nхв тому';
  }

  @override
  String time_hours(int n) {
    return '$nгод тому';
  }
}
