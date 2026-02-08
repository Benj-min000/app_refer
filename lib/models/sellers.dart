class Sellers {
  String? sellerUID;
  String? sellerName;
  String? sellerEmail;
  String? sellerAvatar;

  Sellers({
    required this.sellerUID,
    required this.sellerName,
    required this.sellerAvatar,
    required this.sellerEmail,
  });

  Sellers.fromJson(Map<String, dynamic> json) {
    sellerUID = json["sellerUID"];
    sellerName = json["sellerName"];
    sellerAvatar = json["sellerAvatar"];
    sellerEmail = json["sellerEmail"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["sellerUID"] = sellerUID;
    data["sellerName"] = sellerName;
    data["sellerAvatar"] = sellerAvatar;
    data["sellerEmail"] = sellerEmail;
    return data;
  }
}
