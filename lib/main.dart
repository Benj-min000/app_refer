import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/assistant_methods/address_changer.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/assistant_methods/total_ammount.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/splashScreen/splash_screen.dart';
import 'package:user_app/localization/locale_provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart'; // stripe once only

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  sharedPreferences = await SharedPreferences.getInstance();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Stripe
  Stripe.publishableKey = "pk_test_51QzJ2DEEJccZQYudjQBnQQRxok2UrcXMsjgKQ0BLvqCr5yQI6xtzLrdfmenrIv8zxUcn51Z2muxyKHSlgsmswkgx004DjT0jnR";

  // Load Saved Locale
  LocaleProvider localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  runApp(
    ChangeNotifierProvider<LocaleProvider>(
      create: (_) => localeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartItemCounter()),
        ChangeNotifierProvider(create: (_) => TotalAmmount()),
        ChangeNotifierProvider(create: (_) => AddressChanger()),
      ],
      child: MaterialApp(
        title: 'User App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        locale: localeProvider.locale, // 🔥 Language from Provider
        supportedLocales: const [
          Locale('en'), // English
          Locale('ko'), // Korean
          Locale('pl'), // Polish
          Locale('uk'), // Ukrainian
        ],
        localizationsDelegates: const [
         // AppLocalizations.delegate, // 🔥 Generated localization
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) return supportedLocales.first;
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
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
