// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get helloWorld => '안녕하세요!';

  @override
  String get changeLanguage => '언어 변경';

  @override
  String get welcomeMessage => '우리 앱에 오신 것을 환영합니다!';

  @override
  String get payment => '결제';

  @override
  String get checkout => '결제 진행';

  @override
  String get totalAmount => '총 금액';

  @override
  String get orderSummary => '주문 요약';

  @override
  String get settings => '설정';

  @override
  String get offers => '할인 행사';

  @override
  String get whatsOnYourMind => '무엇을 드시고 싶나요?';

  @override
  String get bookDining => '식사 예약';

  @override
  String get softDrinks => '탄산음료';

  @override
  String get deliveryTime => '45-50분';
}
