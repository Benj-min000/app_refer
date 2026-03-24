// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get time_just_now => 'Właśnie';

  @override
  String time_minutes(int n) {
    return '${n}m temu';
  }

  @override
  String time_hours(int n) {
    return '${n}godz. temu';
  }
}
