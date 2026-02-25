class Restaurants {
  String? restaurantID;
  String? name;
  String? email;
  String? logoUrl;
  String? bannerUrl;
  String? status;

  Restaurants({
    required this.restaurantID,
    required this.name,
    required this.logoUrl,
    required this.bannerUrl,
    required this.email,
    required this.status,
  });

  Restaurants.fromJson(Map<String, dynamic> json) {
    restaurantID = json["restaurantID"];    
    name = json["name"];       
    logoUrl = json["logoUrl"];
    bannerUrl = json["bannerUrl"];  
    email = json["email"];
    status = json["status"];  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["restaurantID"] = restaurantID;
    data["name"] = name;
    data["logoUrl"] = logoUrl;
    data["bannerUrl"] = bannerUrl;
    data["email"] = email;
    data["status"] = status;
    return data;
  }
}