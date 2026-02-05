// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get errorAddressNotFound => 'Address not Found';

  @override
  String get unknownLocation => 'Unbekannter Ort';

  @override
  String get searchAddress => 'Adresse suchen...';

  @override
  String errorReverseGeo(Object error) {
    return 'Fehler bei der umgekehrten Geokodierung: $error';
  }

  @override
  String get goBack => 'Geh zurück';

  @override
  String get suggestedMatch => 'Vorschlag für eine passende Übereinstimmung';

  @override
  String get confirmContinue => 'Bestätigen & Fortfahren';

  @override
  String get refreshLocation => 'Standort aktualisieren';

  @override
  String get hintSearch => 'Suche nach Gerichten oder Geschäften';

  @override
  String get tabFoodDelivery => 'Essenslieferung';

  @override
  String get tabGroceryShopping => 'Lebensmittel · Einkaufen';

  @override
  String get tabPickup => 'Abholung';

  @override
  String get tabGifting => 'Geschenke senden';

  @override
  String get tabBenefits => 'Angebote';

  @override
  String get categoryDiscounts => 'Tägliche Rabatte';

  @override
  String get categoryPork => 'Schweinsfüße/Gekochtes Schweinefleisch';

  @override
  String get categoryTonkatsuSashimi => 'Tonkatsu und Sashimi';

  @override
  String get categoryPizza => 'Pizza';

  @override
  String get categoryStew => 'Gedämpfter Eintopf';

  @override
  String get categoryChinese => 'Chinesisches Essen';

  @override
  String get categoryChicken => 'Huhn';

  @override
  String get categoryKorean => 'Koreanisches Essen';

  @override
  String get categoryOneBowl => 'Ein-Schüssel-Gerichte';

  @override
  String get categoryPichupDiscount => 'Mehr';

  @override
  String seeMore(Object tab) {
    return 'Mehr dazu in $tab';
  }

  @override
  String get changeLanguage => 'Sprache ändern';

  @override
  String get findingLocalization => 'Standort wird ermittelt...';

  @override
  String get hintName => 'Name';

  @override
  String get hintEmail => 'E-Mail';

  @override
  String get hintPassword => 'Passwort';

  @override
  String get hintConfPassword => 'Passwort bestätigen';

  @override
  String get login => 'Anmelden';

  @override
  String get register => 'Registrieren';

  @override
  String get signUp => 'Konto erstellen';

  @override
  String get registeringAccount => 'Registrierung des Kontos...';

  @override
  String get checkingCredentials => 'Überprüfung der Zugangsdaten...';

  @override
  String get errorEnterEmailOrPassword => 'Bitte E-Mail und Passwort eingeben';

  @override
  String get errorEnterRegInfo =>
      'Bitte geben Sie die erforderlichen Informationen für die Registrierung ein';

  @override
  String get errorSelectImage => 'Bitte wählen Sie ein Bild aus';

  @override
  String get errorNoMatchPasswords => 'Passwörter stimmen nicht überein!';

  @override
  String get errorLoginFailed => 'Anmeldung fehlgeschlagen';

  @override
  String get errorNoRecordFound => 'Kein Eintrag gefunden';

  @override
  String get blockedAccountMessage =>
      'Der Administrator hat Ihr Konto gesperrt\n\nMail senden an: admin@gmail.com';

  @override
  String get networkUnavailable =>
      'Netzwerk nicht verfügbar. Bitte erneut versuchen';

  @override
  String get errorFetchingUserData => 'Fehler beim Abrufen der Benutzerdaten';

  @override
  String storageError(Object error) {
    return 'Speicherfehler: $error';
  }

  @override
  String get helloWorld => 'Hallo Welt!';

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
  String get whatsOnYourMind => 'Woran denkst du?';

  @override
  String get bookDining => 'Tisch reservieren';

  @override
  String get softDrinks => 'Erfrischungsgetränke';

  @override
  String get deliveryTime => '45-50 Min';
}
