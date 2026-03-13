// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get errorAddressNotFound => 'Address not Found';

  @override
  String get unknownLocation => 'Невідоме місцезнаходження';

  @override
  String get searchAddress => 'Пошук адреси...';

  @override
  String errorReverseGeo(Object error) {
    return 'Помилка зворотного геокодування: $error';
  }

  @override
  String get grandLocation =>
      'Будь ласка, надайте застосунку дозвіл на визначення місцезнаходження...';

  @override
  String get goBack => 'Назад';

  @override
  String get suggestedMatch => 'Пропонований збіг';

  @override
  String get confirmContinue => 'Підтвердити та продовжити';

  @override
  String get refreshLocation => 'Оновити місцезнаходження';

  @override
  String get hintSearch => 'Пошук страв або магазинів';

  @override
  String get tabFoodDelivery => 'Доставка їжі';

  @override
  String get tabPickup => 'Самовивіз';

  @override
  String get tabGroceryShopping => 'Продукти · Покупки';

  @override
  String get tabGifting => 'Подарунки';

  @override
  String get tabBenefits => 'Акції';

  @override
  String get categoryDiscounts => 'Щоденні знижки';

  @override
  String get categoryPork => 'Свинячі лапки/Варенна свинина';

  @override
  String get categoryTonkatsuSashimi => 'Тонкацу і сашимі';

  @override
  String get categoryPizza => 'Піца';

  @override
  String get categoryStew => 'Тушкована страва на пару';

  @override
  String get categoryChinese => 'Китайська їжа';

  @override
  String get categoryChicken => 'Курка';

  @override
  String get categoryKorean => 'Корейська кухня';

  @override
  String get categoryOneBowl => 'Страви з однієї миски';

  @override
  String get categoryPichupDiscount => 'Більше';

  @override
  String get categoryFastFood => 'Фастфуд';

  @override
  String get categoryCoffee => 'Кава';

  @override
  String get categoryBakery => 'Пекарня';

  @override
  String get categoryLunch => 'Обід';

  @override
  String get categoryFreshProduce => 'Свіжі продукти';

  @override
  String get categoryDairyEggs => 'Молочні продукти та яйця';

  @override
  String get categoryMeat => 'М\'ясо';

  @override
  String get categoryBeverages => 'Напої';

  @override
  String get categoryFrozen => 'Заморожений';

  @override
  String get categorySnacks => 'Закуски';

  @override
  String get categoryHousehold => 'Домогосподарство';

  @override
  String get categoryCakes => 'Торти';

  @override
  String get categoryFlowers => 'Квіти';

  @override
  String get categoryGiftBoxes => 'Подарункові коробки';

  @override
  String get categoryPartySupplies => 'святкове приладдя';

  @override
  String get categoryGiftCards => 'Подарункові картки';

  @override
  String get categorySpecialOccasions => 'Особливі випадки';

  @override
  String get categoryDailyDeals => 'Щоденні пропозиції';

  @override
  String get categoryLoyaltyRewards => 'Нагороди за лояльність';

  @override
  String get categoryCoupons => 'Купони';

  @override
  String get categoryNewOffers => 'Нові пропозиції';

  @override
  String get categoryExclusiveDeals => 'Ексклюзивні пропозиції';

  @override
  String seeMore(Object tab) {
    return 'Дивіться більше в $tab';
  }

  @override
  String get searchAll => 'Усі';

  @override
  String get searchRestaurants => 'Ресторани';

  @override
  String get searchFood => 'Їжа';

  @override
  String get searchStores => 'Магазини';

  @override
  String get findingLocalization => 'Визначення вашого місцезнаходження...';

  @override
  String get changeLanguage => 'Змінити мову';

  @override
  String get hintName => 'Ім\'я';

  @override
  String get hintEmail => 'Електронна пошта';

  @override
  String get hintPassword => 'Пароль';

  @override
  String get hintConfPassword => 'Підтвердьте пароль';

  @override
  String get login => 'Увійти';

  @override
  String get register => 'Зареєструватися';

  @override
  String get signUp => 'Створити акаунт';

  @override
  String get registeringAccount => 'Реєстрація акаунта...';

  @override
  String get checkingCredentials => 'Перевірка даних...';

  @override
  String get errorEnterEmailOrPassword =>
      'Будь ласка, введіть електронну пошту та пароль';

  @override
  String get errorEnterRegInfo =>
      'Будь ласка, введіть необхідну інформацію для реєстрації';

  @override
  String get errorSelectImage => 'Будь ласка, виберіть зображення';

  @override
  String get errorNoMatchPasswords => 'Паролі не збігаються!';

  @override
  String get errorLoginFailed => 'Помилка входу';

  @override
  String get errorNoRecordFound => 'Запис не знайдено';

  @override
  String get blockedAccountMessage =>
      'Адміністратор заблокував ваш акаунт\n\nНапишіть на: admin@gmail.com';

  @override
  String get networkUnavailable => 'Мережа недоступна. Спробуйте ще раз';

  @override
  String get errorFetchingUserData => 'Помилка отримання даних користувача';

  @override
  String storageError(Object error) {
    return 'Помилка сховища: $error';
  }

  @override
  String get helloWorld => 'Привіт, світ!';

  @override
  String get welcomeMessage => 'Ласкаво просимо до нашого додатку!';

  @override
  String get payment => 'Оплата';

  @override
  String get checkout => 'Перейти до оплати';

  @override
  String get totalAmount => 'Загальна сума';

  @override
  String get orderSummary => 'Підсумок замовлення';

  @override
  String get settings => 'Налаштування';

  @override
  String get offers => 'Пропозиції';

  @override
  String get whatsOnYourMind => 'Про що ви думаєте?';

  @override
  String get bookDining => 'Забронювати обід';

  @override
  String get softDrinks => 'Безалкогольні напої';

  @override
  String get myCart => 'Мій кошик';

  @override
  String get cartCleared => 'Кошик очищено';

  @override
  String get get_started => 'Почати';

  @override
  String get pricing => 'Ціноутворення';

  @override
  String get how_it_works => 'Як це працює';

  @override
  String get build_user_experience =>
      'Створіть найкращий пошуковий досвід для ваших користувачів.';

  @override
  String get join_thousands =>
      'Приєднуйтесь до тисяч команд, які масштабують свої програми за допомогою нашої панелі інструментів.';

  @override
  String get sign_in_to_dashboard => 'Увійти в інформаційну панель';

  @override
  String get create_your_account => 'Створіть свій обліковий запис';

  @override
  String get new_to_the_platform => 'Вперше на платформі?';

  @override
  String get already_have_an_account => 'Вже маєте обліковий запис?';

  @override
  String get sign_in => 'Увійти';

  @override
  String get sign_up => 'Зареєструватися';

  @override
  String get log_in => 'Увійти';

  @override
  String get or => 'АБО';

  @override
  String get terms_of_service =>
      'Продовжуючи, ви погоджуєтеся з Умовами надання послуг.';

  @override
  String get with_google => 'з Google';

  @override
  String get ready_to_grow => 'Готові рости?';

  @override
  String get join_restaurants =>
      'Приєднуйтесь до ресторанів, які вже користуються Freequick.';

  @override
  String get register_now => 'Зареєструватися зараз';

  @override
  String get see_how_it_works => 'Дивіться, як це працює';

  @override
  String get now_live_in => 'Зараз живу у Вроцлаві';

  @override
  String get put_your_restaurant_on =>
      'Розмістіть свій ресторан на екранах Вроцлава.';

  @override
  String get manage_your_menu =>
      'Керуйте своїм меню, завантажуйте власні банери та відстежуйте замовлення в режимі реального часу.';

  @override
  String get register_your_restaurant => 'Зареєструйте свій ресторан';

  @override
  String get orders_today => 'Замовлення сьогодні';

  @override
  String get total_orders => 'Загальна кількість замовлень';

  @override
  String get restaurants => 'Ресторани';

  @override
  String get menu_items => 'Пункти меню';

  @override
  String get restaurants_on_platform => 'Ресторани на платформі';

  @override
  String get orders_placed => 'Розміщених замовлень';

  @override
  String get menus_published => 'Меню опубліковано';

  @override
  String get items_available => 'Доступні товари';

  @override
  String get live_platform_stats => 'СТАТИСТИКА ПЛАТФОРМИ В ПРЯМОМУ ЕФІРІ';

  @override
  String get trusted_by_restaurants => 'ДОВІРЯЮТЬ РЕСТОРАНТИ';

  @override
  String get upper_features => 'ОСОБЛИВОСТІ';

  @override
  String get sales_analytics => 'Аналітика продажів';

  @override
  String get track_peak_hours => 'Відстежуйте години пік.';

  @override
  String get custom_banners => 'Власні банери';

  @override
  String get full_creative_control => 'Повний творчий контроль.';

  @override
  String get your_menu_goes_live_instantly =>
      'Ваше меню миттєво опублікується.';

  @override
  String get digital_menu => 'Цифрове меню';

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
  String get info_continue => 'Продовжити';

  @override
  String get owner_s_full_name => 'Owner\'s Full Name';

  @override
  String get owner_full_name => 'Owner\'s Full Name';

  @override
  String get owner_phone => 'Owner\'s Phone';

  @override
  String get back => 'Back';

  @override
  String get admin_overview => 'Огляд';

  @override
  String get admin_join_requests => 'Запити на приєднання';

  @override
  String get admin_users => 'Користувачі';

  @override
  String get admin_notifications => 'Сповіщення';

  @override
  String get admin_panel => 'Панель адміністратора';

  @override
  String get admin => 'Адміністратор';

  @override
  String get administrator => 'Administrator';

  @override
  String get sign_out => 'Вийти';

  @override
  String get hiw_hero_badge => 'Просто. Швидко. Прозоро.';

  @override
  String get hiw_hero_title =>
      'Від реєстрації до першого замовлення за лічені хвилини.';

  @override
  String get hiw_hero_subtitle =>
      'Freequick створений для власників ресторанів, які хочуть зосередитися на приготуванні їжі, а не на управлінні технологіями.';

  @override
  String get hiw_cta_title => 'Готові розпочати?';

  @override
  String get hiw_cta_subtitle =>
      'Приєднуйтесь до ресторанів, які вже користуються Freequick.';

  @override
  String get hiw_cta_primary => 'Зареєструйте свій ресторан';

  @override
  String get hiw_cta_secondary => 'Див. ціни';

  @override
  String get hiw_section_process => 'ПРОЦЕС';

  @override
  String get hiw_section_features => 'ЩО ВИ ОТРИМУЄТЕ';

  @override
  String get hiw_features_title => 'Все, що потрібно ресторану.';

  @override
  String get hiw_step1_title => 'Створіть свій обліковий запис';

  @override
  String get hiw_step1_desc =>
      'Зареєструйтесь, використовуючи дані вашого ресторану. Займає менше 2 хвилин. Кредитна картка не потрібна.';

  @override
  String get hiw_step2_title => 'Налаштуйте свій профіль';

  @override
  String get hiw_step2_desc =>
      'Завантажте свій логотип, банер та встановіть адресу. Ваша вітрина одразу ж запуститься.';

  @override
  String get hiw_step3_title => 'Створіть своє меню';

  @override
  String get hiw_step3_desc =>
      'Додайте меню та страви з фотографіями, цінами та описами. Упорядкуйте за категоріями.';

  @override
  String get hiw_step4_title => 'Отримувати замовлення';

  @override
  String get hiw_step4_desc =>
      'Клієнти знаходять вас, розміщують замовлення та оплачують онлайн. Ви бачите кожне замовлення в режимі реального часу на своїй інформаційній панелі.';

  @override
  String get hiw_step5_title => 'Отримуйте оплату';

  @override
  String get hiw_step5_desc =>
      'Дохід зараховується на ваш зареєстрований банківський рахунок. Ви сплачуєте лише невелику комісію за кожне виконане замовлення.';

  @override
  String get hiw_feature1_title => 'Замовлення в режимі реального часу';

  @override
  String get hiw_feature1_desc =>
      'Кожне замовлення миттєво відображається на вашій інформаційній панелі. Оновлення не потрібне.';

  @override
  String get hiw_feature2_title => 'Аналітика продажів';

  @override
  String get hiw_feature2_desc =>
      'Переглядайте дохід, популярні товари та тенденції замовлень протягом 7 або 30 днів.';

  @override
  String get hiw_feature3_title => 'Індивідуальний брендинг';

  @override
  String get hiw_feature3_desc =>
      'Ваш логотип, банер та кольори — ваш ресторан, ваша ідентичність.';

  @override
  String get hiw_feature4_title => 'Безпечні платежі';

  @override
  String get hiw_feature4_desc =>
      'Усі платежі обробляються безпечно. Ви ніколи не маєте доступу до даних картки.';

  @override
  String get hiw_feature5_title => 'Працює скрізь';

  @override
  String get hiw_feature5_desc =>
      'Панель керування працює на комп’ютері, планшеті та мобільному пристрої. Керуйте з будь-якого місця.';

  @override
  String get hiw_feature6_title => 'Спеціальна підтримка';

  @override
  String get hiw_feature6_desc =>
      'Реальні люди, готові допомогти вам налаштуватися та продовжити роботу.';

  @override
  String get pricing_hero_badge => 'Без щомісячної плати. Ніколи.';

  @override
  String get pricing_hero_title => 'Платіть лише тоді, коли заробляєте.';

  @override
  String get pricing_hero_subtitle =>
      'Freequick стягує невелику комісію лише за виконані замовлення. Якщо ви не заробляєте, ви не платите.';

  @override
  String get pricing_cta_title => 'Почніть безкоштовно вже сьогодні.';

  @override
  String get pricing_cta_subtitle => 'Без комісії до першого замовлення.';

  @override
  String get pricing_cta_primary => 'Зареєструйте свій ресторан';

  @override
  String get pricing_section_fee => 'ЯК ПРАЦЮЄ КОМІСІЯ';

  @override
  String get pricing_section_calculator => 'ОЦІНІТЬ СВІЙ ЗАРОБОК';

  @override
  String get pricing_section_tiers => 'РІВНІ КОМІСІЇ';

  @override
  String get pricing_section_faq => 'ЧАСТО ЗАПИТАННЯ';

  @override
  String get pricing_calculator_title => 'Дивись, що ти зберігаєш.';

  @override
  String get pricing_tiers_title => 'Більше замовлень, нижча ставка.';

  @override
  String get pricing_tiers_subtitle =>
      'У міру зростання вашого ресторану ваша комісія автоматично знижується.';

  @override
  String get pricing_faq_title => 'Поширені питання.';

  @override
  String get pricing_step1_title => 'Клієнт розміщує замовлення';

  @override
  String get pricing_step1_desc =>
      'Вони переглядають ваше меню, додають страви та платять через додаток.';

  @override
  String get pricing_step2_title => 'Ви готуєте та доставляєте';

  @override
  String get pricing_step2_desc =>
      'Ви підтверджуєте замовлення, готуєте його та позначаєте як доставлене.';

  @override
  String get pricing_step3_title => 'Робимо невеликий зріз';

  @override
  String get pricing_step3_desc =>
      'Комісія стягується з вартості замовлення. Решта йде вам.';

  @override
  String get pricing_slider_orders_label => 'Замовлень на день';

  @override
  String pricing_slider_orders_value(int count, int monthly) {
    return '$count замовлень/день · $monthly/місяць';
  }

  @override
  String get pricing_slider_avg_label => 'Середня вартість замовлення';

  @override
  String pricing_slider_avg_value(String amount) {
    return '$amount злотих';
  }

  @override
  String pricing_tier_badge(String tierName, String rate) {
    return '$tierName рівень — $rate комісія';
  }

  @override
  String pricing_tier_monthly(int count) {
    return '$count замовлень/місяць';
  }

  @override
  String get pricing_calc_revenue_label => 'Щоденний дохід';

  @override
  String get pricing_calc_revenue_sub => 'до комісії';

  @override
  String pricing_calc_fee_label(String rate) {
    return 'Комісія за безкоштовну швидку оплату ($rate)';
  }

  @override
  String get pricing_calc_fee_sub => 'на день';

  @override
  String get pricing_calc_keep_label => 'Ви тримаєте';

  @override
  String get pricing_calc_disclaimer =>
      'Комісія стягується лише за виконані та доставлені замовлення.';

  @override
  String get pricing_tier_starter_label => 'Стартер';

  @override
  String get pricing_tier_starter_range => '0 – 100 замовлень/місяць';

  @override
  String get pricing_tier_starter_desc => 'Почніть без початкових витрат.';

  @override
  String get pricing_tier_growing_label => 'Зростання';

  @override
  String get pricing_tier_growing_range => '101 – 500 замовлень/місяць';

  @override
  String get pricing_tier_growing_desc =>
      'Знижуйте ставку, коли нарощуєте свою клієнтську базу.';

  @override
  String get pricing_tier_established_label => 'Засновано';

  @override
  String get pricing_tier_established_range => '501 – 1 500 замовлень/місяць';

  @override
  String get pricing_tier_established_desc =>
      'Винагородження ресторанів з постійно високим обсягом відвідувань.';

  @override
  String get pricing_tier_partner_label => 'Партнер';

  @override
  String get pricing_tier_partner_range => '1 500+ замовлень/місяць';

  @override
  String get pricing_tier_partner_desc =>
      'Наша найкраща ціна для наших партнерів з найбільшим обсягом роботи.';

  @override
  String get pricing_faq1_q =>
      'Чи є якісь плати за налаштування або щомісячна плата?';

  @override
  String get pricing_faq1_a =>
      'Ні. Freequick не стягує жодної плати за налаштування та жодної щомісячної плати. Ви платите комісію лише за виконані замовлення.';

  @override
  String get pricing_faq2_q => 'Коли стягується комісія?';

  @override
  String get pricing_faq2_a =>
      'Комісія розраховується в момент, коли замовлення позначено як доставлене. Вона автоматично списується з вашого балансу виплат.';

  @override
  String get pricing_faq3_q => 'Як часто мені виплачують гроші?';

  @override
  String get pricing_faq3_a =>
      'Виплати обробляються щотижня на ваш зареєстрований банківський рахунок IBAN. Ви можете відстежувати свій баланс у режимі реального часу на інформаційній панелі.';

  @override
  String get pricing_faq4_q => 'Що станеться, якщо замовлення скасовано?';

  @override
  String get pricing_faq4_a =>
      'За скасовані замовлення комісія не стягується. Ви платите лише за успішно завершені доставки.';

  @override
  String get pricing_faq5_q =>
      'Чи можу я пізніше змінити реквізити свого банківського рахунку?';

  @override
  String get pricing_faq5_a =>
      'Так. Ви можете оновити свій IBAN у будь-який час у розділі \"Налаштування\" на своїй інформаційній панелі.';

  @override
  String get pricing_tier_name_starter => 'Стартер';

  @override
  String get pricing_tier_name_growing => 'Зростання';

  @override
  String get pricing_tier_name_established => 'Засновано';

  @override
  String get pricing_tier_name_partner => 'Партнер';

  @override
  String get admin_notifications_tab_send => 'Надіслати сповіщення';

  @override
  String get admin_notifications_tab_history => 'Історія';

  @override
  String get admin_notifications_target_audience => 'Цільова аудиторія';

  @override
  String get admin_notifications_audience_all => 'Усі';

  @override
  String get admin_notifications_audience_restaurants => 'Ресторани';

  @override
  String get admin_notifications_audience_specific => 'Конкретний';

  @override
  String get admin_notifications_audience_label_all => 'Усі користувачі';

  @override
  String get admin_notifications_audience_label_restaurants =>
      'Власники ресторанів';

  @override
  String get admin_notifications_audience_label_specific =>
      'Конкретні користувачі';

  @override
  String get admin_notifications_search_hint =>
      'Пошук за іменем або електронною поштою…';

  @override
  String get admin_notifications_search_hint_more =>
      'Додати більше користувачів…';

  @override
  String get admin_notifications_title_label => 'Заголовок сповіщення';

  @override
  String get admin_notifications_title_hint =>
      'наприклад, доступна нова функція';

  @override
  String get admin_notifications_body_label => 'Повідомлення';

  @override
  String get admin_notifications_body_hint =>
      'Напишіть повідомлення-сповіщення…';

  @override
  String get admin_notifications_send_button => 'Надіслати сповіщення';

  @override
  String get admin_notifications_sending => 'Надсилання…';

  @override
  String get admin_notifications_required => 'Обов\'язково';

  @override
  String get admin_notifications_select_user =>
      'Будь ласка, виберіть принаймні одного користувача.';

  @override
  String get admin_notifications_no_users =>
      'Для цієї аудиторії користувачів не знайдено.';

  @override
  String get admin_notifications_sent_one => 'Надіслано 1 користувачеві';

  @override
  String admin_notifications_sent_many(int count) {
    return 'Надіслано користувачам $count';
  }

  @override
  String get admin_notifications_history_empty => 'Сповіщення ще не надіслано';

  @override
  String get admin_notifications_history_sent_badge => 'Надіслано';

  @override
  String admin_notifications_history_sent_count(int count) {
    return '$count надіслано';
  }

  @override
  String get admin_overview_platform_glance => 'ПЛАТФОРМА КОРОТКО';

  @override
  String get admin_overview_revenue_30d => 'ДОХІД (ОСТАННІ 30 ДНІВ)';

  @override
  String get admin_overview_pending_requests =>
      'ЗАПИТИ НА ПРИЄДНАННЯ, ЩО ОЧІКУЮТЬ НА РОЗГЛЯД';

  @override
  String get admin_overview_view_all => 'Переглянути всі';

  @override
  String get admin_overview_order_status => 'РОЗБИВКА СТАНУ ЗАМОВЛЕННЯ';

  @override
  String get admin_overview_top_restaurants =>
      'НАЙКРАЩІ РЕСТОРАНИ ЗА КІЛЬКІСТЮ ЗАМОВЛЕНЬ';

  @override
  String get admin_overview_stat_restaurants => 'Всього ресторанів';

  @override
  String admin_overview_stat_restaurants_sub(int active) {
    return '$active із замовленнями';
  }

  @override
  String get admin_overview_stat_orders => 'Загальна кількість замовлень';

  @override
  String admin_overview_stat_orders_sub(int count) {
    return '$count сьогодні';
  }

  @override
  String get admin_overview_stat_revenue => 'Загальний дохід';

  @override
  String admin_overview_stat_revenue_sub(String amount) {
    return '$amount PLN за останні 7 днів';
  }

  @override
  String get admin_overview_stat_avg => 'Середня вартість замовлення';

  @override
  String admin_overview_stat_avg_sub(int menus, int items) {
    return '$menus меню · $items пункти';
  }

  @override
  String get admin_overview_loading => '—';

  @override
  String get admin_overview_revenue_no_data => 'Даних про доходи поки що немає';

  @override
  String get admin_overview_no_pending => 'Немає запитів, що очікують розгляду';

  @override
  String admin_overview_pending_nip(String nip, String date) {
    return 'НІП: $nip · Надіслано $date';
  }

  @override
  String get admin_overview_review => 'Огляд';

  @override
  String get admin_overview_no_orders => 'Поки що немає замовлень';

  @override
  String get admin_overview_no_order_data => 'Даних про замовлення ще немає';

  @override
  String admin_overview_orders_count(int count) {
    return '$count замовлень';
  }

  @override
  String get admin_overview_status_pending => 'Очікує на розгляд';

  @override
  String get admin_overview_status_processing => 'Обробка';

  @override
  String get admin_overview_status_delivered => 'Доставлено';

  @override
  String get admin_overview_status_cancelled => 'Скасовано';

  @override
  String get requests_tab_registrations => 'Реєстрації';

  @override
  String get requests_tab_go_live => 'Запити на активацію';

  @override
  String get requests_filter_pending => 'Очікує на розгляд';

  @override
  String get requests_filter_approved => 'Схвалено';

  @override
  String get requests_filter_active => 'Активний';

  @override
  String get requests_filter_rejected => 'Відхилено';

  @override
  String get requests_filter_suspended => 'Призупинено';

  @override
  String get requests_filter_all => 'Усі';

  @override
  String requests_empty_filtered(String filter) {
    return 'Немає запитів $filter';
  }

  @override
  String get requests_empty_all => 'Поки що немає ресторанів';

  @override
  String get requests_go_live_empty => 'Поки що немає запитів на публікацію';

  @override
  String get requests_go_live_section_pending => 'ОЧІКУЄ НА РОЗГЛЯД';

  @override
  String get requests_go_live_section_reviewed => 'ПЕРЕГЛЯНУТО';

  @override
  String requests_go_live_requested(String timeAgo, String date) {
    return 'Запит надіслано $timeAgo · $date';
  }

  @override
  String requests_go_live_activated_on(String date) {
    return 'Активовано $date';
  }

  @override
  String requests_go_live_declined_on(String date) {
    return 'Відхилено $date';
  }

  @override
  String get requests_badge_activated => 'Активовано';

  @override
  String get requests_badge_declined => 'Відхилено';

  @override
  String get requests_badge_pending_review => 'Очікує розгляду';

  @override
  String get requests_action_activate => 'Активувати';

  @override
  String get requests_action_decline => 'Відхилення';

  @override
  String requests_submitted(String date) {
    return 'Надіслано $date';
  }

  @override
  String get requests_status_approved => 'Схвалено';

  @override
  String get requests_status_active => 'Активний';

  @override
  String get requests_status_rejected => 'Відхилено';

  @override
  String get requests_status_suspended => 'Призупинено';

  @override
  String get requests_status_pending => 'Очікує на розгляд';

  @override
  String get requests_action_approve => 'Схвалити';

  @override
  String get requests_action_reject => 'Відхилити';

  @override
  String get requests_action_suspend => 'Призупинити';

  @override
  String get requests_action_reinstate => 'Відновити';

  @override
  String get requests_action_copy_id => 'Скопіювати ідентифікатор ресторану';

  @override
  String requests_copied(String id) {
    return 'Скопійовано: $id';
  }

  @override
  String get requests_confirm_approve_title => 'Схвалити';

  @override
  String get requests_confirm_approve_body =>
      'Це схвалить ресторан і надасть власнику доступ до його панелі керування.';

  @override
  String get requests_confirm_reject_title => 'Відхилити';

  @override
  String get requests_confirm_reject_body =>
      'Це призведе до відхилення ресторану. Власник побачить повідомлення про відхилення після входу в систему.';

  @override
  String get requests_confirm_suspend_title => 'Призупинити';

  @override
  String get requests_confirm_suspend_body =>
      'Це призупинить роботу ресторану. Власник негайно втратить доступ до своєї інформаційної панелі.';

  @override
  String get requests_confirm_reinstate_title => 'Відновити';

  @override
  String get requests_confirm_reinstate_body =>
      'Це відновить активний статус ресторану.';

  @override
  String get requests_confirm_cancel => 'Скасувати';

  @override
  String requests_error_failed(String error) {
    return 'Не вдалося: $error';
  }

  @override
  String requests_setup_progress(int done, int total) {
    return 'Налаштування: $done/$total завершено';
  }

  @override
  String get requests_check_logo => 'Логотип завантажено';

  @override
  String get requests_check_banner => 'Банер завантажено';

  @override
  String get requests_check_address => 'Адреса встановлена';

  @override
  String get requests_check_iban => 'Набір IBAN';

  @override
  String get requests_check_photo => 'Фотографія профілю';

  @override
  String get requests_check_menu => 'Принаймні одне меню';

  @override
  String get users_search_hint => 'Пошук за іменем або електронною поштою…';

  @override
  String get users_filter_all => 'Усі';

  @override
  String get users_filter_restaurant => 'Ресторан';

  @override
  String get users_filter_admin => 'Адміністратор';

  @override
  String get users_filter_customer => 'Клієнт';

  @override
  String get users_empty_filtered =>
      'Немає користувачів, які відповідають вашому фільтру';

  @override
  String get users_empty_all => 'Ще немає користувачів';

  @override
  String get users_banned_badge => 'Заборонено';

  @override
  String users_joined(String date) {
    return 'Приєднався до $date';
  }

  @override
  String get users_detail_title => 'Відомості про користувача';

  @override
  String get users_detail_id => 'Ідентифікатор користувача';

  @override
  String get users_detail_phone => 'Телефон';

  @override
  String get users_detail_joined => 'Приєднався';

  @override
  String get users_detail_role => 'Роль';

  @override
  String get users_action_ban => 'Заборона';

  @override
  String get users_action_unban => 'Розбанити';

  @override
  String get users_action_delete => 'Видалити';

  @override
  String get users_confirm_cancel => 'Скасувати';

  @override
  String get users_ban_title => 'Забанити користувача?';

  @override
  String get users_unban_title => 'Розблокувати користувача?';

  @override
  String get users_ban_body =>
      'Це завадить користувачеві отримати доступ до платформи.';

  @override
  String get users_unban_body => 'Це відновить доступ користувача.';

  @override
  String get users_delete_title => 'Видалити користувача?';

  @override
  String get users_delete_body =>
      'Це остаточно видалить документ користувача з Firestore. Його обліковий запис авторизації залишиться, якщо його не буде видалено окремо з консолі Firebase.';

  @override
  String get users_snack_banned => 'Користувача забанено.';

  @override
  String get users_snack_unbanned => 'Користувача розбанено.';

  @override
  String get users_snack_deleted => 'Користувача видалено.';

  @override
  String get users_copied => 'Скопійовано в буфер обміну';

  @override
  String get users_role_admin => 'Адміністратор';

  @override
  String get users_role_restaurant => 'Ресторан';

  @override
  String get users_role_customer => 'Клієнт';

  @override
  String get analytics_section_glance => 'КОРОТКИЙ ПОГЛЯД';

  @override
  String get analytics_section_revenue => 'ДОХІД З ЧАСОМ';

  @override
  String get analytics_section_status => 'РОЗБИВКА СТАНУ ЗАМОВЛЕННЯ';

  @override
  String get analytics_section_popular => 'НАЙКРАЩІ ЗАМОВЛЕННЯ';

  @override
  String analytics_stat_revenue(int days) {
    return 'Дохід ($daysдн.)';
  }

  @override
  String analytics_stat_orders(int days) {
    return 'Замовлення (${days}d)';
  }

  @override
  String get analytics_stat_today => 'Сьогоднішні продажі';

  @override
  String get analytics_stat_avg => 'Середнє замовлення';

  @override
  String get analytics_no_revenue => 'Немає даних про доходи за цей період';

  @override
  String get analytics_no_orders => 'Немає замовлень за цей період';

  @override
  String get analytics_no_items => 'Немає даних про товар за цей період';

  @override
  String analytics_orders_count(int count) {
    return '$count замовлень';
  }

  @override
  String get analytics_status_normal => 'Звичайний';

  @override
  String get analytics_status_processing => 'Обробка';

  @override
  String get analytics_status_delivered => 'Доставлено';

  @override
  String get analytics_status_cancelled => 'Скасовано';

  @override
  String get shell_nav_overview => 'Огляд';

  @override
  String get shell_nav_orders => 'Замовлення';

  @override
  String get shell_nav_menus => 'Меню';

  @override
  String get shell_nav_promotions => 'Акції';

  @override
  String get shell_nav_analytics => 'Аналітика';

  @override
  String get shell_nav_settings => 'Налаштування';

  @override
  String get shell_restaurant_not_found =>
      'Ресторан не знайдено. Зверніться до служби підтримки.';

  @override
  String get shell_finish_setup => 'Завершити налаштування';

  @override
  String get shell_my_account => 'Мій обліковий запис';

  @override
  String get shell_live_go_offline => 'Живий ефір · Вихід офлайн';

  @override
  String get shell_go_live_pending => 'Опублікувати, очікується розгляд';

  @override
  String get shell_go_live_declined => 'Відхилено · Подати повторну заявку';

  @override
  String get shell_request_go_live => 'Запит на публікацію';

  @override
  String get shell_already_pending =>
      'У вас вже є запит на активацію, що очікує на розгляд.';

  @override
  String get shell_go_live_submitted =>
      'Запит на публікацію надіслано. Ми розглянемо його найближчим часом.';

  @override
  String shell_error(String error) {
    return 'Помилка: $error';
  }

  @override
  String get shell_go_offline_title => 'Вийти в офлайн?';

  @override
  String get shell_go_offline_body =>
      'Ваш ресторан буде прихований від клієнтів. Ви можете будь-коли знову опублікувати його.';

  @override
  String get shell_confirm_cancel => 'Скасувати';

  @override
  String get shell_go_offline_confirm => 'Перейти в офлайн-режим';

  @override
  String get shell_menu_support => 'Зверніться до служби підтримки';

  @override
  String get shell_menu_sales => 'Поговоріть з відділом продажів';

  @override
  String get shell_menu_cookies => 'Налаштування файлів cookie';

  @override
  String get shell_menu_settings => 'Налаштування';

  @override
  String get shell_menu_logout => 'Вийти';

  @override
  String get gate_pending_title => 'Ваш обліковий запис розглядається';

  @override
  String get gate_pending_message =>
      'Ми перевіряємо ваші реєстраційні дані. Зазвичай це займає 1-2 робочих дні. Ми повідомимо вас електронною поштою після схвалення.';

  @override
  String get gate_rejected_title => 'Заявку не схвалено';

  @override
  String get gate_rejected_message =>
      'На жаль, вашу реєстрацію не було схвалено. Будь ласка, зверніться до служби підтримки для отримання додаткової інформації.';

  @override
  String get gate_suspended_title => 'Обліковий запис заблоковано';

  @override
  String get gate_suspended_message =>
      'Ваш обліковий запис заблоковано. Зверніться до служби підтримки, щоб вирішити цю проблему.';

  @override
  String get gate_default_title => 'Доступ недоступний';

  @override
  String get gate_default_message =>
      'Будь ласка, зверніться до служби підтримки.';

  @override
  String get gate_sign_out => 'Вийти';

  @override
  String overview_welcome(String name) {
    return 'Ласкаво просимо назад, $name 👋';
  }

  @override
  String get overview_subtitle =>
      'Ось що відбувається з вашим рестораном сьогодні.';

  @override
  String get overview_section_glance => 'КОРОТКИЙ ПОГЛЯД';

  @override
  String get overview_section_orders => 'ОСТАННІ ЗАМОВЛЕННЯ';

  @override
  String get overview_setup_title => 'Підготуйте свій ресторан';

  @override
  String overview_setup_progress(int done, int total) {
    return 'Виконано [_13 з $total кроків';
  }

  @override
  String get overview_task_done => 'Готово';

  @override
  String get overview_task_setup => 'Налаштування';

  @override
  String get overview_task_logo_title => 'Завантажити логотип ресторану';

  @override
  String get overview_task_logo_desc =>
      'Клієнти бачитимуть ваш логотип у всьому додатку.';

  @override
  String get overview_task_banner_title => 'Додати зображення банера';

  @override
  String get overview_task_banner_desc =>
      'Банер робить вітрину вашого магазину візуально привабливою.';

  @override
  String get overview_task_address_title => 'Встановити адресу ресторану';

  @override
  String get overview_task_address_desc => 'Повідомте клієнтам, де вас знайти.';

  @override
  String get overview_task_photo_title => 'Додати фотографію профілю';

  @override
  String get overview_task_photo_desc =>
      'Додайте обличчя до облікового запису власника ресторану.';

  @override
  String get overview_task_menu_title => 'Створіть меню та додайте елементи';

  @override
  String get overview_task_menu_desc =>
      'Упорядкуйте свої пропозиції в меню зі стравами та цінами.';

  @override
  String get overview_task_iban_title => 'Додати банківський рахунок (IBAN)';

  @override
  String get overview_task_iban_desc =>
      'Потрібно отримувати виплати за замовленнями клієнтів.';

  @override
  String get overview_stat_total_orders => 'Загальна кількість замовлень';

  @override
  String get overview_stat_pending => 'Очікує на розгляд';

  @override
  String get overview_stat_completed => 'Завершено';

  @override
  String get overview_stat_revenue => 'Загальний дохід';

  @override
  String get overview_no_orders => 'Поки що немає замовлень';

  @override
  String get overview_table_order_id => 'ІДЕНТИФІКАТОР ЗАМОВЛЕННЯ';

  @override
  String get overview_table_customer => 'КЛІЄНТ';

  @override
  String get overview_table_items => 'ПРЕДМЕТИ';

  @override
  String get overview_table_status => 'СТАТУС';

  @override
  String get overview_table_total => 'РАЗОМ';

  @override
  String overview_items_count(int count) {
    return '$count елемент';
  }

  @override
  String overview_items_count_plural(int count) {
    return '$count предметів';
  }

  @override
  String get overview_time_just_now => 'Щойно';

  @override
  String overview_time_minutes(int n) {
    return '$nхв тому';
  }

  @override
  String overview_time_hours(int n) {
    return '$nгод тому';
  }

  @override
  String get overview_chef_fallback => 'Шеф-кухар';

  @override
  String get items_app_bar_fallback => 'Елементи';

  @override
  String get items_empty_title => 'Поки що немає товарів';

  @override
  String get items_empty_subtitle => 'Натисніть +, щоб додати перший елемент';

  @override
  String items_error(String error) {
    return 'Помилка: $error';
  }

  @override
  String get items_fab => 'Додати елемент';

  @override
  String get items_sheet_title => 'Додати елемент';

  @override
  String get items_image_upload_label => 'Завантажити зображення елемента';

  @override
  String get items_image_browse => 'Натисніть, щоб переглянути';

  @override
  String get items_field_title_label => 'Назва елемента';

  @override
  String get items_field_title_hint => 'наприклад, Руські вареники';

  @override
  String get items_field_title_required => 'Потрібно вказати назву';

  @override
  String get items_field_info_label => 'Коротка інформація';

  @override
  String get items_field_info_hint => 'наприклад, хрусткі та смачні';

  @override
  String get items_field_info_required => 'Потрібна інформація';

  @override
  String get items_field_desc_label => 'Опис';

  @override
  String get items_field_desc_hint => 'Опишіть предмет...';

  @override
  String get items_field_desc_required => 'Опис обов\'язковий';

  @override
  String get items_field_price_label => 'Ціна (злотих)';

  @override
  String get items_field_price_hint => 'наприклад, 24,99';

  @override
  String get items_field_price_required => 'Ціна обов\'язкова';

  @override
  String get items_field_price_invalid => 'Введіть дійсний номер';

  @override
  String get items_field_tags_label => 'Теги';

  @override
  String get items_field_tags_hint => 'наприклад, веганський';

  @override
  String get items_tag_error_empty => 'Будь ласка, введіть тег';

  @override
  String get items_tag_error_capitalize => 'Перша літера має бути великою';

  @override
  String get items_tag_error_letters => 'Дозволено використовувати лише літери';

  @override
  String get items_tag_error_duplicate => 'Тег вже існує';

  @override
  String get items_discount_toggle => 'Застосувати знижку';

  @override
  String get items_discount_label => 'Знижка %';

  @override
  String get items_discount_required => 'Введіть відсоток знижки';

  @override
  String get items_discount_invalid => 'Введіть значення від 1 до 100';

  @override
  String get items_no_image => 'Будь ласка, виберіть зображення товару.';

  @override
  String get items_added => 'Елемент успішно додано';

  @override
  String get items_submit => 'Додати елемент';

  @override
  String get menus_empty_title => 'Меню поки що немає';

  @override
  String get menus_empty_subtitle => 'Натисніть +, щоб додати своє перше меню';

  @override
  String menus_error(String error) {
    return 'Помилка: $error';
  }

  @override
  String get menus_fab => 'Додати меню';

  @override
  String get menus_sheet_title => 'Додати меню';

  @override
  String get menus_image_upload_label => 'Завантажити зображення банера';

  @override
  String get menus_image_browse => 'Натисніть, щоб переглянути';

  @override
  String get menus_field_title_label => 'Назва меню';

  @override
  String get menus_field_title_hint => 'наприклад, обідні пропозиції';

  @override
  String get menus_field_title_required => 'Потрібно вказати назву';

  @override
  String get menus_field_desc_label => 'Опис';

  @override
  String get menus_field_desc_hint => 'Коротко опишіть це меню...';

  @override
  String get menus_field_desc_required => 'Опис обов\'язковий';

  @override
  String get menus_no_image => 'Будь ласка, виберіть зображення банера.';

  @override
  String get menus_created => 'Меню успішно створено';

  @override
  String get menus_submit => 'Створити меню';

  @override
  String get orders_error => 'Щось пішло не так';

  @override
  String get orders_empty_title => 'Зараз немає замовлень';

  @override
  String get orders_empty_subtitle =>
      'Коли клієнти розміщують замовлення, вони з\'являтимуться тут.';

  @override
  String get orders_table_order_id => 'ІДЕНТИФІКАТОР ЗАМОВЛЕННЯ';

  @override
  String get orders_table_customer => 'КЛІЄНТ';

  @override
  String get orders_table_items => 'ПРЕДМЕТИ';

  @override
  String get orders_table_status => 'СТАТУС';

  @override
  String get orders_table_total => 'РАЗОМ';

  @override
  String orders_item_count(int count) {
    return '$count елемент';
  }

  @override
  String orders_item_count_plural(int count) {
    return '$count елементи';
  }

  @override
  String get promo_not_authenticated => 'Не автентифіковано';

  @override
  String get promo_empty_title => 'Поки що немає акцій';

  @override
  String get promo_empty_subtitle =>
      'Натисніть +, щоб створити свій перший рекламний банер';

  @override
  String get promo_fab => 'Нова акція';

  @override
  String get promo_badge_live => 'Живий';

  @override
  String get promo_badge_inactive => 'Неактивний';

  @override
  String promo_items_linked(int count) {
    return '$count елемент';
  }

  @override
  String promo_items_linked_plural(int count) {
    return '$count елементи';
  }

  @override
  String get promo_edit_button => 'Редагувати';

  @override
  String get promo_sheet_add_title => 'Нова акція';

  @override
  String get promo_sheet_edit_title => 'Редагувати рекламну акцію';

  @override
  String get promo_sheet_delete_button => 'Видалити';

  @override
  String get promo_image_change_hint => 'Натисніть, щоб змінити банер';

  @override
  String get promo_image_upload_hint =>
      'Натисніть, щоб завантажити зображення банера';

  @override
  String get promo_image_upload_label => 'Завантажити зображення банера';

  @override
  String get promo_image_recommended => 'Рекомендовано: 1200×400 пікселів';

  @override
  String get promo_field_title_label => 'Назва рекламної акції';

  @override
  String get promo_field_title_hint => 'наприклад, знижка на вихідні';

  @override
  String get promo_field_title_required => 'Потрібно вказати назву';

  @override
  String get promo_field_desc_label => 'Опис';

  @override
  String get promo_field_desc_hint =>
      'наприклад, знижки до 30% на всі основні страви цими вихідними';

  @override
  String get promo_field_desc_required => 'Опис обов\'язковий';

  @override
  String get promo_date_start => 'Дата початку';

  @override
  String get promo_date_end => 'Дата завершення';

  @override
  String get promo_date_pick => 'Виберіть дату';

  @override
  String get promo_active_toggle => 'Акція активна';

  @override
  String get promo_link_section_label => 'Посилання на товари зі знижкою';

  @override
  String get promo_link_section_hint =>
      'Необов’язково — виберіть товари, на які поширюється ця акція';

  @override
  String get promo_link_no_items =>
      'Не знайдено жодного елемента. Спочатку додайте елементи до своїх меню.';

  @override
  String get promo_save_changes => 'Зберегти зміни';

  @override
  String get promo_create => 'Створити рекламну акцію';

  @override
  String get promo_no_dates =>
      'Будь ласка, встановіть обидві дати початку та завершення.';

  @override
  String get promo_date_order_error =>
      'Дата завершення має бути після дати початку.';

  @override
  String get promo_no_image => 'Будь ласка, виберіть зображення банера.';

  @override
  String get promo_updated => 'Акцію успішно оновлено';

  @override
  String get promo_created => 'Акцію успішно створено';

  @override
  String get promo_banner_cleanup_error =>
      'Банер оновлено, але очищення старого файлу не вдалося.';

  @override
  String get promo_delete_title => 'Видалити рекламну акцію?';

  @override
  String get promo_delete_body =>
      'Це назавжди видалить акцію та її банер. Цю дію неможливо скасувати.';

  @override
  String get promo_delete_cancel => 'Скасувати';

  @override
  String get promo_delete_confirm => 'Видалити';

  @override
  String get promo_deleted => 'Акцію видалено.';

  @override
  String get promo_location_dialog_title => 'Розташування ресторану';

  @override
  String get promo_location_none => 'Місцезнаходження ще не вибрано';

  @override
  String get promo_location_open_map => 'Відкрити карту';

  @override
  String get promo_location_change_map => 'Зміна на карті';

  @override
  String get promo_location_confirm => 'Підтвердити адресу';

  @override
  String get promo_location_no_pick =>
      'Будь ласка, спочатку виберіть місце на карті.';

  @override
  String get settings_section_business => 'Бізнес';

  @override
  String get settings_section_business_sub =>
      'Керуйте профілем та медіафайлами свого ресторану';

  @override
  String get settings_section_profile => 'Профіль користувача';

  @override
  String get settings_section_profile_sub =>
      'Оновіть дані свого особистого облікового запису';

  @override
  String get settings_section_danger => 'НЕБЕЗПЕЧНА ЗОНА';

  @override
  String get settings_section_danger_sub =>
      'Незворотні дії для вашого облікового запису';

  @override
  String get settings_logo_title => 'Логотип ресторану';

  @override
  String get settings_logo_status_staged => 'Новий логотип готовий';

  @override
  String get settings_logo_status_exists => 'Логотип завантажено';

  @override
  String get settings_logo_status_none => 'Ще немає логотипу';

  @override
  String get settings_logo_recommended =>
      'Рекомендовано: 512×512 пікселів, PNG або JPG';

  @override
  String get settings_logo_choose => 'Виберіть';

  @override
  String get settings_logo_upload => 'Завантажити';

  @override
  String get settings_logo_uploading => 'Завантаження…';

  @override
  String get settings_logo_success => 'Логотип оновлено';

  @override
  String get settings_banner_title => 'Банер ресторану';

  @override
  String get settings_banner_choose => 'Натисніть, щоб вибрати банер';

  @override
  String get settings_banner_recommended => 'Рекомендовано: 1200×800 пікселів';

  @override
  String get settings_banner_upload => 'Завантажити банер';

  @override
  String get settings_banner_uploading => 'Завантаження…';

  @override
  String get settings_banner_success => 'Банер оновлено';

  @override
  String get settings_business_title => 'Інформація про бізнес';

  @override
  String get settings_business_saved => 'Інформацію про компанію збережено';

  @override
  String get settings_address_set => 'Встановити адресу ресторану';

  @override
  String get settings_address_change => 'Зміна';

  @override
  String get settings_address_pick => 'Виберіть на карті';

  @override
  String get settings_profile_title => 'Профіль';

  @override
  String get settings_profile_photo_ready =>
      'Нове фото готове — натисніть «Зберегти», щоб застосувати';

  @override
  String get settings_profile_saved => 'Профіль збережено';

  @override
  String get settings_profile_name_hint => 'Ім\'я власника';

  @override
  String get settings_profile_phone_label => 'Номер телефону';

  @override
  String get settings_danger_reset_title => 'Змінити пароль';

  @override
  String get settings_danger_reset_sub =>
      'Надіслати електронний лист для скидання пароля на ваш обліковий запис';

  @override
  String get settings_danger_reset_button => 'Скинути';

  @override
  String get settings_danger_reset_sent => 'Лист для скидання пароля надіслано';

  @override
  String get settings_danger_delete_title => 'Видалити обліковий запис';

  @override
  String get settings_danger_delete_sub =>
      'Видаліть свій ресторан та всі дані назавжди';

  @override
  String get settings_danger_delete_button => 'Видалити';

  @override
  String get settings_danger_delete_dialog_title => 'Видалити обліковий запис';

  @override
  String get settings_danger_delete_dialog_body =>
      'Це назавжди видалить ваш обліковий запис і всі дані ресторану. Цю дію не можна скасувати.';

  @override
  String get settings_cancel => 'Скасувати';

  @override
  String get settings_error => 'Щось пішло не так';

  @override
  String get settings_save_changes => 'Зберегти зміни';

  @override
  String get settings_map_dialog_title => 'Розташування ресторану';

  @override
  String get settings_map_no_location => 'Місцезнаходження ще не вибрано';

  @override
  String get settings_map_open => 'Відкрити карту';

  @override
  String get settings_map_change => 'Зміна на карті';

  @override
  String get settings_map_confirm => 'Підтвердити адресу';

  @override
  String get settings_map_no_pick =>
      'Будь ласка, спочатку виберіть місце на карті.';

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
  String get field_error_required => 'Це поле обов\'язкове';

  @override
  String get field_error_invalid_format => 'Недійсний формат';

  @override
  String get field_email_message => 'Введіть дійсну адресу електронної пошти';

  @override
  String get field_nip_message =>
      'Національний ідентифікаційний номер (NIP) має складатися рівно з 10 цифр';

  @override
  String get field_regon_message => 'REGON має складатися з 9 або 14 цифр';

  @override
  String get field_postal_code_message =>
      'Введіть дійсний поштовий індекс (XX-XXX)';

  @override
  String get field_hint_prefix => 'Введіть';

  @override
  String get items_design_edit_button => 'Редагувати елемент';

  @override
  String get items_design_edit_sheet_title => 'Редагувати елемент';

  @override
  String get items_design_delete_button => 'Видалити елемент';

  @override
  String get items_design_change_image_hint =>
      'Натисніть, щоб змінити зображення';

  @override
  String get items_design_field_title_label => 'Назва елемента';

  @override
  String get items_design_field_info_label => 'Коротка інформація';

  @override
  String get items_design_field_info_hint => 'наприклад, хрусткі та смачні';

  @override
  String get items_design_field_desc_label => 'Опис';

  @override
  String get items_design_field_price_label => 'Ціна (злотих)';

  @override
  String get items_design_field_price_required => 'Ціна обов\'язкова';

  @override
  String get items_design_field_price_invalid => 'Введіть дійсний номер';

  @override
  String get items_design_field_tags_label => 'Теги';

  @override
  String get items_design_field_tags_hint => 'наприклад, веганський';

  @override
  String get items_design_discount_label => 'Знижка %';

  @override
  String get items_design_discount_required => 'Введіть відсоток знижки';

  @override
  String get items_design_discount_invalid => 'Введіть значення від 1 до 100';

  @override
  String get items_design_save_changes => 'Зберегти зміни';

  @override
  String get items_design_saved => 'Елемент успішно збережено';

  @override
  String get items_design_image_cleanup_error =>
      'Зображення оновлено, але очищення старого файлу не вдалося.';

  @override
  String get items_design_delete_dialog_title => 'Видалити елемент';

  @override
  String get items_design_delete_dialog_body =>
      'Ви впевнені, що хочете видалити цей елемент? Цю дію неможливо скасувати.';

  @override
  String get items_design_delete_cancel => 'Скасувати';

  @override
  String get items_design_delete_confirm => 'Видалити';

  @override
  String get items_design_deleted => 'Елемент успішно видалено';

  @override
  String get map_fetching_address => 'Отримання адреси...';

  @override
  String get map_address_not_found => 'Не вдалося знайти адресу';

  @override
  String get map_confirm_button => 'ПІДТВЕРДЖЕННЯ АДРЕСИ';

  @override
  String get menus_design_view_items => 'Переглянути елементи';

  @override
  String get menus_design_edit_button => 'Меню редагування';

  @override
  String get menus_design_edit_sheet_title => 'Меню редагування';

  @override
  String get menus_design_delete_button => 'Видалити меню';

  @override
  String get menus_design_change_image_hint =>
      'Натисніть, щоб змінити зображення';

  @override
  String get menus_design_field_title_label => 'Назва меню';

  @override
  String get menus_design_field_desc_label => 'Опис';

  @override
  String get menus_design_field_title_required => 'Потрібно вказати назву';

  @override
  String get menus_design_field_desc_required => 'Опис обов\'язковий';

  @override
  String get menus_design_save_changes => 'Зберегти зміни';

  @override
  String get menus_design_saved => 'Меню успішно збережено';

  @override
  String get menus_design_banner_cleanup_error =>
      'Банер оновлено, але очищення старого файлу не вдалося.';

  @override
  String get menus_design_delete_dialog_title => 'Видалити меню';

  @override
  String get menus_design_delete_dialog_body =>
      'Ви впевнені, що хочете видалити це меню? Цю дію неможливо скасувати.';

  @override
  String get menus_design_delete_cancel => 'Скасувати';

  @override
  String get menus_design_delete_confirm => 'Видалити';

  @override
  String get menus_design_delete_missing_id =>
      'Помилка: Відсутнє меню або ідентифікатор ресторану';

  @override
  String get menus_design_deleted => 'Меню успішно видалено';

  @override
  String get notif_sheet_title => 'Сповіщення';

  @override
  String notif_unread_count(int count) {
    return '$count непрочитані';
  }

  @override
  String get notif_mark_all_read => 'Позначити як прочитане';

  @override
  String get notif_empty_title => 'Поки що немає сповіщень';

  @override
  String get notif_empty_subtitle =>
      'Повідомлення адміністратора відображатимуться тут';

  @override
  String get notif_time_just_now => 'Щойно';

  @override
  String notif_time_minutes(int n) {
    return '$nхв тому';
  }

  @override
  String notif_time_hours(int n) {
    return '$nгод тому';
  }

  @override
  String get notif_time_yesterday => 'Вчора';

  @override
  String notif_time_days(int n) {
    return '$nднів тому';
  }

  @override
  String get addr_use_current_location =>
      'Використовувати поточне місцезнаходження';

  @override
  String get addr_label_fallback => 'Адреса';

  @override
  String get addr_translating => 'Переклад...';

  @override
  String get addr_error_loading => 'Помилка завантаження адреси';

  @override
  String addr_building(String value) {
    return 'Будівля: $value';
  }

  @override
  String addr_flat(String value) {
    return 'Номер квартири: $value';
  }

  @override
  String addr_address(String value) {
    return 'Адреса: $value';
  }

  @override
  String get addr_see_in_maps => 'Дивитися на Картах';

  @override
  String get addr_delete => 'Видалити';

  @override
  String get addr_delete_dialog_title => 'Видалити адресу';

  @override
  String addr_delete_dialog_body(String label) {
    return 'Ви впевнені, що хочете видалити $label?';
  }

  @override
  String get addr_delete_cancel => 'Скасувати';

  @override
  String get addr_delete_confirm => 'Видалити';

  @override
  String get addr_deleted => 'Адресу успішно видалено';

  @override
  String addr_delete_error(String error) {
    return 'Помилка: $error';
  }
}
