// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get errorAddressNotFound => 'Address not Found';

  @override
  String get unknownLocation => '위치 알 수 없음';

  @override
  String get searchAddress => '주소 검색...';

  @override
  String errorReverseGeo(Object error) {
    return '역지오코딩 오류: $error';
  }

  @override
  String get grandLocation => '앱에 위치 정보 접근 권한을 부여해 주세요...';

  @override
  String get goBack => '뒤로 가기';

  @override
  String get suggestedMatch => '추천 매치';

  @override
  String get confirmContinue => '확인 후 계속 진행';

  @override
  String get refreshLocation => '위치 새로 고침';

  @override
  String get hintSearch => '음식이나 가게를 검색하세요';

  @override
  String get tabFoodDelivery => '음식배달';

  @override
  String get tabPickup => '픽업';

  @override
  String get tabGroceryShopping => '장보기·쇼핑';

  @override
  String get tabGifting => '선물하기';

  @override
  String get tabBenefits => '혜택';

  @override
  String get categoryDiscounts => '일일 할인';

  @override
  String get categoryPork => '돼지족발/삶은 돼지고기';

  @override
  String get categoryTonkatsuSashimi => '돈까스 & 사시미';

  @override
  String get categoryPizza => '피자';

  @override
  String get categoryStew => '찜 스튜';

  @override
  String get categoryChinese => '중국 음식';

  @override
  String get categoryChicken => '닭';

  @override
  String get categoryKorean => '한국 음식';

  @override
  String get categoryOneBowl => '한 그릇 요리';

  @override
  String get categoryPichupDiscount => '더';

  @override
  String get categoryFastFood => '패스트푸드';

  @override
  String get categoryCoffee => '커피';

  @override
  String get categoryBakery => '빵집';

  @override
  String get categoryLunch => '점심';

  @override
  String get categoryFreshProduce => '신선한 농산물';

  @override
  String get categoryDairyEggs => '유제품 및 계란';

  @override
  String get categoryMeat => '고기';

  @override
  String get categoryBeverages => '음료수';

  @override
  String get categoryFrozen => '언';

  @override
  String get categorySnacks => '간식';

  @override
  String get categoryHousehold => '가정';

  @override
  String get categoryCakes => '케이크';

  @override
  String get categoryFlowers => '월경';

  @override
  String get categoryGiftBoxes => '선물 상자';

  @override
  String get categoryPartySupplies => '파티 용품';

  @override
  String get categoryGiftCards => '기프트 카드';

  @override
  String get categorySpecialOccasions => '특별한 날';

  @override
  String get categoryDailyDeals => '오늘의 특가 상품';

  @override
  String get categoryLoyaltyRewards => '로열티 보상';

  @override
  String get categoryCoupons => '쿠폰';

  @override
  String get categoryNewOffers => '새로운 혜택';

  @override
  String get categoryExclusiveDeals => '독점 할인';

  @override
  String seeMore(Object tab) {
    return '$tab에서 더 자세히 알아보세요.';
  }

  @override
  String get findingLocalization => '위치를 찾는 중...';

  @override
  String get changeLanguage => '언어 변경';

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
  String get blockedAccountMessage =>
      '관리자가 계정을 차단했습니다\n\n메일 보내기: admin@gmail.com';

  @override
  String get networkUnavailable => '네트워크를 사용할 수 없습니다. 다시 시도하세요';

  @override
  String get errorFetchingUserData => '사용자 데이터를 가져오는 중 오류 발생';

  @override
  String storageError(Object error) {
    return '스토리지 오류: $error';
  }

  @override
  String get helloWorld => '안녕하세요!';

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
