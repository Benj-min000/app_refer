import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:provider/provider.dart';
import 'package:user_app/providers/cart_provider.dart';
import 'package:user_app/providers/theme_provider.dart';
import 'package:user_app/providers/address_provider.dart';
import 'package:user_app/providers/amount_provider.dart';
import 'package:user_app/providers/locale_provider.dart';

import 'package:user_app/global/global.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:user_app/l10n/app_localizations.dart';

import 'package:user_app/models/language.dart';

import 'package:user_app/screens/splash_screen.dart';

import 'package:user_app/widgets/unified_snackbar.dart';

import 'package:user_app/extensions/extensions_import.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize SharedPreferences
  sharedPreferences = await SharedPreferences.getInstance();

  // Initialize Stripe
  Stripe.publishableKey =
      const String.fromEnvironment("STRIPE_PUBLISHABLE_KEY");
  await Stripe.instance.applySettings();

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

  AddressProvider addressProvider = AddressProvider();
  await addressProvider.loadSavedAddress();

  CartProvider cartProvider = CartProvider();
  await cartProvider.loadCart();

  ThemeProvider themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider.value(value: addressProvider),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: cartProvider),
        ChangeNotifierProvider(create: (c) => AmountProvider()),
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'User App',
      debugShowCheckedModeBanner: false,
      navigatorKey: snackBarNavigatorKey,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,

      locale: localeProvider.locale,

      // Autmatically fetching the languages list from language_model.dart
      supportedLocales: Language.languageList.map((lang) {
        return Locale(lang.code, lang.countryCode);
      }).toList(),

      localizationsDelegates: const [
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
