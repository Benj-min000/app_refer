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
    sellerUID = json["sid"];    
    sellerName = json["name"];       
    sellerAvatar = json["avatar"]; 
    sellerEmail = json["email"];      
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["sid"] = sellerUID;
    data["name"] = sellerName;
    data["avatar"] = sellerAvatar;
    data["email"] = sellerEmail;
    return data;
  }
}