class Items {
  String? menuID;
  String? storeID;
  String? itemID;
  String? title;
  String? info;
  String? publishedDate;
  String? imageUrl;
  String? description;
  String? status;
  double? price;
  double? discount; 
  List<String>? tags;
  int? likes;

  Items({
    this.menuID,
    this.storeID,
    this.itemID,
    this.title,
    this.info,
    this.publishedDate,
    this.imageUrl,
    this.description,
    this.status,
    this.price,
    this.discount,
    this.tags,
    this.likes,
  });

  double get discountedPrice {
    if (price == null || discount == null || discount == 0) {
      return price ?? 0.0;
    }
    return price! * (1 - discount! / 100);
  }
  
  bool get hasDiscount {
    return discount != null && discount! > 0;
  }
  
  double get savedAmount {
    if (price == null || discount == null || discount == 0) {
      return 0.0;
    }
    return price! * (discount! / 100);
  }

  Items.fromJson(Map<String, dynamic> json) {
    menuID = json['menuID'];
    storeID = json['storeID'];
    itemID = json['itemID'];
    title = json['title'];
    info = json['info'];
    publishedDate = json['publishedDate']?.toString();
    imageUrl = json['imageUrl'];
    description = json['description'];
    status = json['status'];
    tags =  json['tags'] != null ? List<String>.from(json['tags']) : null;
    likes = json['likes'] ?? 0;
    discount = json['discount']?.toDouble();
    price = json['price']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'menuID': menuID,
      'storeID': storeID,
      'itemID': itemID,
      'title': title,
      'info': info,
      'publishedDate': publishedDate,
      'imageUrl': imageUrl,
      'description': description,
      'status': status,
      'price': price,
      'discount': discount,
      'tags': tags,
      'likes': likes,
    };
  }
}