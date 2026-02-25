class Menus {
  String? menuID;
  String? restaurantID;
  String? title;
  String? description;
  String? publishedDate;
  String? bannerUrl;

  Menus(
      {this.menuID,
      this.restaurantID,
      this.description,
      this.title,
      this.publishedDate,
      this.bannerUrl});

  Menus.fromJson(Map<String, dynamic> json) {
    menuID = json["menuID"];
    restaurantID = json["restaurantID"];
    title = json["title"];
    description = json["description"];
    bannerUrl = json["bannerUrl"];
    publishedDate = json['publishedDate']?.toString(); 
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["menuID"] = menuID;
    data["restaurantID"] = restaurantID;
    data["title"] = title;
    data["description"] = description;
    data["publishedDate"] = publishedDate;
    data["bannerUrl"] = bannerUrl;
    return data;
  }
}
