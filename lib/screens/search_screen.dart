import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:algoliasearch/algoliasearch_lite.dart';

import 'package:user_app/widgets/search_tabs.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/widgets/my_drower.dart';
import 'package:user_app/widgets/unified_bottom_bar.dart';

import 'package:user_app/screens/home_screen.dart';
import 'package:user_app/screens/orders_screen.dart';
import 'package:user_app/screens/favorites_screen.dart';
import 'package:user_app/screens/menus_screen.dart';
import 'package:user_app/screens/item_details_screen.dart';

import 'package:user_app/models/items.dart';
import 'package:user_app/models/restaurants.dart';
import 'package:user_app/widgets/cart_icon.dart';

class SearchScreen extends StatefulWidget {
  final String initialText;
  const SearchScreen({super.key, required this.initialText});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const String _algoliaAppId = String.fromEnvironment("ALGOLIA_APP_ID");
  static const String _algoliaApiKey = String.fromEnvironment("ALGOLIA_API_KEY");
  static const String _algoliaRestaurantIndex = String.fromEnvironment("ALGOLIA_RESTAURANT_INDEX");
  static const String _algoliaItemIndex = String.fromEnvironment("ALGOLIA_ITEM_INDEX");

  String get appId => _algoliaAppId.isNotEmpty ? _algoliaAppId : throw Exception("ALGOLIA_APP_ID is not defined.");
  String get apiKey => _algoliaApiKey.isNotEmpty ? _algoliaApiKey : throw Exception("ALGOLIA_API_KEY is not defined.");
  String get restaurantIndex => _algoliaRestaurantIndex.isNotEmpty ? _algoliaRestaurantIndex : throw Exception("ALGOLIA_RESTAURANT_INDEX is not defined.");
  String get itemIndex => _algoliaItemIndex.isNotEmpty ? _algoliaItemIndex : throw Exception("ALGOLIA_ITEM_INDEX is not defined.");

  int _currentPageIndex = 2;
  late TextEditingController _searchController;
  late final SearchClient _client;

  // 0 = All, 1 = Restaurants, 2 = Items
  int _selectedTabIndex = 0;

  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;
  String? _error;
  int _totalHits = 0;
  int _processingTime = 0;

