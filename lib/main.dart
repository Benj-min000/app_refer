import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 🌍 Added for localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // 🌍 Added for localization
import 'package:user_app/assistant_methods/address_changer.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/assistant_methods/total_ammount.dart';
import 'package:user_app/global/global.dart'; // ✅ Import global.dart to fix sharedPreferences error
import 'package:flutter_stripe/flutter_stripe.dart'; // for stripe payment method
import 'package:user_app/splashScreen/splash_screen.dart';
import 'package:user_app/localization/locale_provider.dart'; // 🌍 Added for language state management
import 'package:flutter_stripe/flutter_stripe.dart'; // for stripe payment method

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  // 🔹 Initialize Stripe with your Publishable Key
  Stripe.publishableKey = "pk_test_51QzJ2DEEJccZQYudjQBnQQRxok2UrcXMsjgKQ0BLvqCr5yQI6xtzLrdfmenrIv8zxUcn51Z2muxyKHSlgsmswkgx004DjT0jnR"; // Replace with your actual Stripe key

  // 🌍 Load saved language preference
  LocaleProvider localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  // 🌍 Wrap the app with `ChangeNotifierProvider` for locale management
  runApp(
    ChangeNotifierProvider(
      create: (_) => localeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context); // 🌍 Get current locale

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartItemCounter()),
        ChangeNotifierProvider(create: (context) => TotalAmmount()),
        ChangeNotifierProvider(create: (context) => AddressChanger()),
      ],
      child: MaterialApp(
        title: 'Users App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        locale: localeProvider.locale, // 🌍 Set the app's language based on user selection
        supportedLocales: [
          Locale('en'), // English
          Locale('ko'), // Korean
          Locale('pl'), // Polish
          Locale('uk'), // Ukrainian
        ],
        localizationsDelegates: [ // 🌍 Added localization delegates
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) { // 🌍 Added to handle device language settings
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: const MySplashScreen(),
      ),
    );
  }
}
