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
}
