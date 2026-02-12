class Items {
  String? menuID;
  String? sellerID;
  String? itemID;
  String? title;
  String? info;
  String? publishedDate;
  String? thumbnailUrl;
  String? description;
  String? status;
  double? price;

  Items(
      {this.menuID,
      this.sellerID,
      this.itemID,
      this.title,
      this.info,
      this.publishedDate,
      this.thumbnailUrl,
      this.description,
      this.status,
      this.price});

  Items.fromJson(Map<String, dynamic> json) {
    menuID = json['menuID']; 
    sellerID = json['sellerID'];
    itemID = json['itemID'];
    title = json['title'];
    info = json['info'];
    publishedDate = json['publishedDate']?.toString();
    thumbnailUrl = json['thumbnailUrl'];
    description = json['description'];
    status = json['status'];
    price = json['price'] != null ? double.parse(json['price'].toString()) : 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['menuID'] = menuID;
    data['sellerID'] = sellerID;
    data['itemID'] = itemID;
    data['title'] = title;
    data['info'] = info;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['description'] = description; 
    data['status'] = status;
    data['price'] = price;
    return data;
  }
}