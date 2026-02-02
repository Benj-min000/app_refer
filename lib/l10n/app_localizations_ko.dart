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
  String get findingLocalization => '위치를 찾는 중...';

  @override
  String get hintName => '이름';

  @override
  String get hintEmail => '이메일';

  @override
  String get hintPassword => '비밀번호';

  @override
  String get hintConfPassword => '비밀번호 확인';

  @override
  String get login => '로그인';

  @override
  String get register => '회원가입';

  @override
  String get signUp => '가입하기';

  @override
  String get registeringAccount => '계정 등록 중...';

  @override
  String get checkingCredentials => '자격 증명 확인 중...';

  @override
  String get errorEnterEmailOrPassword => '이메일과 비밀번호를 입력하세요';

  @override
  String get errorEnterRegInfo => '회원가입에 필요한 정보를 입력하세요';

  @override
  String get errorSelectImage => '이미지를 선택하세요';

  @override
  String get errorNoMatchPasswords => '비밀번호가 일치하지 않습니다!';

  @override
  String get errorLoginFailed => '로그인 실패';

  @override
  String get errorNoRecordFound => '기록을 찾을 수 없습니다';

  @override
  String get blockedAccountMessage => '관리자가 계정을 차단했습니다\n\n메일 보내기: admin@gmail.com';

  @override
  String get networkUnavailable => '네트워크를 사용할 수 없습니다. 다시 시도하세요';

  @override
  String get errorFetchingUserData => '사용자 데이터를 가져오는 중 오류 발생';

  @override
  String storageError(Object error) {
    return '스토리지 오류: $error';
  }

  @override
  String get welcomeMessage => '앱에 오신 것을 환영합니다!';

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
  String get offers => '혜택';

  @override
  String get whatsOnYourMind => '무엇을 생각하고 계신가요?';

  @override
  String get bookDining => '식사 예약';

  @override
  String get softDrinks => '청량 음료';

  @override
  String get deliveryTime => '45-50분';
}
