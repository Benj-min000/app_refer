import 'package:algoliasearch/algoliasearch_lite.dart';
import 'package:flutter/material.dart';
import 'package:user_app/search/search_tabs.dart';

// Product model
class Product {
  final String title;
  final String productType;
  final String imageUrl;
  final double price;
  final List<String> tags;
  final List<String> colors;

  Product({
    required this.title, 
    required this.productType,
    required this.imageUrl,
    required this.price,
    required this.tags,
    required this.colors,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String image = '';
    if (json['showcase_image'] != null) {
      image = json['showcase_image'] as String;
    } else if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      image = (json['images'] as List)[0] as String;
    }
    
    List<String> tagList = [];
    if (json['tags'] != null && json['tags'] is List) {
      tagList = (json['tags'] as List).map((e) => e.toString()).toList();
    }
    
    List<String> colorList = [];
    if (json['color'] != null && json['color'] is List) {
      colorList = (json['color'] as List).map((e) => e.toString()).toList();
    }
    
    return Product(
      title: json['title'] as String? ?? 'Unknown Product',
      productType: json['product_type'] as String? ?? 'Unknown',
      imageUrl: image,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      tags: tagList,
      colors: colorList,
    );
  }
}

class SearchScreen extends StatefulWidget {
  final String initialText;
  const SearchScreen({super.key, required this.initialText});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  int _selectedTabIndex = 0;
  
  // Algolia client
  late final SearchClient _client;
  
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  int _totalHits = 0;
  int _processingTime = 0;

  final List<String> _selectedCategories = [];
  RangeValues _currentPriceRange = const RangeValues(0, 500);
  final List<String> _availableCategories = ['Tops', 'Pants', 'Shoes', 'Accessories'];

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController(text: widget.initialText);
    
    // Move cursor to the end so they can keep typing
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: _searchController.text.length),
    );
    
    // Initialize Algolia client
    _client = SearchClient(
      appId: 'DCUBTIDH8J',
      apiKey: 'a9d70af22ed10f59f9fbff713de5b4da',
    );
    
    // Perform initial search
    _performSearch(widget.initialText);
  }

  String _buildFilterString() {
    List<String> filters = [];

    if (_selectedCategories.isNotEmpty) {
      final catFilter = _selectedCategories.map((c) => 'product_type:"$c"').join(' OR ');
      filters.add('($catFilter)');
    }

    filters.add('price:${_currentPriceRange.start.round()} TO ${_currentPriceRange.end.round()}');
    
    String finalFilter = filters.join(' AND ');
    print("Generated Filter String: $finalFilter");
    return filters.join(' AND ');
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final searchQuery = SearchForHits(
        indexName: 'algolia_apparel_sample_dataset',
        query: query,
        hitsPerPage: 20,
        filters: _buildFilterString(),
      );

      final response = await _client.searchIndex(request: searchQuery);

      final products = response.hits
          .map((hit) => Product.fromJson(hit))
          .toList();

      setState(() {
        _products = products;
        _totalHits = response.nbHits ?? 0;
        _processingTime = response.processingTimeMS ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
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
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  size: 24, 
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
            title: const Text(
              "I-Eat",
              style: TextStyle(fontFamily: "Signatra", fontSize: 40),
            ),
            centerTitle: true,
            automaticallyImplyLeading: true,
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
                  setState(() => _selectedTabIndex = index);
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
        print('Building item $index: ${product.title} | \$${product.price}');
        
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
                      print('Image error for ${product.title}: $error');
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
                product.productType.toUpperCase(),
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
                  if (product.colors.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(
                      '• ${product.colors.join(", ")}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
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
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Filters", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
            );
          },
        );
      },
    );
  }
}
