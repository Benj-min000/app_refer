// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get errorAddressNotFound => 'Address not Found';

  @override
  String get unknownLocation => 'Unknown Location';

  @override
  String get searchAddress => 'Search address...';

  @override
  String errorReverseGeo(Object error) {
    return 'Error reverse geocoding: $error';
  }

  @override
  String get grandLocation =>
      'Please grand the App the locdation permission...';

  @override
  String get goBack => 'Go Back';

  @override
  String get suggestedMatch => 'Suggested match';

  @override
  String get confirmContinue => 'Confirm & Continue';

  @override
  String get refreshLocation => 'Refresh Location';

  @override
  String get hintSearch => 'Find it! Delicious Dishes';

  @override
  String get tabFoodDelivery => 'Food Delivery';

  @override
  String get tabPickup => 'Pickup';

  @override
  String get tabGroceryShopping => 'Grocery';

  @override
  String get tabGifting => 'Gifting';

  @override
  String get tabBenefits => 'Benefits';

  @override
  String get categoryDiscounts => 'Discounts';

  @override
  String get categoryPork => 'Pork';

  @override
  String get categoryTonkatsuSashimi => 'Tonkatsu & Sashimi';

  @override
  String get categoryPizza => 'Pizza';

  @override
  String get categoryStew => 'Stew';

  @override
  String get categoryChinese => 'Chinese';

  @override
  String get categoryChicken => 'Chicken';

  @override
  String get categoryKorean => 'Korean';

  @override
  String get categoryOneBowl => 'One Bowl';

  @override
  String get categoryPichupDiscount => 'Pickup Discount';

  @override
  String get categoryFastFood => 'Fast Food';

  @override
  String get categoryCoffee => 'Coffee';

  @override
  String get categoryBakery => 'Bakery';

  @override
  String get categoryLunch => 'Lunch';

  @override
  String get categoryFreshProduce => 'Fresh Produce';

  @override
  String get categoryDairyEggs => 'Dairy & Eggs';

  @override
  String get categoryMeat => 'Meat';

  @override
  String get categoryBeverages => 'Beverages';

  @override
  String get categoryFrozen => 'Frozen';

  @override
  String get categorySnacks => 'Snacks';

  @override
  String get categoryHousehold => 'Household';

  @override
  String get categoryCakes => 'Cakes';

  @override
  String get categoryFlowers => 'Flowers';

  @override
  String get categoryGiftBoxes => 'Gift Boxes';

  @override
  String get categoryPartySupplies => 'Party Supplies';

  @override
  String get categoryGiftCards => 'Gift Cards';

  @override
  String get categorySpecialOccasions => 'Special Occasions';

  @override
  String get categoryDailyDeals => 'Daily Deals';

  @override
  String get categoryLoyaltyRewards => 'Loyalty Rewards';

  @override
  String get categoryCoupons => 'Coupons';

  @override
  String get categoryNewOffers => 'New Offers';

  @override
  String get categoryExclusiveDeals => 'Exclusive Deals';

  @override
  String seeMore(Object tab) {
    return 'See more in $tab';
  }

  @override
  String get searchAll => 'All';

  @override
  String get searchRestaurants => 'Restaurants';

  @override
  String get searchFood => 'Food';

  @override
  String get searchStores => 'Stores';

  @override
  String get findingLocalization => 'Finding your localization...';

  @override
  String get changeLanguage => 'Language';

  @override
  String get hintName => 'Name';

  @override
  String get hintEmail => 'Email';

  @override
  String get hintPassword => 'Password';

  @override
  String get hintConfPassword => 'Confirm Password';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get signUp => 'Sign Up';

  @override
  String get registeringAccount => 'Registering Account...';

  @override
  String get checkingCredentials => 'Checking Credentials...';

  @override
  String get errorEnterEmailOrPassword => 'Please Enter Email or Password';

  @override
  String get errorEnterRegInfo =>
      'Please Enter required information for Registration';

  @override
  String get errorSelectImage => 'Please Select an Image';

  @override
  String get errorNoMatchPasswords => 'Passwords don\'t match!';

  @override
  String get errorLoginFailed => 'Login Failed';

  @override
  String get errorNoRecordFound => 'No record found';

  @override
  String get blockedAccountMessage =>
      'Admin has blocked your account\n\nMail to: admin@gmail.com';

  @override
  String get networkUnavailable => 'Network unavailable. Please try again';

  @override
  String get errorFetchingUserData => 'Error fetching user data';

  @override
  String storageError(Object error) {
    return 'Storage Error: $error';
  }

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get welcomeMessage => 'Welcome to our app!';

  @override
  String get payment => 'Payment';

  @override
  String get checkout => 'Proceed to Checkout';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get settings => 'Settings';

  @override
  String get offers => 'Offers';

  @override
  String get whatsOnYourMind => 'What\'s on your mind?';

  @override
  String get bookDining => 'Book Dining';

  @override
  String get softDrinks => 'Soft Drinks';

  @override
  String get myCart => 'My Cart';

  @override
  String get cartCleared => 'Cart has been cleared';

  @override
  String get get_started => 'Get Started';

  @override
  String get pricing => 'Pricing';

  @override
  String get how_it_works => 'How it Works';

  @override
  String get build_user_experience =>
      'Build the best search\\nexperience for your users.';

  @override
  String get join_thousands =>
      'Join thousands of teams scaling their applications with our dashboard.';

  @override
  String get sign_in_to_dashboard => 'Sign in to Dashboard';

  @override
  String get create_your_account => 'Create your account';

  @override
  String get new_to_the_platform => 'New to the platform?';

  @override
  String get already_have_an_account => 'Already have an account?';

  @override
  String get sign_in => 'Sign in';

  @override
  String get sign_up => 'Sign up';

  @override
  String get log_in => 'Log in';

  @override
  String get or => 'OR';

  @override
  String get terms_of_service =>
      'By continuing, you agree to the Terms of Service.';

  @override
  String get with_google => 'with Google';

  @override
  String get ready_to_grow => 'Ready to grow?';

  @override
  String get join_restaurants => 'Join restaurants already on Freequick.';

  @override
  String get register_now => 'Register Now';

  @override
  String get see_how_it_works => 'See How it Works';

  @override
  String get now_live_in => 'Now live in Wrocław';

  @override
  String get put_your_restaurant_on =>
      'Put your restaurant on\\nWrocław\\\'s screens.';

  @override
  String get manage_your_menu =>
      'Manage your menu, upload custom banners, and track orders in real-time.';

  @override
  String get register_your_restaurant => 'Register Your Restaurant';

  @override
  String get orders_today => 'Orders Today';

  @override
  String get total_orders => 'Total Orders';

  @override
  String get restaurants => 'Restaurants';

  @override
  String get menu_items => 'Menu Items';

  @override
  String get restaurants_on_platform => 'Restaurants on platform';

  @override
  String get orders_placed => 'Orders placed';

  @override
  String get menus_published => 'Menus published';

  @override
  String get items_available => 'Items available';

  @override
  String get live_platform_stats => 'LIVE PLATFORM STATS';

  @override
  String get trusted_by_restaurants => 'TRUSTED BY RESTAURANTS';

  @override
  String get upper_features => 'FEATURES';

  @override
  String get sales_analytics => 'Sales Analytics';

  @override
  String get track_peak_hours => 'Track peak hours.';

  @override
  String get custom_banners => 'Custom Banners';

  @override
  String get full_creative_control => 'Full creative control.';

  @override
  String get your_menu_goes_live_instantly => 'Your menu goes live instantly.';

  @override
  String get digital_menu => 'Digital Menu';

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
  String get info_continue => 'Continue';

  @override
  String get owner_s_full_name => 'Owner\'s Full Name';

  @override
  String get owner_full_name => 'Owner\'s Full Name';

  @override
  String get owner_phone => 'Owner\'s Phone';

  @override
  String get back => 'Back';

  @override
  String get admin_overview => 'Overview';

  @override
  String get admin_join_requests => 'Join Requests';

  @override
  String get admin_users => 'Users';

  @override
  String get admin_notifications => 'Notifications';

  @override
  String get admin_panel => 'Admin Panel';

  @override
  String get admin => 'Admin';

  @override
  String get administrator => 'Administrator';

  @override
  String get sign_out => 'Sign Out';

  @override
  String get hiw_hero_badge => 'Simple. Fast. Transparent.';

  @override
  String get hiw_hero_title => 'From sign-up to\nfirst order in minutes.';

  @override
  String get hiw_hero_subtitle =>
      'Freequick is built for restaurant owners who want to focus on cooking — not managing technology.';

  @override
  String get hiw_cta_title => 'Ready to get started?';

  @override
  String get hiw_cta_subtitle => 'Join restaurants already on Freequick.';

  @override
  String get hiw_cta_primary => 'Register Your Restaurant';

  @override
  String get hiw_cta_secondary => 'See Pricing';

  @override
  String get hiw_section_process => 'THE PROCESS';

  @override
  String get hiw_section_features => 'WHAT YOU GET';

  @override
  String get hiw_features_title => 'Everything a restaurant needs.';

  @override
  String get hiw_step1_title => 'Create your account';

  @override
  String get hiw_step1_desc =>
      'Register with your restaurant details. Takes under 2 minutes. No credit card required.';

  @override
  String get hiw_step2_title => 'Set up your profile';

  @override
  String get hiw_step2_desc =>
      'Upload your logo, banner, and set your address. Your storefront goes live immediately.';

  @override
  String get hiw_step3_title => 'Build your menu';

  @override
  String get hiw_step3_desc =>
      'Add menus and items with photos, prices, and descriptions. Organise by category.';

  @override
  String get hiw_step4_title => 'Receive orders';

  @override
  String get hiw_step4_desc =>
      'Customers find you, place orders, and pay online. You see every order in real-time on your dashboard.';

  @override
  String get hiw_step5_title => 'Get paid';

  @override
  String get hiw_step5_desc =>
      'Revenue is settled to your registered bank account. You only pay a small commission per completed order.';

  @override
  String get hiw_feature1_title => 'Real-time orders';

  @override
  String get hiw_feature1_desc =>
      'Every order appears on your dashboard instantly. No refresh needed.';

  @override
  String get hiw_feature2_title => 'Sales analytics';

  @override
  String get hiw_feature2_desc =>
      'See revenue, popular items, and order trends across 7 or 30 days.';

  @override
  String get hiw_feature3_title => 'Custom branding';

  @override
  String get hiw_feature3_desc =>
      'Your logo, banner, and colours — your restaurant, your identity.';

  @override
  String get hiw_feature4_title => 'Secure payments';

  @override
  String get hiw_feature4_desc =>
      'All payments processed securely. You never handle card data.';

  @override
  String get hiw_feature5_title => 'Works everywhere';

  @override
  String get hiw_feature5_desc =>
      'Dashboard runs on desktop, tablet, and mobile. Manage from anywhere.';

  @override
  String get hiw_feature6_title => 'Dedicated support';

  @override
  String get hiw_feature6_desc =>
      'Real people available to help you get set up and stay running.';

  @override
  String get pricing_hero_badge => 'No monthly fees. Ever.';

  @override
  String get pricing_hero_title => 'Pay only when\nyou earn.';

  @override
  String get pricing_hero_subtitle =>
      'Freequick charges a small commission on completed orders only. If you don\'t earn, you don\'t pay.';

  @override
  String get pricing_cta_title => 'Start for free today.';

  @override
  String get pricing_cta_subtitle => 'No fees until your first order.';

  @override
  String get pricing_cta_primary => 'Register Your Restaurant';

  @override
  String get pricing_section_fee => 'HOW THE FEE WORKS';

  @override
  String get pricing_section_calculator => 'ESTIMATE YOUR EARNINGS';

  @override
  String get pricing_section_tiers => 'COMMISSION TIERS';

  @override
  String get pricing_section_faq => 'FREQUENTLY ASKED';

  @override
  String get pricing_calculator_title => 'See what you keep.';

  @override
  String get pricing_tiers_title => 'More orders, lower rate.';

  @override
  String get pricing_tiers_subtitle =>
      'As your restaurant grows, your commission rate goes down automatically.';

  @override
  String get pricing_faq_title => 'Common questions.';

  @override
  String get pricing_step1_title => 'Customer places an order';

  @override
  String get pricing_step1_desc =>
      'They browse your menu, add items, and pay through the app.';

  @override
  String get pricing_step2_title => 'You prepare and deliver';

  @override
  String get pricing_step2_desc =>
      'You confirm the order, prepare it, and mark it as delivered.';

  @override
  String get pricing_step3_title => 'We take a small cut';

  @override
  String get pricing_step3_desc =>
      'A commission is deducted from the order value. The rest goes to you.';

  @override
  String get pricing_slider_orders_label => 'Orders per day';

  @override
  String pricing_slider_orders_value(int count, int monthly) {
    return '$count orders/day · $monthly/month';
  }

  @override
  String get pricing_slider_avg_label => 'Average order value';

  @override
  String pricing_slider_avg_value(String amount) {
    return '$amount PLN';
  }

  @override
  String pricing_tier_badge(String tierName, String rate) {
    return '$tierName tier — $rate commission';
  }

  @override
  String pricing_tier_monthly(int count) {
    return '$count orders/month';
  }

  @override
  String get pricing_calc_revenue_label => 'Daily revenue';

  @override
  String get pricing_calc_revenue_sub => 'before commission';

  @override
  String pricing_calc_fee_label(String rate) {
    return 'Freequick fee ($rate)';
  }

  @override
  String get pricing_calc_fee_sub => 'per day';

  @override
  String get pricing_calc_keep_label => 'You keep';

  @override
  String get pricing_calc_disclaimer =>
      'Commission is only charged on completed, delivered orders.';

  @override
  String get pricing_tier_starter_label => 'Starter';

  @override
  String get pricing_tier_starter_range => '0 – 100 orders/month';

  @override
  String get pricing_tier_starter_desc => 'Get started with no upfront cost.';

  @override
  String get pricing_tier_growing_label => 'Growing';

  @override
  String get pricing_tier_growing_range => '101 – 500 orders/month';

  @override
  String get pricing_tier_growing_desc =>
      'Lower rate as you build your customer base.';

  @override
  String get pricing_tier_established_label => 'Established';

  @override
  String get pricing_tier_established_range => '501 – 1 500 orders/month';

  @override
  String get pricing_tier_established_desc =>
      'Rewarding consistent high-volume restaurants.';

  @override
  String get pricing_tier_partner_label => 'Partner';

  @override
  String get pricing_tier_partner_range => '1 500+ orders/month';

  @override
  String get pricing_tier_partner_desc =>
      'Our best rate for our highest-volume partners.';

  @override
  String get pricing_faq1_q => 'Are there any setup or monthly fees?';

  @override
  String get pricing_faq1_a =>
      'No. Freequick charges zero setup fees and zero monthly fees. You only pay commission on completed orders.';

  @override
  String get pricing_faq2_q => 'When does the commission get deducted?';

  @override
  String get pricing_faq2_a =>
      'Commission is calculated at the time an order is marked as delivered. It is deducted from your payout balance automatically.';

  @override
  String get pricing_faq3_q => 'How often do I get paid?';

  @override
  String get pricing_faq3_a =>
      'Payouts are processed weekly to your registered IBAN bank account. You can track your balance in real-time on the dashboard.';

  @override
  String get pricing_faq4_q => 'What happens if an order is cancelled?';

  @override
  String get pricing_faq4_a =>
      'Cancelled orders are not charged commission. You only pay for successful, completed deliveries.';

  @override
  String get pricing_faq5_q => 'Can I change my bank account details later?';

  @override
  String get pricing_faq5_a =>
      'Yes. You can update your IBAN at any time in the Settings section of your dashboard.';

  @override
  String get pricing_tier_name_starter => 'Starter';

  @override
  String get pricing_tier_name_growing => 'Growing';

  @override
  String get pricing_tier_name_established => 'Established';

  @override
  String get pricing_tier_name_partner => 'Partner';

  @override
  String get admin_notifications_tab_send => 'Send Notification';

  @override
  String get admin_notifications_tab_history => 'History';

  @override
  String get admin_notifications_target_audience => 'Target Audience';

  @override
  String get admin_notifications_audience_all => 'All';

  @override
  String get admin_notifications_audience_restaurants => 'Restaurants';

  @override
  String get admin_notifications_audience_specific => 'Specific';

  @override
  String get admin_notifications_audience_label_all => 'All Users';

  @override
  String get admin_notifications_audience_label_restaurants =>
      'Restaurant Owners';

  @override
  String get admin_notifications_audience_label_specific => 'Specific Users';

  @override
  String get admin_notifications_search_hint => 'Search by name or email…';

  @override
  String get admin_notifications_search_hint_more => 'Add more users…';

  @override
  String get admin_notifications_title_label => 'Notification Title';

  @override
  String get admin_notifications_title_hint => 'e.g. New feature available';

  @override
  String get admin_notifications_body_label => 'Message';

  @override
  String get admin_notifications_body_hint => 'Write the notification message…';

  @override
  String get admin_notifications_send_button => 'Send Notification';

  @override
  String get admin_notifications_sending => 'Sending…';

  @override
  String get admin_notifications_required => 'Required';

  @override
  String get admin_notifications_select_user =>
      'Please select at least one user.';

  @override
  String get admin_notifications_no_users =>
      'No users found for this audience.';

  @override
  String get admin_notifications_sent_one => 'Sent to 1 user';

  @override
  String admin_notifications_sent_many(int count) {
    return 'Sent to $count users';
  }

  @override
  String get admin_notifications_history_empty => 'No notifications sent yet';

  @override
  String get admin_notifications_history_sent_badge => 'Sent';

  @override
  String admin_notifications_history_sent_count(int count) {
    return '$count sent';
  }

  @override
  String get admin_overview_platform_glance => 'PLATFORM AT A GLANCE';

  @override
  String get admin_overview_revenue_30d => 'REVENUE (LAST 30 DAYS)';

  @override
  String get admin_overview_pending_requests => 'PENDING JOIN REQUESTS';

  @override
  String get admin_overview_view_all => 'View all';

  @override
  String get admin_overview_order_status => 'ORDER STATUS BREAKDOWN';

  @override
  String get admin_overview_top_restaurants => 'TOP RESTAURANTS BY ORDERS';

  @override
  String get admin_overview_stat_restaurants => 'Total Restaurants';

  @override
  String admin_overview_stat_restaurants_sub(int active) {
    return '$active with orders';
  }

  @override
  String get admin_overview_stat_orders => 'Total Orders';

  @override
  String admin_overview_stat_orders_sub(int count) {
    return '$count today';
  }

  @override
  String get admin_overview_stat_revenue => 'Total Revenue';

  @override
  String admin_overview_stat_revenue_sub(String amount) {
    return '$amount PLN last 7d';
  }

  @override
  String get admin_overview_stat_avg => 'Avg Order Value';

  @override
  String admin_overview_stat_avg_sub(int menus, int items) {
    return '$menus menus · $items items';
  }

  @override
  String get admin_overview_loading => '—';

  @override
  String get admin_overview_revenue_no_data => 'No revenue data yet';

  @override
  String get admin_overview_no_pending => 'No pending requests';

  @override
  String admin_overview_pending_nip(String nip, String date) {
    return 'NIP: $nip · Submitted $date';
  }

  @override
  String get admin_overview_review => 'Review';

  @override
  String get admin_overview_no_orders => 'No orders yet';

  @override
  String get admin_overview_no_order_data => 'No order data yet';

  @override
  String admin_overview_orders_count(int count) {
    return '$count orders';
  }

  @override
  String get admin_overview_status_pending => 'Pending';

  @override
  String get admin_overview_status_processing => 'Processing';

  @override
  String get admin_overview_status_delivered => 'Delivered';

  @override
  String get admin_overview_status_cancelled => 'Cancelled';

  @override
  String get requests_tab_registrations => 'Registrations';

  @override
  String get requests_tab_go_live => 'Go Live Requests';

  @override
  String get requests_filter_pending => 'Pending';

  @override
  String get requests_filter_approved => 'Approved';

  @override
  String get requests_filter_active => 'Active';

  @override
  String get requests_filter_rejected => 'Rejected';

  @override
  String get requests_filter_suspended => 'Suspended';

  @override
  String get requests_filter_all => 'All';

  @override
  String requests_empty_filtered(String filter) {
    return 'No $filter requests';
  }

  @override
  String get requests_empty_all => 'No restaurants yet';

  @override
  String get requests_go_live_empty => 'No Go Live requests yet';

  @override
  String get requests_go_live_section_pending => 'PENDING REVIEW';

  @override
  String get requests_go_live_section_reviewed => 'REVIEWED';

  @override
  String requests_go_live_requested(String timeAgo, String date) {
    return 'Requested $timeAgo · $date';
  }

  @override
  String requests_go_live_activated_on(String date) {
    return 'Activated on $date';
  }

  @override
  String requests_go_live_declined_on(String date) {
    return 'Declined on $date';
  }

  @override
  String get requests_badge_activated => 'Activated';

  @override
  String get requests_badge_declined => 'Declined';

  @override
  String get requests_badge_pending_review => 'Pending Review';

  @override
  String get requests_action_activate => 'Activate';

  @override
  String get requests_action_decline => 'Decline';

  @override
  String requests_submitted(String date) {
    return 'Submitted $date';
  }

  @override
  String get requests_status_approved => 'Approved';

  @override
  String get requests_status_active => 'Active';

  @override
  String get requests_status_rejected => 'Rejected';

  @override
  String get requests_status_suspended => 'Suspended';

  @override
  String get requests_status_pending => 'Pending';

  @override
  String get requests_action_approve => 'Approve';

  @override
  String get requests_action_reject => 'Reject';

  @override
  String get requests_action_suspend => 'Suspend';

  @override
  String get requests_action_reinstate => 'Reinstate';

  @override
  String get requests_action_copy_id => 'Copy restaurant ID';

  @override
  String requests_copied(String id) {
    return 'Copied: $id';
  }

  @override
  String get requests_confirm_approve_title => 'Approve';

  @override
  String get requests_confirm_approve_body =>
      'This will approve the restaurant and give the owner access to their dashboard.';

  @override
  String get requests_confirm_reject_title => 'Reject';

  @override
  String get requests_confirm_reject_body =>
      'This will reject the restaurant. The owner will see a rejection message when they log in.';

  @override
  String get requests_confirm_suspend_title => 'Suspend';

  @override
  String get requests_confirm_suspend_body =>
      'This will suspend the restaurant. The owner will be locked out of their dashboard immediately.';

  @override
  String get requests_confirm_reinstate_title => 'Reinstate';

  @override
  String get requests_confirm_reinstate_body =>
      'This will reinstate the restaurant to active status.';

  @override
  String get requests_confirm_cancel => 'Cancel';

  @override
  String requests_error_failed(String error) {
    return 'Failed: $error';
  }

  @override
  String requests_setup_progress(int done, int total) {
    return 'Setup: $done/$total complete';
  }

  @override
  String get requests_check_logo => 'Logo uploaded';

  @override
  String get requests_check_banner => 'Banner uploaded';

  @override
  String get requests_check_address => 'Address set';

  @override
  String get requests_check_iban => 'IBAN set';

  @override
  String get requests_check_photo => 'Profile photo';

  @override
  String get requests_check_menu => 'At least one menu';

  @override
  String get users_search_hint => 'Search by name or email…';

  @override
  String get users_filter_all => 'All';

  @override
  String get users_filter_restaurant => 'Restaurant';

  @override
  String get users_filter_admin => 'Admin';

  @override
  String get users_filter_customer => 'Customer';

  @override
  String get users_empty_filtered => 'No users match your filter';

  @override
  String get users_empty_all => 'No users yet';

  @override
  String get users_banned_badge => 'Banned';

  @override
  String users_joined(String date) {
    return 'Joined $date';
  }

  @override
  String get users_detail_title => 'User Details';

  @override
  String get users_detail_id => 'User ID';

  @override
  String get users_detail_phone => 'Phone';

  @override
  String get users_detail_joined => 'Joined';

  @override
  String get users_detail_role => 'Role';

  @override
  String get users_action_ban => 'Ban';

  @override
  String get users_action_unban => 'Unban';

  @override
  String get users_action_delete => 'Delete';

  @override
  String get users_confirm_cancel => 'Cancel';

  @override
  String get users_ban_title => 'Ban User?';

  @override
  String get users_unban_title => 'Unban User?';

  @override
  String get users_ban_body =>
      'This will prevent the user from accessing the platform.';

  @override
  String get users_unban_body => 'This will restore the user\'s access.';

  @override
  String get users_delete_title => 'Delete User?';

  @override
  String get users_delete_body =>
      'This will permanently delete the user\'s Firestore document. Their Auth account will remain unless deleted separately from Firebase Console.';

  @override
  String get users_snack_banned => 'User banned.';

  @override
  String get users_snack_unbanned => 'User unbanned.';

  @override
  String get users_snack_deleted => 'User deleted.';

  @override
  String get users_copied => 'Copied to clipboard';

  @override
  String get users_role_admin => 'Admin';

  @override
  String get users_role_restaurant => 'Restaurant';

  @override
  String get users_role_customer => 'Customer';

  @override
  String get analytics_section_glance => 'AT A GLANCE';

  @override
  String get analytics_section_revenue => 'REVENUE OVER TIME';

  @override
  String get analytics_section_status => 'ORDER STATUS BREAKDOWN';

  @override
  String get analytics_section_popular => 'MOST ORDERED ITEMS';

  @override
  String analytics_stat_revenue(int days) {
    return 'Revenue (${days}d)';
  }

  @override
  String analytics_stat_orders(int days) {
    return 'Orders (${days}d)';
  }

  @override
  String get analytics_stat_today => 'Today\'s Sales';

  @override
  String get analytics_stat_avg => 'Avg Order';

  @override
  String get analytics_no_revenue => 'No revenue data for this period';

  @override
  String get analytics_no_orders => 'No orders in this period';

  @override
  String get analytics_no_items => 'No item data for this period';

  @override
  String analytics_orders_count(int count) {
    return '$count orders';
  }

  @override
  String get analytics_status_normal => 'Normal';

  @override
  String get analytics_status_processing => 'Processing';

  @override
  String get analytics_status_delivered => 'Delivered';

  @override
  String get analytics_status_cancelled => 'Cancelled';

  @override
  String get shell_nav_overview => 'Overview';

  @override
  String get shell_nav_orders => 'Orders';

  @override
  String get shell_nav_menus => 'Menus';

  @override
  String get shell_nav_promotions => 'Promotions';

  @override
  String get shell_nav_analytics => 'Analytics';

  @override
  String get shell_nav_settings => 'Settings';

  @override
  String get shell_restaurant_not_found =>
      'Restaurant not found. Please contact support.';

  @override
  String get shell_finish_setup => 'Finish setup';

  @override
  String get shell_my_account => 'My Account';

  @override
  String get shell_live_go_offline => 'Live · Go Offline';

  @override
  String get shell_go_live_pending => 'Go Live pending review';

  @override
  String get shell_go_live_declined => 'Declined · Reapply';

  @override
  String get shell_request_go_live => 'Request Go Live';

  @override
  String get shell_already_pending =>
      'You already have a pending Go Live request.';

  @override
  String get shell_go_live_submitted =>
      'Go Live request submitted. We\'ll review it shortly.';

  @override
  String shell_error(String error) {
    return 'Error: $error';
  }

  @override
  String get shell_go_offline_title => 'Go Offline?';

  @override
  String get shell_go_offline_body =>
      'Your restaurant will be hidden from customers. You can go live again at any time.';

  @override
  String get shell_confirm_cancel => 'Cancel';

  @override
  String get shell_go_offline_confirm => 'Go Offline';

  @override
  String get shell_menu_support => 'Talk to Support';

  @override
  String get shell_menu_sales => 'Talk to Sales';

  @override
  String get shell_menu_cookies => 'Cookie Preferences';

  @override
  String get shell_menu_settings => 'Settings';

  @override
  String get shell_menu_logout => 'Log out';

  @override
  String get gate_pending_title => 'Your account is under review';

  @override
  String get gate_pending_message =>
      'We\'re reviewing your registration details. This usually takes 1-2 business days. We\'ll notify you by email once approved.';

  @override
  String get gate_rejected_title => 'Application not approved';

  @override
  String get gate_rejected_message =>
      'Unfortunately your registration was not approved. Please contact support for more information.';

  @override
  String get gate_suspended_title => 'Account suspended';

  @override
  String get gate_suspended_message =>
      'Your account has been suspended. Please contact support to resolve this.';

  @override
  String get gate_default_title => 'Access unavailable';

  @override
  String get gate_default_message => 'Please contact support.';

  @override
  String get gate_sign_out => 'Sign out';

  @override
  String overview_welcome(String name) {
    return 'Welcome back, $name 👋';
  }

  @override
  String get overview_subtitle =>
      'Here\'s what\'s happening with your restaurant today.';

  @override
  String get overview_section_glance => 'AT A GLANCE';

  @override
  String get overview_section_orders => 'RECENT ORDERS';

  @override
  String get overview_setup_title => 'Get your restaurant ready';

  @override
  String overview_setup_progress(int done, int total) {
    return '$done of $total steps completed';
  }

  @override
  String get overview_task_done => 'Done';

  @override
  String get overview_task_setup => 'Set up';

  @override
  String get overview_task_logo_title => 'Upload Restaurant Logo';

  @override
  String get overview_task_logo_desc =>
      'Customers will see your logo across the app.';

  @override
  String get overview_task_banner_title => 'Add a Banner Image';

  @override
  String get overview_task_banner_desc =>
      'A banner makes your storefront visually appealing.';

  @override
  String get overview_task_address_title => 'Set Restaurant Address';

  @override
  String get overview_task_address_desc =>
      'Let customers know where to find you.';

  @override
  String get overview_task_photo_title => 'Add a Profile Photo';

  @override
  String get overview_task_photo_desc =>
      'Put a face to your restaurant owner account.';

  @override
  String get overview_task_menu_title => 'Create a Menu & Add Items';

  @override
  String get overview_task_menu_desc =>
      'Organise your offerings into menus with dishes and prices.';

  @override
  String get overview_task_iban_title => 'Add Bank Account (IBAN)';

  @override
  String get overview_task_iban_desc =>
      'Required to receive payouts from customer orders.';

  @override
  String get overview_stat_total_orders => 'Total Orders';

  @override
  String get overview_stat_pending => 'Pending';

  @override
  String get overview_stat_completed => 'Completed';

  @override
  String get overview_stat_revenue => 'Total Revenue';

  @override
  String get overview_no_orders => 'No orders yet';

  @override
  String get overview_table_order_id => 'ORDER ID';

  @override
  String get overview_table_customer => 'CUSTOMER';

  @override
  String get overview_table_items => 'ITEMS';

  @override
  String get overview_table_status => 'STATUS';

  @override
  String get overview_table_total => 'TOTAL';

  @override
  String overview_items_count(int count) {
    return '$count item';
  }

  @override
  String overview_items_count_plural(int count) {
    return '$count items';
  }

  @override
  String get overview_time_just_now => 'Just now';

  @override
  String overview_time_minutes(int n) {
    return '${n}m ago';
  }

  @override
  String overview_time_hours(int n) {
    return '${n}h ago';
  }

  @override
  String get overview_chef_fallback => 'Chef';

  @override
  String get items_app_bar_fallback => 'Items';

  @override
  String get items_empty_title => 'No items yet';

  @override
  String get items_empty_subtitle => 'Tap + to add your first item';

  @override
  String items_error(String error) {
    return 'Error: $error';
  }

  @override
  String get items_fab => 'Add Item';

  @override
  String get items_sheet_title => 'Add Item';

  @override
  String get items_image_upload_label => 'Upload Item Image';

  @override
  String get items_image_browse => 'Click to browse';

  @override
  String get items_field_title_label => 'Item Title';

  @override
  String get items_field_title_hint => 'e.g. Pierogi Ruskie';

  @override
  String get items_field_title_required => 'Title is required';

  @override
  String get items_field_info_label => 'Short Info';

  @override
  String get items_field_info_hint => 'e.g. Crispy and Tasty';

  @override
  String get items_field_info_required => 'Info is required';

  @override
  String get items_field_desc_label => 'Description';

  @override
  String get items_field_desc_hint => 'Describe the item...';

  @override
  String get items_field_desc_required => 'Description is required';

  @override
  String get items_field_price_label => 'Price (PLN)';

  @override
  String get items_field_price_hint => 'e.g. 24.99';

  @override
  String get items_field_price_required => 'Price is required';

  @override
  String get items_field_price_invalid => 'Enter a valid number';

  @override
  String get items_field_tags_label => 'Tags';

  @override
  String get items_field_tags_hint => 'e.g. Vegan';

  @override
  String get items_tag_error_empty => 'Please enter a tag';

  @override
  String get items_tag_error_capitalize => 'First letter must be capitalized';

  @override
  String get items_tag_error_letters => 'Only letters are allowed';

  @override
  String get items_tag_error_duplicate => 'Tag already exists';

  @override
  String get items_discount_toggle => 'Apply Discount';

  @override
  String get items_discount_label => 'Discount %';

  @override
  String get items_discount_required => 'Enter a discount percentage';

  @override
  String get items_discount_invalid => 'Enter a value between 1 and 100';

  @override
  String get items_no_image => 'Please select an item image.';

  @override
  String get items_added => 'Item added successfully';

  @override
  String get items_submit => 'Add Item';

  @override
  String get menus_empty_title => 'No menus yet';

  @override
  String get menus_empty_subtitle => 'Tap + to add your first menu';

  @override
  String menus_error(String error) {
    return 'Error: $error';
  }

  @override
  String get menus_fab => 'Add Menu';

  @override
  String get menus_sheet_title => 'Add Menu';

  @override
  String get menus_image_upload_label => 'Upload Banner Image';

  @override
  String get menus_image_browse => 'Click to browse';

  @override
  String get menus_field_title_label => 'Menu Title';

  @override
  String get menus_field_title_hint => 'e.g. Lunch Specials';

  @override
  String get menus_field_title_required => 'Title is required';

  @override
  String get menus_field_desc_label => 'Description';

  @override
  String get menus_field_desc_hint => 'Briefly describe this menu...';

  @override
  String get menus_field_desc_required => 'Description is required';

  @override
  String get menus_no_image => 'Please select a banner image.';

  @override
  String get menus_created => 'Menu created successfully';

  @override
  String get menus_submit => 'Create Menu';

  @override
  String get orders_error => 'Something went wrong';

  @override
  String get orders_empty_title => 'No orders right now';

  @override
  String get orders_empty_subtitle =>
      'When customers place orders they will appear here.';

  @override
  String get orders_table_order_id => 'ORDER ID';

  @override
  String get orders_table_customer => 'CUSTOMER';

  @override
  String get orders_table_items => 'ITEMS';

  @override
  String get orders_table_status => 'STATUS';

  @override
  String get orders_table_total => 'TOTAL';

  @override
  String orders_item_count(int count) {
    return '$count item';
  }

  @override
  String orders_item_count_plural(int count) {
    return '$count items';
  }

  @override
  String get promo_not_authenticated => 'Not authenticated';

  @override
  String get promo_empty_title => 'No promotions yet';

  @override
  String get promo_empty_subtitle =>
      'Tap + to create your first promotion banner';

  @override
  String get promo_fab => 'New Promotion';

  @override
  String get promo_badge_live => 'Live';

  @override
  String get promo_badge_inactive => 'Inactive';

  @override
  String promo_items_linked(int count) {
    return '$count item';
  }

  @override
  String promo_items_linked_plural(int count) {
    return '$count items';
  }

  @override
  String get promo_edit_button => 'Edit';

  @override
  String get promo_sheet_add_title => 'New Promotion';

  @override
  String get promo_sheet_edit_title => 'Edit Promotion';

  @override
  String get promo_sheet_delete_button => 'Delete';

  @override
  String get promo_image_change_hint => 'Tap to change banner';

  @override
  String get promo_image_upload_hint => 'Tap to upload banner image';

  @override
  String get promo_image_upload_label => 'Upload Banner Image';

  @override
  String get promo_image_recommended => 'Recommended: 1200×400px';

  @override
  String get promo_field_title_label => 'Promotion Title';

  @override
  String get promo_field_title_hint => 'e.g. Weekend Discount';

  @override
  String get promo_field_title_required => 'Title is required';

  @override
  String get promo_field_desc_label => 'Description';

  @override
  String get promo_field_desc_hint =>
      'e.g. Up to 30% off all mains this weekend';

  @override
  String get promo_field_desc_required => 'Description is required';

  @override
  String get promo_date_start => 'Start Date';

  @override
  String get promo_date_end => 'End Date';

  @override
  String get promo_date_pick => 'Pick date';

  @override
  String get promo_active_toggle => 'Promotion Active';

  @override
  String get promo_link_section_label => 'Link Discounted Items';

  @override
  String get promo_link_section_hint =>
      'Optional — select items this promotion applies to';

  @override
  String get promo_link_no_items =>
      'No items found. Add items to your menus first.';

  @override
  String get promo_save_changes => 'Save Changes';

  @override
  String get promo_create => 'Create Promotion';

  @override
  String get promo_no_dates => 'Please set both start and end dates.';

  @override
  String get promo_date_order_error => 'End date must be after start date.';

  @override
  String get promo_no_image => 'Please select a banner image.';

  @override
  String get promo_updated => 'Promotion updated successfully';

  @override
  String get promo_created => 'Promotion created successfully';

  @override
  String get promo_banner_cleanup_error =>
      'Banner updated, but cleanup of old file failed.';

  @override
  String get promo_delete_title => 'Delete Promotion?';

  @override
  String get promo_delete_body =>
      'This will permanently delete the promotion and its banner. This cannot be undone.';

  @override
  String get promo_delete_cancel => 'Cancel';

  @override
  String get promo_delete_confirm => 'Delete';

  @override
  String get promo_deleted => 'Promotion deleted.';

  @override
  String get promo_location_dialog_title => 'Restaurant Location';

  @override
  String get promo_location_none => 'No location selected yet';

  @override
  String get promo_location_open_map => 'Open Map';

  @override
  String get promo_location_change_map => 'Change on Map';

  @override
  String get promo_location_confirm => 'Confirm Address';

  @override
  String get promo_location_no_pick =>
      'Please pick a location on the map first.';

  @override
  String get settings_section_business => 'Business';

  @override
  String get settings_section_business_sub =>
      'Manage your restaurant profile and media';

  @override
  String get settings_section_profile => 'User Profile';

  @override
  String get settings_section_profile_sub =>
      'Update your personal account details';

  @override
  String get settings_section_danger => 'Danger Zone';

  @override
  String get settings_section_danger_sub =>
      'Irreversible actions for your account';

  @override
  String get settings_logo_title => 'Restaurant Logo';

  @override
  String get settings_logo_status_staged => 'New logo ready';

  @override
  String get settings_logo_status_exists => 'Logo uploaded';

  @override
  String get settings_logo_status_none => 'No logo yet';

  @override
  String get settings_logo_recommended => 'Recommended: 512×512px, PNG or JPG';

  @override
  String get settings_logo_choose => 'Choose';

  @override
  String get settings_logo_upload => 'Upload';

  @override
  String get settings_logo_uploading => 'Uploading…';

  @override
  String get settings_logo_success => 'Logo updated';

  @override
  String get settings_banner_title => 'Restaurant Banner';

  @override
  String get settings_banner_choose => 'Click to choose banner';

  @override
  String get settings_banner_recommended => 'Recommended: 1200×800px';

  @override
  String get settings_banner_upload => 'Upload Banner';

  @override
  String get settings_banner_uploading => 'Uploading…';

  @override
  String get settings_banner_success => 'Banner updated';

  @override
  String get settings_business_title => 'Business Info';

  @override
  String get settings_business_saved => 'Business info saved';

  @override
  String get settings_address_set => 'Set restaurant address';

  @override
  String get settings_address_change => 'Change';

  @override
  String get settings_address_pick => 'Pick on map';

  @override
  String get settings_profile_title => 'Profile';

  @override
  String get settings_profile_photo_ready =>
      'New photo ready — press Save to apply';

  @override
  String get settings_profile_saved => 'Profile saved';

  @override
  String get settings_profile_name_hint => 'Owner\'s Name';

  @override
  String get settings_profile_phone_label => 'Phone Number';

  @override
  String get settings_danger_reset_title => 'Change Password';

  @override
  String get settings_danger_reset_sub =>
      'Send a password reset email to your account';

  @override
  String get settings_danger_reset_button => 'Reset';

  @override
  String get settings_danger_reset_sent => 'Password reset email sent';

  @override
  String get settings_danger_delete_title => 'Delete Account';

  @override
  String get settings_danger_delete_sub =>
      'Permanently delete your restaurant and all data';

  @override
  String get settings_danger_delete_button => 'Delete';

  @override
  String get settings_danger_delete_dialog_title => 'Delete Account';

  @override
  String get settings_danger_delete_dialog_body =>
      'This will permanently delete your account and all restaurant data. This cannot be undone.';

  @override
  String get settings_cancel => 'Cancel';

  @override
  String get settings_error => 'Something went wrong';

  @override
  String get settings_save_changes => 'Save Changes';

  @override
  String get settings_map_dialog_title => 'Restaurant Location';

  @override
  String get settings_map_no_location => 'No location selected yet';

  @override
  String get settings_map_open => 'Open Map';

  @override
  String get settings_map_change => 'Change on Map';

  @override
  String get settings_map_confirm => 'Confirm Address';

  @override
  String get settings_map_no_pick => 'Please pick a location on the map first.';

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
  String get field_error_required => 'This field is required';

  @override
  String get field_error_invalid_format => 'Invalid format';

  @override
  String get field_email_message => 'Enter a valid email address';

  @override
  String get field_nip_message => 'NIP must be exactly 10 digits';

  @override
  String get field_regon_message => 'REGON must be 9 or 14 digits';

  @override
  String get field_postal_code_message => 'Enter a valid postal code (XX-XXX)';

  @override
  String get field_hint_prefix => 'Enter ';

  @override
  String get items_design_edit_button => 'Edit Item';

  @override
  String get items_design_edit_sheet_title => 'Edit Item';

  @override
  String get items_design_delete_button => 'Delete Item';

  @override
  String get items_design_change_image_hint => 'Tap to change image';

  @override
  String get items_design_field_title_label => 'Item Title';

  @override
  String get items_design_field_info_label => 'Short Info';

  @override
  String get items_design_field_info_hint => 'e.g. Crispy and Tasty';

  @override
  String get items_design_field_desc_label => 'Description';

  @override
  String get items_design_field_price_label => 'Price (PLN)';

  @override
  String get items_design_field_price_required => 'Price is required';

  @override
  String get items_design_field_price_invalid => 'Enter a valid number';

  @override
  String get items_design_field_tags_label => 'Tags';

  @override
  String get items_design_field_tags_hint => 'e.g. Vegan';

  @override
  String get items_design_discount_label => 'Discount %';

  @override
  String get items_design_discount_required => 'Enter a discount percentage';

  @override
  String get items_design_discount_invalid => 'Enter a value between 1 and 100';

  @override
  String get items_design_save_changes => 'Save Changes';

  @override
  String get items_design_saved => 'Item saved successfully';

  @override
  String get items_design_image_cleanup_error =>
      'Image updated, but cleanup of old file failed.';

  @override
  String get items_design_delete_dialog_title => 'Delete Item';

  @override
  String get items_design_delete_dialog_body =>
      'Are you sure you want to delete this item? This cannot be undone.';

  @override
  String get items_design_delete_cancel => 'Cancel';

  @override
  String get items_design_delete_confirm => 'Delete';

  @override
  String get items_design_deleted => 'Item deleted successfully';

  @override
  String get map_fetching_address => 'Fetching address...';

  @override
  String get map_address_not_found => 'Couldn\'t find the address';

  @override
  String get map_confirm_button => 'CONFIRM ADDRESS';

  @override
  String get menus_design_view_items => 'View Items';

  @override
  String get menus_design_edit_button => 'Edit Menu';

  @override
  String get menus_design_edit_sheet_title => 'Edit Menu';

  @override
  String get menus_design_delete_button => 'Delete Menu';

  @override
  String get menus_design_change_image_hint => 'Tap to change image';

  @override
  String get menus_design_field_title_label => 'Menu Title';

  @override
  String get menus_design_field_desc_label => 'Description';

  @override
  String get menus_design_field_title_required => 'Title is required';

  @override
  String get menus_design_field_desc_required => 'Description is required';

  @override
  String get menus_design_save_changes => 'Save Changes';

  @override
  String get menus_design_saved => 'Menu saved successfully';

  @override
  String get menus_design_banner_cleanup_error =>
      'Banner updated, but cleanup of old file failed.';

  @override
  String get menus_design_delete_dialog_title => 'Delete Menu';

  @override
  String get menus_design_delete_dialog_body =>
      'Are you sure you want to delete this menu? This cannot be undone.';

  @override
  String get menus_design_delete_cancel => 'Cancel';

  @override
  String get menus_design_delete_confirm => 'Delete';

  @override
  String get menus_design_delete_missing_id =>
      'Error: Missing Menu or Restaurant ID';

  @override
  String get menus_design_deleted => 'Menu deleted successfully';

  @override
  String get notif_sheet_title => 'Notifications';

  @override
  String notif_unread_count(int count) {
    return '$count unread';
  }

  @override
  String get notif_mark_all_read => 'Mark all read';

  @override
  String get notif_empty_title => 'No notifications yet';

  @override
  String get notif_empty_subtitle => 'Admin messages will appear here';

  @override
  String get notif_time_just_now => 'Just now';

  @override
  String notif_time_minutes(int n) {
    return '${n}m ago';
  }

  @override
  String notif_time_hours(int n) {
    return '${n}h ago';
  }

  @override
  String get notif_time_yesterday => 'Yesterday';

  @override
  String notif_time_days(int n) {
    return '${n}d ago';
  }

  @override
  String get addr_use_current_location => 'Use Current Location';

  @override
  String get addr_label_fallback => 'Address';

  @override
  String get addr_translating => 'Translating...';

  @override
  String get addr_error_loading => 'Error loading address';

  @override
  String addr_building(String value) {
    return 'Building: $value';
  }

  @override
  String addr_flat(String value) {
    return 'Flat Number: $value';
  }

  @override
  String addr_address(String value) {
    return 'Address: $value';
  }

  @override
  String get addr_see_in_maps => 'See in Maps';

  @override
  String get addr_delete => 'Delete';

  @override
  String get addr_delete_dialog_title => 'Remove Address';

  @override
  String addr_delete_dialog_body(String label) {
    return 'Are you sure you want to remove $label?';
  }

  @override
  String get addr_delete_cancel => 'Cancel';

  @override
  String get addr_delete_confirm => 'Remove';

  @override
  String get addr_deleted => 'Address deleted successfully';

  @override
  String addr_delete_error(String error) {
    return 'Error: $error';
  }
}
