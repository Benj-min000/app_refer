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
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listening for changing the language
    final localeProvider = Provider.of<LocaleProvider>(context);

    // Updating the address
    if (_lastLocale != localeProvider.locale) {
      _lastLocale = localeProvider.locale;
    }
  }

  @override
  void dispose() {
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
                const AddressHeader(),

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
                            if (!mounted) return;
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
                _showAllCategories = false;
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

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("restaurants")
                .where("status", isEqualTo: "Active")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'No restaurants available',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return Column(
                children: snapshot.data!.docs.map((doc) {
                  var storeData = doc.data() as Map<String, dynamic>;
                  return SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: RestaurantCard(
                      restaurantID: doc.id,
                      restaurantName: storeData['name'] ?? 'Unknown Store',
                    ),
                  );
                }).toList(),
              );
            },
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
