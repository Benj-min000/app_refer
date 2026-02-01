// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get helloWorld => 'Witaj Świecie!';

  @override
  String get changeLanguage => 'Zmień język';

  @override
  String get welcomeMessage => 'Witamy w naszej aplikacji!';

  @override
  String get payment => 'Płatność';

  @override
  String get checkout => 'Przejdź do kasy';

  @override
  String get totalAmount => 'Całkowita kwota';

  @override
  String get orderSummary => 'Podsumowanie zamówienia';

  @override
  String get settings => 'Ustawienia';

  @override
  String get offers => 'Oferty';

  @override
  String get whatsOnYourMind => 'Co masz na myśli?';

  @override
  String get bookDining => 'Rezerwacja stolika';

  @override
  String get softDrinks => 'Napoje gazowane';

  @override
  String get deliveryTime => '45-50 min';
}
