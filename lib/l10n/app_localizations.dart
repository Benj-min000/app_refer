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

  /// Tab label for Food Delivery
  ///
  /// In en, this message translates to:
  /// **'Food Delivery'**
  String get tabFoodDelivery;

  /// Tab label for Grocery / Shopping
  ///
  /// In en, this message translates to:
  /// **'Grocery & Shopping'**
  String get tabGroceryShopping;

  /// Tab label for Pickup orders
  ///
  /// In en, this message translates to:
  /// **'Pick-up'**
  String get tabPickup;

  /// Tab label for sending gifts
  ///
  /// In en, this message translates to:
  /// **'Send Gifts'**
  String get tabGifting;

  /// Tab label for viewing all benefits
  ///
  /// In en, this message translates to:
  /// **'View All Benefits'**
  String get tabBenefits;

  /// Label for the discount icon
  ///
  /// In en, this message translates to:
  /// **'Daily Discounts'**
  String get categoryDiscounts;

  ///
  ///
  /// In en, this message translates to:
  /// **'Boiled Pork'**
  String get categoryPork;

  ///
  ///
  /// In en, this message translates to:
  /// **'Tonkatsu & Sashimi'**
  String get categoryTonkatsuSashimi;

  ///
  ///
  /// In en, this message translates to:
  /// **'Pizza'**
  String get categoryPizza;

  ///
  ///
  /// In en, this message translates to:
  /// **'Steamed Stew'**
  String get categoryStew;

  ///
  ///
  /// In en, this message translates to:
  /// **'Chinese Food'**
  String get categoryChinese;

  ///
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get categoryChicken;

  ///
  ///
  /// In en, this message translates to:
  /// **'Korean Food'**
  String get categoryKorean;

  ///
  ///
  /// In en, this message translates to:
  /// **'One-bowl Meals'**
  String get categoryOneBowl;

  /// Category label for More / Other items
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get categoryPichupDiscount;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See more in {tab}'**
  String seeMore(Object tab);

  /// Button or menu label to change language
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// Text shown while app detects location
  ///
  /// In en, this message translates to:
  /// **'Finding your localization...'**
  String get findingLocalization;

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

  /// Estimated delivery time
  ///
  /// In en, this message translates to:
  /// **'45-50 mins'**
  String get deliveryTime;
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
