// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

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
  String get errorEnterRegInfo => 'Please Enter required information for Registration';

  @override
  String get errorSelectImage => 'Please Select an Image';

  @override
  String get errorNoMatchPasswords => 'Passwords don\'t match!';

  @override
  String get errorLoginFailed => 'Login Failed';

  @override
  String get errorNoRecordFound => 'No record found';

  @override
  String get blockedAccountMessage => 'Admin has blocked your account\n\nMail to: admin@gmail.com';

  @override
  String get networkUnavailable => 'Network unavailable. Please try again';

  @override
  String get errorFetchingUserData => 'Error fetching user data';

  @override
  String storageError(Object error) {
    return 'Storage Error: $error';
  }

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
