class Items {
  String? menuID;
  String? storeID;
  String? itemID;
  String? title;
  String? info;
  String? publishedDate;
  String? thumbnailUrl;
  String? description;
  String? status;
  double? price;

  Items({
    this.menuID,
    this.storeID,
    this.itemID,
    this.title,
    this.info,
    this.publishedDate,
    this.thumbnailUrl,
    this.description,
    this.status,
    this.price,
  });

  Items.fromJson(Map<String, dynamic> json) {
    menuID = json['menuID'];
    storeID = json['storeID'];
    itemID = json['itemID'];
    title = json['title'];
    info = json['info'];
    publishedDate = json['publishedDate']?.toString();
    thumbnailUrl = json['thumbnailUrl'];
    description = json['description'];
    status = json['status'];
    
    // Safe price parsing
    if (json['price'] != null) {
      if (json['price'] is String) {
        price = double.tryParse(json['price']) ?? 0.0;
      } else if (json['price'] is num) {
        price = (json['price'] as num).toDouble();
      } else {
        price = 0.0;
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'menuID': menuID,
      'storeID': storeID,
      'itemID': itemID,
      'title': title,
      'info': info,
      'publishedDate': publishedDate,
      'thumbnailUrl': thumbnailUrl,
      'description': description,
      'status': status,
      'price': price,
    };
  }

  String get formattedPrice => price?.toStringAsFixed(2) ?? '0.00';
}