  final List<String> _selectedCategories = [];
  RangeValues _currentPriceRange = const RangeValues(0, 500);
  List<String> _availableCategories = [];
  List<String> _availableItemCategories = [];
  List<String> _availableRestaurantCategories = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialText);
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: _searchController.text.length),
    );
    _client = SearchClient(appId: appId, apiKey: apiKey);
    _performSearch(widget.initialText);
  }

  String _buildItemFilterString() {
    List<String> filters = [];

    filters.add('restaurantStatus:Active');

    final itemTags = _selectedCategories.where((c) => _availableItemCategories.contains(c)).toList();
    
    
    if (itemTags.isNotEmpty) {
      filters.add('(${itemTags.map((c) => 'tags:"$c"').join(' OR ')})');
    }
    filters.add('price:${_currentPriceRange.start.round()} TO ${_currentPriceRange.end.round()}');
    return filters.join(' AND ');
  }

  String _buildRestaurantFilterString() {
    List<String> filters = [];
    filters.add('status:Active');

    final restaurantNames = _selectedCategories.where((c) => _availableRestaurantCategories.contains(c)).toList();
    
    if (restaurantNames.isNotEmpty) {
      filters.add('(${restaurantNames.map((c) => 'name:"$c"').join(' OR ')})');
    }
    return filters.join(' AND ');
  }

  void _clearAllFilters({VoidCallback? onComplete}) {
    setState(() {
      _selectedCategories.clear();
      _currentPriceRange = const RangeValues(0, 500);
    });
    _performSearch(_searchController.text).then((_) {
      onComplete?.call();
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      List<Map<String, dynamic>> combined = [];
      int totalHits = 0;
      int processingTime = 0;

      if (_selectedTabIndex == 0 || _selectedTabIndex == 2) {
        // Search items index
        final itemResponse = await _client.searchIndex(
          request: SearchForHits(
            indexName: itemIndex,
            query: query,
            hitsPerPage: _selectedTabIndex == 0 ? 10 : 20,
            filters: _buildItemFilterString(),
            facets: ['tags'],
          ),
        );
        for (final hit in itemResponse.hits) {
          combined.add({
            ...hit, 
            '_type': 'item',
            'objectID': hit.objectID,
          });
        }
        totalHits += itemResponse.nbHits ?? 0;
        processingTime = itemResponse.processingTimeMS ?? 0;
        if (itemResponse.facets?['tags'] != null) {
          _availableItemCategories = itemResponse.facets!['tags']!.keys.toList();
        }
      }

      if (_selectedTabIndex == 0 || _selectedTabIndex == 1) {
        // Search restaurants index
        final restaurantResponse = await _client.searchIndex(
          request: SearchForHits(
            indexName: restaurantIndex,
            query: query,
            hitsPerPage: _selectedTabIndex == 0 ? 10 : 20,
            filters: _buildRestaurantFilterString(),
            facets: ['name'],
          ),
        );
        for (final hit in restaurantResponse.hits) {
          combined.add({
            ...hit,
            '_type': 'restaurant',
            'objectID': hit.objectID,
          });
        }
        totalHits += restaurantResponse.nbHits ?? 0;
        if (processingTime == 0) processingTime = restaurantResponse.processingTimeMS ?? 0;
        if (restaurantResponse.facets?['name'] != null) {
          _availableRestaurantCategories = restaurantResponse.facets!['name']!.keys.toList();
        }
      }

      setState(() {
        _results = combined;
        _totalHits = totalHits;
        _processingTime = processingTime;
        _isLoading = false;
        // Merge both for All tab
        if (_selectedTabIndex == 0) {
          _availableCategories = {..._availableItemCategories, ..._availableRestaurantCategories}.toList();
        } else if (_selectedTabIndex == 1) {
          _availableCategories = _availableRestaurantCategories;
        } else {
          _availableCategories = _availableItemCategories;
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onResultTap(Map<String, dynamic> result) {
    final type = result['_type'] as String;

    if (type == 'item') {
      final item = Items.fromJson(result);
      final itemID = (result['objectID'] ?? result['itemID'] ?? '') as String;

      if (itemID.isEmpty) {
        Fluttertoast.showToast(msg: "Item ID missing");
        return;
      }

      item.itemID  = itemID;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItemDetailsScreen(model: item),
        ),
      );
    } else if (type == 'restaurant') {
      final restaurantID = (result['objectID'] ?? result['restaurantID'] ?? '') as String;
        
      if (restaurantID.isEmpty) {
        Fluttertoast.showToast(msg: "Restaurant ID missing");
        return;
      }

      final restaurant = Restaurants(
        restaurantID: restaurantID,
        name: result['name'] ?? '',
        logoUrl: result['imageUrl'] ?? '',
        bannerUrl: result['bannerUrl'] ?? '',
        email: result['email'] ?? '',
        status: result['status'] ?? '',
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MenusScreen(model: restaurant),
        ),
      );
    }
  }

  void _onBottomNavTap(int index) {
    if (index == _currentPageIndex) return;
    setState(() => _currentPageIndex = index);
    final Map<int, Widget> routes = {
      0: const HomeScreen(),
      1: const OrdersScreen(),
      3: const FavoritesScreen(),
    };
    if (routes.containsKey(index)) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => routes[index]!));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _client.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchTabs = getSearchTabs(context);

    return DefaultTabController(
      length: searchTabs.length,
      child: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: UnifiedAppBar(
            title: "Search!",
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu_open,
                  color: Colors.white,
                  size: 28,
                  shadows: [Shadow(color: Colors.black.withValues(alpha: 0.3), offset: const Offset(2, 2), blurRadius: 6)],
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              const CartIconWidget(),
            ],
          ),
          drawer: MyDrawer(),
          bottomNavigationBar: UnifiedBottomNavigationBar(
            currentIndex: _currentPageIndex,
            onTap: _onBottomNavTap,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4, top: 16, right: 16, left: 16),
                      child: TextField(
                        autofocus: true,
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search restaurants or items...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _performSearch('');
                                  },
                                )
                              : null,
                        ),
                        onChanged: (value) {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            if (_searchController.text == value) _performSearch(value);
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 8),
                    child: IconButton(
                      onPressed: _showFilterBottomSheet,
                      icon: const Icon(Icons.tune, color: Colors.black, size: 32),
                    ),
                  ),
                ],
              ),
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                labelColor: Colors.redAccent,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.redAccent,
                indicatorSize: TabBarIndicatorSize.label,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.zero,
                tabs: searchTabs.map((t) => Tab(text: t.label)).toList(),
                onTap: (index) {
                  setState(() => _selectedTabIndex = index);
                  _performSearch(_searchController.text);
                },
              ),
              const SizedBox(height: 16),
              if (!_isLoading && _error == null)
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    '$_totalHits results (${_processingTime}ms)',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, wordSpacing: 4),
                  ),
                ),
              const SizedBox(height: 8),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Searching...')],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => _performSearch(_searchController.text), child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.search_off, size: 64, color: Colors.grey), SizedBox(height: 16), Text('No results found')],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final result = _results[index];
        final type = result['_type'] as String;
        final imageUrl = (result['imageUrl'] as String?) ?? '';
        final title = (result['title'] ?? result['name'] ?? '') as String;
        final subtitle = type == 'item'
            ? (result['description'] ?? '') as String
            : (result['description'] ?? '') as String;
        final price = result['price'];

        return GestureDetector(
          onTap: () => _onResultTap(result),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.grey[50],
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: 100,
                              height: 110,
                              fit: BoxFit.cover,
                            )
                          : _imageFallback(),
                      ),
                      if ((result['discount'] ?? 0) > 0)
                        Positioned(
                          top: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${(result['discount'] as num).toInt()}% OFF',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // title + badge row
                        Row(
                          children: [
                            Expanded(
                              child: Text(title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: type == 'item' ? Colors.orange[50] : Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: type == 'item' ? Colors.orange : Colors.green),
                              ),
                              child: Text(
                                type == 'item' ? 'Item' : 'Restaurant',
                                style: TextStyle(fontSize: 10, color: type == 'item' ? Colors.orange[800] : Colors.green[800]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(subtitle.toUpperCase(),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                        if (price != null) ...[
                          const SizedBox(height: 4),
                          Text('\$${(price as num).toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                        if (result['tags'] != null) ...[
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: (result['tags'] as List).take(3).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.blue[200]!),
                                ),
                                child: Text(tag.toString(), style: TextStyle(fontSize: 10, color: Colors.blue[700])),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _imageFallback() => Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.image_not_supported),
      );

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Filters", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    onPressed: () {
                      setModalState(() {
                        _selectedCategories.clear();
                        _currentPriceRange = const RangeValues(0, 500);
                      });
                      _clearAllFilters(onComplete: () {
                        setModalState(() {});
                      });
                    },
                    icon: const Icon(Icons.refresh, size: 18, color: Colors.redAccent),
                    label: const Text("Reset All", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      elevation: 0,
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                _selectedTabIndex == 1 ? "Names" : "Categories",
                style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: _availableCategories.map((cat) {
                  final isSelected = _selectedCategories.contains(cat);
                  return FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      setModalState(() => val ? _selectedCategories.add(cat) : _selectedCategories.remove(cat));
                    },
                  );
                }).toList(),
              ),
              if (_selectedTabIndex != 1) ...[
                const SizedBox(height: 20),
                Text("Price Range: \$${_currentPriceRange.start.round()} - \$${_currentPriceRange.end.round()}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                RangeSlider(
                  values: _currentPriceRange,
                  min: 0,
                  max: 500,
                  divisions: 10,
                  onChanged: (values) => setModalState(() => _currentPriceRange = values),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: () { Navigator.pop(context); _performSearch(_searchController.text); },
                  child: const Text("Apply Filters", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}