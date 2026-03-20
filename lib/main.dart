// lib/main.dart
//
// Provider setup mirrors the user app's main.dart structure.
//
// User app does:
//   MultiProvider(providers: [
//     ChangeNotifierProvider(create: (_) => LocaleProvider()),
//     ChangeNotifierProvider(create: (_) => CartProvider()),
//     ...
//   ])
//
// Rider app does the same — just one provider since the rider has no cart:
//   ChangeNotifierProvider(create: (_) => RiderProvider()..init())
//
// If this app is ever merged into a monorepo with the user app,
// LocaleProvider can be added here too so language stays in sync.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'services/rider_provider.dart';
import 'utils/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/active_delivery_screen.dart' hide AppConstants;
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Same firebase_options.dart as the user app — both apps share the same
  // Firebase project so data flows between them automatically.
  await Firebase.initializeApp();

  runApp(
    // Pattern matches user app:
    //   ChangeNotifierProvider(create: (_) => LocaleProvider())
    ChangeNotifierProvider(
      create: (_) => RiderProvider()..init(),
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
      home: const AppRouter(),
      routes: {
        '/home': (_) => const MainShell(),
        '/active-delivery': (_) => const ActiveDeliveryScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}

// ─── AppRouter ───────────────────────────────────────────────────────────────
// Watches RiderProvider.appState and shows the right screen.
// Same pattern as user app switching between auth/home screens via auth stream.
class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    // Same as user app: Provider.of<LocaleProvider>(context)
    final provider = Provider.of<RiderProvider>(context);

    // Show error snackbar if one is queued
    if (provider.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(provider.errorMessage!),
          backgroundColor: AppTheme.danger,
          behavior: SnackBarBehavior.floating,
        ));
        provider.clearError();
      });
    }

    switch (provider.appState) {
      case RiderAppState.loading:
        return const SplashScreen();
      case RiderAppState.unauthenticated:
        return const LoginScreen();
      case RiderAppState.needsProfile:
        return const ProfileSetupScreen();
      case RiderAppState.onJob:
        return const ActiveDeliveryScreen();
      case RiderAppState.idle:
        return const MainShell();
    }
  }
}

// ─── MainShell: bottom nav ────────────────────────────────────────────────────
// Same IndexedStack + BottomNavigationBar pattern as user app's main scaffold.
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  // Pages — same IndexedStack pattern as user app
  final List<Widget> _pages = const [
    HomeScreen(),
    EarningsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: AppTheme.divider, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet),
              label: 'Earnings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Earnings screen ─────────────────────────────────────────────────────────
class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // context.read — same shorthand used in user app widgets
    final provider = context.read<RiderProvider>();
    final rider = provider.rider;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Earnings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _EarningsSummary(
              totalEarnings: rider?.totalEarnings ?? 0.0,
              totalDeliveries: rider?.totalDeliveries ?? 0,
            ),
            const SizedBox(height: 24),
            const Text('Recent Payouts',
                style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(16)),
              child: const Center(
                child: Column(children: [
                  Icon(Icons.receipt_long_outlined,
                      color: AppTheme.textSecondary, size: 40),
                  SizedBox(height: 10),
                  Text('No payouts yet',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 14)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EarningsSummary extends StatelessWidget {
  final double totalEarnings;
  final int totalDeliveries;
  const _EarningsSummary(
      {required this.totalEarnings, required this.totalDeliveries});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A3330), Color(0xFF0F1E1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Earnings',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          const SizedBox(height: 8),
          Text('zł ${totalEarnings.toStringAsFixed(2)}',
              style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 38,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          Row(children: [
            _Mini(label: 'Deliveries', value: totalDeliveries.toString()),
            const SizedBox(width: 24),
            const _Mini(label: 'This week', value: 'zł 0.00'),
            const SizedBox(width: 24),
            const _Mini(label: 'Today', value: 'zł 0.00'),
          ]),
        ],
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  final String label;
  final String value;
  const _Mini({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value,
          style: const TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 15)),
      Text(label,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
    ]);
  }
}

// ─── Splash screen ────────────────────────────────────────────────────────────
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.delivery_dining,
                  color: AppTheme.primary, size: 44),
            ),
            const SizedBox(height: 24),
            const Text('Rider',
                style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Poland Delivery Platform',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            const SizedBox(height: 48),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppTheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
