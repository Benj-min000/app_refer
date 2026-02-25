class Items {
  String? menuID;
  String? restaurantID;
  String? itemID;
  String? title;
  String? shortInfo;
  String? publishedDate;
  String? imageUrl;
  String? description;
  String? status;
  String? restaurantStatus;
  double? price;
  double? discount; 
  List<String>? tags;
  int? likes;

  Items({
    this.menuID,
    this.restaurantID,
    this.itemID,
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.imageUrl,
    this.description,
    this.status,
    this.restaurantStatus,
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
    restaurantID = json['restaurantID'];
    itemID = json['itemID'];
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate']?.toString();
    imageUrl = json['imageUrl'];
    description = json['description'];
    status = json['status'];
    restaurantStatus = json['restaurantStatus'];
    tags =  json['tags'] != null ? List<String>.from(json['tags']) : null;
    likes = json['likes'] ?? 0;
    discount = json['discount']?.toDouble();
    price = json['price']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'menuID': menuID,
      'restaurantID': restaurantID,
      'itemID': itemID,
      'title': title,
      'shortInfo': shortInfo,
      'publishedDate': publishedDate,
      'imageUrl': imageUrl,
      'description': description,
      'status': status,
      'restaurantStatus': restaurantStatus,
      'price': price,
      'discount': discount,
      'tags': tags,
      'likes': likes,
    };
  }
}