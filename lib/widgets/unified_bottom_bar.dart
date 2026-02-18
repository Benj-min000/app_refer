import 'package:flutter/material.dart';

BottomNavigationBarItem _buildNavItem({
  required IconData icon,
  required IconData activeIcon,
  required String label,
}) {
  return BottomNavigationBarItem(
    icon: Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Icon(
        icon, 
        size: 26,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: Offset(0, 2.0),
            blurRadius: 8.0,
          ),
        ],
      ),
    ),
    activeIcon: Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Icon(
        activeIcon, 
        size: 28,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: Offset(0, 2.0),
            blurRadius: 8.0,
          ),
        ],
      ),
    ),
    label: label,
  );
}

List<BottomNavigationBarItem> get navBarItems => [
  _buildNavItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    label: 'Home',
  ),
  _buildNavItem(
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long,
    label: 'Orders',
  ),
  _buildNavItem(
    icon: Icons.search,
    activeIcon: Icons.search,
    label: 'Search',
  ),
  _buildNavItem(
    icon: Icons.favorite_outline,
    activeIcon: Icons.favorite,
    label: 'Favorites',
  ),
];

class UnifiedBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const UnifiedBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withValues(alpha: 0.8),
          selectedFontSize: 14,
          unselectedFontSize: 13,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          elevation: 0,
          items: navBarItems, 
        ),
      ),
    );
  }
}