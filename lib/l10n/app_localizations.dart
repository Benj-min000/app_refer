import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('ko'),
    Locale('pl'),
    Locale('uk')
  ];

  /// No description provided for @errorAddressNotFound.
  ///
  /// In en, this message translates to:
  /// **'Address not Found'**
  String get errorAddressNotFound;

  /// No description provided for @unknownLocation.
  ///
  /// In en, this message translates to:
  /// **'Unknown Location'**
  String get unknownLocation;

  /// No description provided for @searchAddress.
  ///
  /// In en, this message translates to:
  /// **'Search address...'**
  String get searchAddress;

  /// No description provided for @errorReverseGeo.
  ///
  /// In en, this message translates to:
  /// **'Error reverse geocoding: {error}'**
  String errorReverseGeo(Object error);

  /// No description provided for @grandLocation.
  ///
  /// In en, this message translates to:
  /// **'Please grand the App the locdation permission...'**
  String get grandLocation;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @suggestedMatch.
  ///
  /// In en, this message translates to:
  /// **'Suggested match'**
  String get suggestedMatch;

  /// No description provided for @confirmContinue.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Continue'**
  String get confirmContinue;

  /// No description provided for @refreshLocation.
  ///
  /// In en, this message translates to:
  /// **'Refresh Location'**
  String get refreshLocation;

  /// Placeholder text for the search bar
  ///
  /// In en, this message translates to:
  /// **'Find it! Delicious Dishes'**
  String get hintSearch;

  /// Tab label for food delivery section
  ///
  /// In en, this message translates to:
  /// **'Food Delivery'**
  String get tabFoodDelivery;

  /// Tab label for pickup orders section
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get tabPickup;

  /// Tab label for grocery shopping section
  ///
  /// In en, this message translates to:
  /// **'Grocery'**
  String get tabGroceryShopping;

  /// Tab label for gift shopping section
  ///
  /// In en, this message translates to:
  /// **'Gifting'**
  String get tabGifting;

  /// Tab label for benefits and rewards section
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get tabBenefits;

  /// Category for discounted items
  ///
  /// In en, this message translates to:
  /// **'Discounts'**
  String get categoryDiscounts;

  /// Category for pork dishes
  ///
  /// In en, this message translates to:
  /// **'Pork'**
  String get categoryPork;

  /// Category for Japanese tonkatsu and sashimi
  ///
  /// In en, this message translates to:
  /// **'Tonkatsu & Sashimi'**
  String get categoryTonkatsuSashimi;

  /// Category for pizza
  ///
  /// In en, this message translates to:
  /// **'Pizza'**
  String get categoryPizza;

  /// Category for stew dishes
  ///
  /// In en, this message translates to:
  /// **'Stew'**
  String get categoryStew;

  /// Category for Chinese cuisine
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get categoryChinese;

  /// Category for chicken dishes
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get categoryChicken;

  /// Category for Korean cuisine
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get categoryKorean;

  /// Category for single bowl meals
  ///
  /// In en, this message translates to:
  /// **'One Bowl'**
  String get categoryOneBowl;

  /// Category for pickup order discounts
  ///
  /// In en, this message translates to:
  /// **'Pickup Discount'**
  String get categoryPichupDiscount;

  /// Category for fast food restaurants
  ///
  /// In en, this message translates to:
  /// **'Fast Food'**
  String get categoryFastFood;

  /// Category for coffee shops
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get categoryCoffee;

  /// Category for bakery items
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get categoryBakery;

  /// Category for lunch meals
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get categoryLunch;

  /// Category for fresh fruits and vegetables
  ///
  /// In en, this message translates to:
  /// **'Fresh Produce'**
  String get categoryFreshProduce;

  /// Category for dairy products and eggs
  ///
  /// In en, this message translates to:
  /// **'Dairy & Eggs'**
  String get categoryDairyEggs;

  /// Category for meat products
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get categoryMeat;

  /// Category for drinks and beverages
  ///
  /// In en, this message translates to:
  /// **'Beverages'**
  String get categoryBeverages;

  /// Category for frozen foods
  ///
  /// In en, this message translates to:
  /// **'Frozen'**
  String get categoryFrozen;

  /// Category for snack foods
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get categorySnacks;

  /// Category for household items and supplies
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get categoryHousehold;

  /// Category for cakes and pastries
  ///
  /// In en, this message translates to:
  /// **'Cakes'**
  String get categoryCakes;

  /// Category for flower arrangements
  ///
  /// In en, this message translates to:
  /// **'Flowers'**
  String get categoryFlowers;

  /// Category for pre-made gift boxes
  ///
  /// In en, this message translates to:
  /// **'Gift Boxes'**
  String get categoryGiftBoxes;

  /// Category for party decorations and supplies
  ///
  /// In en, this message translates to:
  /// **'Party Supplies'**
  String get categoryPartySupplies;

  /// Category for digital and physical gift cards
  ///
  /// In en, this message translates to:
  /// **'Gift Cards'**
  String get categoryGiftCards;

  /// Category for special occasion gifts
  ///
  /// In en, this message translates to:
  /// **'Special Occasions'**
  String get categorySpecialOccasions;

  /// Category for daily special offers
  ///
  /// In en, this message translates to:
  /// **'Daily Deals'**
  String get categoryDailyDeals;

  /// Category for loyalty program rewards
  ///
  /// In en, this message translates to:
  /// **'Loyalty Rewards'**
  String get categoryLoyaltyRewards;

  /// Category for available coupons
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get categoryCoupons;

  /// Category for newly added offers
  ///
  /// In en, this message translates to:
  /// **'New Offers'**
  String get categoryNewOffers;

  /// Category for exclusive member deals
  ///
  /// In en, this message translates to:
  /// **'Exclusive Deals'**
  String get categoryExclusiveDeals;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See more in {tab}'**
  String seeMore(Object tab);

  /// No description provided for @searchAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get searchAll;

  /// No description provided for @searchRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get searchRestaurants;

  /// No description provided for @searchFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get searchFood;

  /// No description provided for @searchStores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get searchStores;

  /// Text shown while app detects location
  ///
  /// In en, this message translates to:
  /// **'Finding your localization...'**
  String get findingLocalization;

  ///
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get changeLanguage;

  /// Placeholder for name input field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get hintName;

  /// Placeholder for email input field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get hintEmail;

  /// Placeholder for password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get hintPassword;

  /// Placeholder for confirm password input field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get hintConfPassword;

  /// Button text for login
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Button text for register
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Button text for signing up
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Status text while registering account
  ///
  /// In en, this message translates to:
  /// **'Registering Account...'**
  String get registeringAccount;

  /// Status text while checking login credentials
  ///
  /// In en, this message translates to:
  /// **'Checking Credentials...'**
  String get checkingCredentials;

  /// Error when email or password is missing
  ///
  /// In en, this message translates to:
  /// **'Please Enter Email or Password'**
  String get errorEnterEmailOrPassword;

  /// Error when registration info is incomplete
  ///
  /// In en, this message translates to:
  /// **'Please Enter required information for Registration'**
  String get errorEnterRegInfo;

  /// Error when no image is selected
  ///
  /// In en, this message translates to:
  /// **'Please Select an Image'**
  String get errorSelectImage;

  /// Error when passwords do not match
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match!'**
  String get errorNoMatchPasswords;

  /// Error when login fails
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get errorLoginFailed;

  /// Error when no database record is found
  ///
  /// In en, this message translates to:
  /// **'No record found'**
  String get errorNoRecordFound;

  /// Message shown when account is blocked
  ///
  /// In en, this message translates to:
  /// **'Admin has blocked your account\n\nMail to: admin@gmail.com'**
  String get blockedAccountMessage;

  /// Error when network is unavailable
  ///
  /// In en, this message translates to:
  /// **'Network unavailable. Please try again'**
  String get networkUnavailable;

  /// Error when fetching user data fails
  ///
  /// In en, this message translates to:
  /// **'Error fetching user data'**
  String get errorFetchingUserData;

  /// Error dialog when storage fails
  ///
  /// In en, this message translates to:
  /// **'Storage Error: {error}'**
  String storageError(Object error);

  /// Generic hello world text
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// Welcome message on home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to our app!'**
  String get welcomeMessage;

  /// Label for payment section
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// Button label for checkout
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get checkout;

  /// Label for total amount
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// Label for order summary section
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// Label for settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for offers section
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers;

  /// Section heading for user thoughts or suggestions
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get whatsOnYourMind;

  /// Button to book dining / table
  ///
  /// In en, this message translates to:
  /// **'Book Dining'**
  String get bookDining;

  /// Label for soft drinks
  ///
  /// In en, this message translates to:
  /// **'Soft Drinks'**
  String get softDrinks;

  /// No description provided for @myCart.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get myCart;

  /// No description provided for @cartCleared.
  ///
  /// In en, this message translates to:
  /// **'Cart has been cleared'**
  String get cartCleared;

  /// No description provided for @get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get get_started;

  /// No description provided for @pricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricing;

  /// No description provided for @how_it_works.
  ///
  /// In en, this message translates to:
  /// **'How it Works'**
  String get how_it_works;

  /// No description provided for @build_user_experience.
  ///
  /// In en, this message translates to:
  /// **'Build the best search\\nexperience for your users.'**
  String get build_user_experience;

  /// No description provided for @join_thousands.
  ///
  /// In en, this message translates to:
  /// **'Join thousands of teams scaling their applications with our dashboard.'**
  String get join_thousands;

  /// No description provided for @sign_in_to_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Sign in to Dashboard'**
  String get sign_in_to_dashboard;

  /// No description provided for @create_your_account.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get create_your_account;

  /// No description provided for @new_to_the_platform.
  ///
  /// In en, this message translates to:
  /// **'New to the platform?'**
  String get new_to_the_platform;

  /// No description provided for @already_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get already_have_an_account;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get sign_in;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get sign_up;

  /// No description provided for @log_in.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get log_in;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @terms_of_service.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to the Terms of Service.'**
  String get terms_of_service;

  /// No description provided for @with_google.
  ///
  /// In en, this message translates to:
  /// **'with Google'**
  String get with_google;

  /// No description provided for @ready_to_grow.
  ///
  /// In en, this message translates to:
  /// **'Ready to grow?'**
  String get ready_to_grow;

  /// No description provided for @join_restaurants.
  ///
  /// In en, this message translates to:
  /// **'Join restaurants already on Freequick.'**
  String get join_restaurants;

  /// No description provided for @register_now.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get register_now;

  /// No description provided for @see_how_it_works.
  ///
  /// In en, this message translates to:
  /// **'See How it Works'**
  String get see_how_it_works;

  /// No description provided for @now_live_in.
  ///
  /// In en, this message translates to:
  /// **'Now live in Wrocław'**
  String get now_live_in;

  /// No description provided for @put_your_restaurant_on.
  ///
  /// In en, this message translates to:
  /// **'Put your restaurant on\\nWrocław\\\'s screens.'**
  String get put_your_restaurant_on;

  /// No description provided for @manage_your_menu.
  ///
  /// In en, this message translates to:
  /// **'Manage your menu, upload custom banners, and track orders in real-time.'**
  String get manage_your_menu;

  /// No description provided for @register_your_restaurant.
  ///
  /// In en, this message translates to:
  /// **'Register Your Restaurant'**
  String get register_your_restaurant;

  /// No description provided for @orders_today.
  ///
  /// In en, this message translates to:
  /// **'Orders Today'**
  String get orders_today;

  /// No description provided for @total_orders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get total_orders;

  /// No description provided for @restaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get restaurants;

  /// No description provided for @menu_items.
  ///
  /// In en, this message translates to:
  /// **'Menu Items'**
  String get menu_items;

  /// No description provided for @restaurants_on_platform.
  ///
  /// In en, this message translates to:
  /// **'Restaurants on platform'**
  String get restaurants_on_platform;

  /// No description provided for @orders_placed.
  ///
  /// In en, this message translates to:
  /// **'Orders placed'**
  String get orders_placed;

  /// No description provided for @menus_published.
  ///
  /// In en, this message translates to:
  /// **'Menus published'**
  String get menus_published;

  /// No description provided for @items_available.
  ///
  /// In en, this message translates to:
  /// **'Items available'**
  String get items_available;

  /// No description provided for @live_platform_stats.
  ///
  /// In en, this message translates to:
  /// **'LIVE PLATFORM STATS'**
  String get live_platform_stats;

  /// No description provided for @trusted_by_restaurants.
  ///
  /// In en, this message translates to:
  /// **'TRUSTED BY RESTAURANTS'**
  String get trusted_by_restaurants;

  /// No description provided for @upper_features.
  ///
  /// In en, this message translates to:
  /// **'FEATURES'**
  String get upper_features;

  /// No description provided for @sales_analytics.
  ///
  /// In en, this message translates to:
  /// **'Sales Analytics'**
  String get sales_analytics;

  /// No description provided for @track_peak_hours.
  ///
  /// In en, this message translates to:
  /// **'Track peak hours.'**
  String get track_peak_hours;

  /// No description provided for @custom_banners.
  ///
  /// In en, this message translates to:
  /// **'Custom Banners'**
  String get custom_banners;

  /// No description provided for @full_creative_control.
  ///
  /// In en, this message translates to:
  /// **'Full creative control.'**
  String get full_creative_control;

  /// No description provided for @your_menu_goes_live_instantly.
  ///
  /// In en, this message translates to:
  /// **'Your menu goes live instantly.'**
  String get your_menu_goes_live_instantly;

  /// No description provided for @digital_menu.
  ///
  /// In en, this message translates to:
  /// **'Digital Menu'**
  String get digital_menu;

  /// No description provided for @error_no_user_record_found.
  ///
  /// In en, this message translates to:
  /// **'No user record found.'**
  String get error_no_user_record_found;

  /// No description provided for @permission_restaurant_accounts_only.
  ///
  /// In en, this message translates to:
  /// **'This app is for restaurant accounts only.'**
  String get permission_restaurant_accounts_only;

  /// No description provided for @error_no_restaurant_record_found.
  ///
  /// In en, this message translates to:
  /// **'No restaurant record found. Please contact support.'**
  String get error_no_restaurant_record_found;

  /// No description provided for @creating_partner_account.
  ///
  /// In en, this message translates to:
  /// **'Creating Partner Account...'**
  String get creating_partner_account;

  /// No description provided for @account_is_pending_approval.
  ///
  /// In en, this message translates to:
  /// **'Your account is pending approval. Please sign in once verified.'**
  String get account_is_pending_approval;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @admin_profile.
  ///
  /// In en, this message translates to:
  /// **'Admin Profile'**
  String get admin_profile;

  /// No description provided for @business_name.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get business_name;

  /// No description provided for @business_phone.
  ///
  /// In en, this message translates to:
  /// **'Business Phone'**
  String get business_phone;

  /// No description provided for @info_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get info_continue;

  /// No description provided for @owner_s_full_name.
  ///
  /// In en, this message translates to:
  /// **'Owner\'s Full Name'**
  String get owner_s_full_name;

  /// No description provided for @owner_full_name.
  ///
  /// In en, this message translates to:
  /// **'Owner\'s Full Name'**
  String get owner_full_name;

  /// No description provided for @owner_phone.
  ///
  /// In en, this message translates to:
  /// **'Owner\'s Phone'**
  String get owner_phone;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @admin_overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get admin_overview;

  /// No description provided for @admin_join_requests.
  ///
  /// In en, this message translates to:
  /// **'Join Requests'**
  String get admin_join_requests;

  /// No description provided for @admin_users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get admin_users;

  /// No description provided for @admin_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get admin_notifications;

  /// No description provided for @admin_panel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get admin_panel;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get sign_out;

  /// No description provided for @hiw_hero_badge.
  ///
  /// In en, this message translates to:
  /// **'Simple. Fast. Transparent.'**
  String get hiw_hero_badge;

  /// No description provided for @hiw_hero_title.
  ///
  /// In en, this message translates to:
  /// **'From sign-up to\nfirst order in minutes.'**
  String get hiw_hero_title;

  /// No description provided for @hiw_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Freequick is built for restaurant owners who want to focus on cooking — not managing technology.'**
  String get hiw_hero_subtitle;

  /// No description provided for @hiw_cta_title.
  ///
  /// In en, this message translates to:
  /// **'Ready to get started?'**
  String get hiw_cta_title;

  /// No description provided for @hiw_cta_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Join restaurants already on Freequick.'**
  String get hiw_cta_subtitle;

  /// No description provided for @hiw_cta_primary.
  ///
  /// In en, this message translates to:
  /// **'Register Your Restaurant'**
  String get hiw_cta_primary;

  /// No description provided for @hiw_cta_secondary.
  ///
  /// In en, this message translates to:
  /// **'See Pricing'**
  String get hiw_cta_secondary;

  /// No description provided for @hiw_section_process.
  ///
  /// In en, this message translates to:
  /// **'THE PROCESS'**
  String get hiw_section_process;

  /// No description provided for @hiw_section_features.
  ///
  /// In en, this message translates to:
  /// **'WHAT YOU GET'**
  String get hiw_section_features;

  /// No description provided for @hiw_features_title.
  ///
  /// In en, this message translates to:
  /// **'Everything a restaurant needs.'**
  String get hiw_features_title;

  /// No description provided for @hiw_step1_title.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get hiw_step1_title;

  /// No description provided for @hiw_step1_desc.
  ///
  /// In en, this message translates to:
  /// **'Register with your restaurant details. Takes under 2 minutes. No credit card required.'**
  String get hiw_step1_desc;

  /// No description provided for @hiw_step2_title.
  ///
  /// In en, this message translates to:
  /// **'Set up your profile'**
  String get hiw_step2_title;

  /// No description provided for @hiw_step2_desc.
  ///
  /// In en, this message translates to:
  /// **'Upload your logo, banner, and set your address. Your storefront goes live immediately.'**
  String get hiw_step2_desc;

  /// No description provided for @hiw_step3_title.
  ///
  /// In en, this message translates to:
  /// **'Build your menu'**
  String get hiw_step3_title;

  /// No description provided for @hiw_step3_desc.
  ///
  /// In en, this message translates to:
  /// **'Add menus and items with photos, prices, and descriptions. Organise by category.'**
  String get hiw_step3_desc;

  /// No description provided for @hiw_step4_title.
  ///
  /// In en, this message translates to:
  /// **'Receive orders'**
  String get hiw_step4_title;

  /// No description provided for @hiw_step4_desc.
  ///
  /// In en, this message translates to:
  /// **'Customers find you, place orders, and pay online. You see every order in real-time on your dashboard.'**
  String get hiw_step4_desc;

  /// No description provided for @hiw_step5_title.
  ///
  /// In en, this message translates to:
  /// **'Get paid'**
  String get hiw_step5_title;

  /// No description provided for @hiw_step5_desc.
  ///
  /// In en, this message translates to:
  /// **'Revenue is settled to your registered bank account. You only pay a small commission per completed order.'**
  String get hiw_step5_desc;

  /// No description provided for @hiw_feature1_title.
  ///
  /// In en, this message translates to:
  /// **'Real-time orders'**
  String get hiw_feature1_title;

  /// No description provided for @hiw_feature1_desc.
  ///
  /// In en, this message translates to:
  /// **'Every order appears on your dashboard instantly. No refresh needed.'**
  String get hiw_feature1_desc;

  /// No description provided for @hiw_feature2_title.
  ///
  /// In en, this message translates to:
  /// **'Sales analytics'**
  String get hiw_feature2_title;

  /// No description provided for @hiw_feature2_desc.
  ///
  /// In en, this message translates to:
  /// **'See revenue, popular items, and order trends across 7 or 30 days.'**
  String get hiw_feature2_desc;

  /// No description provided for @hiw_feature3_title.
  ///
  /// In en, this message translates to:
  /// **'Custom branding'**
  String get hiw_feature3_title;

  /// No description provided for @hiw_feature3_desc.
  ///
  /// In en, this message translates to:
  /// **'Your logo, banner, and colours — your restaurant, your identity.'**
  String get hiw_feature3_desc;

  /// No description provided for @hiw_feature4_title.
  ///
  /// In en, this message translates to:
  /// **'Secure payments'**
  String get hiw_feature4_title;

  /// No description provided for @hiw_feature4_desc.
  ///
  /// In en, this message translates to:
  /// **'All payments processed securely. You never handle card data.'**
  String get hiw_feature4_desc;

  /// No description provided for @hiw_feature5_title.
  ///
  /// In en, this message translates to:
  /// **'Works everywhere'**
  String get hiw_feature5_title;

  /// No description provided for @hiw_feature5_desc.
  ///
  /// In en, this message translates to:
  /// **'Dashboard runs on desktop, tablet, and mobile. Manage from anywhere.'**
  String get hiw_feature5_desc;

  /// No description provided for @hiw_feature6_title.
  ///
  /// In en, this message translates to:
  /// **'Dedicated support'**
  String get hiw_feature6_title;

  /// No description provided for @hiw_feature6_desc.
  ///
  /// In en, this message translates to:
  /// **'Real people available to help you get set up and stay running.'**
  String get hiw_feature6_desc;

  /// No description provided for @pricing_hero_badge.
  ///
  /// In en, this message translates to:
  /// **'No monthly fees. Ever.'**
  String get pricing_hero_badge;

  /// No description provided for @pricing_hero_title.
  ///
  /// In en, this message translates to:
  /// **'Pay only when\nyou earn.'**
  String get pricing_hero_title;

  /// No description provided for @pricing_hero_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Freequick charges a small commission on completed orders only. If you don\'t earn, you don\'t pay.'**
  String get pricing_hero_subtitle;

  /// No description provided for @pricing_cta_title.
  ///
  /// In en, this message translates to:
  /// **'Start for free today.'**
  String get pricing_cta_title;

  /// No description provided for @pricing_cta_subtitle.
  ///
  /// In en, this message translates to:
  /// **'No fees until your first order.'**
  String get pricing_cta_subtitle;

  /// No description provided for @pricing_cta_primary.
  ///
  /// In en, this message translates to:
  /// **'Register Your Restaurant'**
  String get pricing_cta_primary;

  /// No description provided for @pricing_section_fee.
  ///
  /// In en, this message translates to:
  /// **'HOW THE FEE WORKS'**
  String get pricing_section_fee;

  /// No description provided for @pricing_section_calculator.
  ///
  /// In en, this message translates to:
  /// **'ESTIMATE YOUR EARNINGS'**
  String get pricing_section_calculator;

  /// No description provided for @pricing_section_tiers.
  ///
  /// In en, this message translates to:
  /// **'COMMISSION TIERS'**
  String get pricing_section_tiers;

  /// No description provided for @pricing_section_faq.
  ///
  /// In en, this message translates to:
  /// **'FREQUENTLY ASKED'**
  String get pricing_section_faq;

  /// No description provided for @pricing_calculator_title.
  ///
  /// In en, this message translates to:
  /// **'See what you keep.'**
  String get pricing_calculator_title;

  /// No description provided for @pricing_tiers_title.
  ///
  /// In en, this message translates to:
  /// **'More orders, lower rate.'**
  String get pricing_tiers_title;

  /// No description provided for @pricing_tiers_subtitle.
  ///
  /// In en, this message translates to:
  /// **'As your restaurant grows, your commission rate goes down automatically.'**
  String get pricing_tiers_subtitle;

  /// No description provided for @pricing_faq_title.
  ///
  /// In en, this message translates to:
  /// **'Common questions.'**
  String get pricing_faq_title;

  /// No description provided for @pricing_step1_title.
  ///
  /// In en, this message translates to:
  /// **'Customer places an order'**
  String get pricing_step1_title;

  /// No description provided for @pricing_step1_desc.
  ///
  /// In en, this message translates to:
  /// **'They browse your menu, add items, and pay through the app.'**
  String get pricing_step1_desc;

  /// No description provided for @pricing_step2_title.
  ///
  /// In en, this message translates to:
  /// **'You prepare and deliver'**
  String get pricing_step2_title;

  /// No description provided for @pricing_step2_desc.
  ///
  /// In en, this message translates to:
  /// **'You confirm the order, prepare it, and mark it as delivered.'**
  String get pricing_step2_desc;

  /// No description provided for @pricing_step3_title.
  ///
  /// In en, this message translates to:
  /// **'We take a small cut'**
  String get pricing_step3_title;

  /// No description provided for @pricing_step3_desc.
  ///
  /// In en, this message translates to:
  /// **'A commission is deducted from the order value. The rest goes to you.'**
  String get pricing_step3_desc;

  /// No description provided for @pricing_slider_orders_label.
  ///
  /// In en, this message translates to:
  /// **'Orders per day'**
  String get pricing_slider_orders_label;

  /// No description provided for @pricing_slider_orders_value.
  ///
  /// In en, this message translates to:
  /// **'{count} orders/day · {monthly}/month'**
  String pricing_slider_orders_value(int count, int monthly);

  /// No description provided for @pricing_slider_avg_label.
  ///
  /// In en, this message translates to:
  /// **'Average order value'**
  String get pricing_slider_avg_label;

  /// No description provided for @pricing_slider_avg_value.
  ///
  /// In en, this message translates to:
  /// **'{amount} PLN'**
  String pricing_slider_avg_value(String amount);

  /// No description provided for @pricing_tier_badge.
  ///
  /// In en, this message translates to:
  /// **'{tierName} tier — {rate} commission'**
  String pricing_tier_badge(String tierName, String rate);

  /// No description provided for @pricing_tier_monthly.
  ///
  /// In en, this message translates to:
  /// **'{count} orders/month'**
  String pricing_tier_monthly(int count);

  /// No description provided for @pricing_calc_revenue_label.
  ///
  /// In en, this message translates to:
  /// **'Daily revenue'**
  String get pricing_calc_revenue_label;

  /// No description provided for @pricing_calc_revenue_sub.
  ///
  /// In en, this message translates to:
  /// **'before commission'**
  String get pricing_calc_revenue_sub;

  /// No description provided for @pricing_calc_fee_label.
  ///
  /// In en, this message translates to:
  /// **'Freequick fee ({rate})'**
  String pricing_calc_fee_label(String rate);

  /// No description provided for @pricing_calc_fee_sub.
  ///
  /// In en, this message translates to:
  /// **'per day'**
  String get pricing_calc_fee_sub;

  /// No description provided for @pricing_calc_keep_label.
  ///
  /// In en, this message translates to:
  /// **'You keep'**
  String get pricing_calc_keep_label;

  /// No description provided for @pricing_calc_disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Commission is only charged on completed, delivered orders.'**
  String get pricing_calc_disclaimer;

  /// No description provided for @pricing_tier_starter_label.
  ///
  /// In en, this message translates to:
  /// **'Starter'**
  String get pricing_tier_starter_label;

  /// No description provided for @pricing_tier_starter_range.
  ///
  /// In en, this message translates to:
  /// **'0 – 100 orders/month'**
  String get pricing_tier_starter_range;

  /// No description provided for @pricing_tier_starter_desc.
  ///
  /// In en, this message translates to:
  /// **'Get started with no upfront cost.'**
  String get pricing_tier_starter_desc;

  /// No description provided for @pricing_tier_growing_label.
  ///
  /// In en, this message translates to:
  /// **'Growing'**
  String get pricing_tier_growing_label;

  /// No description provided for @pricing_tier_growing_range.
  ///
  /// In en, this message translates to:
  /// **'101 – 500 orders/month'**
  String get pricing_tier_growing_range;

  /// No description provided for @pricing_tier_growing_desc.
  ///
  /// In en, this message translates to:
  /// **'Lower rate as you build your customer base.'**
  String get pricing_tier_growing_desc;

  /// No description provided for @pricing_tier_established_label.
  ///
  /// In en, this message translates to:
  /// **'Established'**
  String get pricing_tier_established_label;

  /// No description provided for @pricing_tier_established_range.
  ///
  /// In en, this message translates to:
  /// **'501 – 1 500 orders/month'**
  String get pricing_tier_established_range;

  /// No description provided for @pricing_tier_established_desc.
  ///
  /// In en, this message translates to:
  /// **'Rewarding consistent high-volume restaurants.'**
  String get pricing_tier_established_desc;

  /// No description provided for @pricing_tier_partner_label.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get pricing_tier_partner_label;

  /// No description provided for @pricing_tier_partner_range.
  ///
  /// In en, this message translates to:
  /// **'1 500+ orders/month'**
  String get pricing_tier_partner_range;

  /// No description provided for @pricing_tier_partner_desc.
  ///
  /// In en, this message translates to:
  /// **'Our best rate for our highest-volume partners.'**
  String get pricing_tier_partner_desc;

  /// No description provided for @pricing_faq1_q.
  ///
  /// In en, this message translates to:
  /// **'Are there any setup or monthly fees?'**
  String get pricing_faq1_q;

  /// No description provided for @pricing_faq1_a.
  ///
  /// In en, this message translates to:
  /// **'No. Freequick charges zero setup fees and zero monthly fees. You only pay commission on completed orders.'**
  String get pricing_faq1_a;

  /// No description provided for @pricing_faq2_q.
  ///
  /// In en, this message translates to:
  /// **'When does the commission get deducted?'**
  String get pricing_faq2_q;

  /// No description provided for @pricing_faq2_a.
  ///
  /// In en, this message translates to:
  /// **'Commission is calculated at the time an order is marked as delivered. It is deducted from your payout balance automatically.'**
  String get pricing_faq2_a;

  /// No description provided for @pricing_faq3_q.
  ///
  /// In en, this message translates to:
  /// **'How often do I get paid?'**
  String get pricing_faq3_q;

  /// No description provided for @pricing_faq3_a.
  ///
  /// In en, this message translates to:
  /// **'Payouts are processed weekly to your registered IBAN bank account. You can track your balance in real-time on the dashboard.'**
  String get pricing_faq3_a;

  /// No description provided for @pricing_faq4_q.
  ///
  /// In en, this message translates to:
  /// **'What happens if an order is cancelled?'**
  String get pricing_faq4_q;

  /// No description provided for @pricing_faq4_a.
  ///
  /// In en, this message translates to:
  /// **'Cancelled orders are not charged commission. You only pay for successful, completed deliveries.'**
  String get pricing_faq4_a;

  /// No description provided for @pricing_faq5_q.
  ///
  /// In en, this message translates to:
  /// **'Can I change my bank account details later?'**
  String get pricing_faq5_q;

  /// No description provided for @pricing_faq5_a.
  ///
  /// In en, this message translates to:
  /// **'Yes. You can update your IBAN at any time in the Settings section of your dashboard.'**
  String get pricing_faq5_a;

  /// No description provided for @pricing_tier_name_starter.
  ///
  /// In en, this message translates to:
  /// **'Starter'**
  String get pricing_tier_name_starter;

  /// No description provided for @pricing_tier_name_growing.
  ///
  /// In en, this message translates to:
  /// **'Growing'**
  String get pricing_tier_name_growing;

  /// No description provided for @pricing_tier_name_established.
  ///
  /// In en, this message translates to:
  /// **'Established'**
  String get pricing_tier_name_established;

  /// No description provided for @pricing_tier_name_partner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get pricing_tier_name_partner;

  /// No description provided for @admin_notifications_tab_send.
  ///
  /// In en, this message translates to:
  /// **'Send Notification'**
  String get admin_notifications_tab_send;

  /// No description provided for @admin_notifications_tab_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get admin_notifications_tab_history;

  /// No description provided for @admin_notifications_target_audience.
  ///
  /// In en, this message translates to:
  /// **'Target Audience'**
  String get admin_notifications_target_audience;

  /// No description provided for @admin_notifications_audience_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get admin_notifications_audience_all;

  /// No description provided for @admin_notifications_audience_restaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get admin_notifications_audience_restaurants;

  /// No description provided for @admin_notifications_audience_specific.
  ///
  /// In en, this message translates to:
  /// **'Specific'**
  String get admin_notifications_audience_specific;

  /// No description provided for @admin_notifications_audience_label_all.
  ///
  /// In en, this message translates to:
  /// **'All Users'**
  String get admin_notifications_audience_label_all;

  /// No description provided for @admin_notifications_audience_label_restaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Owners'**
  String get admin_notifications_audience_label_restaurants;

  /// No description provided for @admin_notifications_audience_label_specific.
  ///
  /// In en, this message translates to:
  /// **'Specific Users'**
  String get admin_notifications_audience_label_specific;

  /// No description provided for @admin_notifications_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email…'**
  String get admin_notifications_search_hint;

  /// No description provided for @admin_notifications_search_hint_more.
  ///
  /// In en, this message translates to:
  /// **'Add more users…'**
  String get admin_notifications_search_hint_more;

  /// No description provided for @admin_notifications_title_label.
  ///
  /// In en, this message translates to:
  /// **'Notification Title'**
  String get admin_notifications_title_label;

  /// No description provided for @admin_notifications_title_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. New feature available'**
  String get admin_notifications_title_hint;

  /// No description provided for @admin_notifications_body_label.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get admin_notifications_body_label;

  /// No description provided for @admin_notifications_body_hint.
  ///
  /// In en, this message translates to:
  /// **'Write the notification message…'**
  String get admin_notifications_body_hint;

  /// No description provided for @admin_notifications_send_button.
  ///
  /// In en, this message translates to:
  /// **'Send Notification'**
  String get admin_notifications_send_button;

  /// No description provided for @admin_notifications_sending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get admin_notifications_sending;

  /// No description provided for @admin_notifications_required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get admin_notifications_required;

  /// No description provided for @admin_notifications_select_user.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one user.'**
  String get admin_notifications_select_user;

  /// No description provided for @admin_notifications_no_users.
  ///
  /// In en, this message translates to:
  /// **'No users found for this audience.'**
  String get admin_notifications_no_users;

  /// No description provided for @admin_notifications_sent_one.
  ///
  /// In en, this message translates to:
  /// **'Sent to 1 user'**
  String get admin_notifications_sent_one;

  /// No description provided for @admin_notifications_sent_many.
  ///
  /// In en, this message translates to:
  /// **'Sent to {count} users'**
  String admin_notifications_sent_many(int count);

  /// No description provided for @admin_notifications_history_empty.
  ///
  /// In en, this message translates to:
  /// **'No notifications sent yet'**
  String get admin_notifications_history_empty;

  /// No description provided for @admin_notifications_history_sent_badge.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get admin_notifications_history_sent_badge;

  /// No description provided for @admin_notifications_history_sent_count.
  ///
  /// In en, this message translates to:
  /// **'{count} sent'**
  String admin_notifications_history_sent_count(int count);

  /// No description provided for @admin_overview_platform_glance.
  ///
  /// In en, this message translates to:
  /// **'PLATFORM AT A GLANCE'**
  String get admin_overview_platform_glance;

  /// No description provided for @admin_overview_revenue_30d.
  ///
  /// In en, this message translates to:
  /// **'REVENUE (LAST 30 DAYS)'**
  String get admin_overview_revenue_30d;

  /// No description provided for @admin_overview_pending_requests.
  ///
  /// In en, this message translates to:
  /// **'PENDING JOIN REQUESTS'**
  String get admin_overview_pending_requests;

  /// No description provided for @admin_overview_view_all.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get admin_overview_view_all;

  /// No description provided for @admin_overview_order_status.
  ///
  /// In en, this message translates to:
  /// **'ORDER STATUS BREAKDOWN'**
  String get admin_overview_order_status;

  /// No description provided for @admin_overview_top_restaurants.
  ///
  /// In en, this message translates to:
  /// **'TOP RESTAURANTS BY ORDERS'**
  String get admin_overview_top_restaurants;

  /// No description provided for @admin_overview_stat_restaurants.
  ///
  /// In en, this message translates to:
  /// **'Total Restaurants'**
  String get admin_overview_stat_restaurants;

  /// No description provided for @admin_overview_stat_restaurants_sub.
  ///
  /// In en, this message translates to:
  /// **'{active} with orders'**
  String admin_overview_stat_restaurants_sub(int active);

  /// No description provided for @admin_overview_stat_orders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get admin_overview_stat_orders;

  /// No description provided for @admin_overview_stat_orders_sub.
  ///
  /// In en, this message translates to:
  /// **'{count} today'**
  String admin_overview_stat_orders_sub(int count);

  /// No description provided for @admin_overview_stat_revenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get admin_overview_stat_revenue;

  /// No description provided for @admin_overview_stat_revenue_sub.
  ///
  /// In en, this message translates to:
  /// **'{amount} PLN last 7d'**
  String admin_overview_stat_revenue_sub(String amount);

  /// No description provided for @admin_overview_stat_avg.
  ///
  /// In en, this message translates to:
  /// **'Avg Order Value'**
  String get admin_overview_stat_avg;

  /// No description provided for @admin_overview_stat_avg_sub.
  ///
  /// In en, this message translates to:
  /// **'{menus} menus · {items} items'**
  String admin_overview_stat_avg_sub(int menus, int items);

  /// No description provided for @admin_overview_loading.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get admin_overview_loading;

  /// No description provided for @admin_overview_revenue_no_data.
  ///
  /// In en, this message translates to:
  /// **'No revenue data yet'**
  String get admin_overview_revenue_no_data;

  /// No description provided for @admin_overview_no_pending.
  ///
  /// In en, this message translates to:
  /// **'No pending requests'**
  String get admin_overview_no_pending;

  /// No description provided for @admin_overview_pending_nip.
  ///
  /// In en, this message translates to:
  /// **'NIP: {nip} · Submitted {date}'**
  String admin_overview_pending_nip(String nip, String date);

  /// No description provided for @admin_overview_review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get admin_overview_review;

  /// No description provided for @admin_overview_no_orders.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get admin_overview_no_orders;

  /// No description provided for @admin_overview_no_order_data.
  ///
  /// In en, this message translates to:
  /// **'No order data yet'**
  String get admin_overview_no_order_data;

  /// No description provided for @admin_overview_orders_count.
  ///
  /// In en, this message translates to:
  /// **'{count} orders'**
  String admin_overview_orders_count(int count);

  /// No description provided for @admin_overview_status_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get admin_overview_status_pending;

  /// No description provided for @admin_overview_status_processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get admin_overview_status_processing;

  /// No description provided for @admin_overview_status_delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get admin_overview_status_delivered;

  /// No description provided for @admin_overview_status_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get admin_overview_status_cancelled;

  /// No description provided for @requests_tab_registrations.
  ///
  /// In en, this message translates to:
  /// **'Registrations'**
  String get requests_tab_registrations;

  /// No description provided for @requests_tab_go_live.
  ///
  /// In en, this message translates to:
  /// **'Go Live Requests'**
  String get requests_tab_go_live;

  /// No description provided for @requests_filter_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get requests_filter_pending;

  /// No description provided for @requests_filter_approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get requests_filter_approved;

  /// No description provided for @requests_filter_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get requests_filter_active;

  /// No description provided for @requests_filter_rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get requests_filter_rejected;

  /// No description provided for @requests_filter_suspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get requests_filter_suspended;

  /// No description provided for @requests_filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get requests_filter_all;

  /// No description provided for @requests_empty_filtered.
  ///
  /// In en, this message translates to:
  /// **'No {filter} requests'**
  String requests_empty_filtered(String filter);

  /// No description provided for @requests_empty_all.
  ///
  /// In en, this message translates to:
  /// **'No restaurants yet'**
  String get requests_empty_all;

  /// No description provided for @requests_go_live_empty.
  ///
  /// In en, this message translates to:
  /// **'No Go Live requests yet'**
  String get requests_go_live_empty;

  /// No description provided for @requests_go_live_section_pending.
  ///
  /// In en, this message translates to:
  /// **'PENDING REVIEW'**
  String get requests_go_live_section_pending;

  /// No description provided for @requests_go_live_section_reviewed.
  ///
  /// In en, this message translates to:
  /// **'REVIEWED'**
  String get requests_go_live_section_reviewed;

  /// No description provided for @requests_go_live_requested.
  ///
  /// In en, this message translates to:
  /// **'Requested {timeAgo} · {date}'**
  String requests_go_live_requested(String timeAgo, String date);

  /// No description provided for @requests_go_live_activated_on.
  ///
  /// In en, this message translates to:
  /// **'Activated on {date}'**
  String requests_go_live_activated_on(String date);

  /// No description provided for @requests_go_live_declined_on.
  ///
  /// In en, this message translates to:
  /// **'Declined on {date}'**
  String requests_go_live_declined_on(String date);

  /// No description provided for @requests_badge_activated.
  ///
  /// In en, this message translates to:
  /// **'Activated'**
  String get requests_badge_activated;

  /// No description provided for @requests_badge_declined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get requests_badge_declined;

  /// No description provided for @requests_badge_pending_review.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get requests_badge_pending_review;

  /// No description provided for @requests_action_activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get requests_action_activate;

  /// No description provided for @requests_action_decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get requests_action_decline;

  /// No description provided for @requests_submitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted {date}'**
  String requests_submitted(String date);

  /// No description provided for @requests_status_approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get requests_status_approved;

  /// No description provided for @requests_status_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get requests_status_active;

  /// No description provided for @requests_status_rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get requests_status_rejected;

  /// No description provided for @requests_status_suspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get requests_status_suspended;

  /// No description provided for @requests_status_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get requests_status_pending;

  /// No description provided for @requests_action_approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get requests_action_approve;

  /// No description provided for @requests_action_reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get requests_action_reject;

  /// No description provided for @requests_action_suspend.
  ///
  /// In en, this message translates to:
  /// **'Suspend'**
  String get requests_action_suspend;

  /// No description provided for @requests_action_reinstate.
  ///
  /// In en, this message translates to:
  /// **'Reinstate'**
  String get requests_action_reinstate;

  /// No description provided for @requests_action_copy_id.
  ///
  /// In en, this message translates to:
  /// **'Copy restaurant ID'**
  String get requests_action_copy_id;

  /// No description provided for @requests_copied.
  ///
  /// In en, this message translates to:
  /// **'Copied: {id}'**
  String requests_copied(String id);

  /// No description provided for @requests_confirm_approve_title.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get requests_confirm_approve_title;

  /// No description provided for @requests_confirm_approve_body.
  ///
  /// In en, this message translates to:
  /// **'This will approve the restaurant and give the owner access to their dashboard.'**
  String get requests_confirm_approve_body;

  /// No description provided for @requests_confirm_reject_title.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get requests_confirm_reject_title;

  /// No description provided for @requests_confirm_reject_body.
  ///
  /// In en, this message translates to:
  /// **'This will reject the restaurant. The owner will see a rejection message when they log in.'**
  String get requests_confirm_reject_body;

  /// No description provided for @requests_confirm_suspend_title.
  ///
  /// In en, this message translates to:
  /// **'Suspend'**
  String get requests_confirm_suspend_title;

  /// No description provided for @requests_confirm_suspend_body.
  ///
  /// In en, this message translates to:
  /// **'This will suspend the restaurant. The owner will be locked out of their dashboard immediately.'**
  String get requests_confirm_suspend_body;

  /// No description provided for @requests_confirm_reinstate_title.
  ///
  /// In en, this message translates to:
  /// **'Reinstate'**
  String get requests_confirm_reinstate_title;

  /// No description provided for @requests_confirm_reinstate_body.
  ///
  /// In en, this message translates to:
  /// **'This will reinstate the restaurant to active status.'**
  String get requests_confirm_reinstate_body;

  /// No description provided for @requests_confirm_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get requests_confirm_cancel;

  /// No description provided for @requests_error_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed: {error}'**
  String requests_error_failed(String error);

  /// No description provided for @requests_setup_progress.
  ///
  /// In en, this message translates to:
  /// **'Setup: {done}/{total} complete'**
  String requests_setup_progress(int done, int total);

  /// No description provided for @requests_check_logo.
  ///
  /// In en, this message translates to:
  /// **'Logo uploaded'**
  String get requests_check_logo;

  /// No description provided for @requests_check_banner.
  ///
  /// In en, this message translates to:
  /// **'Banner uploaded'**
  String get requests_check_banner;

  /// No description provided for @requests_check_address.
  ///
  /// In en, this message translates to:
  /// **'Address set'**
  String get requests_check_address;

  /// No description provided for @requests_check_iban.
  ///
  /// In en, this message translates to:
  /// **'IBAN set'**
  String get requests_check_iban;

  /// No description provided for @requests_check_photo.
  ///
  /// In en, this message translates to:
  /// **'Profile photo'**
  String get requests_check_photo;

  /// No description provided for @requests_check_menu.
  ///
  /// In en, this message translates to:
  /// **'At least one menu'**
  String get requests_check_menu;

  /// No description provided for @users_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email…'**
  String get users_search_hint;

  /// No description provided for @users_filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get users_filter_all;

  /// No description provided for @users_filter_restaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get users_filter_restaurant;

  /// No description provided for @users_filter_admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get users_filter_admin;

  /// No description provided for @users_filter_customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get users_filter_customer;

  /// No description provided for @users_empty_filtered.
  ///
  /// In en, this message translates to:
  /// **'No users match your filter'**
  String get users_empty_filtered;

  /// No description provided for @users_empty_all.
  ///
  /// In en, this message translates to:
  /// **'No users yet'**
  String get users_empty_all;

  /// No description provided for @users_banned_badge.
  ///
  /// In en, this message translates to:
  /// **'Banned'**
  String get users_banned_badge;

  /// No description provided for @users_joined.
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String users_joined(String date);

  /// No description provided for @users_detail_title.
  ///
  /// In en, this message translates to:
  /// **'User Details'**
  String get users_detail_title;

  /// No description provided for @users_detail_id.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get users_detail_id;

  /// No description provided for @users_detail_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get users_detail_phone;

  /// No description provided for @users_detail_joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get users_detail_joined;

  /// No description provided for @users_detail_role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get users_detail_role;

  /// No description provided for @users_action_ban.
  ///
  /// In en, this message translates to:
  /// **'Ban'**
  String get users_action_ban;

  /// No description provided for @users_action_unban.
  ///
  /// In en, this message translates to:
  /// **'Unban'**
  String get users_action_unban;

  /// No description provided for @users_action_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get users_action_delete;

  /// No description provided for @users_confirm_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get users_confirm_cancel;

  /// No description provided for @users_ban_title.
  ///
  /// In en, this message translates to:
  /// **'Ban User?'**
  String get users_ban_title;

  /// No description provided for @users_unban_title.
  ///
  /// In en, this message translates to:
  /// **'Unban User?'**
  String get users_unban_title;

  /// No description provided for @users_ban_body.
  ///
  /// In en, this message translates to:
  /// **'This will prevent the user from accessing the platform.'**
  String get users_ban_body;

  /// No description provided for @users_unban_body.
  ///
  /// In en, this message translates to:
  /// **'This will restore the user\'s access.'**
  String get users_unban_body;

  /// No description provided for @users_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete User?'**
  String get users_delete_title;

  /// No description provided for @users_delete_body.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete the user\'s Firestore document. Their Auth account will remain unless deleted separately from Firebase Console.'**
  String get users_delete_body;

  /// No description provided for @users_snack_banned.
  ///
  /// In en, this message translates to:
  /// **'User banned.'**
  String get users_snack_banned;

  /// No description provided for @users_snack_unbanned.
  ///
  /// In en, this message translates to:
  /// **'User unbanned.'**
  String get users_snack_unbanned;

  /// No description provided for @users_snack_deleted.
  ///
  /// In en, this message translates to:
  /// **'User deleted.'**
  String get users_snack_deleted;

  /// No description provided for @users_copied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get users_copied;

  /// No description provided for @users_role_admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get users_role_admin;

  /// No description provided for @users_role_restaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get users_role_restaurant;

  /// No description provided for @users_role_customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get users_role_customer;

  /// No description provided for @analytics_section_glance.
  ///
  /// In en, this message translates to:
  /// **'AT A GLANCE'**
  String get analytics_section_glance;

  /// No description provided for @analytics_section_revenue.
  ///
  /// In en, this message translates to:
  /// **'REVENUE OVER TIME'**
  String get analytics_section_revenue;

  /// No description provided for @analytics_section_status.
  ///
  /// In en, this message translates to:
  /// **'ORDER STATUS BREAKDOWN'**
  String get analytics_section_status;

  /// No description provided for @analytics_section_popular.
  ///
  /// In en, this message translates to:
  /// **'MOST ORDERED ITEMS'**
  String get analytics_section_popular;

  /// No description provided for @analytics_stat_revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue ({days}d)'**
  String analytics_stat_revenue(int days);

  /// No description provided for @analytics_stat_orders.
  ///
  /// In en, this message translates to:
  /// **'Orders ({days}d)'**
  String analytics_stat_orders(int days);

  /// No description provided for @analytics_stat_today.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sales'**
  String get analytics_stat_today;

  /// No description provided for @analytics_stat_avg.
  ///
  /// In en, this message translates to:
  /// **'Avg Order'**
  String get analytics_stat_avg;

  /// No description provided for @analytics_no_revenue.
  ///
  /// In en, this message translates to:
  /// **'No revenue data for this period'**
  String get analytics_no_revenue;

  /// No description provided for @analytics_no_orders.
  ///
  /// In en, this message translates to:
  /// **'No orders in this period'**
  String get analytics_no_orders;

  /// No description provided for @analytics_no_items.
  ///
  /// In en, this message translates to:
  /// **'No item data for this period'**
  String get analytics_no_items;

  /// No description provided for @analytics_orders_count.
  ///
  /// In en, this message translates to:
  /// **'{count} orders'**
  String analytics_orders_count(int count);

  /// No description provided for @analytics_status_normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get analytics_status_normal;

  /// No description provided for @analytics_status_processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get analytics_status_processing;

  /// No description provided for @analytics_status_delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get analytics_status_delivered;

  /// No description provided for @analytics_status_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get analytics_status_cancelled;

  /// No description provided for @shell_nav_overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get shell_nav_overview;

  /// No description provided for @shell_nav_orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get shell_nav_orders;

  /// No description provided for @shell_nav_menus.
  ///
  /// In en, this message translates to:
  /// **'Menus'**
  String get shell_nav_menus;

  /// No description provided for @shell_nav_promotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get shell_nav_promotions;

  /// No description provided for @shell_nav_analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get shell_nav_analytics;

  /// No description provided for @shell_nav_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get shell_nav_settings;

  /// No description provided for @shell_restaurant_not_found.
  ///
  /// In en, this message translates to:
  /// **'Restaurant not found. Please contact support.'**
  String get shell_restaurant_not_found;

  /// No description provided for @shell_finish_setup.
  ///
  /// In en, this message translates to:
  /// **'Finish setup'**
  String get shell_finish_setup;

  /// No description provided for @shell_my_account.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get shell_my_account;

  /// No description provided for @shell_live_go_offline.
  ///
  /// In en, this message translates to:
  /// **'Live · Go Offline'**
  String get shell_live_go_offline;

  /// No description provided for @shell_go_live_pending.
  ///
  /// In en, this message translates to:
  /// **'Go Live pending review'**
  String get shell_go_live_pending;

  /// No description provided for @shell_go_live_declined.
  ///
  /// In en, this message translates to:
  /// **'Declined · Reapply'**
  String get shell_go_live_declined;

  /// No description provided for @shell_request_go_live.
  ///
  /// In en, this message translates to:
  /// **'Request Go Live'**
  String get shell_request_go_live;

  /// No description provided for @shell_already_pending.
  ///
  /// In en, this message translates to:
  /// **'You already have a pending Go Live request.'**
  String get shell_already_pending;

  /// No description provided for @shell_go_live_submitted.
  ///
  /// In en, this message translates to:
  /// **'Go Live request submitted. We\'ll review it shortly.'**
  String get shell_go_live_submitted;

  /// No description provided for @shell_error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String shell_error(String error);

  /// No description provided for @shell_go_offline_title.
  ///
  /// In en, this message translates to:
  /// **'Go Offline?'**
  String get shell_go_offline_title;

  /// No description provided for @shell_go_offline_body.
  ///
  /// In en, this message translates to:
  /// **'Your restaurant will be hidden from customers. You can go live again at any time.'**
  String get shell_go_offline_body;

  /// No description provided for @shell_confirm_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get shell_confirm_cancel;

  /// No description provided for @shell_go_offline_confirm.
  ///
  /// In en, this message translates to:
  /// **'Go Offline'**
  String get shell_go_offline_confirm;

  /// No description provided for @shell_menu_support.
  ///
  /// In en, this message translates to:
  /// **'Talk to Support'**
  String get shell_menu_support;

  /// No description provided for @shell_menu_sales.
  ///
  /// In en, this message translates to:
  /// **'Talk to Sales'**
  String get shell_menu_sales;

  /// No description provided for @shell_menu_cookies.
  ///
  /// In en, this message translates to:
  /// **'Cookie Preferences'**
  String get shell_menu_cookies;

  /// No description provided for @shell_menu_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get shell_menu_settings;

  /// No description provided for @shell_menu_logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get shell_menu_logout;

  /// No description provided for @gate_pending_title.
  ///
  /// In en, this message translates to:
  /// **'Your account is under review'**
  String get gate_pending_title;

  /// No description provided for @gate_pending_message.
  ///
  /// In en, this message translates to:
  /// **'We\'re reviewing your registration details. This usually takes 1-2 business days. We\'ll notify you by email once approved.'**
  String get gate_pending_message;

  /// No description provided for @gate_rejected_title.
  ///
  /// In en, this message translates to:
  /// **'Application not approved'**
  String get gate_rejected_title;

  /// No description provided for @gate_rejected_message.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately your registration was not approved. Please contact support for more information.'**
  String get gate_rejected_message;

  /// No description provided for @gate_suspended_title.
  ///
  /// In en, this message translates to:
  /// **'Account suspended'**
  String get gate_suspended_title;

  /// No description provided for @gate_suspended_message.
  ///
  /// In en, this message translates to:
  /// **'Your account has been suspended. Please contact support to resolve this.'**
  String get gate_suspended_message;

  /// No description provided for @gate_default_title.
  ///
  /// In en, this message translates to:
  /// **'Access unavailable'**
  String get gate_default_title;

  /// No description provided for @gate_default_message.
  ///
  /// In en, this message translates to:
  /// **'Please contact support.'**
  String get gate_default_message;

  /// No description provided for @gate_sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get gate_sign_out;

  /// No description provided for @overview_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name} 👋'**
  String overview_welcome(String name);

  /// No description provided for @overview_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Here\'s what\'s happening with your restaurant today.'**
  String get overview_subtitle;

  /// No description provided for @overview_section_glance.
  ///
  /// In en, this message translates to:
  /// **'AT A GLANCE'**
  String get overview_section_glance;

  /// No description provided for @overview_section_orders.
  ///
  /// In en, this message translates to:
  /// **'RECENT ORDERS'**
  String get overview_section_orders;

  /// No description provided for @overview_setup_title.
  ///
  /// In en, this message translates to:
  /// **'Get your restaurant ready'**
  String get overview_setup_title;

  /// No description provided for @overview_setup_progress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} steps completed'**
  String overview_setup_progress(int done, int total);

  /// No description provided for @overview_task_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get overview_task_done;

  /// No description provided for @overview_task_setup.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get overview_task_setup;

  /// No description provided for @overview_task_logo_title.
  ///
  /// In en, this message translates to:
  /// **'Upload Restaurant Logo'**
  String get overview_task_logo_title;

  /// No description provided for @overview_task_logo_desc.
  ///
  /// In en, this message translates to:
  /// **'Customers will see your logo across the app.'**
  String get overview_task_logo_desc;

  /// No description provided for @overview_task_banner_title.
  ///
  /// In en, this message translates to:
  /// **'Add a Banner Image'**
  String get overview_task_banner_title;

  /// No description provided for @overview_task_banner_desc.
  ///
  /// In en, this message translates to:
  /// **'A banner makes your storefront visually appealing.'**
  String get overview_task_banner_desc;

  /// No description provided for @overview_task_address_title.
  ///
  /// In en, this message translates to:
  /// **'Set Restaurant Address'**
  String get overview_task_address_title;

  /// No description provided for @overview_task_address_desc.
  ///
  /// In en, this message translates to:
  /// **'Let customers know where to find you.'**
  String get overview_task_address_desc;

  /// No description provided for @overview_task_photo_title.
  ///
  /// In en, this message translates to:
  /// **'Add a Profile Photo'**
  String get overview_task_photo_title;

  /// No description provided for @overview_task_photo_desc.
  ///
  /// In en, this message translates to:
  /// **'Put a face to your restaurant owner account.'**
  String get overview_task_photo_desc;

  /// No description provided for @overview_task_menu_title.
  ///
  /// In en, this message translates to:
  /// **'Create a Menu & Add Items'**
  String get overview_task_menu_title;

  /// No description provided for @overview_task_menu_desc.
  ///
  /// In en, this message translates to:
  /// **'Organise your offerings into menus with dishes and prices.'**
  String get overview_task_menu_desc;

  /// No description provided for @overview_task_iban_title.
  ///
  /// In en, this message translates to:
  /// **'Add Bank Account (IBAN)'**
  String get overview_task_iban_title;

  /// No description provided for @overview_task_iban_desc.
  ///
  /// In en, this message translates to:
  /// **'Required to receive payouts from customer orders.'**
  String get overview_task_iban_desc;

  /// No description provided for @overview_stat_total_orders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get overview_stat_total_orders;

  /// No description provided for @overview_stat_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get overview_stat_pending;

  /// No description provided for @overview_stat_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get overview_stat_completed;

  /// No description provided for @overview_stat_revenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get overview_stat_revenue;

  /// No description provided for @overview_no_orders.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get overview_no_orders;

  /// No description provided for @overview_table_order_id.
  ///
  /// In en, this message translates to:
  /// **'ORDER ID'**
  String get overview_table_order_id;

  /// No description provided for @overview_table_customer.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMER'**
  String get overview_table_customer;

  /// No description provided for @overview_table_items.
  ///
  /// In en, this message translates to:
  /// **'ITEMS'**
  String get overview_table_items;

  /// No description provided for @overview_table_status.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get overview_table_status;

  /// No description provided for @overview_table_total.
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get overview_table_total;

  /// No description provided for @overview_items_count.
  ///
  /// In en, this message translates to:
  /// **'{count} item'**
  String overview_items_count(int count);

  /// No description provided for @overview_items_count_plural.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String overview_items_count_plural(int count);

  /// No description provided for @overview_time_just_now.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get overview_time_just_now;

  /// No description provided for @overview_time_minutes.
  ///
  /// In en, this message translates to:
  /// **'{n}m ago'**
  String overview_time_minutes(int n);

  /// No description provided for @overview_time_hours.
  ///
  /// In en, this message translates to:
  /// **'{n}h ago'**
  String overview_time_hours(int n);

  /// No description provided for @overview_chef_fallback.
  ///
  /// In en, this message translates to:
  /// **'Chef'**
  String get overview_chef_fallback;

  /// No description provided for @items_app_bar_fallback.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items_app_bar_fallback;

  /// No description provided for @items_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No items yet'**
  String get items_empty_title;

  /// No description provided for @items_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first item'**
  String get items_empty_subtitle;

  /// No description provided for @items_error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String items_error(String error);

  /// No description provided for @items_fab.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get items_fab;

  /// No description provided for @items_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get items_sheet_title;

  /// No description provided for @items_image_upload_label.
  ///
  /// In en, this message translates to:
  /// **'Upload Item Image'**
  String get items_image_upload_label;

  /// No description provided for @items_image_browse.
  ///
  /// In en, this message translates to:
  /// **'Click to browse'**
  String get items_image_browse;

  /// No description provided for @items_field_title_label.
  ///
  /// In en, this message translates to:
  /// **'Item Title'**
  String get items_field_title_label;

  /// No description provided for @items_field_title_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Pierogi Ruskie'**
  String get items_field_title_hint;

  /// No description provided for @items_field_title_required.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get items_field_title_required;

  /// No description provided for @items_field_info_label.
  ///
  /// In en, this message translates to:
  /// **'Short Info'**
  String get items_field_info_label;

  /// No description provided for @items_field_info_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Crispy and Tasty'**
  String get items_field_info_hint;

  /// No description provided for @items_field_info_required.
  ///
  /// In en, this message translates to:
  /// **'Info is required'**
  String get items_field_info_required;

  /// No description provided for @items_field_desc_label.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get items_field_desc_label;

  /// No description provided for @items_field_desc_hint.
  ///
  /// In en, this message translates to:
  /// **'Describe the item...'**
  String get items_field_desc_hint;

  /// No description provided for @items_field_desc_required.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get items_field_desc_required;

  /// No description provided for @items_field_price_label.
  ///
  /// In en, this message translates to:
  /// **'Price (PLN)'**
  String get items_field_price_label;

  /// No description provided for @items_field_price_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 24.99'**
  String get items_field_price_hint;

  /// No description provided for @items_field_price_required.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get items_field_price_required;

  /// No description provided for @items_field_price_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get items_field_price_invalid;

  /// No description provided for @items_field_tags_label.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get items_field_tags_label;

  /// No description provided for @items_field_tags_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Vegan'**
  String get items_field_tags_hint;

  /// No description provided for @items_tag_error_empty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a tag'**
  String get items_tag_error_empty;

  /// No description provided for @items_tag_error_capitalize.
  ///
  /// In en, this message translates to:
  /// **'First letter must be capitalized'**
  String get items_tag_error_capitalize;

  /// No description provided for @items_tag_error_letters.
  ///
  /// In en, this message translates to:
  /// **'Only letters are allowed'**
  String get items_tag_error_letters;

  /// No description provided for @items_tag_error_duplicate.
  ///
  /// In en, this message translates to:
  /// **'Tag already exists'**
  String get items_tag_error_duplicate;

  /// No description provided for @items_discount_toggle.
  ///
  /// In en, this message translates to:
  /// **'Apply Discount'**
  String get items_discount_toggle;

  /// No description provided for @items_discount_label.
  ///
  /// In en, this message translates to:
  /// **'Discount %'**
  String get items_discount_label;

  /// No description provided for @items_discount_required.
  ///
  /// In en, this message translates to:
  /// **'Enter a discount percentage'**
  String get items_discount_required;

  /// No description provided for @items_discount_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a value between 1 and 100'**
  String get items_discount_invalid;

  /// No description provided for @items_no_image.
  ///
  /// In en, this message translates to:
  /// **'Please select an item image.'**
  String get items_no_image;

  /// No description provided for @items_added.
  ///
  /// In en, this message translates to:
  /// **'Item added successfully'**
  String get items_added;

  /// No description provided for @items_submit.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get items_submit;

  /// No description provided for @menus_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No menus yet'**
  String get menus_empty_title;

  /// No description provided for @menus_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first menu'**
  String get menus_empty_subtitle;

  /// No description provided for @menus_error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String menus_error(String error);

  /// No description provided for @menus_fab.
  ///
  /// In en, this message translates to:
  /// **'Add Menu'**
  String get menus_fab;

  /// No description provided for @menus_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Add Menu'**
  String get menus_sheet_title;

  /// No description provided for @menus_image_upload_label.
  ///
  /// In en, this message translates to:
  /// **'Upload Banner Image'**
  String get menus_image_upload_label;

  /// No description provided for @menus_image_browse.
  ///
  /// In en, this message translates to:
  /// **'Click to browse'**
  String get menus_image_browse;

  /// No description provided for @menus_field_title_label.
  ///
  /// In en, this message translates to:
  /// **'Menu Title'**
  String get menus_field_title_label;

  /// No description provided for @menus_field_title_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Lunch Specials'**
  String get menus_field_title_hint;

  /// No description provided for @menus_field_title_required.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get menus_field_title_required;

  /// No description provided for @menus_field_desc_label.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get menus_field_desc_label;

  /// No description provided for @menus_field_desc_hint.
  ///
  /// In en, this message translates to:
  /// **'Briefly describe this menu...'**
  String get menus_field_desc_hint;

  /// No description provided for @menus_field_desc_required.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get menus_field_desc_required;

  /// No description provided for @menus_no_image.
  ///
  /// In en, this message translates to:
  /// **'Please select a banner image.'**
  String get menus_no_image;

  /// No description provided for @menus_created.
  ///
  /// In en, this message translates to:
  /// **'Menu created successfully'**
  String get menus_created;

  /// No description provided for @menus_submit.
  ///
  /// In en, this message translates to:
  /// **'Create Menu'**
  String get menus_submit;

  /// No description provided for @orders_error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get orders_error;

  /// No description provided for @orders_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No orders right now'**
  String get orders_empty_title;

  /// No description provided for @orders_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'When customers place orders they will appear here.'**
  String get orders_empty_subtitle;

  /// No description provided for @orders_table_order_id.
  ///
  /// In en, this message translates to:
  /// **'ORDER ID'**
  String get orders_table_order_id;

  /// No description provided for @orders_table_customer.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMER'**
  String get orders_table_customer;

  /// No description provided for @orders_table_items.
  ///
  /// In en, this message translates to:
  /// **'ITEMS'**
  String get orders_table_items;

  /// No description provided for @orders_table_status.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get orders_table_status;

  /// No description provided for @orders_table_total.
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get orders_table_total;

  /// No description provided for @orders_item_count.
  ///
  /// In en, this message translates to:
  /// **'{count} item'**
  String orders_item_count(int count);

  /// No description provided for @orders_item_count_plural.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String orders_item_count_plural(int count);

  /// No description provided for @promo_not_authenticated.
  ///
  /// In en, this message translates to:
  /// **'Not authenticated'**
  String get promo_not_authenticated;

  /// No description provided for @promo_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No promotions yet'**
  String get promo_empty_title;

  /// No description provided for @promo_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + to create your first promotion banner'**
  String get promo_empty_subtitle;

  /// No description provided for @promo_fab.
  ///
  /// In en, this message translates to:
  /// **'New Promotion'**
  String get promo_fab;

  /// No description provided for @promo_badge_live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get promo_badge_live;

  /// No description provided for @promo_badge_inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get promo_badge_inactive;

  /// No description provided for @promo_items_linked.
  ///
  /// In en, this message translates to:
  /// **'{count} item'**
  String promo_items_linked(int count);

  /// No description provided for @promo_items_linked_plural.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String promo_items_linked_plural(int count);

  /// No description provided for @promo_edit_button.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get promo_edit_button;

  /// No description provided for @promo_sheet_add_title.
  ///
  /// In en, this message translates to:
  /// **'New Promotion'**
  String get promo_sheet_add_title;

  /// No description provided for @promo_sheet_edit_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Promotion'**
  String get promo_sheet_edit_title;

  /// No description provided for @promo_sheet_delete_button.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get promo_sheet_delete_button;

  /// No description provided for @promo_image_change_hint.
  ///
  /// In en, this message translates to:
  /// **'Tap to change banner'**
  String get promo_image_change_hint;

  /// No description provided for @promo_image_upload_hint.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload banner image'**
  String get promo_image_upload_hint;

  /// No description provided for @promo_image_upload_label.
  ///
  /// In en, this message translates to:
  /// **'Upload Banner Image'**
  String get promo_image_upload_label;

  /// No description provided for @promo_image_recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended: 1200×400px'**
  String get promo_image_recommended;

  /// No description provided for @promo_field_title_label.
  ///
  /// In en, this message translates to:
  /// **'Promotion Title'**
  String get promo_field_title_label;

  /// No description provided for @promo_field_title_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Weekend Discount'**
  String get promo_field_title_hint;

  /// No description provided for @promo_field_title_required.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get promo_field_title_required;

  /// No description provided for @promo_field_desc_label.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get promo_field_desc_label;

  /// No description provided for @promo_field_desc_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Up to 30% off all mains this weekend'**
  String get promo_field_desc_hint;

  /// No description provided for @promo_field_desc_required.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get promo_field_desc_required;

  /// No description provided for @promo_date_start.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get promo_date_start;

  /// No description provided for @promo_date_end.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get promo_date_end;

  /// No description provided for @promo_date_pick.
  ///
  /// In en, this message translates to:
  /// **'Pick date'**
  String get promo_date_pick;

  /// No description provided for @promo_active_toggle.
  ///
  /// In en, this message translates to:
  /// **'Promotion Active'**
  String get promo_active_toggle;

  /// No description provided for @promo_link_section_label.
  ///
  /// In en, this message translates to:
  /// **'Link Discounted Items'**
  String get promo_link_section_label;

  /// No description provided for @promo_link_section_hint.
  ///
  /// In en, this message translates to:
  /// **'Optional — select items this promotion applies to'**
  String get promo_link_section_hint;

  /// No description provided for @promo_link_no_items.
  ///
  /// In en, this message translates to:
  /// **'No items found. Add items to your menus first.'**
  String get promo_link_no_items;

  /// No description provided for @promo_save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get promo_save_changes;

  /// No description provided for @promo_create.
  ///
  /// In en, this message translates to:
  /// **'Create Promotion'**
  String get promo_create;

  /// No description provided for @promo_no_dates.
  ///
  /// In en, this message translates to:
  /// **'Please set both start and end dates.'**
  String get promo_no_dates;

  /// No description provided for @promo_date_order_error.
  ///
  /// In en, this message translates to:
  /// **'End date must be after start date.'**
  String get promo_date_order_error;

  /// No description provided for @promo_no_image.
  ///
  /// In en, this message translates to:
  /// **'Please select a banner image.'**
  String get promo_no_image;

  /// No description provided for @promo_updated.
  ///
  /// In en, this message translates to:
  /// **'Promotion updated successfully'**
  String get promo_updated;

  /// No description provided for @promo_created.
  ///
  /// In en, this message translates to:
  /// **'Promotion created successfully'**
  String get promo_created;

  /// No description provided for @promo_banner_cleanup_error.
  ///
  /// In en, this message translates to:
  /// **'Banner updated, but cleanup of old file failed.'**
  String get promo_banner_cleanup_error;

  /// No description provided for @promo_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Promotion?'**
  String get promo_delete_title;

  /// No description provided for @promo_delete_body.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete the promotion and its banner. This cannot be undone.'**
  String get promo_delete_body;

  /// No description provided for @promo_delete_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get promo_delete_cancel;

  /// No description provided for @promo_delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get promo_delete_confirm;

  /// No description provided for @promo_deleted.
  ///
  /// In en, this message translates to:
  /// **'Promotion deleted.'**
  String get promo_deleted;

  /// No description provided for @promo_location_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Location'**
  String get promo_location_dialog_title;

  /// No description provided for @promo_location_none.
  ///
  /// In en, this message translates to:
  /// **'No location selected yet'**
  String get promo_location_none;

  /// No description provided for @promo_location_open_map.
  ///
  /// In en, this message translates to:
  /// **'Open Map'**
  String get promo_location_open_map;

  /// No description provided for @promo_location_change_map.
  ///
  /// In en, this message translates to:
  /// **'Change on Map'**
  String get promo_location_change_map;

  /// No description provided for @promo_location_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Address'**
  String get promo_location_confirm;

  /// No description provided for @promo_location_no_pick.
  ///
  /// In en, this message translates to:
  /// **'Please pick a location on the map first.'**
  String get promo_location_no_pick;

  /// No description provided for @settings_section_business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get settings_section_business;

  /// No description provided for @settings_section_business_sub.
  ///
  /// In en, this message translates to:
  /// **'Manage your restaurant profile and media'**
  String get settings_section_business_sub;

  /// No description provided for @settings_section_profile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get settings_section_profile;

  /// No description provided for @settings_section_profile_sub.
  ///
  /// In en, this message translates to:
  /// **'Update your personal account details'**
  String get settings_section_profile_sub;

  /// No description provided for @settings_section_danger.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get settings_section_danger;

  /// No description provided for @settings_section_danger_sub.
  ///
  /// In en, this message translates to:
  /// **'Irreversible actions for your account'**
  String get settings_section_danger_sub;

  /// No description provided for @settings_logo_title.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Logo'**
  String get settings_logo_title;

  /// No description provided for @settings_logo_status_staged.
  ///
  /// In en, this message translates to:
  /// **'New logo ready'**
  String get settings_logo_status_staged;

  /// No description provided for @settings_logo_status_exists.
  ///
  /// In en, this message translates to:
  /// **'Logo uploaded'**
  String get settings_logo_status_exists;

  /// No description provided for @settings_logo_status_none.
  ///
  /// In en, this message translates to:
  /// **'No logo yet'**
  String get settings_logo_status_none;

  /// No description provided for @settings_logo_recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended: 512×512px, PNG or JPG'**
  String get settings_logo_recommended;

  /// No description provided for @settings_logo_choose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get settings_logo_choose;

  /// No description provided for @settings_logo_upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get settings_logo_upload;

  /// No description provided for @settings_logo_uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get settings_logo_uploading;

  /// No description provided for @settings_logo_success.
  ///
  /// In en, this message translates to:
  /// **'Logo updated'**
  String get settings_logo_success;

  /// No description provided for @settings_banner_title.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Banner'**
  String get settings_banner_title;

  /// No description provided for @settings_banner_choose.
  ///
  /// In en, this message translates to:
  /// **'Click to choose banner'**
  String get settings_banner_choose;

  /// No description provided for @settings_banner_recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended: 1200×800px'**
  String get settings_banner_recommended;

  /// No description provided for @settings_banner_upload.
  ///
  /// In en, this message translates to:
  /// **'Upload Banner'**
  String get settings_banner_upload;

  /// No description provided for @settings_banner_uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get settings_banner_uploading;

  /// No description provided for @settings_banner_success.
  ///
  /// In en, this message translates to:
  /// **'Banner updated'**
  String get settings_banner_success;

  /// No description provided for @settings_business_title.
  ///
  /// In en, this message translates to:
  /// **'Business Info'**
  String get settings_business_title;

  /// No description provided for @settings_business_saved.
  ///
  /// In en, this message translates to:
  /// **'Business info saved'**
  String get settings_business_saved;

  /// No description provided for @settings_address_set.
  ///
  /// In en, this message translates to:
  /// **'Set restaurant address'**
  String get settings_address_set;

  /// No description provided for @settings_address_change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get settings_address_change;

  /// No description provided for @settings_address_pick.
  ///
  /// In en, this message translates to:
  /// **'Pick on map'**
  String get settings_address_pick;

  /// No description provided for @settings_profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settings_profile_title;

  /// No description provided for @settings_profile_photo_ready.
  ///
  /// In en, this message translates to:
  /// **'New photo ready — press Save to apply'**
  String get settings_profile_photo_ready;

  /// No description provided for @settings_profile_saved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get settings_profile_saved;

  /// No description provided for @settings_profile_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Owner\'s Name'**
  String get settings_profile_name_hint;

  /// No description provided for @settings_profile_phone_label.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get settings_profile_phone_label;

  /// No description provided for @settings_danger_reset_title.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get settings_danger_reset_title;

  /// No description provided for @settings_danger_reset_sub.
  ///
  /// In en, this message translates to:
  /// **'Send a password reset email to your account'**
  String get settings_danger_reset_sub;

  /// No description provided for @settings_danger_reset_button.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get settings_danger_reset_button;

  /// No description provided for @settings_danger_reset_sent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get settings_danger_reset_sent;

  /// No description provided for @settings_danger_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settings_danger_delete_title;

  /// No description provided for @settings_danger_delete_sub.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your restaurant and all data'**
  String get settings_danger_delete_sub;

  /// No description provided for @settings_danger_delete_button.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get settings_danger_delete_button;

  /// No description provided for @settings_danger_delete_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settings_danger_delete_dialog_title;

  /// No description provided for @settings_danger_delete_dialog_body.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all restaurant data. This cannot be undone.'**
  String get settings_danger_delete_dialog_body;

  /// No description provided for @settings_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settings_cancel;

  /// No description provided for @settings_error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get settings_error;

  /// No description provided for @settings_save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get settings_save_changes;

  /// No description provided for @settings_map_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Location'**
  String get settings_map_dialog_title;

  /// No description provided for @settings_map_no_location.
  ///
  /// In en, this message translates to:
  /// **'No location selected yet'**
  String get settings_map_no_location;

  /// No description provided for @settings_map_open.
  ///
  /// In en, this message translates to:
  /// **'Open Map'**
  String get settings_map_open;

  /// No description provided for @settings_map_change.
  ///
  /// In en, this message translates to:
  /// **'Change on Map'**
  String get settings_map_change;

  /// No description provided for @settings_map_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Address'**
  String get settings_map_confirm;

  /// No description provided for @settings_map_no_pick.
  ///
  /// In en, this message translates to:
  /// **'Please pick a location on the map first.'**
  String get settings_map_no_pick;

  /// No description provided for @tap_to_upload_image.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload image'**
  String get tap_to_upload_image;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @password_does_not_meet_requirements.
  ///
  /// In en, this message translates to:
  /// **'Password does not meet requirements'**
  String get password_does_not_meet_requirements;

  /// No description provided for @password_is_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get password_is_required;

  /// No description provided for @snackbar_dismiss.
  ///
  /// In en, this message translates to:
  /// **'DISMISS'**
  String get snackbar_dismiss;

  /// No description provided for @field_error_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get field_error_required;

  /// No description provided for @field_error_invalid_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid format'**
  String get field_error_invalid_format;

  /// No description provided for @field_email_message.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get field_email_message;

  /// No description provided for @field_nip_message.
  ///
  /// In en, this message translates to:
  /// **'NIP must be exactly 10 digits'**
  String get field_nip_message;

  /// No description provided for @field_regon_message.
  ///
  /// In en, this message translates to:
  /// **'REGON must be 9 or 14 digits'**
  String get field_regon_message;

  /// No description provided for @field_postal_code_message.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid postal code (XX-XXX)'**
  String get field_postal_code_message;

  /// No description provided for @field_hint_prefix.
  ///
  /// In en, this message translates to:
  /// **'Enter '**
  String get field_hint_prefix;

  /// No description provided for @items_design_edit_button.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get items_design_edit_button;

  /// No description provided for @items_design_edit_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get items_design_edit_sheet_title;

  /// No description provided for @items_design_delete_button.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get items_design_delete_button;

  /// No description provided for @items_design_change_image_hint.
  ///
  /// In en, this message translates to:
  /// **'Tap to change image'**
  String get items_design_change_image_hint;

  /// No description provided for @items_design_field_title_label.
  ///
  /// In en, this message translates to:
  /// **'Item Title'**
  String get items_design_field_title_label;

  /// No description provided for @items_design_field_info_label.
  ///
  /// In en, this message translates to:
  /// **'Short Info'**
  String get items_design_field_info_label;

  /// No description provided for @items_design_field_info_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Crispy and Tasty'**
  String get items_design_field_info_hint;

  /// No description provided for @items_design_field_desc_label.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get items_design_field_desc_label;

  /// No description provided for @items_design_field_price_label.
  ///
  /// In en, this message translates to:
  /// **'Price (PLN)'**
  String get items_design_field_price_label;

  /// No description provided for @items_design_field_price_required.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get items_design_field_price_required;

  /// No description provided for @items_design_field_price_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get items_design_field_price_invalid;

  /// No description provided for @items_design_field_tags_label.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get items_design_field_tags_label;

  /// No description provided for @items_design_field_tags_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Vegan'**
  String get items_design_field_tags_hint;

  /// No description provided for @items_design_discount_label.
  ///
  /// In en, this message translates to:
  /// **'Discount %'**
  String get items_design_discount_label;

  /// No description provided for @items_design_discount_required.
  ///
  /// In en, this message translates to:
  /// **'Enter a discount percentage'**
  String get items_design_discount_required;

  /// No description provided for @items_design_discount_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a value between 1 and 100'**
  String get items_design_discount_invalid;

  /// No description provided for @items_design_save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get items_design_save_changes;

  /// No description provided for @items_design_saved.
  ///
  /// In en, this message translates to:
  /// **'Item saved successfully'**
  String get items_design_saved;

  /// No description provided for @items_design_image_cleanup_error.
  ///
  /// In en, this message translates to:
  /// **'Image updated, but cleanup of old file failed.'**
  String get items_design_image_cleanup_error;

  /// No description provided for @items_design_delete_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get items_design_delete_dialog_title;

  /// No description provided for @items_design_delete_dialog_body.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item? This cannot be undone.'**
  String get items_design_delete_dialog_body;

  /// No description provided for @items_design_delete_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get items_design_delete_cancel;

  /// No description provided for @items_design_delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get items_design_delete_confirm;

  /// No description provided for @items_design_deleted.
  ///
  /// In en, this message translates to:
  /// **'Item deleted successfully'**
  String get items_design_deleted;

  /// No description provided for @map_fetching_address.
  ///
  /// In en, this message translates to:
  /// **'Fetching address...'**
  String get map_fetching_address;

  /// No description provided for @map_address_not_found.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find the address'**
  String get map_address_not_found;

  /// No description provided for @map_confirm_button.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM ADDRESS'**
  String get map_confirm_button;

  /// No description provided for @menus_design_view_items.
  ///
  /// In en, this message translates to:
  /// **'View Items'**
  String get menus_design_view_items;

  /// No description provided for @menus_design_edit_button.
  ///
  /// In en, this message translates to:
  /// **'Edit Menu'**
  String get menus_design_edit_button;

  /// No description provided for @menus_design_edit_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Menu'**
  String get menus_design_edit_sheet_title;

  /// No description provided for @menus_design_delete_button.
  ///
  /// In en, this message translates to:
  /// **'Delete Menu'**
  String get menus_design_delete_button;

  /// No description provided for @menus_design_change_image_hint.
  ///
  /// In en, this message translates to:
  /// **'Tap to change image'**
  String get menus_design_change_image_hint;

  /// No description provided for @menus_design_field_title_label.
  ///
  /// In en, this message translates to:
  /// **'Menu Title'**
  String get menus_design_field_title_label;

  /// No description provided for @menus_design_field_desc_label.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get menus_design_field_desc_label;

  /// No description provided for @menus_design_field_title_required.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get menus_design_field_title_required;

  /// No description provided for @menus_design_field_desc_required.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get menus_design_field_desc_required;

  /// No description provided for @menus_design_save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get menus_design_save_changes;

  /// No description provided for @menus_design_saved.
  ///
  /// In en, this message translates to:
  /// **'Menu saved successfully'**
  String get menus_design_saved;

  /// No description provided for @menus_design_banner_cleanup_error.
  ///
  /// In en, this message translates to:
  /// **'Banner updated, but cleanup of old file failed.'**
  String get menus_design_banner_cleanup_error;

  /// No description provided for @menus_design_delete_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Menu'**
  String get menus_design_delete_dialog_title;

  /// No description provided for @menus_design_delete_dialog_body.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this menu? This cannot be undone.'**
  String get menus_design_delete_dialog_body;

  /// No description provided for @menus_design_delete_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get menus_design_delete_cancel;

  /// No description provided for @menus_design_delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get menus_design_delete_confirm;

  /// No description provided for @menus_design_delete_missing_id.
  ///
  /// In en, this message translates to:
  /// **'Error: Missing Menu or Restaurant ID'**
  String get menus_design_delete_missing_id;

  /// No description provided for @menus_design_deleted.
  ///
  /// In en, this message translates to:
  /// **'Menu deleted successfully'**
  String get menus_design_deleted;

  /// No description provided for @notif_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notif_sheet_title;

  /// No description provided for @notif_unread_count.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String notif_unread_count(int count);

  /// No description provided for @notif_mark_all_read.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notif_mark_all_read;

  /// No description provided for @notif_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notif_empty_title;

  /// No description provided for @notif_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Admin messages will appear here'**
  String get notif_empty_subtitle;

  /// No description provided for @notif_time_just_now.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get notif_time_just_now;

  /// No description provided for @notif_time_minutes.
  ///
  /// In en, this message translates to:
  /// **'{n}m ago'**
  String notif_time_minutes(int n);

  /// No description provided for @notif_time_hours.
  ///
  /// In en, this message translates to:
  /// **'{n}h ago'**
  String notif_time_hours(int n);

  /// No description provided for @notif_time_yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notif_time_yesterday;

  /// No description provided for @notif_time_days.
  ///
  /// In en, this message translates to:
  /// **'{n}d ago'**
  String notif_time_days(int n);

  /// No description provided for @addr_use_current_location.
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get addr_use_current_location;

  /// No description provided for @addr_label_fallback.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addr_label_fallback;

  /// No description provided for @addr_translating.
  ///
  /// In en, this message translates to:
  /// **'Translating...'**
  String get addr_translating;

  /// No description provided for @addr_error_loading.
  ///
  /// In en, this message translates to:
  /// **'Error loading address'**
  String get addr_error_loading;

  /// No description provided for @addr_building.
  ///
  /// In en, this message translates to:
  /// **'Building: {value}'**
  String addr_building(String value);

  /// No description provided for @addr_flat.
  ///
  /// In en, this message translates to:
  /// **'Flat Number: {value}'**
  String addr_flat(String value);

  /// No description provided for @addr_address.
  ///
  /// In en, this message translates to:
  /// **'Address: {value}'**
  String addr_address(String value);

  /// No description provided for @addr_see_in_maps.
  ///
  /// In en, this message translates to:
  /// **'See in Maps'**
  String get addr_see_in_maps;

  /// No description provided for @addr_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get addr_delete;

  /// No description provided for @addr_delete_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Remove Address'**
  String get addr_delete_dialog_title;

  /// No description provided for @addr_delete_dialog_body.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {label}?'**
  String addr_delete_dialog_body(String label);

  /// No description provided for @addr_delete_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get addr_delete_cancel;

  /// No description provided for @addr_delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get addr_delete_confirm;

  /// No description provided for @addr_deleted.
  ///
  /// In en, this message translates to:
  /// **'Address deleted successfully'**
  String get addr_deleted;

  /// No description provided for @addr_delete_error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String addr_delete_error(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'ko', 'pl', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
    case 'pl':
      return AppLocalizationsPl();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
