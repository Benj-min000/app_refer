import 'package:flutter/material.dart';

import 'package:user_app/cake/cakeItems.dart';
import 'package:user_app/restaurent/restaurent1.dart';
import 'package:user_app/restaurent/restaurent2.dart';
import 'package:user_app/restaurent/restaurent3.dart';
import 'package:user_app/restaurent/restaurent4.dart';
import 'package:user_app/restaurent/restaurent5.dart';
import 'package:user_app/Home/HomeLargeItems.dart';
import 'package:user_app/Home/HomePageItems3.dart';
import 'package:user_app/Home/HomePageMediumItems.dart';
import 'package:user_app/Home/HomepageItems4.dart';

import "package:user_app/services/location_service.dart";
import 'package:provider/provider.dart';
import 'package:user_app/localization/locale_provider.dart';

import 'package:user_app/extensions/context_translate_ext.dart';

import 'package:user_app/Home/home_category_items.dart';
import 'package:user_app/Home/home_tabs.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _DiningPagePageState();
}

class _DiningPagePageState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  String _location = "";

  // State variable for changing the visibility of the whole address
  //  false: address in 1 line
  //  true: address in 2 or more lines
  bool _showFullAddress = false;

  // didChangeDependencies() will be creating new listeners every time it runs
  // so I've added this flag to prevent this
  bool _listenerAdded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_listenerAdded) {
      final localeProvider = Provider.of<LocaleProvider>(context);
      localeProvider.addListener(_updateAddress);
      _listenerAdded = true;
    }

    // Updating the address every thime we change the language
    _updateAddress();
  }

  void _updateAddress() async {
    setState(() {
      _location = context.t.findingLocalization;
    });
    
    final languageCode =
      Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;

    final Map<String, dynamic> addressMap = await LocationService.fetchUserLocationAddress(languageCode);

    if (mounted) {
      setState(() {
        _location = addressMap['fullAddress'] ?? context.t.errorAddressNotFound;
      });
    }
  }

  @override
  void dispose() {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    localeProvider.removeListener(_updateAddress);
    _searchController.dispose();
    super.dispose();
  }

  Widget categoryBox(HomeCategoryItem item) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.redAccent.shade100,
          child: Icon(item.icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(item.label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeCategories = getHomeCategories(context);
    final homeTabs = getHomeTabs(context);

    return DefaultTabController(
      length: 6,
      initialIndex: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location + Search
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.redAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    
                    Expanded(
                      child: Text(
                        _location,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 14, 
                          fontWeight: FontWeight.bold
                        ),

                        // Only one row of the address visible
                        maxLines: _showFullAddress ? null : 1, 
                        overflow: _showFullAddress ? TextOverflow.visible : TextOverflow.ellipsis,

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

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search),
                      hintText: context.t.hintSearch,
                      hintStyle: TextStyle(
                        fontSize: 13.5,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Horizontal TabBar
          TabBar(
            isScrollable: true,
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.redAccent,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero, 
            tabs: homeTabs.map((tab) => Tab(text: tab.label)).toList(),
          ),
          
          const SizedBox(height: 16),

          // Category Grid
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: homeCategories.map(categoryBox).toList(),
            ),
          ),

          // Your Existing Widgets (unchanged)
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
          const SizedBox(height: 100, width: double.infinity, child: HomePageItems3()),
          const SizedBox(height: 100, width: double.infinity, child: HomePageItems4()),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('IN THE SPOTLIGHT',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 126, 126, 126))),
          ),
          const SizedBox(height: 220, width: double.infinity, child: CakeItems1()),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('OUR RESTAURENTS',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 126, 126, 126))),
          ),
          
          const SizedBox(height: 300, width: double.infinity, child: Restaurent1()),
          const SizedBox(height: 300, width: double.infinity, child: Restaurent2()),
          const SizedBox(height: 300, width: double.infinity, child: Restaurent3()),
          const SizedBox(height: 300, width: double.infinity, child: Restaurent4()),
          const SizedBox(height: 300, width: double.infinity, child: Restaurent5()),

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
