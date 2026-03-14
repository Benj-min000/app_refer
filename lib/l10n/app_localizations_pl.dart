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

  @override
  String get get_started => 'Rozpocznij';

  @override
  String get pricing => 'Wycena';

  @override
  String get how_it_works => 'Jak to działa';

  @override
  String get build_user_experience =>
      'Zbuduj najlepsze środowisko wyszukiwania dla swoich użytkowników.';

  @override
  String get join_thousands =>
      'Dołącz do tysięcy zespołów skalujących swoje aplikacje za pomocą naszego pulpitu nawigacyjnego.';

  @override
  String get sign_in_to_dashboard => 'Zaloguj się do Panelu sterowania';

  @override
  String get create_your_account => 'Utwórz swoje konto';

  @override
  String get new_to_the_platform => 'Nowość na platformie?';

  @override
  String get already_have_an_account => 'Masz już konto?';

  @override
  String get sign_in => 'Zalogować się';

  @override
  String get sign_up => 'Zapisać się';

  @override
  String get log_in => 'Zaloguj się';

  @override
  String get or => 'LUB';

  @override
  String get terms_of_service =>
      'Kontynuując, akceptujesz Warunki korzystania z usługi.';

  @override
  String get with_google => 'z Google';

  @override
  String get ready_to_grow => 'Gotowy na rozwój?';

  @override
  String get join_restaurants =>
      'Dołącz do restauracji, które już korzystają z Freequick.';

  @override
  String get register_now => 'Zarejestruj się teraz';

  @override
  String get see_how_it_works => 'Zobacz jak to działa';

  @override
  String get now_live_in => 'Teraz mieszkam we Wrocławiu';

  @override
  String get put_your_restaurant_on =>
      'Umieść swoją restaurację na ekranach\nWrocławia.';

  @override
  String get manage_your_menu =>
      'Zarządzaj swoim menu, przesyłaj niestandardowe banery i śledź zamówienia w czasie rzeczywistym.';

  @override
  String get register_your_restaurant => 'Zarejestruj swoją restaurację';

  @override
  String get orders_today => 'Zamówienia dzisiaj';

  @override
  String get total_orders => 'Łączna liczba zamówień';

  @override
  String get restaurants => 'Restauracje';

  @override
  String get menu_items => 'Pozycje menu';

  @override
  String get restaurants_on_platform => 'Restauracje na peronie';

  @override
  String get orders_placed => 'Złożone zamówienia';

  @override
  String get menus_published => 'Opublikowane menu';

  @override
  String get items_available => 'Dostępne przedmioty';

  @override
  String get live_platform_stats => 'STATYSTYKI PLATFORMY NA ŻYWO';

  @override
  String get trusted_by_restaurants => 'ZAUFALI NAM RESTAURACJE';

  @override
  String get upper_features => 'CECHY';

  @override
  String get sales_analytics => 'Analityka sprzedaży';

  @override
  String get track_peak_hours => 'Śledź godziny szczytu.';

  @override
  String get custom_banners => 'Niestandardowe banery';

  @override
  String get full_creative_control => 'Pełna kontrola kreatywna.';

  @override
  String get your_menu_goes_live_instantly =>
      'Twoje menu będzie dostępne natychmiast.';

  @override
  String get digital_menu => 'Menu cyfrowe';

  @override
  String get error_no_user_record_found => 'No user record found.';

  @override
  String get permission_restaurant_accounts_only =>
      'This app is for restaurant accounts only.';

  @override
  String get error_no_restaurant_record_found =>
      'No restaurant record found. Please contact support.';

  @override
  String get creating_partner_account => 'Creating Partner Account...';

  @override
  String get account_is_pending_approval =>
      'Your account is pending approval. Please sign in once verified.';

  @override
  String get business => 'Business';

  @override
  String get admin_profile => 'Admin Profile';

  @override
  String get business_name => 'Business Name';

  @override
  String get business_phone => 'Business Phone';

  @override
  String get info_continue => 'Kontynuować';

  @override
  String get owner_s_full_name => 'Owner\'s Full Name';

  @override
  String get owner_full_name => 'Owner\'s Full Name';

  @override
  String get owner_phone => 'Owner\'s Phone';

  @override
  String get back => 'Back';

  @override
  String get admin_overview => 'Przegląd';

  @override
  String get admin_join_requests => 'Prośby o dołączenie';

  @override
  String get admin_users => 'Użytkownicy';

  @override
  String get admin_notifications => 'Powiadomienia';

  @override
  String get admin_panel => 'Panel administracyjny';

  @override
  String get admin => 'Administrator';

  @override
  String get administrator => 'Administrator';

  @override
  String get sign_out => 'Wyloguj się';

  @override
  String get hiw_hero_badge => 'Proste. Szybkie. Przejrzyste.';

  @override
  String get hiw_hero_title =>
      'Od rejestracji do pierwszego zamówienia w kilka minut.';

  @override
  String get hiw_hero_subtitle =>
      'Freequick został stworzony dla właścicieli restauracji, którzy chcą skupić się na gotowaniu, a nie na zarządzaniu technologią.';

  @override
  String get hiw_cta_title => 'Gotowy zacząć?';

  @override
  String get hiw_cta_subtitle =>
      'Dołącz do restauracji, które już korzystają z Freequick.';

  @override
  String get hiw_cta_primary => 'Zarejestruj swoją restaurację';

  @override
  String get hiw_cta_secondary => 'Zobacz cennik';

  @override
  String get hiw_section_process => 'PROCES';

  @override
  String get hiw_section_features => 'CO OTRZYMASZ';

  @override
  String get hiw_features_title => 'Wszystko, czego potrzebuje restauracja.';

  @override
  String get hiw_step1_title => 'Utwórz swoje konto';

  @override
  String get hiw_step1_desc =>
      'Zarejestruj się, podając dane swojej restauracji. Zajmie to mniej niż 2 minuty. Nie jest wymagana karta kredytowa.';

  @override
  String get hiw_step2_title => 'Skonfiguruj swój profil';

  @override
  String get hiw_step2_desc =>
      'Prześlij swoje logo, baner i ustaw adres. Twoja witryna sklepowa będzie natychmiast dostępna.';

  @override
  String get hiw_step3_title => 'Zbuduj swoje menu';

  @override
  String get hiw_step3_desc =>
      'Dodawaj menu i pozycje ze zdjęciami, cenami i opisami. Sortuj według kategorii.';

  @override
  String get hiw_step4_title => 'Otrzymuj zamówienia';

  @override
  String get hiw_step4_desc =>
      'Klienci znajdą Cię, złożą zamówienia i zapłacą online. Każde zamówienie widzisz na bieżąco na swoim pulpicie.';

  @override
  String get hiw_step5_title => 'Otrzymaj zapłatę';

  @override
  String get hiw_step5_desc =>
      'Przychody są rozliczane na Twoje zarejestrowane konto bankowe. Płacisz jedynie niewielką prowizję za każde zrealizowane zamówienie.';

  @override
  String get hiw_feature1_title => 'Zamówienia w czasie rzeczywistym';

  @override
  String get hiw_feature1_desc =>
      'Każde zamówienie natychmiast pojawia się na Twoim pulpicie. Nie wymaga odświeżania.';

  @override
  String get hiw_feature2_title => 'Analityka sprzedaży';

  @override
  String get hiw_feature2_desc =>
      'Zobacz przychody, popularne produkty i trendy zamówień na przestrzeni 7 lub 30 dni.';

  @override
  String get hiw_feature3_title => 'Niestandardowe branding';

  @override
  String get hiw_feature3_desc =>
      'Twoje logo, baner i kolory — Twoja restauracja, Twoja tożsamość.';

  @override
  String get hiw_feature4_title => 'Bezpieczne płatności';

  @override
  String get hiw_feature4_desc =>
      'Wszystkie płatności są przetwarzane bezpiecznie. Nigdy nie udostępniasz danych karty.';

  @override
  String get hiw_feature5_title => 'Działa wszędzie';

  @override
  String get hiw_feature5_desc =>
      'Panel działa na komputerach stacjonarnych, tabletach i urządzeniach mobilnych. Zarządzaj z dowolnego miejsca.';

  @override
  String get hiw_feature6_title => 'Dedykowane wsparcie';

  @override
  String get hiw_feature6_desc =>
      'Prawdziwi ludzie, którzy pomogą Ci w uruchomieniu i utrzymaniu wszystkiego w ruchu.';

  @override
  String get pricing_hero_badge => 'Żadnych opłat miesięcznych. Nigdy.';

  @override
  String get pricing_hero_title => 'Płać tylko wtedy, gdy zarobisz.';

  @override
  String get pricing_hero_subtitle =>
      'Freequick pobiera niewielką prowizję tylko od zrealizowanych zamówień. Jeśli nie zarobisz, nie płacisz.';

  @override
  String get pricing_cta_title => 'Zacznij za darmo już dziś.';

  @override
  String get pricing_cta_subtitle =>
      'Brak opłat do momentu złożenia pierwszego zamówienia.';

  @override
  String get pricing_cta_primary => 'Zarejestruj swoją restaurację';

  @override
  String get pricing_section_fee => 'JAK DZIAŁA OPŁATA';

  @override
  String get pricing_section_calculator => 'OSZACUJ SWOJE ZAROBKI';

  @override
  String get pricing_section_tiers => 'POZIOMY PROWIZJI';

  @override
  String get pricing_section_faq => 'CZĘSTO ZADAWANE';

  @override
  String get pricing_calculator_title => 'Zobacz, co zachowasz.';

  @override
  String get pricing_tiers_title => 'Więcej zamówień, niższa stawka.';

  @override
  String get pricing_tiers_subtitle =>
      'W miarę rozwoju Twojej restauracji stawka prowizji automatycznie spada.';

  @override
  String get pricing_faq_title => 'Często zadawane pytania.';

  @override
  String get pricing_step1_title => 'Klient składa zamówienie';

  @override
  String get pricing_step1_desc =>
      'Przeglądają menu, dodają pozycje i płacą za pośrednictwem aplikacji.';

  @override
  String get pricing_step2_title => 'Ty przygotowujesz i dostarczasz';

  @override
  String get pricing_step2_desc =>
      'Potwierdzasz zamówienie, przygotowujesz je i oznaczasz jako dostarczone.';

  @override
  String get pricing_step3_title => 'Robimy małe cięcie';

  @override
  String get pricing_step3_desc =>
      'Prowizja jest odliczana od wartości zamówienia. Reszta trafia do Ciebie.';

  @override
  String get pricing_slider_orders_label => 'Zamówienia dziennie';

  @override
  String pricing_slider_orders_value(int count, int monthly) {
    return '$count zamówień/dzień · $monthly/miesiąc';
  }

  @override
  String get pricing_slider_avg_label => 'Średnia wartość zamówienia';

  @override
  String pricing_slider_avg_value(String amount) {
    return '$amount zł';
  }

  @override
  String pricing_tier_badge(String tierName, String rate) {
    return '$tierName poziom — $rate prowizja';
  }

  @override
  String pricing_tier_monthly(int count) {
    return '$count zamówień/miesiąc';
  }

  @override
  String get pricing_calc_revenue_label => 'Dzienny przychód';

  @override
  String get pricing_calc_revenue_sub => 'przed komisją';

  @override
  String pricing_calc_fee_label(String rate) {
    return 'Opłata za bezpłatną szybką dostawę ($rate)';
  }

  @override
  String get pricing_calc_fee_sub => 'za dzień';

  @override
  String get pricing_calc_keep_label => 'Ty trzymasz';

  @override
  String get pricing_calc_disclaimer =>
      'Prowizja pobierana jest wyłącznie za zrealizowane i dostarczone zamówienia.';

  @override
  String get pricing_tier_starter_label => 'Rozrusznik';

  @override
  String get pricing_tier_starter_range => '0 – 100 zamówień/miesiąc';

  @override
  String get pricing_tier_starter_desc =>
      'Zacznij bez żadnych początkowych kosztów.';

  @override
  String get pricing_tier_growing_label => 'Rozwój';

  @override
  String get pricing_tier_growing_range => '101 – 500 zamówień/miesiąc';

  @override
  String get pricing_tier_growing_desc =>
      'Niższa stawka w miarę rozbudowywania bazy klientów.';

  @override
  String get pricing_tier_established_label => 'Przyjęty';

  @override
  String get pricing_tier_established_range => '501 – 1 500 zamówień/miesiąc';

  @override
  String get pricing_tier_established_desc =>
      'Nagradzanie restauracji o stałym, dużym obrocie.';

  @override
  String get pricing_tier_partner_label => 'Partner';

  @override
  String get pricing_tier_partner_range => '1 500+ zamówień/miesiąc';

  @override
  String get pricing_tier_partner_desc =>
      'Nasza najlepsza stawka dla partnerów o największej liczbie zamówień.';

  @override
  String get pricing_faq1_q =>
      'Czy są jakieś opłaty za konfigurację lub opłaty miesięczne?';

  @override
  String get pricing_faq1_a =>
      'Nie. Freequick nie pobiera żadnych opłat instalacyjnych ani miesięcznych. Płacisz prowizję tylko od zrealizowanych zamówień.';

  @override
  String get pricing_faq2_q => 'Kiedy pobierana jest prowizja?';

  @override
  String get pricing_faq2_a =>
      'Prowizja jest naliczana w momencie oznaczenia zamówienia jako dostarczone. Jest ona automatycznie pobierana z Twojego salda wypłaty.';

  @override
  String get pricing_faq3_q => 'Jak często otrzymuję wypłatę?';

  @override
  String get pricing_faq3_a =>
      'Wypłaty są przetwarzane co tydzień na Twoje zarejestrowane konto bankowe IBAN. Możesz śledzić swoje saldo na bieżąco w panelu.';

  @override
  String get pricing_faq4_q =>
      'Co się stanie, jeśli zamówienie zostanie anulowane?';

  @override
  String get pricing_faq4_a =>
      'Za anulowane zamówienia nie pobieramy prowizji. Płacisz tylko za pomyślnie zrealizowane dostawy.';

  @override
  String get pricing_faq5_q =>
      'Czy mogę później zmienić dane swojego konta bankowego?';

  @override
  String get pricing_faq5_a =>
      'Tak. Możesz zaktualizować swój numer IBAN w dowolnym momencie w sekcji Ustawienia w panelu.';

  @override
  String get pricing_tier_name_starter => 'Rozrusznik';

  @override
  String get pricing_tier_name_growing => 'Rozwój';

  @override
  String get pricing_tier_name_established => 'Przyjęty';

  @override
  String get pricing_tier_name_partner => 'Partner';

  @override
  String get admin_notifications_tab_send => 'Wyślij powiadomienie';

  @override
  String get admin_notifications_tab_history => 'Historia';

  @override
  String get admin_notifications_target_audience => 'Grupa docelowa';

  @override
  String get admin_notifications_audience_all => 'Wszystko';

  @override
  String get admin_notifications_audience_restaurants => 'Restauracje';

  @override
  String get admin_notifications_audience_specific => 'Specyficzny';

  @override
  String get admin_notifications_audience_label_all => 'Wszyscy użytkownicy';

  @override
  String get admin_notifications_audience_label_restaurants =>
      'Właściciele restauracji';

  @override
  String get admin_notifications_audience_label_specific =>
      'Konkretni użytkownicy';

  @override
  String get admin_notifications_search_hint =>
      'Szukaj po nazwie lub adresie e-mail…';

  @override
  String get admin_notifications_search_hint_more =>
      'Dodaj więcej użytkowników…';

  @override
  String get admin_notifications_title_label => 'Tytuł powiadomienia';

  @override
  String get admin_notifications_title_hint => 'np. Nowa funkcja dostępna';

  @override
  String get admin_notifications_body_label => 'Wiadomość';

  @override
  String get admin_notifications_body_hint => 'Napisz wiadomość powiadomienia…';

  @override
  String get admin_notifications_send_button => 'Wyślij powiadomienie';

  @override
  String get admin_notifications_sending => 'Przesyłka…';

  @override
  String get admin_notifications_required => 'Wymagany';

  @override
  String get admin_notifications_select_user =>
      'Proszę wybrać co najmniej jednego użytkownika.';

  @override
  String get admin_notifications_no_users =>
      'Nie znaleziono użytkowników dla tej grupy odbiorców.';

  @override
  String get admin_notifications_sent_one => 'Wysłano do 1 użytkownika';

  @override
  String admin_notifications_sent_many(int count) {
    return 'Wysłano do $count użytkowników';
  }

  @override
  String get admin_notifications_history_empty =>
      'Nie wysłano jeszcze żadnych powiadomień';

  @override
  String get admin_notifications_history_sent_badge => 'Wysłano';

  @override
  String admin_notifications_history_sent_count(int count) {
    return '$count wysłano';
  }

  @override
  String get admin_overview_platform_glance => 'PLATFORMA W SKRÓCIE';

  @override
  String get admin_overview_revenue_30d => 'DOCHODY (OSTATNIE 30 DNI)';

  @override
  String get admin_overview_pending_requests =>
      'OCZEKUJĄCE PROŚBY O DOŁĄCZENIE';

  @override
  String get admin_overview_view_all => 'Zobacz wszystko';

  @override
  String get admin_overview_order_status => 'ZESTAWIENIE STATUSU ZAMÓWIENIA';

  @override
  String get admin_overview_top_restaurants =>
      'NAJLEPSZE RESTAURACJE WEDŁUG ZAMÓWIEŃ';

  @override
  String get admin_overview_stat_restaurants => 'Całkowita liczba restauracji';

  @override
  String admin_overview_stat_restaurants_sub(int active) {
    return '$active z zamówieniami';
  }

  @override
  String get admin_overview_stat_orders => 'Łączna liczba zamówień';

  @override
  String admin_overview_stat_orders_sub(int count) {
    return '$count dzisiaj';
  }

  @override
  String get admin_overview_stat_revenue => 'Całkowity przychód';

  @override
  String admin_overview_stat_revenue_sub(String amount) {
    return '$amount zł ostatnie 7 dni';
  }

  @override
  String get admin_overview_stat_avg => 'Średnia wartość zamówienia';

  @override
  String admin_overview_stat_avg_sub(int menus, int items) {
    return '$menus menu · $items pozycji';
  }

  @override
  String get admin_overview_loading => '—';

  @override
  String get admin_overview_revenue_no_data => 'Brak danych o przychodach';

  @override
  String get admin_overview_no_pending => 'Brak oczekujących żądań';

  @override
  String admin_overview_pending_nip(String nip, String date) {
    return 'NIP: $nip · Wysłano $date';
  }

  @override
  String get admin_overview_review => 'Recenzja';

  @override
  String get admin_overview_no_orders => 'Brak zamówień';

  @override
  String get admin_overview_no_order_data => 'Brak danych o zamówieniu';

  @override
  String admin_overview_orders_count(int count) {
    return '$count zamówień';
  }

  @override
  String get admin_overview_status_pending => 'Aż do';

  @override
  String get admin_overview_status_processing => 'Przetwarzanie';

  @override
  String get admin_overview_status_delivered => 'Dostarczony';

  @override
  String get admin_overview_status_cancelled => 'Odwołany';

  @override
  String get requests_tab_registrations => 'Rejestracje';

  @override
  String get requests_tab_go_live => 'Żądania uruchomienia';

  @override
  String get requests_filter_pending => 'Aż do';

  @override
  String get requests_filter_approved => 'Zatwierdzony';

  @override
  String get requests_filter_active => 'Aktywny';

  @override
  String get requests_filter_rejected => 'Odrzucony';

  @override
  String get requests_filter_suspended => 'Zawieszony';

  @override
  String get requests_filter_all => 'Wszystko';

  @override
  String requests_empty_filtered(String filter) {
    return 'Brak $filter żądań';
  }

  @override
  String get requests_empty_all => 'Jeszcze nie ma restauracji';

  @override
  String get requests_go_live_empty => 'Brak jeszcze próśb o uruchomienie';

  @override
  String get requests_go_live_section_pending => 'OCZEKUJĄCE NA PRZEGLĄD';

  @override
  String get requests_go_live_section_reviewed => 'PRZEGLĄDANE';

  @override
  String requests_go_live_requested(String timeAgo, String date) {
    return 'Poproszono $timeAgo · $date';
  }

  @override
  String requests_go_live_activated_on(String date) {
    return 'Aktywowano w dniu $date';
  }

  @override
  String requests_go_live_declined_on(String date) {
    return 'Odrzucono $date';
  }

  @override
  String get requests_badge_activated => 'Aktywowany';

  @override
  String get requests_badge_declined => 'Odrzucony';

  @override
  String get requests_badge_pending_review => 'Oczekujące na przegląd';

  @override
  String get requests_action_activate => 'Aktywować';

  @override
  String get requests_action_decline => 'Spadek';

  @override
  String requests_submitted(String date) {
    return 'Wysłano $date';
  }

  @override
  String get requests_status_approved => 'Zatwierdzony';

  @override
  String get requests_status_active => 'Aktywny';

  @override
  String get requests_status_rejected => 'Odrzucony';

  @override
  String get requests_status_suspended => 'Zawieszony';

  @override
  String get requests_status_pending => 'Aż do';

  @override
  String get requests_action_approve => 'Zatwierdzić';

  @override
  String get requests_action_reject => 'Odrzucić';

  @override
  String get requests_action_suspend => 'Wstrzymać';

  @override
  String get requests_action_reinstate => 'Przywracać na stanowisko';

  @override
  String get requests_action_copy_id => 'Skopiuj identyfikator restauracji';

  @override
  String requests_copied(String id) {
    return 'Skopiowano: $id';
  }

  @override
  String get requests_confirm_approve_title => 'Zatwierdzić';

  @override
  String get requests_confirm_approve_body =>
      'Spowoduje to zatwierdzenie restauracji i przyznanie właścicielowi dostępu do panelu.';

  @override
  String get requests_confirm_reject_title => 'Odrzucić';

  @override
  String get requests_confirm_reject_body =>
      'Spowoduje to odrzucenie restauracji. Właściciel zobaczy komunikat o odrzuceniu po zalogowaniu.';

  @override
  String get requests_confirm_suspend_title => 'Wstrzymać';

  @override
  String get requests_confirm_suspend_body =>
      'Spowoduje to zawieszenie restauracji. Właściciel zostanie natychmiast zablokowany w panelu.';

  @override
  String get requests_confirm_reinstate_title => 'Przywracać na stanowisko';

  @override
  String get requests_confirm_reinstate_body =>
      'Spowoduje to przywrócenie statusu restauracji aktywnej.';

  @override
  String get requests_confirm_cancel => 'Anulować';

  @override
  String requests_error_failed(String error) {
    return 'Nie udało się: $error';
  }

  @override
  String requests_setup_progress(int done, int total) {
    return 'Konfiguracja: $done/$total ukończona';
  }

  @override
  String get requests_check_logo => 'Logo zostało przesłane';

  @override
  String get requests_check_banner => 'Baner przesłany';

  @override
  String get requests_check_address => 'Zestaw adresów';

  @override
  String get requests_check_iban => 'Zestaw IBAN';

  @override
  String get requests_check_photo => 'Zdjęcie profilowe';

  @override
  String get requests_check_menu => 'Co najmniej jedno menu';

  @override
  String get users_search_hint => 'Szukaj po nazwie lub adresie e-mail…';

  @override
  String get users_filter_all => 'Wszystko';

  @override
  String get users_filter_restaurant => 'Restauracja';

  @override
  String get users_filter_admin => 'Administrator';

  @override
  String get users_filter_customer => 'Klient';

  @override
  String get users_empty_filtered =>
      'Żaden użytkownik nie pasuje do Twojego filtra';

  @override
  String get users_empty_all => 'Brak użytkowników';

  @override
  String get users_banned_badge => 'Zakazany';

  @override
  String users_joined(String date) {
    return 'Dołączył $date';
  }

  @override
  String get users_detail_title => 'Szczegóły użytkownika';

  @override
  String get users_detail_id => 'Identyfikator użytkownika';

  @override
  String get users_detail_phone => 'Telefon';

  @override
  String get users_detail_joined => 'Dołączył';

  @override
  String get users_detail_role => 'Rola';

  @override
  String get users_action_ban => 'Zakaz';

  @override
  String get users_action_unban => 'Odbanuj';

  @override
  String get users_action_delete => 'Usuwać';

  @override
  String get users_confirm_cancel => 'Anulować';

  @override
  String get users_ban_title => 'Zablokować użytkownika?';

  @override
  String get users_unban_title => 'Odbanować użytkownika?';

  @override
  String get users_ban_body =>
      'Spowoduje to, że użytkownik nie będzie mógł uzyskać dostępu do platformy.';

  @override
  String get users_unban_body =>
      'Spowoduje to przywrócenie użytkownikowi dostępu.';

  @override
  String get users_delete_title => 'Usunąć użytkownika?';

  @override
  String get users_delete_body =>
      'Spowoduje to trwałe usunięcie dokumentu Firestore użytkownika. Konto użytkownika Auth pozostanie, chyba że zostanie usunięte oddzielnie z poziomu konsoli Firebase.';

  @override
  String get users_snack_banned => 'Użytkownik został zablokowany.';

  @override
  String get users_snack_unbanned => 'Użytkownik został odblokowany.';

  @override
  String get users_snack_deleted => 'Użytkownik został usunięty.';

  @override
  String get users_copied => 'Skopiowano do schowka';

  @override
  String get users_role_admin => 'Administrator';

  @override
  String get users_role_restaurant => 'Restauracja';

  @override
  String get users_role_customer => 'Klient';

  @override
  String get analytics_section_glance => 'W SKRÓCIE';

  @override
  String get analytics_section_revenue => 'PRZYCHODY W CZASIE';

  @override
  String get analytics_section_status => 'ZESTAWIENIE STATUSU ZAMÓWIENIA';

  @override
  String get analytics_section_popular => 'NAJCZĘŚCIEJ ZAMAWIANE PRZEDMIOTY';

  @override
  String analytics_stat_revenue(int days) {
    return 'Przychód (${days}d)';
  }

  @override
  String analytics_stat_orders(int days) {
    return 'Zamówienia (${days}d)';
  }

  @override
  String get analytics_stat_today => 'Dzisiejsza sprzedaż';

  @override
  String get analytics_stat_avg => 'Średnie zamówienie';

  @override
  String get analytics_no_revenue => 'Brak danych o przychodach za ten okres';

  @override
  String get analytics_no_orders => 'Brak zamówień w tym okresie';

  @override
  String get analytics_no_items => 'Brak danych o przedmiotach w tym okresie';

  @override
  String analytics_orders_count(int count) {
    return '$count zamówień';
  }

  @override
  String get analytics_status_normal => 'Normalna';

  @override
  String get analytics_status_processing => 'Przetwarzanie';

  @override
  String get analytics_status_delivered => 'Dostarczony';

  @override
  String get analytics_status_cancelled => 'Odwołany';

  @override
  String get shell_nav_overview => 'Przegląd';

  @override
  String get shell_nav_orders => 'Święcenia';

  @override
  String get shell_nav_menus => 'Menu';

  @override
  String get shell_nav_promotions => 'Promocje';

  @override
  String get shell_nav_analytics => 'Analityka';

  @override
  String get shell_nav_settings => 'Ustawienia';

  @override
  String get shell_restaurant_not_found =>
      'Nie znaleziono restauracji. Skontaktuj się z pomocą techniczną.';

  @override
  String get shell_finish_setup => 'Zakończ konfigurację';

  @override
  String get shell_my_account => 'Moje konto';

  @override
  String get shell_live_go_offline => 'Na żywo · Przejdź do trybu offline';

  @override
  String get shell_go_live_pending =>
      'Przejdź na żywo w oczekiwaniu na przegląd';

  @override
  String get shell_go_live_declined => 'Odrzucono · Złóż wniosek ponownie';

  @override
  String get shell_request_go_live => 'Prośba o uruchomienie';

  @override
  String get shell_already_pending =>
      'Masz już oczekującą prośbę o uruchomienie.';

  @override
  String get shell_go_live_submitted =>
      'Prośba o uruchomienie została wysłana. Wkrótce ją rozpatrzymy.';

  @override
  String shell_error(String error) {
    return 'Błąd: $error';
  }

  @override
  String get shell_go_offline_title => 'Przejść do trybu offline?';

  @override
  String get shell_go_offline_body =>
      'Twoja restauracja będzie ukryta przed klientami. Możesz ją ponownie uruchomić w dowolnym momencie.';

  @override
  String get shell_confirm_cancel => 'Anulować';

  @override
  String get shell_go_offline_confirm => 'Przejdź do trybu offline';

  @override
  String get shell_menu_support => 'Skontaktuj się z pomocą techniczną';

  @override
  String get shell_menu_sales => 'Porozmawiaj ze sprzedażą';

  @override
  String get shell_menu_cookies => 'Preferencje dotyczące plików cookie';

  @override
  String get shell_menu_settings => 'Ustawienia';

  @override
  String get shell_menu_logout => 'Wyloguj się';

  @override
  String get gate_pending_title => 'Twoje konto jest w trakcie sprawdzania';

  @override
  String get gate_pending_message =>
      'Sprawdzamy Twoje dane rejestracyjne. Zazwyczaj zajmuje to 1-2 dni robocze. Po zatwierdzeniu powiadomimy Cię e-mailem.';

  @override
  String get gate_rejected_title => 'Wniosek niezatwierdzony';

  @override
  String get gate_rejected_message =>
      'Niestety Twoja rejestracja nie została zatwierdzona. Skontaktuj się z pomocą techniczną, aby uzyskać więcej informacji.';

  @override
  String get gate_suspended_title => 'Konto zawieszone';

  @override
  String get gate_suspended_message =>
      'Twoje konto zostało zawieszone. Skontaktuj się z pomocą techniczną, aby rozwiązać ten problem.';

  @override
  String get gate_default_title => 'Dostęp niedostępny';

  @override
  String get gate_default_message => 'Skontaktuj się z pomocą techniczną.';

  @override
  String get gate_sign_out => 'Wyloguj się';

  @override
  String overview_welcome(String name) {
    return 'Witamy ponownie, $name 👋';
  }

  @override
  String get overview_subtitle =>
      'Oto, co dzieje się dziś w Twojej restauracji.';

  @override
  String get overview_section_glance => 'W SKRÓCIE';

  @override
  String get overview_section_orders => 'Ostatnie zamówienia';

  @override
  String get overview_setup_title => 'Przygotuj swoją restaurację';

  @override
  String overview_setup_progress(int done, int total) {
    return 'Wykonano$done z $total kroków';
  }

  @override
  String get overview_task_done => 'Zrobione';

  @override
  String get overview_task_setup => 'Organizować coś';

  @override
  String get overview_task_logo_title => 'Prześlij logo restauracji';

  @override
  String get overview_task_logo_desc =>
      'Klienci zobaczą Twoje logo w całej aplikacji.';

  @override
  String get overview_task_banner_title => 'Dodaj obraz banera';

  @override
  String get overview_task_banner_desc =>
      'Baner sprawia, że witryna Twojego sklepu staje się bardziej atrakcyjna wizualnie.';

  @override
  String get overview_task_address_title => 'Ustaw adres restauracji';

  @override
  String get overview_task_address_desc =>
      'Poinformuj klientów, gdzie mogą Cię znaleźć.';

  @override
  String get overview_task_photo_title => 'Dodaj zdjęcie profilowe';

  @override
  String get overview_task_photo_desc =>
      'Dodaj twarz do konta właściciela restauracji.';

  @override
  String get overview_task_menu_title => 'Utwórz menu i dodaj pozycje';

  @override
  String get overview_task_menu_desc =>
      'Uporządkuj swoją ofertę w menu zawierającym dania i ceny.';

  @override
  String get overview_task_iban_title => 'Dodaj konto bankowe (IBAN)';

  @override
  String get overview_task_iban_desc =>
      'Wymagane do otrzymywania wypłat z zamówień klientów.';

  @override
  String get overview_stat_total_orders => 'Łączna liczba zamówień';

  @override
  String get overview_stat_pending => 'Aż do';

  @override
  String get overview_stat_completed => 'Zakończony';

  @override
  String get overview_stat_revenue => 'Całkowity przychód';

  @override
  String get overview_no_orders => 'Brak zamówień';

  @override
  String get overview_table_order_id => 'ID ZAMÓWIENIA';

  @override
  String get overview_table_customer => 'KLIENT';

  @override
  String get overview_table_items => 'RZECZY';

  @override
  String get overview_table_status => 'STATUS';

  @override
  String get overview_table_total => 'CAŁKOWITY';

  @override
  String overview_items_count(int count) {
    return '$count element';
  }

  @override
  String overview_items_count_plural(int count) {
    return '$count elementów';
  }

  @override
  String get overview_time_just_now => 'Właśnie';

  @override
  String overview_time_minutes(int n) {
    return '${n}minut temu';
  }

  @override
  String overview_time_hours(int n) {
    return '${n}godz. temu';
  }

  @override
  String get overview_chef_fallback => 'Szef kuchni';

  @override
  String get items_app_bar_fallback => 'Rzeczy';

  @override
  String get items_empty_title => 'Brak jeszcze pozycji';

  @override
  String get items_empty_subtitle => 'Kliknij +, aby dodać pierwszy element';

  @override
  String items_error(String error) {
    return 'Błąd: $error';
  }

  @override
  String get items_fab => 'Dodaj element';

  @override
  String get items_sheet_title => 'Dodaj element';

  @override
  String get items_image_upload_label => 'Prześlij obraz przedmiotu';

  @override
  String get items_image_browse => 'Kliknij, aby przeglądać';

  @override
  String get items_field_title_label => 'Tytuł przedmiotu';

  @override
  String get items_field_title_hint => 'np. Pierogi Ruskie';

  @override
  String get items_field_title_required => 'Tytuł jest wymagany';

  @override
  String get items_field_info_label => 'Krótkie informacje';

  @override
  String get items_field_info_hint => 'np. Chrupiące i smaczne';

  @override
  String get items_field_info_required => 'Informacje są wymagane';

  @override
  String get items_field_desc_label => 'Opis';

  @override
  String get items_field_desc_hint => 'Opisz przedmiot...';

  @override
  String get items_field_desc_required => 'Opis jest wymagany';

  @override
  String get items_field_price_label => 'Cena (zł)';

  @override
  String get items_field_price_hint => 'np. 24,99';

  @override
  String get items_field_price_required => 'Cena jest wymagana';

  @override
  String get items_field_price_invalid => 'Wprowadź prawidłowy numer';

  @override
  String get items_field_tags_label => 'Tagi';

  @override
  String get items_field_tags_hint => 'np. Wegańskie';

  @override
  String get items_tag_error_empty => 'Proszę wpisać tag';

  @override
  String get items_tag_error_capitalize => 'Pierwsza litera musi być wielka';

  @override
  String get items_tag_error_letters => 'Dozwolone są tylko litery';

  @override
  String get items_tag_error_duplicate => 'Tag już istnieje';

  @override
  String get items_discount_toggle => 'Zastosuj zniżkę';

  @override
  String get items_discount_label => 'Rabat %';

  @override
  String get items_discount_required => 'Wprowadź procent rabatu';

  @override
  String get items_discount_invalid => 'Wprowadź wartość od 1 do 100';

  @override
  String get items_no_image => 'Proszę wybrać obraz przedmiotu.';

  @override
  String get items_added => 'Element dodany pomyślnie';

  @override
  String get items_submit => 'Dodaj element';

  @override
  String get menus_empty_title => 'Brak menu';

  @override
  String get menus_empty_subtitle => 'Kliknij +, aby dodać pierwsze menu';

  @override
  String menus_error(String error) {
    return 'Błąd: $error';
  }

  @override
  String get menus_fab => 'Dodaj menu';

  @override
  String get menus_sheet_title => 'Dodaj menu';

  @override
  String get menus_image_upload_label => 'Prześlij obraz banera';

  @override
  String get menus_image_browse => 'Kliknij, aby przeglądać';

  @override
  String get menus_field_title_label => 'Tytuł menu';

  @override
  String get menus_field_title_hint => 'np. Lunch Specjalny';

  @override
  String get menus_field_title_required => 'Tytuł jest wymagany';

  @override
  String get menus_field_desc_label => 'Opis';

  @override
  String get menus_field_desc_hint => 'Krótko opisz to menu...';

  @override
  String get menus_field_desc_required => 'Opis jest wymagany';

  @override
  String get menus_no_image => 'Proszę wybrać obraz banera.';

  @override
  String get menus_created => 'Menu utworzone pomyślnie';

  @override
  String get menus_submit => 'Utwórz menu';

  @override
  String get orders_error => 'Coś poszło nie tak';

  @override
  String get orders_empty_title => 'Brak zamówień w tej chwili';

  @override
  String get orders_empty_subtitle =>
      'Gdy klienci złożą zamówienie, pojawi się ono w tym miejscu.';

  @override
  String get orders_table_order_id => 'ID ZAMÓWIENIA';

  @override
  String get orders_table_customer => 'KLIENT';

  @override
  String get orders_table_items => 'RZECZY';

  @override
  String get orders_table_status => 'STATUS';

  @override
  String get orders_table_total => 'CAŁKOWITY';

  @override
  String orders_item_count(int count) {
    return '$count element';
  }

  @override
  String orders_item_count_plural(int count) {
    return '$count elementów';
  }

  @override
  String get promo_not_authenticated => 'Nie uwierzytelniono';

  @override
  String get promo_empty_title => 'Brak promocji';

  @override
  String get promo_empty_subtitle =>
      'Kliknij +, aby utworzyć swój pierwszy baner promocyjny';

  @override
  String get promo_fab => 'Nowa promocja';

  @override
  String get promo_badge_live => 'Na żywo';

  @override
  String get promo_badge_inactive => 'Nieaktywny';

  @override
  String promo_items_linked(int count) {
    return '$count element';
  }

  @override
  String promo_items_linked_plural(int count) {
    return '$count elementów';
  }

  @override
  String get promo_edit_button => 'Redagować';

  @override
  String get promo_sheet_add_title => 'Nowa promocja';

  @override
  String get promo_sheet_edit_title => 'Edytuj promocję';

  @override
  String get promo_sheet_delete_button => 'Usuwać';

  @override
  String get promo_image_change_hint => 'Kliknij, aby zmienić baner';

  @override
  String get promo_image_upload_hint => 'Kliknij, aby przesłać obraz banera';

  @override
  String get promo_image_upload_label => 'Prześlij obraz banera';

  @override
  String get promo_image_recommended => 'Zalecane: 1200×400px';

  @override
  String get promo_field_title_label => 'Tytuł promocyjny';

  @override
  String get promo_field_title_hint => 'np. Zniżka weekendowa';

  @override
  String get promo_field_title_required => 'Tytuł jest wymagany';

  @override
  String get promo_field_desc_label => 'Opis';

  @override
  String get promo_field_desc_hint =>
      'np. Do 30% zniżki na wszystkie dania główne w ten weekend';

  @override
  String get promo_field_desc_required => 'Opis jest wymagany';

  @override
  String get promo_date_start => 'Data rozpoczęcia';

  @override
  String get promo_date_end => 'Data zakończenia';

  @override
  String get promo_date_pick => 'Wybierz datę';

  @override
  String get promo_active_toggle => 'Promocja aktywna';

  @override
  String get promo_link_section_label => 'Link do artykułów objętych rabatem';

  @override
  String get promo_link_section_hint =>
      'Opcjonalnie — wybierz pozycje, których dotyczy ta promocja';

  @override
  String get promo_link_no_items =>
      'Nie znaleziono żadnych pozycji. Najpierw dodaj pozycje do menu.';

  @override
  String get promo_save_changes => 'Zapisz zmiany';

  @override
  String get promo_create => 'Utwórz promocję';

  @override
  String get promo_no_dates => 'Proszę ustawić datę początkową i końcową.';

  @override
  String get promo_date_order_error =>
      'Data zakończenia musi być późniejsza niż data rozpoczęcia.';

  @override
  String get promo_no_image => 'Proszę wybrać obraz banera.';

  @override
  String get promo_updated => 'Promocja została pomyślnie zaktualizowana';

  @override
  String get promo_created => 'Promocja utworzona pomyślnie';

  @override
  String get promo_banner_cleanup_error =>
      'Baner został zaktualizowany, ale czyszczenie starego pliku nie powiodło się.';

  @override
  String get promo_delete_title => 'Usunąć promocję?';

  @override
  String get promo_delete_body =>
      'Spowoduje to trwałe usunięcie promocji i jej baneru. Tej czynności nie można cofnąć.';

  @override
  String get promo_delete_cancel => 'Anulować';

  @override
  String get promo_delete_confirm => 'Usuwać';

  @override
  String get promo_deleted => 'Promocja została usunięta.';

  @override
  String get promo_location_dialog_title => 'Lokalizacja restauracji';

  @override
  String get promo_location_none => 'Nie wybrano jeszcze żadnej lokalizacji';

  @override
  String get promo_location_open_map => 'Otwórz mapę';

  @override
  String get promo_location_change_map => 'Zmiana na mapie';

  @override
  String get promo_location_confirm => 'Potwierdź adres';

  @override
  String get promo_location_no_pick => 'Najpierw wybierz lokalizację na mapie.';

  @override
  String get settings_section_business => 'Biznes';

  @override
  String get settings_section_business_sub =>
      'Zarządzaj profilem i mediami swojej restauracji';

  @override
  String get settings_section_profile => 'Profil użytkownika';

  @override
  String get settings_section_profile_sub =>
      'Zaktualizuj dane swojego konta osobistego';

  @override
  String get settings_section_danger => 'Strefa zagrożenia';

  @override
  String get settings_section_danger_sub =>
      'Nieodwracalne działania dla Twojego konta';

  @override
  String get settings_logo_title => 'Logo restauracji';

  @override
  String get settings_logo_status_staged => 'Nowe logo gotowe';

  @override
  String get settings_logo_status_exists => 'Logo zostało przesłane';

  @override
  String get settings_logo_status_none => 'Brak logo';

  @override
  String get settings_logo_recommended => 'Zalecane: 512×512px, PNG lub JPG';

  @override
  String get settings_logo_choose => 'Wybierać';

  @override
  String get settings_logo_upload => 'Wgrywać';

  @override
  String get settings_logo_uploading => 'Przesyłanie…';

  @override
  String get settings_logo_success => 'Zaktualizowano logo';

  @override
  String get settings_banner_title => 'Baner restauracji';

  @override
  String get settings_banner_choose => 'Kliknij, aby wybrać baner';

  @override
  String get settings_banner_recommended => 'Zalecane: 1200×800px';

  @override
  String get settings_banner_upload => 'Prześlij baner';

  @override
  String get settings_banner_uploading => 'Przesyłanie…';

  @override
  String get settings_banner_success => 'Baner zaktualizowany';

  @override
  String get settings_business_title => 'Informacje biznesowe';

  @override
  String get settings_business_saved => 'Informacje o firmie zostały zapisane';

  @override
  String get settings_address_set => 'Ustaw adres restauracji';

  @override
  String get settings_address_change => 'Zmiana';

  @override
  String get settings_address_pick => 'Wybierz na mapie';

  @override
  String get settings_profile_title => 'Profil';

  @override
  String get settings_profile_photo_ready =>
      'Nowe zdjęcie gotowe — naciśnij Zapisz, aby zastosować';

  @override
  String get settings_profile_saved => 'Profil zapisany';

  @override
  String get settings_profile_name_hint => 'Imię i nazwisko właściciela';

  @override
  String get settings_profile_phone_label => 'Numer telefonu';

  @override
  String get settings_danger_reset_title => 'Zmień hasło';

  @override
  String get settings_danger_reset_sub =>
      'Wyślij e-mail z prośbą o zresetowanie hasła na swoje konto';

  @override
  String get settings_danger_reset_button => 'Nastawić';

  @override
  String get settings_danger_reset_sent =>
      'E-mail z resetem hasła został wysłany';

  @override
  String get settings_danger_delete_title => 'Usuń konto';

  @override
  String get settings_danger_delete_sub =>
      'Trwale usuń swoją restaurację i wszystkie dane';

  @override
  String get settings_danger_delete_button => 'Usuwać';

  @override
  String get settings_danger_delete_dialog_title => 'Usuń konto';

  @override
  String get settings_danger_delete_dialog_body =>
      'Spowoduje to trwałe usunięcie Twojego konta i wszystkich danych restauracji. Tej czynności nie można cofnąć.';

  @override
  String get settings_cancel => 'Anulować';

  @override
  String get settings_error => 'Coś poszło nie tak';

  @override
  String get settings_save_changes => 'Zapisz zmiany';

  @override
  String get settings_map_dialog_title => 'Lokalizacja restauracji';

  @override
  String get settings_map_no_location =>
      'Nie wybrano jeszcze żadnej lokalizacji';

  @override
  String get settings_map_open => 'Otwórz mapę';

  @override
  String get settings_map_change => 'Zmiana na mapie';

  @override
  String get settings_map_confirm => 'Potwierdź adres';

  @override
  String get settings_map_no_pick => 'Najpierw wybierz lokalizację na mapie.';

  @override
  String get tap_to_upload_image => 'Tap to upload image';

  @override
  String get ok => 'OK';

  @override
  String get password_does_not_meet_requirements =>
      'Password does not meet requirements';

  @override
  String get password_is_required => 'Password is required';

  @override
  String get snackbar_dismiss => 'DISMISS';

  @override
  String get field_error_required => 'To pole jest wymagane';

  @override
  String get field_error_invalid_format => 'Nieprawidłowy format';

  @override
  String get field_email_message => 'Podaj prawidłowy adres e-mail';

  @override
  String get field_nip_message => 'NIP musi składać się dokładnie z 10 cyfr';

  @override
  String get field_regon_message => 'REGON musi mieć 9 lub 14 cyfr';

  @override
  String get field_postal_code_message =>
      'Wprowadź prawidłowy kod pocztowy (XX-XXX)';

  @override
  String get field_hint_prefix => 'Wchodzić ';

  @override
  String get items_design_edit_button => 'Edytuj element';

  @override
  String get items_design_edit_sheet_title => 'Edytuj element';

  @override
  String get items_design_delete_button => 'Usuń element';

  @override
  String get items_design_change_image_hint => 'Kliknij, aby zmienić obraz';

  @override
  String get items_design_field_title_label => 'Tytuł przedmiotu';

  @override
  String get items_design_field_info_label => 'Krótkie informacje';

  @override
  String get items_design_field_info_hint => 'np. Chrupiące i smaczne';

  @override
  String get items_design_field_desc_label => 'Opis';

  @override
  String get items_design_field_price_label => 'Cena (zł)';

  @override
  String get items_design_field_price_required => 'Cena jest wymagana';

  @override
  String get items_design_field_price_invalid => 'Wprowadź prawidłowy numer';

  @override
  String get items_design_field_tags_label => 'Tagi';

  @override
  String get items_design_field_tags_hint => 'np. Wegańskie';

  @override
  String get items_design_discount_label => 'Rabat %';

  @override
  String get items_design_discount_required => 'Wprowadź procent rabatu';

  @override
  String get items_design_discount_invalid => 'Wprowadź wartość od 1 do 100';

  @override
  String get items_design_save_changes => 'Zapisz zmiany';

  @override
  String get items_design_saved => 'Element zapisany pomyślnie';

  @override
  String get items_design_image_cleanup_error =>
      'Obraz został zaktualizowany, ale oczyszczenie starego pliku nie powiodło się.';

  @override
  String get items_design_delete_dialog_title => 'Usuń element';

  @override
  String get items_design_delete_dialog_body =>
      'Czy na pewno chcesz usunąć ten element? Tej czynności nie można cofnąć.';

  @override
  String get items_design_delete_cancel => 'Anulować';

  @override
  String get items_design_delete_confirm => 'Usuwać';

  @override
  String get items_design_deleted => 'Element został pomyślnie usunięty';

  @override
  String get map_fetching_address => 'Pobieranie adresu...';

  @override
  String get map_address_not_found => 'Nie można znaleźć adresu';

  @override
  String get map_confirm_button => 'POTWIERDŹ ADRES';

  @override
  String get menus_design_view_items => 'Wyświetl elementy';

  @override
  String get menus_design_edit_button => 'Edytuj menu';

  @override
  String get menus_design_edit_sheet_title => 'Edytuj menu';

  @override
  String get menus_design_delete_button => 'Usuń menu';

  @override
  String get menus_design_change_image_hint => 'Kliknij, aby zmienić obraz';

  @override
  String get menus_design_field_title_label => 'Tytuł menu';

  @override
  String get menus_design_field_desc_label => 'Opis';

  @override
  String get menus_design_field_title_required => 'Tytuł jest wymagany';

  @override
  String get menus_design_field_desc_required => 'Opis jest wymagany';

  @override
  String get menus_design_save_changes => 'Zapisz zmiany';

  @override
  String get menus_design_saved => 'Menu zostało pomyślnie zapisane';

  @override
  String get menus_design_banner_cleanup_error =>
      'Baner został zaktualizowany, ale czyszczenie starego pliku nie powiodło się.';

  @override
  String get menus_design_delete_dialog_title => 'Usuń menu';

  @override
  String get menus_design_delete_dialog_body =>
      'Czy na pewno chcesz usunąć to menu? Tej czynności nie można cofnąć.';

  @override
  String get menus_design_delete_cancel => 'Anulować';

  @override
  String get menus_design_delete_confirm => 'Usuwać';

  @override
  String get menus_design_delete_missing_id =>
      'Błąd: Brak menu lub identyfikatora restauracji';

  @override
  String get menus_design_deleted => 'Menu zostało pomyślnie usunięte';

  @override
  String get notif_sheet_title => 'Powiadomienia';

  @override
  String notif_unread_count(int count) {
    return '$count nieprzeczytane';
  }

  @override
  String get notif_mark_all_read => 'Oznacz wszystkie jako przeczytane';

  @override
  String get notif_empty_title => 'Brak powiadomień';

  @override
  String get notif_empty_subtitle =>
      'Wiadomości administratora będą się tutaj pojawiać';

  @override
  String get notif_time_just_now => 'Właśnie';

  @override
  String notif_time_minutes(int n) {
    return '${n}m temu';
  }

  @override
  String notif_time_hours(int n) {
    return '${n}godz. temu';
  }

  @override
  String get notif_time_yesterday => 'Wczoraj';

  @override
  String notif_time_days(int n) {
    return '${n}dni temu';
  }

  @override
  String get addr_use_current_location => 'Użyj bieżącej lokalizacji';

  @override
  String get addr_label_fallback => 'Adres';

  @override
  String get addr_translating => 'Tłumaczenie...';

  @override
  String get addr_error_loading => 'Błąd ładowania adresu';

  @override
  String addr_building(String value) {
    return 'Budynek: $value';
  }

  @override
  String addr_flat(String value) {
    return 'Numer mieszkania: $value';
  }

  @override
  String addr_address(String value) {
    return 'Adres: $value';
  }

  @override
  String get addr_see_in_maps => 'Zobacz na mapach';

  @override
  String get addr_delete => 'Usuwać';

  @override
  String get addr_delete_dialog_title => 'Usuń adres';

  @override
  String addr_delete_dialog_body(String label) {
    return 'Czy na pewno chcesz usunąć $label?';
  }

  @override
  String get addr_delete_cancel => 'Anulować';

  @override
  String get addr_delete_confirm => 'Usunąć';

  @override
  String get addr_deleted => 'Adres został pomyślnie usunięty';

  @override
  String addr_delete_error(String error) {
    return 'Błąd: $error';
  }

  @override
  String get hintPhone => 'Numer telefonu';

  @override
  String get welcomeNotifTitle => 'Powitanie!';

  @override
  String welcomeNotifBody(String name) {
    return 'Dziękujemy za dołączenie do naszej aplikacji, $name!';
  }
}
