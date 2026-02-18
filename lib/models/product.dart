class Product {
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final List<String> tags;

  Product({
    required this.title, 
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.tags,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String image = json['imageUrl'] as String? ?? '';
    
    List<String> tagList = [];
    if (json['tags'] != null && json['tags'] is List) {
      tagList = (json['tags'] as List).map((e) => e.toString()).toList();
    }
        
    return Product(
      title: json['title'] as String? ?? 'Unknown Product',
      description: json['description'] as String? ?? 'No Description',
      imageUrl: image,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      tags: tagList,
    );
  }
}
