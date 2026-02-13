class Menus {
  String? menuID;
  String? storeID;
  String? title;
  String? info;
  String? publishedDate;
  String? thumbnailUrl;
  String? status;

  Menus(
      {this.menuID,
      this.storeID,
      this.info,
      this.title,
      this.publishedDate,
      this.status,
      this.thumbnailUrl});

  Menus.fromJson(Map<String, dynamic> json) {
    menuID = json["menuID"];
    storeID = json["storeID"];
    title = json["title"];
    info = json["info"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
    publishedDate = json['publishedDate']?.toString(); 
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["menuID"] = menuID;
    data["storeID"] = storeID;
    data["title"] = title;
    data["info"] = info;
    data["publishedDate"] = publishedDate;
    data["thumbnailUrl"] = thumbnailUrl;
    data["status"] = status;
    return data;
  }
}
