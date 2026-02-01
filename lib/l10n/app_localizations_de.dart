// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get helloWorld => 'Hallo Welt!';

  @override
  String get changeLanguage => 'Sprache ändern';

  @override
  String get welcomeMessage => 'Willkommen in unserer App!';

  @override
  String get payment => 'Zahlung';

  @override
  String get checkout => 'Zur Kasse';

  @override
  String get totalAmount => 'Gesamtbetrag';

  @override
  String get orderSummary => 'Bestellübersicht';

  @override
  String get settings => 'Einstellungen';

  @override
  String get offers => 'Angebote';

  @override
  String get whatsOnYourMind => 'Was hast du auf dem Herzen?';

  @override
  String get bookDining => 'Tisch reservieren';

  @override
  String get softDrinks => 'Alkoholfreie Getränke';

  @override
  String get deliveryTime => '45-50 Min.';
}
