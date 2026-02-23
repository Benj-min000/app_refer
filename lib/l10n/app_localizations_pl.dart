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
  String get unknownLocation => 'Nieznana lokalizacja';

  @override
  String get searchAddress => 'Wyszukaj adres...';

  @override
  String errorReverseGeo(Object error) {
    return 'Błąd odwrotnego geokodowania: $error';
  }

  @override
  String get grandLocation =>
      'Proszę o udzielenie aplikacji zgody na lokalizację...';

  @override
  String get goBack => 'Wróć';

  @override
  String get suggestedMatch => 'Sugerowane dopasowanie';

  @override
  String get confirmContinue => 'Potwierdź i kontynuuj';

  @override
  String get refreshLocation => 'Odśwież lokalizację';

  @override
  String get hintSearch => 'Wyszukaj dania lub sklepy';

  @override
  String get tabFoodDelivery => 'Dostawa jedzenia';

  @override
  String get tabPickup => 'Odbiór osobisty';

  @override
  String get tabGroceryShopping => 'Zakupy spożywcze';

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
  String get categoryFastFood => 'Fast food';

  @override
  String get categoryCoffee => 'Kawa';

  @override
  String get categoryBakery => 'Piekarnia';

  @override
  String get categoryLunch => 'Obiad';

  @override
  String get categoryFreshProduce => 'Świeże produkty';

  @override
  String get categoryDairyEggs => 'Nabiał i jaja';

  @override
  String get categoryMeat => 'Mięso';

  @override
  String get categoryBeverages => 'Napoje';

  @override
  String get categoryFrozen => 'Mrożony';

  @override
  String get categorySnacks => 'Przekąski';

  @override
  String get categoryHousehold => 'Gospodarstwo domowe';

  @override
  String get categoryCakes => 'Ciasta';

  @override
  String get categoryFlowers => 'Kwiaty';

  @override
  String get categoryGiftBoxes => 'Pudełka prezentowe';

  @override
  String get categoryPartySupplies => 'Artykuły imprezowe';

  @override
  String get categoryGiftCards => 'Karty podarunkowe';

  @override
  String get categorySpecialOccasions => 'Specjalne okazje';

  @override
  String get categoryDailyDeals => 'Oferty dnia';

  @override
  String get categoryLoyaltyRewards => 'Nagrody za lojalność';

  @override
  String get categoryCoupons => 'Kupony';

  @override
  String get categoryNewOffers => 'Nowe oferty';

  @override
  String get categoryExclusiveDeals => 'Ekskluzywne oferty';

  @override
  String seeMore(Object tab) {
    return 'Zobacz więcej w $tab';
  }

  @override
  String get searchAll => 'Wszystko';

  @override
  String get searchRestaurants => 'Restauracje';

  @override
  String get searchFood => 'Żywność';

  @override
  String get searchStores => 'Sklepy';

  @override
  String get findingLocalization => 'Trwa lokalizowanie...';

  @override
  String get changeLanguage => 'Zmień język';

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
  String get myCart => 'Mój koszyk';

  @override
  String get cartCleared => 'Koszyk został wyczyszczony';
}
