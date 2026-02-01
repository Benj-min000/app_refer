// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get helloWorld => 'Привіт Світ!';

  @override
  String get changeLanguage => 'Змінити мову';

  @override
  String get welcomeMessage => 'Ласкаво просимо до нашого додатку!';

  @override
  String get payment => 'Оплата';

  @override
  String get checkout => 'Перейти до оформлення';

  @override
  String get totalAmount => 'Загальна сума';

  @override
  String get orderSummary => 'Підсумок замовлення';

  @override
  String get settings => 'Налаштування';

  @override
  String get offers => 'Пропозиції';

  @override
  String get whatsOnYourMind => 'Що вас цікавить?';

  @override
  String get bookDining => 'Бронювання столика';

  @override
  String get softDrinks => 'Безалкогольні напої';

  @override
  String get deliveryTime => '45-50 хв';
}
