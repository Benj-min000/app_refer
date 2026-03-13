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
  String get searchAll => '모두';

  @override
  String get searchRestaurants => '레스토랑';

  @override
  String get searchFood => '음식';

  @override
  String get searchStores => '백화점';

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
  String get myCart => '내 장바구니';

  @override
  String get cartCleared => '장바구니가 비워졌습니다';

  @override
  String get get_started => '시작하기';

  @override
  String get pricing => '가격';

  @override
  String get how_it_works => '작동 방식';

  @override
  String get build_user_experience => '사용자에게 최고의 검색 경험을 제공하세요.';

  @override
  String get join_thousands => '저희 대시보드를 통해 애플리케이션 확장을 진행하는 수천 개의 팀에 합류하세요.';

  @override
  String get sign_in_to_dashboard => '대시보드에 로그인하세요';

  @override
  String get create_your_account => '계정을 만드세요';

  @override
  String get new_to_the_platform => '이 플랫폼을 처음 사용하시나요?';

  @override
  String get already_have_an_account => '이미 계정이 있으신가요?';

  @override
  String get sign_in => '로그인';

  @override
  String get sign_up => '가입하기';

  @override
  String get log_in => '로그인';

  @override
  String get or => '또는';

  @override
  String get terms_of_service => '계속 진행하시면 서비스 약관에 동의하시는 것입니다.';

  @override
  String get with_google => '구글과 함께';

  @override
  String get ready_to_grow => '성장할 준비가 되셨나요?';

  @override
  String get join_restaurants => 'Freequick에 이미 등록된 레스토랑에 합류하세요.';

  @override
  String get register_now => '지금 등록하세요';

  @override
  String get see_how_it_works => '작동 방식을 확인해 보세요';

  @override
  String get now_live_in => '현재 브로츠와프에 거주하고 있습니다.';

  @override
  String get put_your_restaurant_on => '브로츠와프의 스크린에 당신의 레스토랑을 홍보하세요.';

  @override
  String get manage_your_menu => '메뉴를 관리하고, 맞춤 배너를 업로드하고, 주문을 실시간으로 추적하세요.';

  @override
  String get register_your_restaurant => '레스토랑 등록하기';

  @override
  String get orders_today => '오늘 주문';

  @override
  String get total_orders => '총 주문량';

  @override
  String get restaurants => '레스토랑';

  @override
  String get menu_items => '메뉴 항목';

  @override
  String get restaurants_on_platform => '플랫폼 내 레스토랑';

  @override
  String get orders_placed => '주문 완료';

  @override
  String get menus_published => '메뉴가 게시되었습니다';

  @override
  String get items_available => '판매 가능 상품';

  @override
  String get live_platform_stats => '실시간 플랫폼 통계';

  @override
  String get trusted_by_restaurants => '레스토랑들이 신뢰하는 제품';

  @override
  String get upper_features => '특징';

  @override
  String get sales_analytics => '판매 분석';

  @override
  String get track_peak_hours => '피크 시간대를 추적하세요.';

  @override
  String get custom_banners => '맞춤 배너';

  @override
  String get full_creative_control => '완전한 창작의 자유.';

  @override
  String get your_menu_goes_live_instantly => '메뉴가 즉시 게시됩니다.';

  @override
  String get digital_menu => '디지털 메뉴';

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
  String get info_continue => '계속하다';

  @override
  String get owner_s_full_name => 'Owner\'s Full Name';

  @override
  String get owner_full_name => 'Owner\'s Full Name';

  @override
  String get owner_phone => 'Owner\'s Phone';

  @override
  String get back => 'Back';

  @override
  String get admin_overview => '개요';

  @override
  String get admin_join_requests => '가입 요청';

  @override
  String get admin_users => '사용자';

  @override
  String get admin_notifications => '알림';

  @override
  String get admin_panel => '관리자 패널';

  @override
  String get admin => '관리자';

  @override
  String get administrator => 'Administrator';

  @override
  String get sign_out => '로그아웃';

  @override
  String get hiw_hero_badge => '간단하고, 빠르고, 투명합니다.';

  @override
  String get hiw_hero_title => '회원가입부터 첫 주문까지 몇 분밖에 걸리지 않습니다.';

  @override
  String get hiw_hero_subtitle =>
      'Freequick은 요리에 집중하고 싶어하는 레스토랑 운영자를 위해 설계되었으며, 기술 관리에는 신경 쓰지 않아도 됩니다.';

  @override
  String get hiw_cta_title => '시작할 준비 되셨나요?';

  @override
  String get hiw_cta_subtitle => 'Freequick에 이미 등록된 레스토랑에 합류하세요.';

  @override
  String get hiw_cta_primary => '레스토랑 등록하기';

  @override
  String get hiw_cta_secondary => '가격 보기';

  @override
  String get hiw_section_process => '그 과정';

  @override
  String get hiw_section_features => '제공되는 상품';

  @override
  String get hiw_features_title => '레스토랑에 필요한 모든 것.';

  @override
  String get hiw_step1_title => '계정을 만드세요';

  @override
  String get hiw_step1_desc =>
      '레스토랑 정보를 입력하여 등록하세요. 2분도 채 걸리지 않습니다. 신용카드는 필요하지 않습니다.';

  @override
  String get hiw_step2_title => '프로필을 설정하세요';

  @override
  String get hiw_step2_desc => '로고와 배너를 업로드하고 주소를 설정하세요. 온라인 스토어가 즉시 오픈됩니다.';

  @override
  String get hiw_step3_title => '메뉴를 만들어보세요';

  @override
  String get hiw_step3_desc =>
      '사진, 가격, 설명을 포함한 메뉴와 항목을 추가하세요. 카테고리별로 정리할 수 있습니다.';

  @override
  String get hiw_step4_title => '주문을 받으세요';

  @override
  String get hiw_step4_desc =>
      '고객은 온라인으로 당신을 찾아 주문하고 결제합니다. 당신은 대시보드에서 모든 주문을 실시간으로 확인할 수 있습니다.';

  @override
  String get hiw_step5_title => '돈을 받으세요';

  @override
  String get hiw_step5_desc =>
      '수익금은 등록된 은행 계좌로 입금됩니다. 주문이 완료된 건당 소액의 수수료만 지불하시면 됩니다.';

  @override
  String get hiw_feature1_title => '실시간 주문';

  @override
  String get hiw_feature1_desc => '모든 주문 내역이 대시보드에 즉시 표시됩니다. 새로 고침할 필요가 없습니다.';

  @override
  String get hiw_feature2_title => '판매 분석';

  @override
  String get hiw_feature2_desc => '7일 또는 30일 동안의 매출, 인기 상품 및 주문 추세를 확인하세요.';

  @override
  String get hiw_feature3_title => '맞춤형 브랜딩';

  @override
  String get hiw_feature3_desc => '로고, 배너, 색상 — 레스토랑의 정체성을 나타냅니다.';

  @override
  String get hiw_feature4_title => '안전한 결제';

  @override
  String get hiw_feature4_desc =>
      '모든 결제는 안전하게 처리됩니다. 고객님은 카드 정보를 절대 직접 입력하지 않습니다.';

  @override
  String get hiw_feature5_title => '어디에서든 작동합니다';

  @override
  String get hiw_feature5_desc => '대시보드는 데스크톱, 태블릿, 모바일에서 실행됩니다. 어디서든 관리하세요.';

  @override
  String get hiw_feature6_title => '전담 지원';

  @override
  String get hiw_feature6_desc => '실제 담당자들이 여러분의 설정과 운영을 도와드립니다.';

  @override
  String get pricing_hero_badge => '월 사용료는 전혀 없습니다.';

  @override
  String get pricing_hero_title => '수익이 발생할 때만 지불하세요.';

  @override
  String get pricing_hero_subtitle =>
      'Freequick은 완료된 주문에 대해서만 소액의 수수료를 부과합니다. 수익이 발생하지 않으면 비용을 지불할 필요가 없습니다.';

  @override
  String get pricing_cta_title => '지금 바로 무료로 시작하세요.';

  @override
  String get pricing_cta_subtitle => '첫 주문 전까지는 수수료가 없습니다.';

  @override
  String get pricing_cta_primary => '레스토랑 등록하기';

  @override
  String get pricing_section_fee => '수수료 계산 방식';

  @override
  String get pricing_section_calculator => '예상 수입을 계산해 보세요';

  @override
  String get pricing_section_tiers => '수수료 등급';

  @override
  String get pricing_section_faq => '자주 묻는 질문';

  @override
  String get pricing_calculator_title => '무엇을 남겼는지 확인해 보세요.';

  @override
  String get pricing_tiers_title => '주문량이 많을수록 요금이 낮아집니다.';

  @override
  String get pricing_tiers_subtitle => '레스토랑 규모가 커질수록 수수료율은 자동으로 낮아집니다.';

  @override
  String get pricing_faq_title => '자주 묻는 질문.';

  @override
  String get pricing_step1_title => '고객이 주문을 합니다';

  @override
  String get pricing_step1_desc =>
      '사용자들은 앱을 통해 메뉴를 살펴보고, 원하는 항목을 추가하고, 결제할 수 있습니다.';

  @override
  String get pricing_step2_title => '당신은 준비하고 전달합니다.';

  @override
  String get pricing_step2_desc => '주문을 확인하고, 준비한 후, 배송 완료로 표시합니다.';

  @override
  String get pricing_step3_title => '우리는 약간의 이익을 취합니다';

  @override
  String get pricing_step3_desc => '주문 금액에서 수수료가 차감됩니다. 나머지 금액은 고객님께 돌아갑니다.';

  @override
  String get pricing_slider_orders_label => '하루 주문량';

  @override
  String pricing_slider_orders_value(int count, int monthly) {
    return '$count 주문/일 · $monthly 주문/월';
  }

  @override
  String get pricing_slider_avg_label => '평균 주문 금액';

  @override
  String pricing_slider_avg_value(String amount) {
    return '$amount PLN';
  }

  @override
  String pricing_tier_badge(String tierName, String rate) {
    return '$tierName 티어 — $rate 커미션';
  }

  @override
  String pricing_tier_monthly(int count) {
    return '$count 주문/월';
  }

  @override
  String get pricing_calc_revenue_label => '일일 수익';

  @override
  String get pricing_calc_revenue_sub => '수수료 부과 전';

  @override
  String pricing_calc_fee_label(String rate) {
    return '무료 빠른 수수료($rate)';
  }

  @override
  String get pricing_calc_fee_sub => '하루에';

  @override
  String get pricing_calc_keep_label => '당신은 계속';

  @override
  String get pricing_calc_disclaimer => '수수료는 주문이 완료되어 배송된 경우에만 부과됩니다.';

  @override
  String get pricing_tier_starter_label => '기동기';

  @override
  String get pricing_tier_starter_range => '월 0~100건의 주문';

  @override
  String get pricing_tier_starter_desc => '초기 비용 없이 지금 바로 시작하세요.';

  @override
  String get pricing_tier_growing_label => '성장';

  @override
  String get pricing_tier_growing_range => '월 101~500건의 주문';

  @override
  String get pricing_tier_growing_desc => '고객 기반이 구축될수록 요금을 낮추세요.';

  @override
  String get pricing_tier_established_label => '확립된';

  @override
  String get pricing_tier_established_range => '월 501~1,500건의 주문';

  @override
  String get pricing_tier_established_desc => '꾸준히 높은 매출을 올리는 레스토랑에 보상을 제공합니다.';

  @override
  String get pricing_tier_partner_label => '파트너';

  @override
  String get pricing_tier_partner_range => '1,500건 이상의 주문/월';

  @override
  String get pricing_tier_partner_desc => '거래량이 가장 많은 파트너사에게 가장 유리한 요금을 제공합니다.';

  @override
  String get pricing_faq1_q => '설치비나 월 사용료가 있나요?';

  @override
  String get pricing_faq1_a =>
      '아니요. Freequick은 설치비나 월 사용료를 전혀 받지 않습니다. 완료된 주문에 대해서만 수수료를 지불하시면 됩니다.';

  @override
  String get pricing_faq2_q => '수수료는 언제 공제되나요?';

  @override
  String get pricing_faq2_a =>
      '수수료는 주문이 배송 완료로 표시되는 시점에 계산됩니다. 해당 수수료는 지급 잔액에서 자동으로 차감됩니다.';

  @override
  String get pricing_faq3_q => '급여는 얼마나 자주 지급되나요?';

  @override
  String get pricing_faq3_a =>
      '지급금은 등록된 IBAN 은행 계좌로 매주 지급됩니다. 대시보드에서 실시간으로 잔액을 확인할 수 있습니다.';

  @override
  String get pricing_faq4_q => '주문이 취소되면 어떻게 되나요?';

  @override
  String get pricing_faq4_a =>
      '주문 취소 시에는 수수료가 부과되지 않습니다. 성공적으로 완료된 배송에 대해서만 수수료를 지불하시면 됩니다.';

  @override
  String get pricing_faq5_q => '나중에 은행 계좌 정보를 변경할 수 있나요?';

  @override
  String get pricing_faq5_a => '네. 대시보드의 설정 섹션에서 언제든지 IBAN을 업데이트할 수 있습니다.';

  @override
  String get pricing_tier_name_starter => '기동기';

  @override
  String get pricing_tier_name_growing => '성장';

  @override
  String get pricing_tier_name_established => '확립된';

  @override
  String get pricing_tier_name_partner => '파트너';

  @override
  String get admin_notifications_tab_send => '알림 보내기';

  @override
  String get admin_notifications_tab_history => '역사';

  @override
  String get admin_notifications_target_audience => '타겟 고객';

  @override
  String get admin_notifications_audience_all => '모두';

  @override
  String get admin_notifications_audience_restaurants => '레스토랑';

  @override
  String get admin_notifications_audience_specific => '특정한';

  @override
  String get admin_notifications_audience_label_all => '모든 사용자';

  @override
  String get admin_notifications_audience_label_restaurants => '레스토랑 사장님들';

  @override
  String get admin_notifications_audience_label_specific => '특정 사용자';

  @override
  String get admin_notifications_search_hint => '이름 또는 이메일로 검색하세요…';

  @override
  String get admin_notifications_search_hint_more => '사용자 추가하기…';

  @override
  String get admin_notifications_title_label => '알림 제목';

  @override
  String get admin_notifications_title_hint => '예: 새로운 기능이 추가되었습니다';

  @override
  String get admin_notifications_body_label => '메시지';

  @override
  String get admin_notifications_body_hint => '알림 메시지를 작성하세요…';

  @override
  String get admin_notifications_send_button => '알림 보내기';

  @override
  String get admin_notifications_sending => '배상…';

  @override
  String get admin_notifications_required => '필수의';

  @override
  String get admin_notifications_select_user => '최소 한 명의 사용자를 선택해 주세요.';

  @override
  String get admin_notifications_no_users => '이 대상 그룹에 해당하는 사용자를 찾을 수 없습니다.';

  @override
  String get admin_notifications_sent_one => '사용자 1명에게 전송됨';

  @override
  String admin_notifications_sent_many(int count) {
    return '$count명의 사용자에게 전송됨';
  }

  @override
  String get admin_notifications_history_empty => '아직 알림이 전송되지 않았습니다.';

  @override
  String get admin_notifications_history_sent_badge => '전송된';

  @override
  String admin_notifications_history_sent_count(int count) {
    return '$count 보냈습니다';
  }

  @override
  String get admin_overview_platform_glance => '플랫폼 개요';

  @override
  String get admin_overview_revenue_30d => '매출 (최근 30일)';

  @override
  String get admin_overview_pending_requests => '가입 요청 대기 중';

  @override
  String get admin_overview_view_all => '모두 보기';

  @override
  String get admin_overview_order_status => '주문 상태 분석';

  @override
  String get admin_overview_top_restaurants => '주문 순으로 뽑은 최고의 레스토랑';

  @override
  String get admin_overview_stat_restaurants => '총 레스토랑 수';

  @override
  String admin_overview_stat_restaurants_sub(int active) {
    return '$active 주문과 함께';
  }

  @override
  String get admin_overview_stat_orders => '총 주문량';

  @override
  String admin_overview_stat_orders_sub(int count) {
    return '$count 오늘';
  }

  @override
  String get admin_overview_stat_revenue => '총 수익';

  @override
  String admin_overview_stat_revenue_sub(String amount) {
    return '$amount PLN 지난 7일';
  }

  @override
  String get admin_overview_stat_avg => '평균 주문 금액';

  @override
  String admin_overview_stat_avg_sub(int menus, int items) {
    return '$menus 메뉴 · $items 항목';
  }

  @override
  String get admin_overview_loading => '—';

  @override
  String get admin_overview_revenue_no_data => '아직 수익 데이터가 없습니다.';

  @override
  String get admin_overview_no_pending => '보류 중인 요청 없음';

  @override
  String admin_overview_pending_nip(String nip, String date) {
    return 'NIP: $nip · 제출됨 $date';
  }

  @override
  String get admin_overview_review => '검토';

  @override
  String get admin_overview_no_orders => '아직 주문이 없습니다.';

  @override
  String get admin_overview_no_order_data => '아직 주문 데이터가 없습니다.';

  @override
  String admin_overview_orders_count(int count) {
    return '$count 주문';
  }

  @override
  String get admin_overview_status_pending => '보류 중';

  @override
  String get admin_overview_status_processing => '처리 중';

  @override
  String get admin_overview_status_delivered => '배송 완료';

  @override
  String get admin_overview_status_cancelled => '취소';

  @override
  String get requests_tab_registrations => '등록';

  @override
  String get requests_tab_go_live => '라이브 방송 요청';

  @override
  String get requests_filter_pending => '보류 중';

  @override
  String get requests_filter_approved => '승인됨';

  @override
  String get requests_filter_active => '활동적인';

  @override
  String get requests_filter_rejected => '거절됨';

  @override
  String get requests_filter_suspended => '정지된';

  @override
  String get requests_filter_all => '모두';

  @override
  String requests_empty_filtered(String filter) {
    return '$filter 요청 없음';
  }

  @override
  String get requests_empty_all => '아직 레스토랑이 없습니다.';

  @override
  String get requests_go_live_empty => '아직 Go Live 요청이 없습니다.';

  @override
  String get requests_go_live_section_pending => '검토 중';

  @override
  String get requests_go_live_section_reviewed => '검토 완료';

  @override
  String requests_go_live_requested(String timeAgo, String date) {
    return '요청됨 $timeAgo · $date';
  }

  @override
  String requests_go_live_activated_on(String date) {
    return '$date에서 활성화됨';
  }

  @override
  String requests_go_live_declined_on(String date) {
    return '$date에서 거절됨';
  }

  @override
  String get requests_badge_activated => '활성화됨';

  @override
  String get requests_badge_declined => '거절됨';

  @override
  String get requests_badge_pending_review => '검토 중';

  @override
  String get requests_action_activate => '활성화';

  @override
  String get requests_action_decline => '감소';

  @override
  String requests_submitted(String date) {
    return '제출됨 $date';
  }

  @override
  String get requests_status_approved => '승인됨';

  @override
  String get requests_status_active => '활동적인';

  @override
  String get requests_status_rejected => '거절됨';

  @override
  String get requests_status_suspended => '정지된';

  @override
  String get requests_status_pending => '보류 중';

  @override
  String get requests_action_approve => '승인하다';

  @override
  String get requests_action_reject => '거부하다';

  @override
  String get requests_action_suspend => '유예하다';

  @override
  String get requests_action_reinstate => '복원';

  @override
  String get requests_action_copy_id => '레스토랑 ID 복사';

  @override
  String requests_copied(String id) {
    return '복사됨: $id';
  }

  @override
  String get requests_confirm_approve_title => '승인하다';

  @override
  String get requests_confirm_approve_body =>
      '이렇게 하면 레스토랑이 승인되고 소유자는 대시보드에 액세스할 수 있게 됩니다.';

  @override
  String get requests_confirm_reject_title => '거부하다';

  @override
  String get requests_confirm_reject_body =>
      '이렇게 하면 해당 레스토랑의 신청이 거부됩니다. 레스토랑 주인은 로그인할 때 거부 메시지를 보게 됩니다.';

  @override
  String get requests_confirm_suspend_title => '유예하다';

  @override
  String get requests_confirm_suspend_body =>
      '이렇게 하면 레스토랑 계정이 정지됩니다. 소유자는 즉시 관리자 페이지에 접근할 수 없게 됩니다.';

  @override
  String get requests_confirm_reinstate_title => '복원';

  @override
  String get requests_confirm_reinstate_body => '이렇게 하면 레스토랑이 다시 영업 상태로 돌아갑니다.';

  @override
  String get requests_confirm_cancel => '취소';

  @override
  String requests_error_failed(String error) {
    return '실패: $error';
  }

  @override
  String requests_setup_progress(int done, int total) {
    return '설정: $done/$total 완료';
  }

  @override
  String get requests_check_logo => '로고가 업로드되었습니다';

  @override
  String get requests_check_banner => '배너 업로드됨';

  @override
  String get requests_check_address => '주소 세트';

  @override
  String get requests_check_iban => 'IBAN 설정';

  @override
  String get requests_check_photo => '프로필 사진';

  @override
  String get requests_check_menu => '메뉴 하나 이상';

  @override
  String get users_search_hint => '이름 또는 이메일로 검색하세요…';

  @override
  String get users_filter_all => '모두';

  @override
  String get users_filter_restaurant => '식당';

  @override
  String get users_filter_admin => '관리자';

  @override
  String get users_filter_customer => '고객';

  @override
  String get users_empty_filtered => '필터 조건에 맞는 사용자가 없습니다.';

  @override
  String get users_empty_all => '아직 사용자가 없습니다';

  @override
  String get users_banned_badge => '금지됨';

  @override
  String users_joined(String date) {
    return '$date에 가입했습니다';
  }

  @override
  String get users_detail_title => '사용자 정보';

  @override
  String get users_detail_id => '사용자 ID';

  @override
  String get users_detail_phone => '핸드폰';

  @override
  String get users_detail_joined => '가입함';

  @override
  String get users_detail_role => '역할';

  @override
  String get users_action_ban => '반';

  @override
  String get users_action_unban => '차단 해제';

  @override
  String get users_action_delete => '삭제';

  @override
  String get users_confirm_cancel => '취소';

  @override
  String get users_ban_title => '사용자 차단?';

  @override
  String get users_unban_title => '사용자 차단을 해제하시겠습니까?';

  @override
  String get users_ban_body => '이렇게 하면 사용자가 플랫폼에 접근할 수 없게 됩니다.';

  @override
  String get users_unban_body => '이렇게 하면 사용자의 접근 권한이 복원됩니다.';

  @override
  String get users_delete_title => '사용자 삭제하시겠습니까?';

  @override
  String get users_delete_body =>
      '이렇게 하면 사용자의 Firestore 문서가 영구적으로 삭제됩니다. 사용자의 인증 계정은 Firebase 콘솔에서 별도로 삭제하지 않는 한 유지됩니다.';

  @override
  String get users_snack_banned => '사용자가 차단되었습니다.';

  @override
  String get users_snack_unbanned => '사용자 차단이 해제되었습니다.';

  @override
  String get users_snack_deleted => '사용자가 삭제되었습니다.';

  @override
  String get users_copied => '클립보드에 복사됨';

  @override
  String get users_role_admin => '관리자';

  @override
  String get users_role_restaurant => '식당';

  @override
  String get users_role_customer => '고객';

  @override
  String get analytics_section_glance => '한눈에 보기';

  @override
  String get analytics_section_revenue => '시간 경과에 따른 수익';

  @override
  String get analytics_section_status => '주문 상태 분석';

  @override
  String get analytics_section_popular => '가장 많이 주문된 품목';

  @override
  String analytics_stat_revenue(int days) {
    return '수익(${days}d)';
  }

  @override
  String analytics_stat_orders(int days) {
    return '주문(${days}d)';
  }

  @override
  String get analytics_stat_today => '오늘의 판매량';

  @override
  String get analytics_stat_avg => '평균 주문';

  @override
  String get analytics_no_revenue => '이 기간에 대한 매출 데이터는 없습니다.';

  @override
  String get analytics_no_orders => '이 기간 동안 주문 없음';

  @override
  String get analytics_no_items => '이 기간에는 항목 데이터가 없습니다.';

  @override
  String analytics_orders_count(int count) {
    return '$count 주문';
  }

  @override
  String get analytics_status_normal => '정상';

  @override
  String get analytics_status_processing => '처리 중';

  @override
  String get analytics_status_delivered => '배송 완료';

  @override
  String get analytics_status_cancelled => '취소';

  @override
  String get shell_nav_overview => '개요';

  @override
  String get shell_nav_orders => '명령';

  @override
  String get shell_nav_menus => '메뉴';

  @override
  String get shell_nav_promotions => '프로모션';

  @override
  String get shell_nav_analytics => '해석학';

  @override
  String get shell_nav_settings => '설정';

  @override
  String get shell_restaurant_not_found => '레스토랑을 찾을 수 없습니다. 고객 지원팀에 문의해 주세요.';

  @override
  String get shell_finish_setup => '설정 완료';

  @override
  String get shell_my_account => '내 계정';

  @override
  String get shell_live_go_offline => '라이브 · 오프라인';

  @override
  String get shell_go_live_pending => '검토 후 출시 예정';

  @override
  String get shell_go_live_declined => '거절됨 · 재신청';

  @override
  String get shell_request_go_live => '요청 실행';

  @override
  String get shell_already_pending => '이미 서비스 개시 요청이 접수되어 대기 중입니다.';

  @override
  String get shell_go_live_submitted => '서비스 개시 요청이 제출되었습니다. 곧 검토 후 알려드리겠습니다.';

  @override
  String shell_error(String error) {
    return '오류: $error';
  }

  @override
  String get shell_go_offline_title => '오프라인으로 전환하시겠습니까?';

  @override
  String get shell_go_offline_body =>
      '레스토랑 정보가 고객에게 표시되지 않습니다. 언제든지 다시 활성화할 수 있습니다.';

  @override
  String get shell_confirm_cancel => '취소';

  @override
  String get shell_go_offline_confirm => '오프라인으로 전환';

  @override
  String get shell_menu_support => '지원팀에 문의하세요';

  @override
  String get shell_menu_sales => '영업 담당자에게 문의하세요';

  @override
  String get shell_menu_cookies => '쿠키 기본 설정';

  @override
  String get shell_menu_settings => '설정';

  @override
  String get shell_menu_logout => '로그아웃';

  @override
  String get gate_pending_title => '귀하의 계정은 검토 중입니다.';

  @override
  String get gate_pending_message =>
      '회원님의 등록 정보를 검토 중입니다. 일반적으로 1~2영업일이 소요됩니다. 승인되면 이메일로 알려드리겠습니다.';

  @override
  String get gate_rejected_title => '신청이 승인되지 않았습니다.';

  @override
  String get gate_rejected_message =>
      '죄송하지만 등록이 승인되지 않았습니다. 자세한 내용은 고객 지원팀에 문의해 주세요.';

  @override
  String get gate_suspended_title => '계정 정지됨';

  @override
  String get gate_suspended_message =>
      '회원님의 계정이 정지되었습니다. 문제를 해결하려면 고객 지원팀에 문의하세요.';

  @override
  String get gate_default_title => '접근 불가';

  @override
  String get gate_default_message => '고객 지원팀에 문의해 주세요.';

  @override
  String get gate_sign_out => '로그아웃';

  @override
  String overview_welcome(String name) {
    return '$name 👋 다시 오신 것을 환영합니다!';
  }

  @override
  String get overview_subtitle => '오늘 당신의 레스토랑에서 일어나는 일은 다음과 같습니다.';

  @override
  String get overview_section_glance => '한눈에 보기';

  @override
  String get overview_section_orders => '최근 주문';

  @override
  String get overview_setup_title => '레스토랑을 준비하세요';

  @override
  String overview_setup_progress(int done, int total) {
    return '$done/$total 단계 완료';
  }

  @override
  String get overview_task_done => '완료';

  @override
  String get overview_task_setup => '설정';

  @override
  String get overview_task_logo_title => '레스토랑 로고 업로드';

  @override
  String get overview_task_logo_desc => '고객은 앱 전체에서 귀사의 로고를 보게 될 것입니다.';

  @override
  String get overview_task_banner_title => '배너 이미지 추가';

  @override
  String get overview_task_banner_desc => '배너는 매장 외관을 시각적으로 매력적으로 만들어줍니다.';

  @override
  String get overview_task_address_title => '레스토랑 주소 설정';

  @override
  String get overview_task_address_desc => '고객에게 당신의 위치를 알려주세요.';

  @override
  String get overview_task_photo_title => '프로필 사진 추가';

  @override
  String get overview_task_photo_desc => '레스토랑 사장님 계정에 얼굴을 더해보세요.';

  @override
  String get overview_task_menu_title => '메뉴를 만들고 항목을 추가하세요';

  @override
  String get overview_task_menu_desc => '메뉴판에 요리와 가격을 함께 정리하여 제공하세요.';

  @override
  String get overview_task_iban_title => '은행 계좌(IBAN)를 추가하세요';

  @override
  String get overview_task_iban_desc => '고객 주문에 대한 대금 지급을 받으려면 필수적입니다.';

  @override
  String get overview_stat_total_orders => '총 주문량';

  @override
  String get overview_stat_pending => '보류 중';

  @override
  String get overview_stat_completed => '완전한';

  @override
  String get overview_stat_revenue => '총 수익';

  @override
  String get overview_no_orders => '아직 주문이 없습니다.';

  @override
  String get overview_table_order_id => '주문 ID';

  @override
  String get overview_table_customer => '고객';

  @override
  String get overview_table_items => '품목';

  @override
  String get overview_table_status => '상태';

  @override
  String get overview_table_total => '총';

  @override
  String overview_items_count(int count) {
    return '$count 항목';
  }

  @override
  String overview_items_count_plural(int count) {
    return '$count개 항목';
  }

  @override
  String get overview_time_just_now => '방금';

  @override
  String overview_time_minutes(int n) {
    return '${n}m 전';
  }

  @override
  String overview_time_hours(int n) {
    return '$n시간 전';
  }

  @override
  String get overview_chef_fallback => '요리사';

  @override
  String get items_app_bar_fallback => '품목';

  @override
  String get items_empty_title => '아직 상품이 없습니다';

  @override
  String get items_empty_subtitle => '+를 눌러 첫 번째 항목을 추가하세요';

  @override
  String items_error(String error) {
    return '오류: $error';
  }

  @override
  String get items_fab => '항목 추가';

  @override
  String get items_sheet_title => '항목 추가';

  @override
  String get items_image_upload_label => '상품 이미지 업로드';

  @override
  String get items_image_browse => '클릭하여 살펴보세요';

  @override
  String get items_field_title_label => '품목명';

  @override
  String get items_field_title_hint => '예: 피에로기 루스키';

  @override
  String get items_field_title_required => '제목을 입력해야 합니다.';

  @override
  String get items_field_info_label => '간략 정보';

  @override
  String get items_field_info_hint => '예: 바삭하고 맛있는';

  @override
  String get items_field_info_required => '정보가 필요합니다';

  @override
  String get items_field_desc_label => '설명';

  @override
  String get items_field_desc_hint => '상품을 설명해 주세요...';

  @override
  String get items_field_desc_required => '설명이 필요합니다';

  @override
  String get items_field_price_label => '가격(PLN)';

  @override
  String get items_field_price_hint => '예: 24.99';

  @override
  String get items_field_price_required => '가격이 필요합니다';

  @override
  String get items_field_price_invalid => '유효한 숫자를 입력하세요';

  @override
  String get items_field_tags_label => '태그';

  @override
  String get items_field_tags_hint => '예: 비건';

  @override
  String get items_tag_error_empty => '태그를 입력하세요';

  @override
  String get items_tag_error_capitalize => '첫 글자는 반드시 대문자여야 합니다.';

  @override
  String get items_tag_error_letters => '글자만 허용됩니다.';

  @override
  String get items_tag_error_duplicate => '태그가 이미 존재합니다';

  @override
  String get items_discount_toggle => '할인 적용';

  @override
  String get items_discount_label => '할인 %';

  @override
  String get items_discount_required => '할인율을 입력하세요';

  @override
  String get items_discount_invalid => '1에서 100 사이의 값을 입력하세요.';

  @override
  String get items_no_image => '상품 이미지를 선택해 주세요.';

  @override
  String get items_added => '항목이 성공적으로 추가되었습니다.';

  @override
  String get items_submit => '항목 추가';

  @override
  String get menus_empty_title => '아직 메뉴가 없습니다';

  @override
  String get menus_empty_subtitle => '+를 눌러 첫 번째 메뉴를 추가하세요';

  @override
  String menus_error(String error) {
    return '오류: $error';
  }

  @override
  String get menus_fab => '메뉴 추가';

  @override
  String get menus_sheet_title => '메뉴 추가';

  @override
  String get menus_image_upload_label => '배너 이미지 업로드';

  @override
  String get menus_image_browse => '클릭하여 살펴보세요';

  @override
  String get menus_field_title_label => '메뉴 제목';

  @override
  String get menus_field_title_hint => '예: 점심 특선 메뉴';

  @override
  String get menus_field_title_required => '제목을 입력해야 합니다.';

  @override
  String get menus_field_desc_label => '설명';

  @override
  String get menus_field_desc_hint => '이 메뉴에 대해 간략하게 설명해 주세요...';

  @override
  String get menus_field_desc_required => '설명이 필요합니다';

  @override
  String get menus_no_image => '배너 이미지를 선택해 주세요.';

  @override
  String get menus_created => '메뉴가 성공적으로 생성되었습니다.';

  @override
  String get menus_submit => '메뉴 만들기';

  @override
  String get orders_error => '뭔가 잘못됐어요';

  @override
  String get orders_empty_title => '현재 주문이 없습니다';

  @override
  String get orders_empty_subtitle => '고객이 주문을 하면 여기에 표시됩니다.';

  @override
  String get orders_table_order_id => '주문 ID';

  @override
  String get orders_table_customer => '고객';

  @override
  String get orders_table_items => '품목';

  @override
  String get orders_table_status => '상태';

  @override
  String get orders_table_total => '총';

  @override
  String orders_item_count(int count) {
    return '$count 항목';
  }

  @override
  String orders_item_count_plural(int count) {
    return '$count개 항목';
  }

  @override
  String get promo_not_authenticated => '인증되지 않음';

  @override
  String get promo_empty_title => '아직 프로모션이 없습니다.';

  @override
  String get promo_empty_subtitle => '+ 버튼을 눌러 첫 번째 프로모션 배너를 만드세요.';

  @override
  String get promo_fab => '새로운 프로모션';

  @override
  String get promo_badge_live => '살다';

  @override
  String get promo_badge_inactive => '비활성화됨';

  @override
  String promo_items_linked(int count) {
    return '$count 항목';
  }

  @override
  String promo_items_linked_plural(int count) {
    return '$count개 항목';
  }

  @override
  String get promo_edit_button => '편집하다';

  @override
  String get promo_sheet_add_title => '새로운 프로모션';

  @override
  String get promo_sheet_edit_title => '편집 프로모션';

  @override
  String get promo_sheet_delete_button => '삭제';

  @override
  String get promo_image_change_hint => '배너를 변경하려면 탭하세요.';

  @override
  String get promo_image_upload_hint => '배너 이미지를 업로드하려면 탭하세요.';

  @override
  String get promo_image_upload_label => '배너 이미지 업로드';

  @override
  String get promo_image_recommended => '권장 해상도: 1200×400px';

  @override
  String get promo_field_title_label => '승진 제목';

  @override
  String get promo_field_title_hint => '예: 주말 할인';

  @override
  String get promo_field_title_required => '제목을 입력해야 합니다.';

  @override
  String get promo_field_desc_label => '설명';

  @override
  String get promo_field_desc_hint => '예: 이번 주말 모든 메인 메뉴 최대 30% 할인';

  @override
  String get promo_field_desc_required => '설명이 필요합니다';

  @override
  String get promo_date_start => '시작일';

  @override
  String get promo_date_end => '종료일';

  @override
  String get promo_date_pick => '날짜를 선택하세요';

  @override
  String get promo_active_toggle => '프로모션 활동 중';

  @override
  String get promo_link_section_label => '할인 상품 링크';

  @override
  String get promo_link_section_hint => '(선택 사항) - 프로모션이 적용되는 품목을 선택하세요';

  @override
  String get promo_link_no_items => '항목을 찾을 수 없습니다. 먼저 메뉴에 항목을 추가하세요.';

  @override
  String get promo_save_changes => '변경 사항 저장';

  @override
  String get promo_create => '프로모션 생성';

  @override
  String get promo_no_dates => '시작일과 종료일을 모두 설정해 주세요.';

  @override
  String get promo_date_order_error => '종료일은 시작일 이후여야 합니다.';

  @override
  String get promo_no_image => '배너 이미지를 선택해 주세요.';

  @override
  String get promo_updated => '프로모션이 성공적으로 업데이트되었습니다.';

  @override
  String get promo_created => '프로모션이 성공적으로 생성되었습니다.';

  @override
  String get promo_banner_cleanup_error => '배너는 업데이트되었지만, 이전 파일 정리에는 실패했습니다.';

  @override
  String get promo_delete_title => '프로모션을 삭제하시겠습니까?';

  @override
  String get promo_delete_body =>
      '이렇게 하면 프로모션과 배너가 영구적으로 삭제됩니다. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get promo_delete_cancel => '취소';

  @override
  String get promo_delete_confirm => '삭제';

  @override
  String get promo_deleted => '프로모션이 삭제되었습니다.';

  @override
  String get promo_location_dialog_title => '레스토랑 위치';

  @override
  String get promo_location_none => '아직 위치를 선택하지 않았습니다.';

  @override
  String get promo_location_open_map => '지도 열기';

  @override
  String get promo_location_change_map => '지도상의 변화';

  @override
  String get promo_location_confirm => '주소 확인';

  @override
  String get promo_location_no_pick => '먼저 지도에서 위치를 선택해 주세요.';

  @override
  String get settings_section_business => '사업';

  @override
  String get settings_section_business_sub => '레스토랑 프로필 및 미디어를 관리하세요';

  @override
  String get settings_section_profile => '사용자 프로필';

  @override
  String get settings_section_profile_sub => '개인 계정 정보를 업데이트하세요';

  @override
  String get settings_section_danger => '위험 지역';

  @override
  String get settings_section_danger_sub => '계정에 대한 돌이킬 수 없는 조치';

  @override
  String get settings_logo_title => '레스토랑 로고';

  @override
  String get settings_logo_status_staged => '새 로고 준비 완료';

  @override
  String get settings_logo_status_exists => '로고가 업로드되었습니다';

  @override
  String get settings_logo_status_none => '아직 로고가 없습니다';

  @override
  String get settings_logo_recommended => '권장 형식: 512×512px, PNG 또는 JPG';

  @override
  String get settings_logo_choose => '선택하다';

  @override
  String get settings_logo_upload => '업로드';

  @override
  String get settings_logo_uploading => '업로드 중…';

  @override
  String get settings_logo_success => '로고 업데이트됨';

  @override
  String get settings_banner_title => '레스토랑 배너';

  @override
  String get settings_banner_choose => '배너를 선택하려면 클릭하세요';

  @override
  String get settings_banner_recommended => '권장 해상도: 1200×800px';

  @override
  String get settings_banner_upload => '배너 업로드';

  @override
  String get settings_banner_uploading => '업로드 중…';

  @override
  String get settings_banner_success => '배너 업데이트됨';

  @override
  String get settings_business_title => '사업 정보';

  @override
  String get settings_business_saved => '사업 정보가 저장되었습니다';

  @override
  String get settings_address_set => '레스토랑 주소를 설정하세요';

  @override
  String get settings_address_change => '변화';

  @override
  String get settings_address_pick => '지도에서 선택하세요';

  @override
  String get settings_profile_title => '윤곽';

  @override
  String get settings_profile_photo_ready => '새 사진 준비 완료 — 저장을 눌러 적용하세요';

  @override
  String get settings_profile_saved => '프로필이 저장되었습니다';

  @override
  String get settings_profile_name_hint => '소유자 이름';

  @override
  String get settings_profile_phone_label => '전화 번호';

  @override
  String get settings_danger_reset_title => '비밀번호 변경';

  @override
  String get settings_danger_reset_sub => '계정으로 비밀번호 재설정 이메일을 보내주세요';

  @override
  String get settings_danger_reset_button => '다시 놓기';

  @override
  String get settings_danger_reset_sent => '비밀번호 재설정 이메일이 발송되었습니다.';

  @override
  String get settings_danger_delete_title => '계정 삭제';

  @override
  String get settings_danger_delete_sub => '레스토랑과 모든 데이터를 영구적으로 삭제합니다.';

  @override
  String get settings_danger_delete_button => '삭제';

  @override
  String get settings_danger_delete_dialog_title => '계정 삭제';

  @override
  String get settings_danger_delete_dialog_body =>
      '이렇게 하면 계정과 모든 레스토랑 데이터가 영구적으로 삭제됩니다. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get settings_cancel => '취소';

  @override
  String get settings_error => '뭔가 잘못됐어요';

  @override
  String get settings_save_changes => '변경 사항 저장';

  @override
  String get settings_map_dialog_title => '레스토랑 위치';

  @override
  String get settings_map_no_location => '아직 위치를 선택하지 않았습니다.';

  @override
  String get settings_map_open => '지도 열기';

  @override
  String get settings_map_change => '지도상의 변화';

  @override
  String get settings_map_confirm => '주소 확인';

  @override
  String get settings_map_no_pick => '먼저 지도에서 위치를 선택해 주세요.';

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
  String get field_error_required => '이 항목은 필수 입력 사항입니다.';

  @override
  String get field_error_invalid_format => '잘못된 형식입니다';

  @override
  String get field_email_message => '유효한 이메일 주소를 입력하세요';

  @override
  String get field_nip_message => 'NIP는 정확히 10자리 숫자여야 합니다.';

  @override
  String get field_regon_message => 'REGON은 9자리 또는 14자리 숫자여야 합니다.';

  @override
  String get field_postal_code_message => '유효한 우편번호(XX-XXX)를 입력하세요.';

  @override
  String get field_hint_prefix => '입력하다 ';

  @override
  String get items_design_edit_button => '항목 편집';

  @override
  String get items_design_edit_sheet_title => '항목 편집';

  @override
  String get items_design_delete_button => '항목 삭제';

  @override
  String get items_design_change_image_hint => '이미지를 변경하려면 탭하세요.';

  @override
  String get items_design_field_title_label => '품목명';

  @override
  String get items_design_field_info_label => '간략 정보';

  @override
  String get items_design_field_info_hint => '예: 바삭하고 맛있는';

  @override
  String get items_design_field_desc_label => '설명';

  @override
  String get items_design_field_price_label => '가격(PLN)';

  @override
  String get items_design_field_price_required => '가격이 필요합니다';

  @override
  String get items_design_field_price_invalid => '유효한 숫자를 입력하세요';

  @override
  String get items_design_field_tags_label => '태그';

  @override
  String get items_design_field_tags_hint => '예: 비건';

  @override
  String get items_design_discount_label => '할인 %';

  @override
  String get items_design_discount_required => '할인율을 입력하세요';

  @override
  String get items_design_discount_invalid => '1에서 100 사이의 값을 입력하세요.';

  @override
  String get items_design_save_changes => '변경 사항 저장';

  @override
  String get items_design_saved => '항목이 성공적으로 저장되었습니다.';

  @override
  String get items_design_image_cleanup_error =>
      '이미지가 업데이트되었지만 이전 파일 정리에는 실패했습니다.';

  @override
  String get items_design_delete_dialog_title => '항목 삭제';

  @override
  String get items_design_delete_dialog_body =>
      '이 항목을 정말 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';

  @override
  String get items_design_delete_cancel => '취소';

  @override
  String get items_design_delete_confirm => '삭제';

  @override
  String get items_design_deleted => '항목이 성공적으로 삭제되었습니다.';

  @override
  String get map_fetching_address => '주소를 가져오는 중...';

  @override
  String get map_address_not_found => '주소를 찾을 수 없습니다';

  @override
  String get map_confirm_button => '주소 확인';

  @override
  String get menus_design_view_items => '상품 보기';

  @override
  String get menus_design_edit_button => '편집 메뉴';

  @override
  String get menus_design_edit_sheet_title => '편집 메뉴';

  @override
  String get menus_design_delete_button => '삭제 메뉴';

  @override
  String get menus_design_change_image_hint => '이미지를 변경하려면 탭하세요.';

  @override
  String get menus_design_field_title_label => '메뉴 제목';

  @override
  String get menus_design_field_desc_label => '설명';

  @override
  String get menus_design_field_title_required => '제목을 입력해야 합니다.';

  @override
  String get menus_design_field_desc_required => '설명이 필요합니다';

  @override
  String get menus_design_save_changes => '변경 사항 저장';

  @override
  String get menus_design_saved => '메뉴가 성공적으로 저장되었습니다';

  @override
  String get menus_design_banner_cleanup_error =>
      '배너는 업데이트되었지만, 이전 파일 정리에는 실패했습니다.';

  @override
  String get menus_design_delete_dialog_title => '삭제 메뉴';

  @override
  String get menus_design_delete_dialog_body =>
      '이 메뉴를 정말 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';

  @override
  String get menus_design_delete_cancel => '취소';

  @override
  String get menus_design_delete_confirm => '삭제';

  @override
  String get menus_design_delete_missing_id => '오류: 메뉴 또는 레스토랑 ID가 누락되었습니다';

  @override
  String get menus_design_deleted => '메뉴가 성공적으로 삭제되었습니다.';

  @override
  String get notif_sheet_title => '알림';

  @override
  String notif_unread_count(int count) {
    return '$count 읽지 않음';
  }

  @override
  String get notif_mark_all_read => '모두 읽음으로 표시';

  @override
  String get notif_empty_title => '아직 알림이 없습니다.';

  @override
  String get notif_empty_subtitle => '관리자 메시지가 여기에 표시됩니다.';

  @override
  String get notif_time_just_now => '방금';

  @override
  String notif_time_minutes(int n) {
    return '${n}m 전';
  }

  @override
  String notif_time_hours(int n) {
    return '$n시간 전';
  }

  @override
  String get notif_time_yesterday => '어제';

  @override
  String notif_time_days(int n) {
    return '$n일 전';
  }

  @override
  String get addr_use_current_location => '현재 위치 사용';

  @override
  String get addr_label_fallback => '주소';

  @override
  String get addr_translating => '번역 중...';

  @override
  String get addr_error_loading => '주소 로딩 오류';

  @override
  String addr_building(String value) {
    return '건물: $value';
  }

  @override
  String addr_flat(String value) {
    return '아파트 번호: $value';
  }

  @override
  String addr_address(String value) {
    return '주소: $value';
  }

  @override
  String get addr_see_in_maps => '지도에서 보기';

  @override
  String get addr_delete => '삭제';

  @override
  String get addr_delete_dialog_title => '주소 삭제';

  @override
  String addr_delete_dialog_body(String label) {
    return '$label을 정말로 삭제하시겠습니까?';
  }

  @override
  String get addr_delete_cancel => '취소';

  @override
  String get addr_delete_confirm => '제거하다';

  @override
  String get addr_deleted => '주소가 성공적으로 삭제되었습니다.';

  @override
  String addr_delete_error(String error) {
    return '오류: $error';
  }
}
