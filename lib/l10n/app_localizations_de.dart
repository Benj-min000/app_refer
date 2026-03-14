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
  String get grandLocation =>
      'Bitte erteilen Sie der App die Standortberechtigung...';

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
  String get tabPickup => 'Abholung';

  @override
  String get tabGroceryShopping => 'Lebensmittel · Einkaufen';

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
  String get categoryFastFood => 'Fastfood';

  @override
  String get categoryCoffee => 'Kaffee';

  @override
  String get categoryBakery => 'Bäckerei';

  @override
  String get categoryLunch => 'Mittagessen';

  @override
  String get categoryFreshProduce => 'Frisches Obst und Gemüse';

  @override
  String get categoryDairyEggs => 'Milchprodukte & Eier';

  @override
  String get categoryMeat => 'Fleisch';

  @override
  String get categoryBeverages => 'Getränke';

  @override
  String get categoryFrozen => 'Gefroren';

  @override
  String get categorySnacks => 'Snacks';

  @override
  String get categoryHousehold => 'Haushalt';

  @override
  String get categoryCakes => 'Kuchen';

  @override
  String get categoryFlowers => 'Blumen';

  @override
  String get categoryGiftBoxes => 'Geschenkboxen';

  @override
  String get categoryPartySupplies => 'Partyartikel';

  @override
  String get categoryGiftCards => 'Geschenkgutscheine';

  @override
  String get categorySpecialOccasions => 'Besondere Anlässe';

  @override
  String get categoryDailyDeals => 'Tagesangebote';

  @override
  String get categoryLoyaltyRewards => 'Treueprämien';

  @override
  String get categoryCoupons => 'Gutscheine';

  @override
  String get categoryNewOffers => 'Neue Angebote';

  @override
  String get categoryExclusiveDeals => 'Exklusive Angebote';

  @override
  String seeMore(Object tab) {
    return 'Mehr dazu in $tab';
  }

  @override
  String get searchAll => 'Alle';

  @override
  String get searchRestaurants => 'Restaurants';

  @override
  String get searchFood => 'Essen';

  @override
  String get searchStores => 'Geschäfte';

  @override
  String get findingLocalization => 'Standort wird ermittelt...';

  @override
  String get changeLanguage => 'Sprache ändern';

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
  String get myCart => 'Mein Warenkorb';

  @override
  String get cartCleared => 'Der Warenkorb wurde geleert.';

  @override
  String get get_started => 'Los geht\'s';

  @override
  String get pricing => 'Preisgestaltung';

  @override
  String get how_it_works => 'So funktioniert es';

  @override
  String get build_user_experience =>
      'Schaffen Sie das beste Sucherlebnis für Ihre Nutzer.';

  @override
  String get join_thousands =>
      'Schließen Sie sich Tausenden von Teams an, die ihre Anwendungen mit unserem Dashboard skalieren.';

  @override
  String get sign_in_to_dashboard => 'Im Dashboard anmelden';

  @override
  String get create_your_account => 'Erstellen Sie Ihr Konto';

  @override
  String get new_to_the_platform => 'Neu auf der Plattform?';

  @override
  String get already_have_an_account => 'Sie haben bereits ein Konto?';

  @override
  String get sign_in => 'anmelden';

  @override
  String get sign_up => 'Melden Sie sich an';

  @override
  String get log_in => 'Einloggen';

  @override
  String get or => 'ODER';

  @override
  String get terms_of_service =>
      'Indem Sie fortfahren, stimmen Sie den Nutzungsbedingungen zu.';

  @override
  String get with_google => 'mit Google';

  @override
  String get ready_to_grow => 'Bereit für Wachstum?';

  @override
  String get join_restaurants =>
      'Schließen Sie sich Restaurants an, die bereits bei Freequick registriert sind.';

  @override
  String get register_now => 'Jetzt registrieren';

  @override
  String get see_how_it_works => 'So funktioniert es';

  @override
  String get now_live_in => 'Ich wohne jetzt in Breslau.';

  @override
  String get put_your_restaurant_on =>
      'Präsentieren Sie Ihr Restaurant auf den Bildschirmen von Breslau.';

  @override
  String get manage_your_menu =>
      'Verwalten Sie Ihre Speisekarte, laden Sie individuelle Banner hoch und verfolgen Sie Bestellungen in Echtzeit.';

  @override
  String get register_your_restaurant => 'Registrieren Sie Ihr Restaurant';

  @override
  String get orders_today => 'Heute bestellen';

  @override
  String get total_orders => 'Gesamtbestellungen';

  @override
  String get restaurants => 'Restaurants';

  @override
  String get menu_items => 'Menüpunkte';

  @override
  String get restaurants_on_platform => 'Restaurants auf dem Bahnsteig';

  @override
  String get orders_placed => 'Bestellungen aufgegeben';

  @override
  String get menus_published => 'veröffentlichte Menüs';

  @override
  String get items_available => 'Verfügbare Artikel';

  @override
  String get live_platform_stats => 'LIVE-PLATTFORMSTATISTIKEN';

  @override
  String get trusted_by_restaurants => 'VON RESTAURANTS EMPFOHLEN';

  @override
  String get upper_features => 'MERKMALE';

  @override
  String get sales_analytics => 'Vertriebsanalyse';

  @override
  String get track_peak_hours => 'Spitzenzeiten verfolgen.';

  @override
  String get custom_banners => 'Individuelle Banner';

  @override
  String get full_creative_control => 'Volle kreative Kontrolle.';

  @override
  String get your_menu_goes_live_instantly =>
      'Ihr Menü wird sofort veröffentlicht.';

  @override
  String get digital_menu => 'Digitales Menü';

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
  String get info_continue => 'Weitermachen';

  @override
  String get owner_s_full_name => 'Owner\'s Full Name';

  @override
  String get owner_full_name => 'Owner\'s Full Name';

  @override
  String get owner_phone => 'Owner\'s Phone';

  @override
  String get back => 'Back';

  @override
  String get admin_overview => 'Überblick';

  @override
  String get admin_join_requests => 'Beitrittsanfragen';

  @override
  String get admin_users => 'Benutzer';

  @override
  String get admin_notifications => 'Benachrichtigungen';

  @override
  String get admin_panel => 'Admin-Panel';

  @override
  String get admin => 'Administrator';

  @override
  String get administrator => 'Administrator';

  @override
  String get sign_out => 'Abmelden';

  @override
  String get hiw_hero_badge => 'Einfach. Schnell. Transparent.';

  @override
  String get hiw_hero_title =>
      'Von der Anmeldung bis zur ersten Bestellung in wenigen Minuten.';

  @override
  String get hiw_hero_subtitle =>
      'Freequick wurde für Restaurantbesitzer entwickelt, die sich auf das Kochen konzentrieren wollen – und nicht auf die Verwaltung von Technologie.';

  @override
  String get hiw_cta_title => 'Bereit loszulegen?';

  @override
  String get hiw_cta_subtitle =>
      'Schließen Sie sich Restaurants an, die bereits bei Freequick registriert sind.';

  @override
  String get hiw_cta_primary => 'Registrieren Sie Ihr Restaurant';

  @override
  String get hiw_cta_secondary => 'Siehe Preise';

  @override
  String get hiw_section_process => 'DER PROZESS';

  @override
  String get hiw_section_features => 'WAS SIE ERHALTEN';

  @override
  String get hiw_features_title => 'Alles, was ein Restaurant braucht.';

  @override
  String get hiw_step1_title => 'Erstellen Sie Ihr Konto';

  @override
  String get hiw_step1_desc =>
      'Registrieren Sie sich mit Ihren Restaurantdaten. Dauert weniger als 2 Minuten. Keine Kreditkarte erforderlich.';

  @override
  String get hiw_step2_title => 'Richten Sie Ihr Profil ein';

  @override
  String get hiw_step2_desc =>
      'Laden Sie Ihr Logo und Banner hoch und geben Sie Ihre Adresse an. Ihr Online-Shop ist sofort online.';

  @override
  String get hiw_step3_title => 'Stellen Sie Ihr Menü zusammen';

  @override
  String get hiw_step3_desc =>
      'Fügen Sie Menüs und Artikel mit Fotos, Preisen und Beschreibungen hinzu. Sortieren Sie nach Kategorien.';

  @override
  String get hiw_step4_title => 'Bestellungen entgegennehmen';

  @override
  String get hiw_step4_desc =>
      'Kunden finden Sie, bestellen und bezahlen online. Sie sehen jede Bestellung in Echtzeit auf Ihrem Dashboard.';

  @override
  String get hiw_step5_title => 'Geld erhalten';

  @override
  String get hiw_step5_desc =>
      'Die Einnahmen werden Ihrem registrierten Bankkonto gutgeschrieben. Sie zahlen lediglich eine geringe Provision pro abgeschlossener Bestellung.';

  @override
  String get hiw_feature1_title => 'Echtzeitbestellungen';

  @override
  String get hiw_feature1_desc =>
      'Jede Bestellung erscheint sofort in Ihrem Dashboard. Kein Aktualisieren erforderlich.';

  @override
  String get hiw_feature2_title => 'Vertriebsanalyse';

  @override
  String get hiw_feature2_desc =>
      'Sehen Sie Umsatz, beliebte Artikel und Bestelltrends über 7 oder 30 Tage.';

  @override
  String get hiw_feature3_title => 'Individuelles Branding';

  @override
  String get hiw_feature3_desc =>
      'Ihr Logo, Ihr Banner und Ihre Farben – Ihr Restaurant, Ihre Identität.';

  @override
  String get hiw_feature4_title => 'Sichere Zahlungen';

  @override
  String get hiw_feature4_desc =>
      'Alle Zahlungen werden sicher abgewickelt. Sie haben niemals Zugriff auf Ihre Kartendaten.';

  @override
  String get hiw_feature5_title => 'Funktioniert überall';

  @override
  String get hiw_feature5_desc =>
      'Das Dashboard läuft auf Desktop-Computern, Tablets und Mobilgeräten. Verwalten Sie es von überall.';

  @override
  String get hiw_feature6_title => 'Engagierter Support';

  @override
  String get hiw_feature6_desc =>
      'Echte Ansprechpartner helfen Ihnen bei der Einrichtung und dem laufenden Betrieb.';

  @override
  String get pricing_hero_badge => 'Keine monatlichen Gebühren. Garantiert.';

  @override
  String get pricing_hero_title => 'Zahle nur, wenn du verdienst.';

  @override
  String get pricing_hero_subtitle =>
      'Freequick erhebt nur eine geringe Provision auf abgeschlossene Bestellungen. Wenn Sie nichts verdienen, zahlen Sie auch nichts.';

  @override
  String get pricing_cta_title => 'Starten Sie noch heute kostenlos.';

  @override
  String get pricing_cta_subtitle =>
      'Es fallen keine Gebühren bis zu Ihrer ersten Bestellung an.';

  @override
  String get pricing_cta_primary => 'Registrieren Sie Ihr Restaurant';

  @override
  String get pricing_section_fee => 'SO FUNKTIONIERT DIE GEBÜHR';

  @override
  String get pricing_section_calculator => 'Schätzen Sie Ihre Einnahmen';

  @override
  String get pricing_section_tiers => 'Kommissionsstufen';

  @override
  String get pricing_section_faq => 'HÄUFIG GESTELLT';

  @override
  String get pricing_calculator_title => 'Schau, was du behältst.';

  @override
  String get pricing_tiers_title => 'Mehr Bestellungen, niedrigerer Preis.';

  @override
  String get pricing_tiers_subtitle =>
      'Mit dem Wachstum Ihres Restaurants sinkt Ihre Provisionsrate automatisch.';

  @override
  String get pricing_faq_title => 'Häufig gestellte Fragen.';

  @override
  String get pricing_step1_title => 'Ein Kunde gibt eine Bestellung auf';

  @override
  String get pricing_step1_desc =>
      'Sie durchstöbern Ihre Speisekarte, fügen Artikel hinzu und bezahlen über die App.';

  @override
  String get pricing_step2_title => 'Sie bereiten vor und liefern';

  @override
  String get pricing_step2_desc =>
      'Sie bestätigen die Bestellung, bereiten sie vor und markieren sie als geliefert.';

  @override
  String get pricing_step3_title => 'Wir behalten einen kleinen Anteil ein.';

  @override
  String get pricing_step3_desc =>
      'Vom Bestellwert wird eine Provision abgezogen. Der Rest geht an Sie.';

  @override
  String get pricing_slider_orders_label => 'Bestellungen pro Tag';

  @override
  String pricing_slider_orders_value(int count, int monthly) {
    return '$count Bestellungen/Tag · $monthly/Monat';
  }

  @override
  String get pricing_slider_avg_label => 'Durchschnittlicher Bestellwert';

  @override
  String pricing_slider_avg_value(String amount) {
    return '$amount PLN';
  }

  @override
  String pricing_tier_badge(String tierName, String rate) {
    return '$tierName Stufe — $rate Provision';
  }

  @override
  String pricing_tier_monthly(int count) {
    return '$count Bestellungen/Monat';
  }

  @override
  String get pricing_calc_revenue_label => 'Tageseinnahmen';

  @override
  String get pricing_calc_revenue_sub => 'vor der Kommission';

  @override
  String pricing_calc_fee_label(String rate) {
    return 'Freequick-Gebühr ($rate)';
  }

  @override
  String get pricing_calc_fee_sub => 'pro Tag';

  @override
  String get pricing_calc_keep_label => 'Du behältst';

  @override
  String get pricing_calc_disclaimer =>
      'Die Provision wird nur für abgeschlossene und ausgelieferte Bestellungen erhoben.';

  @override
  String get pricing_tier_starter_label => 'Anlasser';

  @override
  String get pricing_tier_starter_range => '0 – 100 Bestellungen/Monat';

  @override
  String get pricing_tier_starter_desc => 'Starten Sie ohne Vorabkosten.';

  @override
  String get pricing_tier_growing_label => 'Anbau';

  @override
  String get pricing_tier_growing_range => '101 – 500 Bestellungen/Monat';

  @override
  String get pricing_tier_growing_desc =>
      'Niedrigere Preise bei wachsendem Kundenstamm.';

  @override
  String get pricing_tier_established_label => 'Gegründet';

  @override
  String get pricing_tier_established_range => '501 – 1.500 Bestellungen/Monat';

  @override
  String get pricing_tier_established_desc =>
      'Belohnung von Restaurants mit konstant hohem Umsatz.';

  @override
  String get pricing_tier_partner_label => 'Partner';

  @override
  String get pricing_tier_partner_range =>
      'Mehr als 1.500 Bestellungen pro Monat';

  @override
  String get pricing_tier_partner_desc =>
      'Unser bester Tarif für unsere Partner mit dem höchsten Auftragsvolumen.';

  @override
  String get pricing_faq1_q =>
      'Fallen Einrichtungs- oder monatliche Gebühren an?';

  @override
  String get pricing_faq1_a =>
      'Nein. Freequick erhebt weder Einrichtungsgebühren noch monatliche Gebühren. Sie zahlen lediglich eine Provision auf abgeschlossene Bestellungen.';

  @override
  String get pricing_faq2_q => 'Wann wird die Provision abgezogen?';

  @override
  String get pricing_faq2_a =>
      'Die Provision wird berechnet, sobald eine Bestellung als zugestellt markiert ist. Sie wird automatisch von Ihrem Auszahlungsguthaben abgezogen.';

  @override
  String get pricing_faq3_q => 'Wie oft werde ich bezahlt?';

  @override
  String get pricing_faq3_a =>
      'Auszahlungen erfolgen wöchentlich auf Ihr registriertes IBAN-Bankkonto. Ihren Kontostand können Sie in Echtzeit im Dashboard verfolgen.';

  @override
  String get pricing_faq4_q =>
      'Was passiert, wenn eine Bestellung storniert wird?';

  @override
  String get pricing_faq4_a =>
      'Für stornierte Bestellungen wird keine Provision erhoben. Sie zahlen nur für erfolgreiche, abgeschlossene Lieferungen.';

  @override
  String get pricing_faq5_q => 'Kann ich meine Bankverbindung später ändern?';

  @override
  String get pricing_faq5_a =>
      'Ja. Sie können Ihre IBAN jederzeit im Einstellungsbereich Ihres Dashboards aktualisieren.';

  @override
  String get pricing_tier_name_starter => 'Anlasser';

  @override
  String get pricing_tier_name_growing => 'Anbau';

  @override
  String get pricing_tier_name_established => 'Gegründet';

  @override
  String get pricing_tier_name_partner => 'Partner';

  @override
  String get admin_notifications_tab_send => 'Benachrichtigung senden';

  @override
  String get admin_notifications_tab_history => 'Geschichte';

  @override
  String get admin_notifications_target_audience => 'Zielgruppe';

  @override
  String get admin_notifications_audience_all => 'Alle';

  @override
  String get admin_notifications_audience_restaurants => 'Restaurants';

  @override
  String get admin_notifications_audience_specific => 'Spezifisch';

  @override
  String get admin_notifications_audience_label_all => 'Alle Benutzer';

  @override
  String get admin_notifications_audience_label_restaurants =>
      'Restaurantbesitzer';

  @override
  String get admin_notifications_audience_label_specific =>
      'Bestimmte Benutzer';

  @override
  String get admin_notifications_search_hint =>
      'Suche nach Name oder E-Mail-Adresse…';

  @override
  String get admin_notifications_search_hint_more =>
      'Weitere Benutzer hinzufügen…';

  @override
  String get admin_notifications_title_label => 'Benachrichtigungstitel';

  @override
  String get admin_notifications_title_hint => 'z.B. Neue Funktion verfügbar';

  @override
  String get admin_notifications_body_label => 'Nachricht';

  @override
  String get admin_notifications_body_hint =>
      'Schreiben Sie die Benachrichtigungsnachricht…';

  @override
  String get admin_notifications_send_button => 'Benachrichtigung senden';

  @override
  String get admin_notifications_sending => 'Senden…';

  @override
  String get admin_notifications_required => 'Erforderlich';

  @override
  String get admin_notifications_select_user =>
      'Bitte wählen Sie mindestens einen Benutzer aus.';

  @override
  String get admin_notifications_no_users =>
      'Für diese Zielgruppe wurden keine Nutzer gefunden.';

  @override
  String get admin_notifications_sent_one => 'An 1 Benutzer gesendet';

  @override
  String admin_notifications_sent_many(int count) {
    return 'An $count Benutzer gesendet';
  }

  @override
  String get admin_notifications_history_empty =>
      'Es wurden noch keine Benachrichtigungen versendet.';

  @override
  String get admin_notifications_history_sent_badge => 'Gesendet';

  @override
  String admin_notifications_history_sent_count(int count) {
    return '$count gesendet';
  }

  @override
  String get admin_overview_platform_glance => 'PLATTFORM IM ÜBERBLICK';

  @override
  String get admin_overview_revenue_30d => 'EINNAHMEN (LETZTE 30 TAGE)';

  @override
  String get admin_overview_pending_requests => 'AUSSTEHENDE BEITRITTSANFRAGEN';

  @override
  String get admin_overview_view_all => 'Alle anzeigen';

  @override
  String get admin_overview_order_status => 'AUFLEITUNG DES BESTELLSTATUS';

  @override
  String get admin_overview_top_restaurants =>
      'TOP-RESTAURANTS NACH BESTELLUNGEN';

  @override
  String get admin_overview_stat_restaurants => 'Gesamtzahl der Restaurants';

  @override
  String admin_overview_stat_restaurants_sub(int active) {
    return '$active mit Bestellungen';
  }

  @override
  String get admin_overview_stat_orders => 'Gesamtbestellungen';

  @override
  String admin_overview_stat_orders_sub(int count) {
    return '$count heute';
  }

  @override
  String get admin_overview_stat_revenue => 'Gesamtertrag';

  @override
  String admin_overview_stat_revenue_sub(String amount) {
    return '$amount PLN letzte 7 Tage';
  }

  @override
  String get admin_overview_stat_avg => 'Durchschnittlicher Bestellwert';

  @override
  String admin_overview_stat_avg_sub(int menus, int items) {
    return '$menus Menüs · $items Artikel';
  }

  @override
  String get admin_overview_loading => '—';

  @override
  String get admin_overview_revenue_no_data => 'Noch keine Umsatzdaten.';

  @override
  String get admin_overview_no_pending => 'Keine offenen Anfragen';

  @override
  String admin_overview_pending_nip(String nip, String date) {
    return 'NIP: $nip · Eingereicht $date';
  }

  @override
  String get admin_overview_review => 'Rezension';

  @override
  String get admin_overview_no_orders => 'Noch keine Bestellungen';

  @override
  String get admin_overview_no_order_data => 'Noch keine Bestelldaten.';

  @override
  String admin_overview_orders_count(int count) {
    return '$count Bestellungen';
  }

  @override
  String get admin_overview_status_pending => 'Ausstehend';

  @override
  String get admin_overview_status_processing => 'Verarbeitung';

  @override
  String get admin_overview_status_delivered => 'Geliefert';

  @override
  String get admin_overview_status_cancelled => 'Abgesagt';

  @override
  String get requests_tab_registrations => 'Anmeldungen';

  @override
  String get requests_tab_go_live => 'Go-Live-Anfragen';

  @override
  String get requests_filter_pending => 'Ausstehend';

  @override
  String get requests_filter_approved => 'Genehmigt';

  @override
  String get requests_filter_active => 'Aktiv';

  @override
  String get requests_filter_rejected => 'Abgelehnt';

  @override
  String get requests_filter_suspended => 'Ausgesetzt';

  @override
  String get requests_filter_all => 'Alle';

  @override
  String requests_empty_filtered(String filter) {
    return 'Keine $filter Anfragen';
  }

  @override
  String get requests_empty_all => 'Noch keine Restaurants';

  @override
  String get requests_go_live_empty => 'Noch keine Go-Live-Anfragen.';

  @override
  String get requests_go_live_section_pending => 'ÜBERPRÜFUNG AUSSTEHEND';

  @override
  String get requests_go_live_section_reviewed => 'ÜBERPRÜFT';

  @override
  String requests_go_live_requested(String timeAgo, String date) {
    return 'Angefordert $timeAgo · $date';
  }

  @override
  String requests_go_live_activated_on(String date) {
    return 'Aktiviert am $date';
  }

  @override
  String requests_go_live_declined_on(String date) {
    return 'Abgelehnt am $date';
  }

  @override
  String get requests_badge_activated => 'Aktiviert';

  @override
  String get requests_badge_declined => 'Abgelehnt';

  @override
  String get requests_badge_pending_review => 'Prüfung ausstehend';

  @override
  String get requests_action_activate => 'Aktivieren';

  @override
  String get requests_action_decline => 'Abfall';

  @override
  String requests_submitted(String date) {
    return 'Eingereicht $date';
  }

  @override
  String get requests_status_approved => 'Genehmigt';

  @override
  String get requests_status_active => 'Aktiv';

  @override
  String get requests_status_rejected => 'Abgelehnt';

  @override
  String get requests_status_suspended => 'Ausgesetzt';

  @override
  String get requests_status_pending => 'Ausstehend';

  @override
  String get requests_action_approve => 'Genehmigen';

  @override
  String get requests_action_reject => 'Ablehnen';

  @override
  String get requests_action_suspend => 'Aussetzen';

  @override
  String get requests_action_reinstate => 'Wiedereinsetzen';

  @override
  String get requests_action_copy_id => 'Restaurant-ID kopieren';

  @override
  String requests_copied(String id) {
    return 'Kopiert: $id';
  }

  @override
  String get requests_confirm_approve_title => 'Genehmigen';

  @override
  String get requests_confirm_approve_body =>
      'Damit wird das Restaurant freigegeben und der Inhaber erhält Zugriff auf sein Dashboard.';

  @override
  String get requests_confirm_reject_title => 'Ablehnen';

  @override
  String get requests_confirm_reject_body =>
      'Das Restaurant wird dadurch abgelehnt. Der Inhaber sieht beim Einloggen eine Ablehnungsnachricht.';

  @override
  String get requests_confirm_suspend_title => 'Aussetzen';

  @override
  String get requests_confirm_suspend_body =>
      'Dies führt zur vorübergehenden Schließung des Restaurants. Der Inhaber wird umgehend von seinem Dashboard ausgesperrt.';

  @override
  String get requests_confirm_reinstate_title => 'Wiedereinsetzen';

  @override
  String get requests_confirm_reinstate_body =>
      'Damit wird das Restaurant wieder in Betrieb genommen.';

  @override
  String get requests_confirm_cancel => 'Stornieren';

  @override
  String requests_error_failed(String error) {
    return 'Fehlgeschlagen: $error';
  }

  @override
  String requests_setup_progress(int done, int total) {
    return 'Einrichtung: $done/$total abgeschlossen';
  }

  @override
  String get requests_check_logo => 'Logo hochgeladen';

  @override
  String get requests_check_banner => 'Banner hochgeladen';

  @override
  String get requests_check_address => 'Adresse festgelegt';

  @override
  String get requests_check_iban => 'IBAN-Einstellung';

  @override
  String get requests_check_photo => 'Profilfoto';

  @override
  String get requests_check_menu => 'Mindestens ein Menü';

  @override
  String get users_search_hint => 'Suche nach Name oder E-Mail-Adresse…';

  @override
  String get users_filter_all => 'Alle';

  @override
  String get users_filter_restaurant => 'Restaurant';

  @override
  String get users_filter_admin => 'Administrator';

  @override
  String get users_filter_customer => 'Kunde';

  @override
  String get users_empty_filtered => 'Keine Nutzer entsprechen Ihrem Filter.';

  @override
  String get users_empty_all => 'Noch keine Benutzer';

  @override
  String get users_banned_badge => 'Verboten';

  @override
  String users_joined(String date) {
    return 'Beigetreten $date';
  }

  @override
  String get users_detail_title => 'Benutzerdetails';

  @override
  String get users_detail_id => 'Benutzer-ID';

  @override
  String get users_detail_phone => 'Telefon';

  @override
  String get users_detail_joined => 'Beigetreten';

  @override
  String get users_detail_role => 'Rolle';

  @override
  String get users_action_ban => 'Verbot';

  @override
  String get users_action_unban => 'Entbannung';

  @override
  String get users_action_delete => 'Löschen';

  @override
  String get users_confirm_cancel => 'Stornieren';

  @override
  String get users_ban_title => 'Benutzer sperren?';

  @override
  String get users_unban_title => 'Benutzer entsperren?';

  @override
  String get users_ban_body =>
      'Dies verhindert, dass der Benutzer auf die Plattform zugreifen kann.';

  @override
  String get users_unban_body =>
      'Dadurch wird der Zugriff des Benutzers wiederhergestellt.';

  @override
  String get users_delete_title => 'Benutzer löschen?';

  @override
  String get users_delete_body =>
      'Dadurch wird das Firestore-Dokument des Benutzers endgültig gelöscht. Sein Authentifizierungskonto bleibt erhalten, sofern es nicht separat über die Firebase-Konsole gelöscht wird.';

  @override
  String get users_snack_banned => 'Benutzer gesperrt.';

  @override
  String get users_snack_unbanned => 'Benutzer wurde entsperrt.';

  @override
  String get users_snack_deleted => 'Benutzer gelöscht.';

  @override
  String get users_copied => 'In die Zwischenablage kopiert';

  @override
  String get users_role_admin => 'Administrator';

  @override
  String get users_role_restaurant => 'Restaurant';

  @override
  String get users_role_customer => 'Kunde';

  @override
  String get analytics_section_glance => 'AUF EINEN BLICK';

  @override
  String get analytics_section_revenue => 'EINNAHMEN IM ZEITVERLAUF';

  @override
  String get analytics_section_status => 'AUFLEITUNG DES BESTELLSTATUS';

  @override
  String get analytics_section_popular => 'MEISTBESTELLTE ARTIKEL';

  @override
  String analytics_stat_revenue(int days) {
    return 'Umsatz (${days}d)';
  }

  @override
  String analytics_stat_orders(int days) {
    return 'Aufträge (${days}d)';
  }

  @override
  String get analytics_stat_today => 'Heutige Angebote';

  @override
  String get analytics_stat_avg => 'Durchschnittliche Bestellung';

  @override
  String get analytics_no_revenue =>
      'Für diesen Zeitraum liegen keine Umsatzdaten vor.';

  @override
  String get analytics_no_orders =>
      'In diesem Zeitraum wurden keine Bestellungen aufgegeben.';

  @override
  String get analytics_no_items =>
      'Für diesen Zeitraum liegen keine Artikeldaten vor.';

  @override
  String analytics_orders_count(int count) {
    return '$count Bestellungen';
  }

  @override
  String get analytics_status_normal => 'Normal';

  @override
  String get analytics_status_processing => 'Verarbeitung';

  @override
  String get analytics_status_delivered => 'Geliefert';

  @override
  String get analytics_status_cancelled => 'Abgesagt';

  @override
  String get shell_nav_overview => 'Überblick';

  @override
  String get shell_nav_orders => 'Bestellungen';

  @override
  String get shell_nav_menus => 'Menüs';

  @override
  String get shell_nav_promotions => 'Werbeaktionen';

  @override
  String get shell_nav_analytics => 'Analysen';

  @override
  String get shell_nav_settings => 'Einstellungen';

  @override
  String get shell_restaurant_not_found =>
      'Restaurant nicht gefunden. Bitte kontaktieren Sie den Kundenservice.';

  @override
  String get shell_finish_setup => 'Einrichtung abschließen';

  @override
  String get shell_my_account => 'Mein Konto';

  @override
  String get shell_live_go_offline => 'Live · Offline gehen';

  @override
  String get shell_go_live_pending =>
      'Live-Schaltung vorbehaltlich der Überprüfung';

  @override
  String get shell_go_live_declined => 'Abgelehnt · Erneut bewerben';

  @override
  String get shell_request_go_live => 'Anfrage zum Livegang';

  @override
  String get shell_already_pending =>
      'Sie haben bereits eine ausstehende Go-Live-Anfrage.';

  @override
  String get shell_go_live_submitted =>
      'Die Anfrage zur Live-Schaltung wurde eingereicht. Wir werden sie in Kürze prüfen.';

  @override
  String shell_error(String error) {
    return 'Fehler: $error';
  }

  @override
  String get shell_go_offline_title => 'Offline gehen?';

  @override
  String get shell_go_offline_body =>
      'Ihr Restaurant wird für Kunden unsichtbar sein. Sie können es jederzeit wieder online stellen.';

  @override
  String get shell_confirm_cancel => 'Stornieren';

  @override
  String get shell_go_offline_confirm => 'Offline gehen';

  @override
  String get shell_menu_support => 'Wenden Sie sich an den Support.';

  @override
  String get shell_menu_sales => 'Sprechen Sie mit dem Vertrieb';

  @override
  String get shell_menu_cookies => 'Cookie-Einstellungen';

  @override
  String get shell_menu_settings => 'Einstellungen';

  @override
  String get shell_menu_logout => 'Abmelden';

  @override
  String get gate_pending_title => 'Ihr Konto wird derzeit überprüft.';

  @override
  String get gate_pending_message =>
      'Wir prüfen Ihre Registrierungsdaten. Dies dauert in der Regel 1–2 Werktage. Wir benachrichtigen Sie per E-Mail, sobald Ihre Registrierung genehmigt wurde.';

  @override
  String get gate_rejected_title => 'Antrag nicht genehmigt';

  @override
  String get gate_rejected_message =>
      'Ihre Registrierung wurde leider nicht genehmigt. Bitte kontaktieren Sie den Support für weitere Informationen.';

  @override
  String get gate_suspended_title => 'Konto gesperrt';

  @override
  String get gate_suspended_message =>
      'Ihr Konto wurde gesperrt. Bitte kontaktieren Sie den Support, um das Problem zu beheben.';

  @override
  String get gate_default_title => 'Zugriff nicht möglich';

  @override
  String get gate_default_message => 'Bitte wenden Sie sich an den Support.';

  @override
  String get gate_sign_out => 'Abmelden';

  @override
  String overview_welcome(String name) {
    return 'Willkommen zurück, $name 👋';
  }

  @override
  String get overview_subtitle => 'Das passiert heute in Ihrem Restaurant.';

  @override
  String get overview_section_glance => 'AUF EINEN BLICK';

  @override
  String get overview_section_orders => 'Aktuelle Bestellungen';

  @override
  String get overview_setup_title => 'Bereiten Sie Ihr Restaurant vor';

  @override
  String overview_setup_progress(int done, int total) {
    return '13 von 12 Schritten abgeschlossen';
  }

  @override
  String get overview_task_done => 'Erledigt';

  @override
  String get overview_task_setup => 'Aufstellen';

  @override
  String get overview_task_logo_title => 'Restaurantlogo hochladen';

  @override
  String get overview_task_logo_desc =>
      'Kunden werden Ihr Logo in der gesamten App sehen.';

  @override
  String get overview_task_banner_title => 'Fügen Sie ein Bannerbild hinzu';

  @override
  String get overview_task_banner_desc =>
      'Ein Banner macht Ihr Schaufenster optisch ansprechender.';

  @override
  String get overview_task_address_title => 'Restaurantadresse festlegen';

  @override
  String get overview_task_address_desc =>
      'Informieren Sie Ihre Kunden darüber, wo sie Sie finden können.';

  @override
  String get overview_task_photo_title => 'Füge ein Profilfoto hinzu';

  @override
  String get overview_task_photo_desc =>
      'Geben Sie Ihrem Restaurantbesitzer-Konto ein Gesicht.';

  @override
  String get overview_task_menu_title => 'Menü erstellen & Elemente hinzufügen';

  @override
  String get overview_task_menu_desc =>
      'Organisieren Sie Ihr Angebot in Menüs mit Gerichten und Preisen.';

  @override
  String get overview_task_iban_title => 'Bankkonto hinzufügen (IBAN)';

  @override
  String get overview_task_iban_desc =>
      'Erforderlich, um Auszahlungen aus Kundenbestellungen zu erhalten.';

  @override
  String get overview_stat_total_orders => 'Gesamtbestellungen';

  @override
  String get overview_stat_pending => 'Ausstehend';

  @override
  String get overview_stat_completed => 'Vollendet';

  @override
  String get overview_stat_revenue => 'Gesamtertrag';

  @override
  String get overview_no_orders => 'Noch keine Bestellungen';

  @override
  String get overview_table_order_id => 'Bestellnummer';

  @override
  String get overview_table_customer => 'KUNDE';

  @override
  String get overview_table_items => 'ARTIKEL';

  @override
  String get overview_table_status => 'STATUS';

  @override
  String get overview_table_total => 'GESAMT';

  @override
  String overview_items_count(int count) {
    return '$count Artikel';
  }

  @override
  String overview_items_count_plural(int count) {
    return '$count Artikel';
  }

  @override
  String get overview_time_just_now => 'Soeben';

  @override
  String overview_time_minutes(int n) {
    return '${n}m vor';
  }

  @override
  String overview_time_hours(int n) {
    return '${n}Stunden zuvor';
  }

  @override
  String get overview_chef_fallback => 'Küchenchef';

  @override
  String get items_app_bar_fallback => 'Artikel';

  @override
  String get items_empty_title => 'Noch keine Artikel';

  @override
  String get items_empty_subtitle =>
      'Tippe auf +, um deinen ersten Eintrag hinzuzufügen.';

  @override
  String items_error(String error) {
    return 'Fehler: $error';
  }

  @override
  String get items_fab => 'Artikel hinzufügen';

  @override
  String get items_sheet_title => 'Artikel hinzufügen';

  @override
  String get items_image_upload_label => 'Artikelbild hochladen';

  @override
  String get items_image_browse => 'Zum Durchsuchen klicken';

  @override
  String get items_field_title_label => 'Artikelbezeichnung';

  @override
  String get items_field_title_hint => 'z.B. Pierogi Ruskie';

  @override
  String get items_field_title_required => 'Ein Titel ist erforderlich';

  @override
  String get items_field_info_label => 'Kurzinfo';

  @override
  String get items_field_info_hint => 'z.B. knusprig und lecker';

  @override
  String get items_field_info_required => 'Es werden Informationen benötigt.';

  @override
  String get items_field_desc_label => 'Beschreibung';

  @override
  String get items_field_desc_hint => 'Beschreiben Sie den Artikel...';

  @override
  String get items_field_desc_required => 'Eine Beschreibung ist erforderlich.';

  @override
  String get items_field_price_label => 'Preis (PLN)';

  @override
  String get items_field_price_hint => 'z. B. 24,99';

  @override
  String get items_field_price_required => 'Preis erforderlich';

  @override
  String get items_field_price_invalid => 'Geben Sie eine gültige Nummer ein';

  @override
  String get items_field_tags_label => 'Tags';

  @override
  String get items_field_tags_hint => 'z.B. Vegan';

  @override
  String get items_tag_error_empty => 'Bitte geben Sie ein Schlagwort ein.';

  @override
  String get items_tag_error_capitalize =>
      'Der erste Buchstabe muss großgeschrieben werden.';

  @override
  String get items_tag_error_letters => 'Nur Buchstaben sind erlaubt';

  @override
  String get items_tag_error_duplicate => 'Tag existiert bereits';

  @override
  String get items_discount_toggle => 'Rabatt anwenden';

  @override
  String get items_discount_label => 'Rabatt %';

  @override
  String get items_discount_required => 'Geben Sie einen Rabattprozentsatz ein';

  @override
  String get items_discount_invalid =>
      'Geben Sie einen Wert zwischen 1 und 100 ein.';

  @override
  String get items_no_image => 'Bitte wählen Sie ein Artikelbild aus.';

  @override
  String get items_added => 'Artikel erfolgreich hinzugefügt';

  @override
  String get items_submit => 'Artikel hinzufügen';

  @override
  String get menus_empty_title => 'Noch keine Menüs';

  @override
  String get menus_empty_subtitle =>
      'Tippe auf +, um dein erstes Menü hinzuzufügen';

  @override
  String menus_error(String error) {
    return 'Fehler: $error';
  }

  @override
  String get menus_fab => 'Menü hinzufügen';

  @override
  String get menus_sheet_title => 'Menü hinzufügen';

  @override
  String get menus_image_upload_label => 'Bannerbild hochladen';

  @override
  String get menus_image_browse => 'Zum Durchsuchen klicken';

  @override
  String get menus_field_title_label => 'Menütitel';

  @override
  String get menus_field_title_hint => 'z.B. Mittagsangebote';

  @override
  String get menus_field_title_required => 'Ein Titel ist erforderlich';

  @override
  String get menus_field_desc_label => 'Beschreibung';

  @override
  String get menus_field_desc_hint => 'Beschreiben Sie dieses Menü kurz...';

  @override
  String get menus_field_desc_required => 'Eine Beschreibung ist erforderlich.';

  @override
  String get menus_no_image => 'Bitte wählen Sie ein Bannerbild aus.';

  @override
  String get menus_created => 'Menü erfolgreich erstellt';

  @override
  String get menus_submit => 'Menü erstellen';

  @override
  String get orders_error => 'Etwas ist schiefgelaufen.';

  @override
  String get orders_empty_title => 'Derzeit keine Bestellungen.';

  @override
  String get orders_empty_subtitle =>
      'Wenn Kunden Bestellungen aufgeben, werden diese hier angezeigt.';

  @override
  String get orders_table_order_id => 'Bestellnummer';

  @override
  String get orders_table_customer => 'KUNDE';

  @override
  String get orders_table_items => 'ARTIKEL';

  @override
  String get orders_table_status => 'STATUS';

  @override
  String get orders_table_total => 'GESAMT';

  @override
  String orders_item_count(int count) {
    return '$count Artikel';
  }

  @override
  String orders_item_count_plural(int count) {
    return '$count Artikel';
  }

  @override
  String get promo_not_authenticated => 'Nicht authentifiziert';

  @override
  String get promo_empty_title => 'Noch keine Werbeaktionen';

  @override
  String get promo_empty_subtitle =>
      'Tippe auf +, um dein erstes Werbebanner zu erstellen.';

  @override
  String get promo_fab => 'Neue Aktion';

  @override
  String get promo_badge_live => 'Live';

  @override
  String get promo_badge_inactive => 'Inaktiv';

  @override
  String promo_items_linked(int count) {
    return '$count Artikel';
  }

  @override
  String promo_items_linked_plural(int count) {
    return '$count Artikel';
  }

  @override
  String get promo_edit_button => 'Bearbeiten';

  @override
  String get promo_sheet_add_title => 'Neue Aktion';

  @override
  String get promo_sheet_edit_title => 'Aktion bearbeiten';

  @override
  String get promo_sheet_delete_button => 'Löschen';

  @override
  String get promo_image_change_hint =>
      'Tippen Sie hier, um das Banner zu ändern.';

  @override
  String get promo_image_upload_hint =>
      'Tippen Sie hier, um ein Bannerbild hochzuladen.';

  @override
  String get promo_image_upload_label => 'Bannerbild hochladen';

  @override
  String get promo_image_recommended => 'Empfohlene Größe: 1200×400px';

  @override
  String get promo_field_title_label => 'Beförderungstitel';

  @override
  String get promo_field_title_hint => 'z. B. Wochenendrabatt';

  @override
  String get promo_field_title_required => 'Ein Titel ist erforderlich';

  @override
  String get promo_field_desc_label => 'Beschreibung';

  @override
  String get promo_field_desc_hint =>
      'z. B. Bis zu 30 % Rabatt auf alle Hauptgerichte an diesem Wochenende';

  @override
  String get promo_field_desc_required => 'Eine Beschreibung ist erforderlich.';

  @override
  String get promo_date_start => 'Startdatum';

  @override
  String get promo_date_end => 'Enddatum';

  @override
  String get promo_date_pick => 'Wählen Sie ein Datum';

  @override
  String get promo_active_toggle => 'Aktion aktiv';

  @override
  String get promo_link_section_label => 'Link zu reduzierten Artikeln';

  @override
  String get promo_link_section_hint =>
      'Optional – Wählen Sie die Artikel aus, für die diese Aktion gilt.';

  @override
  String get promo_link_no_items =>
      'Keine Artikel gefunden. Fügen Sie zuerst Artikel zu Ihren Menüs hinzu.';

  @override
  String get promo_save_changes => 'Änderungen speichern';

  @override
  String get promo_create => 'Aktion erstellen';

  @override
  String get promo_no_dates =>
      'Bitte geben Sie sowohl das Start- als auch das Enddatum an.';

  @override
  String get promo_date_order_error =>
      'Das Enddatum muss nach dem Startdatum liegen.';

  @override
  String get promo_no_image => 'Bitte wählen Sie ein Bannerbild aus.';

  @override
  String get promo_updated => 'Aktion erfolgreich aktualisiert';

  @override
  String get promo_created => 'Werbeaktion erfolgreich erstellt';

  @override
  String get promo_banner_cleanup_error =>
      'Banner wurde aktualisiert, aber die Bereinigung der alten Datei ist fehlgeschlagen.';

  @override
  String get promo_delete_title => 'Werbeaktion löschen?';

  @override
  String get promo_delete_body =>
      'Dadurch werden die Werbeaktion und das zugehörige Banner endgültig gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.';

  @override
  String get promo_delete_cancel => 'Stornieren';

  @override
  String get promo_delete_confirm => 'Löschen';

  @override
  String get promo_deleted => 'Werbeaktion gelöscht.';

  @override
  String get promo_location_dialog_title => 'Restaurantstandort';

  @override
  String get promo_location_none => 'Noch kein Standort ausgewählt';

  @override
  String get promo_location_open_map => 'Karte öffnen';

  @override
  String get promo_location_change_map => 'Änderung auf der Karte';

  @override
  String get promo_location_confirm => 'Adresse bestätigen';

  @override
  String get promo_location_no_pick =>
      'Bitte wählen Sie zuerst einen Ort auf der Karte aus.';

  @override
  String get settings_section_business => 'Geschäft';

  @override
  String get settings_section_business_sub =>
      'Verwalten Sie Ihr Restaurantprofil und Ihre Medien';

  @override
  String get settings_section_profile => 'Benutzerprofil';

  @override
  String get settings_section_profile_sub =>
      'Aktualisieren Sie Ihre persönlichen Kontodaten.';

  @override
  String get settings_section_danger => 'Gefahrenzone';

  @override
  String get settings_section_danger_sub =>
      'Unwiderrufliche Maßnahmen für Ihr Konto';

  @override
  String get settings_logo_title => 'Restaurantlogo';

  @override
  String get settings_logo_status_staged => 'Neues Logo fertig';

  @override
  String get settings_logo_status_exists => 'Logo hochgeladen';

  @override
  String get settings_logo_status_none => 'Noch kein Logo';

  @override
  String get settings_logo_recommended => 'Empfohlen: 512×512px, PNG oder JPG';

  @override
  String get settings_logo_choose => 'Wählen';

  @override
  String get settings_logo_upload => 'Hochladen';

  @override
  String get settings_logo_uploading => 'Wird hochgeladen…';

  @override
  String get settings_logo_success => 'Logo aktualisiert';

  @override
  String get settings_banner_title => 'Restaurantbanner';

  @override
  String get settings_banner_choose =>
      'Klicken Sie hier, um das Banner auszuwählen.';

  @override
  String get settings_banner_recommended => 'Empfohlene Größe: 1200×800px';

  @override
  String get settings_banner_upload => 'Banner hochladen';

  @override
  String get settings_banner_uploading => 'Wird hochgeladen…';

  @override
  String get settings_banner_success => 'Banner aktualisiert';

  @override
  String get settings_business_title => 'Geschäftsinformationen';

  @override
  String get settings_business_saved => 'Geschäftsinformationen gespeichert';

  @override
  String get settings_address_set => 'Restaurantadresse festlegen';

  @override
  String get settings_address_change => 'Ändern';

  @override
  String get settings_address_pick => 'Auf der Karte auswählen';

  @override
  String get settings_profile_title => 'Profil';

  @override
  String get settings_profile_photo_ready =>
      'Neues Foto fertig – zum Anwenden auf „Speichern“ klicken.';

  @override
  String get settings_profile_saved => 'Profil gespeichert';

  @override
  String get settings_profile_name_hint => 'Name des Eigentümers';

  @override
  String get settings_profile_phone_label => 'Telefonnummer';

  @override
  String get settings_danger_reset_title => 'Kennwort ändern';

  @override
  String get settings_danger_reset_sub =>
      'Senden Sie eine E-Mail zum Zurücksetzen Ihres Passworts an Ihr Konto.';

  @override
  String get settings_danger_reset_button => 'Zurücksetzen';

  @override
  String get settings_danger_reset_sent =>
      'E-Mail zum Zurücksetzen des Passworts gesendet';

  @override
  String get settings_danger_delete_title => 'Konto löschen';

  @override
  String get settings_danger_delete_sub =>
      'Löschen Sie Ihr Restaurant und alle Daten endgültig.';

  @override
  String get settings_danger_delete_button => 'Löschen';

  @override
  String get settings_danger_delete_dialog_title => 'Konto löschen';

  @override
  String get settings_danger_delete_dialog_body =>
      'Dadurch werden Ihr Konto und alle Restaurantdaten endgültig gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.';

  @override
  String get settings_cancel => 'Stornieren';

  @override
  String get settings_error => 'Etwas ist schiefgelaufen.';

  @override
  String get settings_save_changes => 'Änderungen speichern';

  @override
  String get settings_map_dialog_title => 'Restaurantstandort';

  @override
  String get settings_map_no_location => 'Noch kein Standort ausgewählt';

  @override
  String get settings_map_open => 'Karte öffnen';

  @override
  String get settings_map_change => 'Änderung auf der Karte';

  @override
  String get settings_map_confirm => 'Adresse bestätigen';

  @override
  String get settings_map_no_pick =>
      'Bitte wählen Sie zuerst einen Ort auf der Karte aus.';

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
  String get field_error_required => 'Dieses Feld ist erforderlich';

  @override
  String get field_error_invalid_format => 'Ungültiges Format';

  @override
  String get field_email_message =>
      'Geben Sie eine gültige E-Mail-Adresse ein.';

  @override
  String get field_nip_message =>
      'Die NIP-Nummer muss genau 10 Ziffern lang sein.';

  @override
  String get field_regon_message => 'REGON muss 9 oder 14 Ziffern lang sein.';

  @override
  String get field_postal_code_message =>
      'Geben Sie eine gültige Postleitzahl ein (XX-XXX).';

  @override
  String get field_hint_prefix => 'Eingeben ';

  @override
  String get items_design_edit_button => 'Element bearbeiten';

  @override
  String get items_design_edit_sheet_title => 'Element bearbeiten';

  @override
  String get items_design_delete_button => 'Element löschen';

  @override
  String get items_design_change_image_hint =>
      'Tippen Sie, um das Bild zu ändern';

  @override
  String get items_design_field_title_label => 'Artikelbezeichnung';

  @override
  String get items_design_field_info_label => 'Kurzinfo';

  @override
  String get items_design_field_info_hint => 'z.B. knusprig und lecker';

  @override
  String get items_design_field_desc_label => 'Beschreibung';

  @override
  String get items_design_field_price_label => 'Preis (PLN)';

  @override
  String get items_design_field_price_required => 'Preis erforderlich';

  @override
  String get items_design_field_price_invalid =>
      'Geben Sie eine gültige Nummer ein';

  @override
  String get items_design_field_tags_label => 'Tags';

  @override
  String get items_design_field_tags_hint => 'z.B. Vegan';

  @override
  String get items_design_discount_label => 'Rabatt %';

  @override
  String get items_design_discount_required =>
      'Geben Sie einen Rabattprozentsatz ein';

  @override
  String get items_design_discount_invalid =>
      'Geben Sie einen Wert zwischen 1 und 100 ein.';

  @override
  String get items_design_save_changes => 'Änderungen speichern';

  @override
  String get items_design_saved => 'Element erfolgreich gespeichert';

  @override
  String get items_design_image_cleanup_error =>
      'Das Bild wurde aktualisiert, aber die Bereinigung der alten Datei ist fehlgeschlagen.';

  @override
  String get items_design_delete_dialog_title => 'Element löschen';

  @override
  String get items_design_delete_dialog_body =>
      'Sind Sie sicher, dass Sie diesen Eintrag löschen möchten? Dieser Vorgang kann nicht rückgängig gemacht werden.';

  @override
  String get items_design_delete_cancel => 'Stornieren';

  @override
  String get items_design_delete_confirm => 'Löschen';

  @override
  String get items_design_deleted => 'Element erfolgreich gelöscht';

  @override
  String get map_fetching_address => 'Adresse wird abgerufen...';

  @override
  String get map_address_not_found =>
      'Die Adresse konnte nicht gefunden werden.';

  @override
  String get map_confirm_button => 'ADRESSE BESTÄTIGEN';

  @override
  String get menus_design_view_items => 'Artikel ansehen';

  @override
  String get menus_design_edit_button => 'Menü bearbeiten';

  @override
  String get menus_design_edit_sheet_title => 'Menü bearbeiten';

  @override
  String get menus_design_delete_button => 'Menü löschen';

  @override
  String get menus_design_change_image_hint =>
      'Tippen Sie, um das Bild zu ändern';

  @override
  String get menus_design_field_title_label => 'Menütitel';

  @override
  String get menus_design_field_desc_label => 'Beschreibung';

  @override
  String get menus_design_field_title_required => 'Ein Titel ist erforderlich';

  @override
  String get menus_design_field_desc_required =>
      'Eine Beschreibung ist erforderlich.';

  @override
  String get menus_design_save_changes => 'Änderungen speichern';

  @override
  String get menus_design_saved => 'Menü erfolgreich gespeichert';

  @override
  String get menus_design_banner_cleanup_error =>
      'Banner wurde aktualisiert, aber die Bereinigung der alten Datei ist fehlgeschlagen.';

  @override
  String get menus_design_delete_dialog_title => 'Menü löschen';

  @override
  String get menus_design_delete_dialog_body =>
      'Möchten Sie dieses Menü wirklich löschen? Dieser Vorgang kann nicht rückgängig gemacht werden.';

  @override
  String get menus_design_delete_cancel => 'Stornieren';

  @override
  String get menus_design_delete_confirm => 'Löschen';

  @override
  String get menus_design_delete_missing_id =>
      'Fehler: Menü- oder Restaurant-ID fehlt.';

  @override
  String get menus_design_deleted => 'Menü erfolgreich gelöscht';

  @override
  String get notif_sheet_title => 'Benachrichtigungen';

  @override
  String notif_unread_count(int count) {
    return '$count ungelesen';
  }

  @override
  String get notif_mark_all_read => 'Als gelesen markieren';

  @override
  String get notif_empty_title => 'Noch keine Benachrichtigungen';

  @override
  String get notif_empty_subtitle =>
      'Administratormeldungen werden hier angezeigt.';

  @override
  String get notif_time_just_now => 'Soeben';

  @override
  String notif_time_minutes(int n) {
    return '${n}m vor';
  }

  @override
  String notif_time_hours(int n) {
    return '${n}Stunden zuvor';
  }

  @override
  String get notif_time_yesterday => 'Gestern';

  @override
  String notif_time_days(int n) {
    return '${n}d ago';
  }

  @override
  String get addr_use_current_location => 'Aktuellen Standort verwenden';

  @override
  String get addr_label_fallback => 'Adresse';

  @override
  String get addr_translating => 'Übersetzung...';

  @override
  String get addr_error_loading => 'Fehler beim Laden der Adresse';

  @override
  String addr_building(String value) {
    return 'Gebäude: $value';
  }

  @override
  String addr_flat(String value) {
    return 'Wohnungsnummer: $value';
  }

  @override
  String addr_address(String value) {
    return 'Adresse: $value';
  }

  @override
  String get addr_see_in_maps => 'In Karten ansehen';

  @override
  String get addr_delete => 'Löschen';

  @override
  String get addr_delete_dialog_title => 'Adresse entfernen';

  @override
  String addr_delete_dialog_body(String label) {
    return 'Möchten Sie $label wirklich entfernen?';
  }

  @override
  String get addr_delete_cancel => 'Stornieren';

  @override
  String get addr_delete_confirm => 'Entfernen';

  @override
  String get addr_deleted => 'Adresse erfolgreich gelöscht';

  @override
  String addr_delete_error(String error) {
    return 'Fehler: $error';
  }

  @override
  String get hintPhone => 'Telefonnummer';

  @override
  String get welcomeNotifTitle => 'Willkommen!';

  @override
  String welcomeNotifBody(String name) {
    return 'Vielen Dank, dass Sie unserer App beigetreten sind, $name!';
  }
}
