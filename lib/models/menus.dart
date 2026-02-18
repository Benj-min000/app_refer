class Menus {
  String? menuID;
  String? restaurantID;
  String? title;
  String? info;
  String? publishedDate;
  String? imageUrl;
  String? status;

  Menus(
      {this.menuID,
      this.restaurantID,
      this.info,
      this.title,
      this.publishedDate,
      this.status,
      this.imageUrl});

  Menus.fromJson(Map<String, dynamic> json) {
    menuID = json["menuID"];
    restaurantID = json["restaurantID"];
    title = json["title"];
    info = json["info"];
    imageUrl = json["imageUrl"];
    status = json["status"];
    publishedDate = json['publishedDate']?.toString(); 
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["menuID"] = menuID;
    data["restaurantID"] = restaurantID;
    data["title"] = title;
    data["info"] = info;
    data["publishedDate"] = publishedDate;
    data["imageUrl"] = imageUrl;
    data["status"] = status;
    return data;
  }
}
