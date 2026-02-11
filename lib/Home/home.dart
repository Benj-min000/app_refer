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

import 'package:user_app/Home/home_category_items.dart';
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

  String _location = "";

  // State variable for changing the visibility of the whole address
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
    final homeCategories = getHomeCategories(context);
    final homeTabs = getHomeTabs(context);

    return DefaultTabController(
      length: homeTabs.length,
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
                  borderRadius: BorderRadius.circular(16),
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
                        
                        const SizedBox(width: 8,),

                        Expanded(
                          child: Tooltip(
                            message: _location,
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
                                  fontWeight: FontWeight.bold
                                ),
                                maxLines: _showFullAddress ? null : 1, 
                                overflow: _showFullAddress ? TextOverflow.visible : TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _showFullAddress = !_showFullAddress),
                          child: Icon(
                            _showFullAddress ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

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

          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: const EdgeInsets.symmetric(horizontal: 16.0), 
            labelColor: Colors.redAccent,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.redAccent,
            indicatorSize: TabBarIndicatorSize.label, 
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero, 
            tabs: homeTabs.map((tabs) => Tab(text: tabs.label)).toList(),
            onTap: (index) {
              setState(() => _selectedTabIndex = index);
            },
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 16.0, 
              right: 16.0, 
              top: 16.0, 
              bottom: 0.0, 
            ),
            child: GridView.count(
              padding: EdgeInsets.zero,
              crossAxisCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.65,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: homeCategories.map(categoryBox).toList(),
            ),
          ),

          Divider(),

          InkWell(
            onTap: () { },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Builder(
                builder: (context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.t.seeMore(homeTabs[_selectedTabIndex].label),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black54),
                    ],
                  );
                },
              ),
            ),
          ),
          Divider(),

          const SizedBox(height: 30),

          const SizedBox(height: 250, width: double.infinity, child: HomeLargeItems()),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('EXPLORE',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 126, 126, 126))),
          ),
          const SizedBox(height: 180, width: double.infinity, child: HomeMediumItems()),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('WHATS ON YOUR MIND?',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 126, 126, 126))),
          ),
          ...List.generate(homePageItemsLenght(), (index) =>
            SizedBox(
              height: 100,
              width: double.infinity, 
              child: HomePageItems(itemsIndex: index)
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('IN THE SPOTLIGHT',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 126, 126, 126))),
          ),
          const SizedBox(height: 220, width: double.infinity, child: CakeItems()),

          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('OUR RESTAURENTS',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 126, 126, 126))),
          ),
          
          ...List.generate(restaurantsListLength(), (index) => 
            SizedBox(
              height: 300, 
              width: double.infinity, 
              child: RestaurantCard(restaurantIndex: index),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('FEATURES',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 126, 126, 126))),
          ),
        ],
      ),
    );
  }
}
