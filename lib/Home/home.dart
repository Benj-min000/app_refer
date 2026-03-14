import 'package:flutter/material.dart';

import 'package:user_app/widgets/restaurant_card.dart';

import 'package:user_app/Home/HomePageMediumItems.dart';
import 'package:user_app/Home/HomeLargeItems.dart';

import 'package:user_app/Home/HomePageItems.dart';

import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/locale_provider.dart';

import 'package:user_app/extensions/context_translate_ext.dart';

import 'package:user_app/Home/home_tabs.dart';

import 'package:user_app/models/home_page_items.dart';

import 'package:user_app/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/widgets/address_header.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _DiningPagePageState();
}

class _DiningPagePageState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTabIndex = 0;
  bool _showAllCategories = false;

  Locale? _lastLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localeProvider = Provider.of<LocaleProvider>(context);
    if (_lastLocale != localeProvider.locale) {
      _lastLocale = localeProvider.locale;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = getHomeTabs(context);
    final selectedTab = tabs[_selectedTabIndex];
    final hasMoreCategories = selectedTab.categories.length > 10;
    final displayedCategories = _showAllCategories
        ? selectedTab.categories
        : selectedTab.categories.take(10).toList();

    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -- Header ------------------------------------------------------
          _buildHeader(context),

          // -- Tab bar -----------------------------------------------------
          _buildTabBar(context, tabs),

          // -- Category grid -----------------------------------------------
          _buildCategoryGrid(
              context, displayedCategories, hasMoreCategories, selectedTab),

          const SizedBox(height: 8),

          // -- Featured carousel -------------------------------------------
          _buildSectionHeader(
              context, 'Featured', Icons.local_fire_department_rounded,
              color: Colors.deepOrange),
          const SizedBox(
            height: 220,
            width: double.infinity,
            child: HomeLargeItems(),
          ),

          const SizedBox(height: 8),

          // -- Explore carousel --------------------------------------------
          _buildSectionHeader(context, 'Explore', Icons.explore_rounded,
              color: Colors.pink),
          const SizedBox(
            height: 170,
            width: double.infinity,
            child: HomeMediumItems(),
          ),

          const SizedBox(height: 8),

          // -- What's on your mind -----------------------------------------
          _buildSectionHeader(
              context, "What's on your mind?", Icons.restaurant_menu_rounded,
              color: Colors.redAccent),
          ...List.generate(
            homePageItemsLenght(),
            (index) => SizedBox(
              height: 100,
              width: double.infinity,
              child: HomePageItems(itemsIndex: index),
            ),
          ),

          const SizedBox(height: 8),

          // -- Spotlight restaurants ---------------------------------------
          _buildSectionHeader(context, 'In the Spotlight', Icons.stars_rounded,
              color: Colors.amber.shade700),
          _buildRestaurantList(),

          // -- Features ----------------------------------------------------
          _buildSectionHeader(
              context, 'Features', Icons.featured_play_list_rounded,
              color: Colors.teal),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // -- Header -----------------------------------------------------------------

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.red),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AddressHeader(),
          const SizedBox(height: 14),
          // Search bar
          GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const SearchScreen(initialText: ''),
                  transitionDuration: const Duration(milliseconds: 400),
                  reverseTransitionDuration: const Duration(milliseconds: 300),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return ScaleTransition(
                      scale: CurvedAnimation(
                          parent: animation, curve: Curves.easeOutQuart),
                      alignment: Alignment.topCenter,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                ),
              );
              _searchController.clear();
              if (!mounted) return;
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded,
                      color: Colors.redAccent, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    context.l10n.hintSearch,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -- Tab bar ----------------------------------------------------------------

  Widget _buildTabBar(BuildContext context, List tabs) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        labelColor: Colors.redAccent,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        unselectedLabelColor: Colors.grey[500],
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        indicatorColor: Colors.redAccent,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 3,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        tabs: tabs.map((tab) => Tab(text: tab.label)).toList(),
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
            _showAllCategories = false;
          });
        },
      ),
    );
  }

  // -- Category grid ----------------------------------------------------------

  Widget _buildCategoryGrid(BuildContext context, List displayedCategories,
      bool hasMoreCategories, selectedTab) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 0.72,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            itemCount: displayedCategories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(displayedCategories[index]);
            },
          ),
          if (hasMoreCategories) ...[
            const SizedBox(height: 8),
            Divider(height: 1, color: Colors.grey[100]),
            InkWell(
              onTap: () =>
                  setState(() => _showAllCategories = !_showAllCategories),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _showAllCategories
                          ? 'Show Less'
                          : context.l10n.seeMore(selectedTab.label),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _showAllCategories
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryItem(HomeCategoryItem category) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SearchScreen(
                initialText: '',
                categoryFilter: category.label, // e.g. 'Pizza', 'Sushi'
                initialTabIndex: 2, // go straight to Items tab
              ),
            ));
      },
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.redAccent.withValues(alpha: 0.15),
                  Colors.pink.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Icon(
                category.icon,
                size: 26,
                color: Colors.redAccent,
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 28,
            child: Center(
              child: Text(
                category.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -- Section header ---------------------------------------------------------

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    Color color = Colors.redAccent,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              letterSpacing: 0.1,
            ),
          ),
          const Spacer(),
          if (actionLabel != null && onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // -- Restaurant list --------------------------------------------------------

  Widget _buildRestaurantList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("restaurants")
          .where("status", isEqualTo: "Active")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(Icons.storefront_outlined,
                      size: 40, color: Colors.grey[300]),
                  const SizedBox(height: 8),
                  Text(
                    'No restaurants available',
                    style: TextStyle(
                        color: Colors.grey[500], fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: snapshot.data!.docs.map((doc) {
              final restData = doc.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 280,
                    width: double.infinity,
                    child: RestaurantCard(
                      restaurantID: doc.id,
                      restaurantName: restData['name'] ?? 'Unknown Store',
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
