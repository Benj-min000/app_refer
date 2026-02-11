class Menus {
  String? menuID;
  String? sellerID;
  String? title;
  String? info;
  String? publishedDate;
  String? thumbnailUrl;
  String? status;

  Menus(
      {this.menuID,
      this.sellerID,
      this.info,
      this.title,
      this.publishedDate,
      this.status,
      this.thumbnailUrl});

  Menus.fromJson(Map<String, dynamic> json) {
    menuID = json["menuID"];
    sellerID = json["sellerID"];
    title = json["title"];
    info = json["info"];
    thumbnailUrl = json["thumbnailUrl"];
    status = json["status"];
    publishedDate = json['publishedDate']?.toString(); 
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["menuID"] = menuID;
    data["sellerID"] = sellerID;
    data["title"] = title;
    data["info"] = info;
    data["publishedDate"] = publishedDate;
    data["thumbnailUrl"] = thumbnailUrl;
    data["status"] = status;
    return data;
  }
}
