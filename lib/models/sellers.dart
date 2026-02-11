class Sellers {
  String? sellerID;
  String? name;
  String? email;
  String? avatar;

  Sellers({
    required this.sellerID,
    required this.name,
    required this.avatar,
    required this.email,
  });

  Sellers.fromJson(Map<String, dynamic> json) {
    sellerID = json["sellerID"];    
    name = json["name"];       
    avatar = json["avatar"]; 
    email = json["email"];      
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["sellerID"] = sellerID;
    data["name"] = name;
    data["avatar"] = avatar;
    data["email"] = email;
    return data;
  }
}