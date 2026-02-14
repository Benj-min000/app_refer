import 'dart:async';
import 'package:flutter/material.dart';

import 'package:user_app/cake/cakeItems.dart';

import 'package:user_app/restaurants/restaurant_card.dart';
import 'package:user_app/models/restaurant.dart';

import 'package:user_app/Home/HomePageMediumItems.dart';
import 'package:user_app/Home/HomeLargeItems.dart';

import 'package:user_app/Home/HomePageItems.dart';

import "package:user_app/services/location_service.dart";
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/locale_provider.dart';

import 'package:user_app/extensions/context_translate_ext.dart';

import 'package:user_app/Home/home_tabs.dart';

import 'package:user_app/screens/address_screen.dart';
import 'package:user_app/assistant_methods/address_changer.dart';
import "package:user_app/services/translator_service.dart";
import 'package:user_app/models/home_page_items.dart';

import 'package:user_app/screens/search_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _DiningPagePageState();
}

class _DiningPagePageState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

  int _selectedTabIndex = 0;
  bool _showAllCategories = false;

  String _location = "";
  bool _showFullAddress = false;
  
  Locale? _lastLocale;
  
  int? _lastAddressIndex;

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        _updateAddress();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listening for changing the language
    final localeProvider = Provider.of<LocaleProvider>(context);

    // Listening for chaning the address
    final addressProvider = Provider.of<AddressChanger>(context);

    // Updating the address
    if (_lastLocale != localeProvider.locale || 
      _lastAddressIndex != addressProvider.count) {
    
      _lastLocale = localeProvider.locale;
      _lastAddressIndex = addressProvider.count;

      _updateAddress();
    }
  }

  void _updateAddress() async {
    final addressProvider = Provider.of<AddressChanger>(context, listen: false);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final languageCode = localeProvider.locale.languageCode;

    Map<String, dynamic> dataToProcess;

    if (addressProvider.count >= 0) {
      dataToProcess = addressProvider.selectedAddress;
    } else {
      if (mounted) setState(() => _location = context.t.findingLocalization);
    
      try {
        final dataToProcess = await LocationService.fetchUserCurrentLocation(langCode: languageCode);
        if (mounted) {
          setState(() {
            _location = dataToProcess['fullAddress'];
          });
        }
      } catch (e) {
        if (mounted) setState(() => _location = context.t.errorAddressNotFound);
      }
      return;
    }

    String finalAddress = await TranslationService.formatAndTranslateAddress(dataToProcess, languageCode);
    
    if (mounted) {
      setState(() {
        _location = finalAddress;
      });
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Widget categoryBox(HomeCategoryItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.redAccent.shade100,
          child: Icon(item.icon, color: Colors.white),
        ),
        
        const SizedBox(height: 8),

        Text(
          item.label, 
          textAlign: TextAlign.center,
          maxLines: 2,
          style: const TextStyle(
            fontSize: 12,
            height: 1.2,
          ),
        ),
      ],
    );
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
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.redAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddressScreen()));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on, 
                          color: Colors.white, 
                          size: 32,
                        ),
                        
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _showFullAddress = !_showFullAddress;
                              });
                            },
                            child: Text(
                              _location,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: _showFullAddress ? null : 1,
                              overflow: _showFullAddress ? TextOverflow.visible : TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _showFullAddress = !_showFullAddress),
                          child: Icon(
                            _showFullAddress ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: context.t.hintSearch,
                            hintStyle: TextStyle(fontSize: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) async {
                            await Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => SearchScreen(initialText: value),
                                transitionDuration: const Duration(milliseconds: 400),
                                reverseTransitionDuration: const Duration(milliseconds: 300),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  var curvedAnimation = CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutQuart, // Smooth expansion
                                  );

                                  return ScaleTransition(
                                    scale: curvedAnimation,
                                    alignment: Alignment.topCenter, // The expands from the top
                                    child: FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                  );
                                },
                              ),
                            );
                            
                            _searchController.clear();
                            if (mounted) return;
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ),
                  ]
                ),
              ],
            ),
          ),

          Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            labelColor: Colors.blue.shade700,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            unselectedLabelColor: Colors.grey[600],
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            indicatorColor: Colors.blue.shade700,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            tabs: tabs.map((tab) => Tab(text: tab.label)).toList(),
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
                _showAllCategories = false; // Reset when switching tabs
              });
            },
          ),
        ),

        // Category Grid
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 0.65,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: displayedCategories.length,
            itemBuilder: (context, index) {
              final category = displayedCategories[index];
              return _buildCategoryItem(category);
            },
          ),
        ),

        if (hasMoreCategories)
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                InkWell(
                  onTap: () {
                    setState(() {
                      _showAllCategories = !_showAllCategories;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _showAllCategories 
                              ? 'Show Less' 
                              : context.t.seeMore(selectedTab.label),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _showAllCategories 
                              ? Icons.keyboard_arrow_up 
                              : Icons.keyboard_arrow_down,
                          size: 18,
                          color: Colors.grey[700],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey[200]),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const SizedBox(
            height: 250,
            width: double.infinity,
            child: HomeLargeItems(),
          ),

          _buildSectionHeader('EXPLORE'),

          const SizedBox(
            height: 180,
            width: double.infinity,
            child: HomeMediumItems(),
          ),

          _buildSectionHeader('WHAT\'S ON YOUR MIND?'),

          ...List.generate(
            homePageItemsLenght(),
            (index) => SizedBox(
              height: 100,
              width: double.infinity,
              child: HomePageItems(itemsIndex: index),
            ),
          ),

          _buildSectionHeader('IN THE SPOTLIGHT'),

          const SizedBox(
            height: 220,
            width: double.infinity,
            child: CakeItems(),
          ),

          _buildSectionHeader('OUR RESTAURANTS'),

          ...List.generate(
            restaurantsListLength(),
            (index) => SizedBox(
              height: 300,
              width: double.infinity,
              child: RestaurantCard(restaurantIndex: index),
            ),
          ),

          _buildSectionHeader('FEATURES'),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(HomeCategoryItem category) {
    return InkWell(
      onTap: () {
        // Handle category tap
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                category.icon,
                size: 28,
                color: Colors.blue.shade700,
              ),
            ),
          ),
          SizedBox(
            height: 32,
            child: Center(
              child: Text(
                category.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
