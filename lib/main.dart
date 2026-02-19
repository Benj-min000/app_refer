import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:user_app/l10n/app_localizations.dart';
import 'package:user_app/models/language.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/assistant_methods/address_changer.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/assistant_methods/total_amount.dart';
import 'package:user_app/assistant_methods/locale_provider.dart';

import 'package:user_app/global/global.dart';
import 'package:user_app/splashScreen/splash_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize SharedPreferences
  sharedPreferences = await SharedPreferences.getInstance();

  // Initialize Stripe
  Stripe.publishableKey = const String.fromEnvironment("STRIPE_PUBLISHABLE_KEY");

  // This needs to be here so that the user can login 
  // After release change it to AndroidProvider.playIntegrity
  // MarcinDebugToken: 3770756b-47ff-40fc-b3ab-5dd0d0608ea6
  await FirebaseAppCheck.instance.activate(
    providerAndroid: AndroidDebugProvider(),
    providerApple: AppleDebugProvider(),
  );

  // Load Saved Locale
  LocaleProvider localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  AddressChanger addressChanger = AddressChanger();
  await addressChanger.loadSavedAddress();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider.value(value: addressChanger),
        ChangeNotifierProvider(create: (_) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'User App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.lightBlue,
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
      ),

      locale: localeProvider.locale,

      // Autmatically fetching the languages list from language_model.dart
      supportedLocales: Language.languageList.map((lang) {
        return Locale(lang.code, lang.countryCode);
      }).toList(),

      localizationsDelegates: const[
        AppLocalizations.delegate,
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
    );
  }
}
