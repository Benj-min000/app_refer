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
}
