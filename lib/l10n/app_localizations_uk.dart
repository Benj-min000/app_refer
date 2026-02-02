// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get helloWorld => 'Привіт, світ!';

  @override
  String get changeLanguage => 'Змінити мову';

  @override
  String get findingLocalization => 'Визначення вашого місцезнаходження...';

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
  String get errorEnterEmailOrPassword => 'Будь ласка, введіть електронну пошту та пароль';

  @override
  String get errorEnterRegInfo => 'Будь ласка, введіть необхідну інформацію для реєстрації';

  @override
  String get errorSelectImage => 'Будь ласка, виберіть зображення';

  @override
  String get errorNoMatchPasswords => 'Паролі не збігаються!';

  @override
  String get errorLoginFailed => 'Помилка входу';

  @override
  String get errorNoRecordFound => 'Запис не знайдено';

  @override
  String get blockedAccountMessage => 'Адміністратор заблокував ваш акаунт\n\nНапишіть на: admin@gmail.com';

  @override
  String get networkUnavailable => 'Мережа недоступна. Спробуйте ще раз';

  @override
  String get errorFetchingUserData => 'Помилка отримання даних користувача';

  @override
  String storageError(Object error) {
    return 'Помилка сховища: $error';
  }

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
  String get deliveryTime => '45-50 хв';
}
