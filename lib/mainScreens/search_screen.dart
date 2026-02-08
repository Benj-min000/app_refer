import 'package:algoliasearch/algoliasearch_lite.dart';
import 'package:flutter/material.dart';

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
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  
  // Algolia client
  late final SearchClient _client;
  
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  int _totalHits = 0;
  int _processingTime = 0;

  @override
  void initState() {
    super.initState();
    
    // Initialize Algolia client
    _client = SearchClient(
      appId: 'DCUBTIDH8J',
      apiKey: 'a9d70af22ed10f59f9fbff713de5b4da',
    );
    
    // Perform initial search
    _performSearch('');
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('Searching for: "$query"');
      
      // Create search query
      final searchQuery = SearchForHits(
        indexName: 'algolia_apparel_sample_dataset',
        query: query,
        hitsPerPage: 20,
      );

      final response = await _client.searchIndex(request: searchQuery);

      print('[x] Got ${response.nbHits} hits in ${response.processingTimeMS}ms');

      // Parse results
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
      print('Error: $e');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Algolia Search Test'),
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
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

          // Stats
          if (!_isLoading && _error == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '$_totalHits results (${_processingTime}ms)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),

          const SizedBox(height: 8),

          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
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
}
