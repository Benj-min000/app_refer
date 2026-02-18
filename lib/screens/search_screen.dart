import 'package:algoliasearch/algoliasearch_lite.dart';
import 'package:flutter/material.dart';
import 'package:user_app/search/search_tabs.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/widgets/my_drower.dart';
import 'package:user_app/screens/home_screen.dart';
import 'package:user_app/screens/orders_screen.dart';
import "package:user_app/screens/favorites_screen.dart";
import 'package:user_app/widgets/unified_bottom_bar.dart';
import 'package:user_app/models/product.dart';


class SearchScreen extends StatefulWidget {
  final String initialText;
  const SearchScreen({super.key, required this.initialText});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const String _algoliaAppId = String.fromEnvironment("ALGOLIA_APP_ID");
  static const String _algoliaApiKey = String.fromEnvironment("ALGOLIA_API_KEY");
  static const String _algoliaIndexName = String.fromEnvironment("ALGOLIA_INDEX_NAME");

  int _currentPageIndex = 2;
  late TextEditingController _searchController;
  late final SearchClient _client;

  int _selectedTabIndex = 0;
  
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  int _totalHits = 0;
  int _processingTime = 0;

  final List<String> _selectedCategories = [];
  RangeValues _currentPriceRange = const RangeValues(0, 500);
  List<String> _availableCategories = [];

  String get appId {
    if (_algoliaAppId.isEmpty) {
      throw Exception("ALGOLIA_APP_ID is not defined. Ensure you passed it via --dart-define.");
    }
    return _algoliaAppId;
  }

  String get apiKey {
    if (_algoliaApiKey.isEmpty) {
      throw Exception("ALGOLIA_API_KEY is not defined. Ensure you passed it via --dart-define.");
    }
    return _algoliaApiKey;
  }

  String get indexName {
    if (_algoliaIndexName.isEmpty) {
      throw Exception("ALGOLIA_INDEX_NAME is not defined. Ensure you passed it via --dart-define.");
    }
    return _algoliaIndexName;
  }

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

  String _buildFilterString() {
    List<String> filters = [];

    switch(_selectedTabIndex) {
      case 1: filters.add('type:Restaurant'); break;
      case 2: filters.add('type:Food'); break;
      case 3: filters.add('type:Store'); break;
    }

    if (_selectedCategories.isNotEmpty) {
      final catFilter = _selectedCategories.map((c) => 'tags:"$c"').join(' OR ');
      filters.add('($catFilter)');
    }

    filters.add('price:${_currentPriceRange.start.round()} TO ${_currentPriceRange.end.round()}');
    
    String finalFilter = filters.join(' AND ');
    debugPrint("Generated Filter String: $finalFilter");
    return filters.join(' AND ');
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategories.clear();
      _currentPriceRange = const RangeValues(0, 500);
    });
    _performSearch(_searchController.text);
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final searchQuery = SearchForHits(
        indexName: indexName,
        query: query,
        hitsPerPage: 20,
        filters: _buildFilterString(),
        facets: ['tags'],
      );

      final response = await _client.searchIndex(request: searchQuery);

      final products = response.hits
          .map((hit) => Product.fromJson(hit))
          .toList();

      List<String> dynamicTags = [];
      if (response.facets != null && response.facets!['tags'] != null) {
        dynamicTags = response.facets!['tags']!.keys.toList();
      }

      setState(() {
        _products = products;
        _totalHits = response.nbHits ?? 0;
        _processingTime = response.processingTimeMS ?? 0;
        _isLoading = false;

        if (_availableCategories.isEmpty || _selectedCategories.isEmpty) {
          _availableCategories = dynamicTags;
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => routes[index]!),
      );
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
              builder: (context) {
                return IconButton(
                  icon: Icon(
                    Icons.menu_open, 
                    color: Colors.white,
                    size: 28, 
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        offset: Offset(2.0, 2.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.shopping_bag,
                  size: 28, 
                  color: Colors.white, 
                  shadows: [
                    Shadow(
                      color: Colors.pink.withValues(alpha: 0.3),
                      offset: const Offset(1.0, 1.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                onPressed: () {
                  
                },
              ),
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
              // Search box
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4, top: 16, right: 16, left: 16),
                      child: TextField(
                        autofocus: true,
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                          // Debounce search - wait 500ms after user stops typing
                          Future.delayed(const Duration(milliseconds: 500), () {
                            if (_searchController.text == value) {
                              _performSearch(value);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 8),
                    child: IconButton(
                      onPressed: () => _showFilterBottomSheet(), 
                      icon: const Icon(
                        Icons.tune, 
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                  ),
                ],
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
                tabs: searchTabs.map((tabs) => Tab(text: tabs.label)).toList(),
                onTap: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                  _performSearch(_searchController.text);
                },
              ),

              const SizedBox(height: 16,),

              // Stats
              if (!_isLoading && _error == null)
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    '$_totalHits results (${_processingTime}ms)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 4,
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              // Content
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // Loading state
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Searching...'),
          ],
        ),
      );
    }

    // Error state
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _performSearch(_searchController.text),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No products found'),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _products.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final product = _products[index];
        // Only for debug
        debugPrint('Building item $index: ${product.title} | \$${product.price}');
        
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: product.imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        width: 80,
                        height: 80,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // Error when getting the image
                      debugPrint('Image error for ${product.title}: $error');
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                )
              : Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.checkroom, size: 40),
                ),
          title: Text(
            product.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                product.description.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              if (product.tags.isNotEmpty) ...[
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: product.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue[700],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                      _clearAllFilters();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.refresh, size: 18, color: Colors.redAccent),
                    label: const Text(
                      "Reset All",
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.redAccent,
                      elevation: 0,
                      side: const BorderSide(color: Colors.redAccent, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Categories", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: _availableCategories.map((cat) {
                  final isSelected = _selectedCategories.contains(cat);
                  return FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) {
                      setModalState(() {
                        val ? _selectedCategories.add(cat) : _selectedCategories.remove(cat);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text("Price Range: \$${_currentPriceRange.start.round()} - \$${_currentPriceRange.end.round()}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              RangeSlider(
                values: _currentPriceRange,
                min: 0,
                max: 500,
                divisions: 10,
                onChanged: (values) {
                  setModalState(() => _currentPriceRange = values);
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: () {
                    Navigator.pop(context);
                    _performSearch(_searchController.text);
                  },
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
