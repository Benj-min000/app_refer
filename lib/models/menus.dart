import 'package:cloud_firestore/cloud_firestore.dart';

class Menus {
  String? menuID;
  String? restaurantID;
  String? title;
  String? description;
  Timestamp? createdAt;
  String? bannerUrl;

  Menus(
      {this.menuID,
      this.restaurantID,
      this.description,
      this.title,
      this.createdAt,
      this.bannerUrl});

  Menus.fromJson(Map<String, dynamic> json) {
    menuID = json["menuID"];
    restaurantID = json["restaurantID"];
    title = json["title"];
    description = json["description"];
    bannerUrl = json["bannerUrl"];
    createdAt = json['createdAt']; 
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["menuID"] = menuID;
    data["restaurantID"] = restaurantID;
    data["title"] = title;
    data["description"] = description;
    data["createdAt"] = createdAt;
    data["bannerUrl"] = bannerUrl;
    return data;
  }
}