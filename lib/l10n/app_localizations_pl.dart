// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get errorAddressNotFound => 'Address not Found';

  @override
  String get hintSearch => 'Wyszukaj dania lub sklepy';

  @override
  String get tabFoodDelivery => 'Dostawa jedzenia';

  @override
  String get tabGroceryShopping => 'Zakupy spożywcze';

  @override
  String get tabPickup => 'Odbiór osobisty';

  @override
  String get tabGifting => 'Wyślij prezent';

  @override
  String get tabBenefits => 'Oferty';

  @override
  String get categoryDiscounts => 'Codzienne zniżki';

  @override
  String get categoryPork => 'Nóżki wieprzowe/Gotowana wieprzowina';

  @override
  String get categoryTonkatsuSashimi => 'Tonkatsu i Sashimi';

  @override
  String get categoryPizza => 'Pizza';

  @override
  String get categoryStew => 'Gulasz na parze';

  @override
  String get categoryChinese => 'Chińskie jedzenie';

  @override
  String get categoryChicken => 'Kurczak';

  @override
  String get categoryKorean => 'Koreańskie jedzenie';

  @override
  String get categoryOneBowl => 'Posiłki jednogarnkowe';

  @override
  String get categoryPichupDiscount => 'Więcej';

  @override
  String get seeMoreFoodDelivery => 'Zobacz więcej w dostawie jedzenia';

  @override
  String get changeLanguage => 'Zmień język';

  @override
  String get findingLocalization => 'Trwa lokalizowanie...';

  @override
  String get hintName => 'Imię';

  @override
  String get hintEmail => 'Email';

  @override
  String get hintPassword => 'Hasło';

  @override
  String get hintConfPassword => 'Potwierdź hasło';

  @override
  String get login => 'Zaloguj';

  @override
  String get register => 'Zarejestruj';

  @override
  String get signUp => 'Załóż konto';

  @override
  String get registeringAccount => 'Rejestrowanie konta...';

  @override
  String get checkingCredentials => 'Sprawdzanie danych...';

  @override
  String get errorEnterEmailOrPassword => 'Wprowadź email i hasło';

  @override
  String get errorEnterRegInfo => 'Wprowadź wymagane informacje do rejestracji';

  @override
  String get errorSelectImage => 'Wybierz obraz';

  @override
  String get errorNoMatchPasswords => 'Hasła nie są zgodne!';

  @override
  String get errorLoginFailed => 'Logowanie nieudane';

  @override
  String get errorNoRecordFound => 'Nie znaleziono rekordu';

  @override
  String get blockedAccountMessage =>
      'Administrator zablokował Twoje konto\n\nWyślij maila na: admin@gmail.com';

  @override
  String get networkUnavailable => 'Sieć niedostępna. Spróbuj ponownie';

  @override
  String get errorFetchingUserData =>
      'Błąd podczas pobierania danych użytkownika';

  @override
  String storageError(Object error) {
    return 'Błąd pamięci: $error';
  }

  @override
  String get helloWorld => 'Witaj świecie!';

  @override
  String get welcomeMessage => 'Witamy w naszej aplikacji!';

  @override
  String get payment => 'Płatność';

  @override
  String get checkout => 'Przejdź do kasy';

  @override
  String get totalAmount => 'Łączna kwota';

  @override
  String get orderSummary => 'Podsumowanie zamówienia';

  @override
  String get settings => 'Ustawienia';

  @override
  String get offers => 'Oferty';

  @override
  String get whatsOnYourMind => 'O czym myślisz?';

  @override
  String get bookDining => 'Rezerwacja posiłku';

  @override
  String get softDrinks => 'Napoje bezalkoholowe';

  @override
  String get deliveryTime => '45-50 min';
}
