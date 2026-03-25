// lib/main.dart — Rider app

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/utils/app_constants.dart';

import 'firebase_options.dart';
import 'providers/rider_provider.dart';
import 'providers/rider_stats_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utils/app_theme.dart';
import 'global/global.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/active_delivery_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  riderPrefs = await SharedPreferences.getInstance();

  final riderProvider = RiderProvider();
  riderProvider.init();

  runApp(
    ChangeNotifierProvider.value(
      value: riderProvider,
      child: const RiderApp(),
    ),
  );
}

class RiderApp extends StatelessWidget {
  const RiderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const _AppRouter(),
    );
  }
}

// ── Router ────────────────────────────────────────────────────────────────────

class _AppRouter extends StatelessWidget {
  const _AppRouter();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RiderProvider>();

    switch (provider.appState) {
      case RiderAppState.loading:
        return const _SplashScreen();

      case RiderAppState.unauthenticated:
        return const LoginScreen();

      case RiderAppState.needsProfile:
        return const ProfileSetupScreen();

      case RiderAppState.idle:
      case RiderAppState.onJob:
        return ChangeNotifierProvider(
          key: ValueKey(provider.rider!.uid),
          create: (_) => RiderStatsProvider(provider.rider!.uid),
          child: provider.appState == RiderAppState.onJob
              ? const ActiveDeliveryScreen()
              : const _RiderShell(),
        );
    }
  }
}

// ── Shell — bottom nav + screen switching ─────────────────────────────────────

class _RiderShell extends StatefulWidget {
  const _RiderShell();

  @override
  State<_RiderShell> createState() => _RiderShellState();
}

class _RiderShellState extends State<_RiderShell> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: AppTheme.surface,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ── Splash ────────────────────────────────────────────────────────────────────

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delivery_dining_rounded,
              color: AppTheme.primary,
              size: 64,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: AppTheme.primary,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}

void setupFCM() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.data['type'] == 'DISPATCH_JOB') {
      FirebaseFirestore.instance
          .collection('dispatch_jobs')
          .get();
    }
  });
}