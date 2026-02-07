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
  String get tabGroceryShopping => 'Grocery & Shopping';

  @override
  String get tabPickup => 'Pick-up';

  @override
  String get tabGifting => 'Send Gifts';

  @override
  String get tabBenefits => 'View All Benefits';

  @override
  String get categoryDiscounts => 'Daily Discounts';

  @override
  String get categoryPork => 'Boiled Pork';

  @override
  String get categoryTonkatsuSashimi => 'Tonkatsu & Sashimi';

  @override
  String get categoryPizza => 'Pizza';

  @override
  String get categoryStew => 'Steamed Stew';

  @override
  String get categoryChinese => 'Chinese Food';

  @override
  String get categoryChicken => 'Chicken';

  @override
  String get categoryKorean => 'Korean Food';

  @override
  String get categoryOneBowl => 'One-bowl Meals';

  @override
  String get categoryPichupDiscount => 'More';

  @override
  String seeMore(Object tab) {
    return 'See more in $tab';
  }

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get findingLocalization => 'Finding your localization...';

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
  String get deliveryTime => '45-50 mins';
}
