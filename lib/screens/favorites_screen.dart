import 'package:flutter/material.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/widgets/unified_bottom_bar.dart';
import 'package:user_app/screens/home_screen.dart';
import 'package:user_app/screens/orders_screen.dart';
import 'package:user_app/screens/search_screen.dart';
import 'package:user_app/widgets/my_drower.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoritesScreen> {
  int _currentPageIndex = 3;
  
  void _onBottomNavTap(int index) {
    if (index == _currentPageIndex) return;
    
    setState(() {
      _currentPageIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrdersScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SearchScreen(initialText: '')),
        );
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: UnifiedAppBar(
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu_open, color: Colors.white, size: 28),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: MyDrawer(),
        bottomNavigationBar: UnifiedBottomNavigationBar(
          currentIndex: _currentPageIndex,
          onTap: _onBottomNavTap,
        ),
        body: Center(
          child: Text('Favorites Content'), // Add your actual favorites content here
        ),
      ),
    );
  }
}