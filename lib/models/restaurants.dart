class Restaurants {
  String? restaurantID;
  String? name;
  String? email;
  String? imageUrl;

  Restaurants({
    required this.restaurantID,
    required this.name,
    required this.imageUrl,
    required this.email,
  });

  Restaurants.fromJson(Map<String, dynamic> json) {
    restaurantID = json["restaurantID"];    
    name = json["name"];       
    imageUrl = json["imageUrl"]; 
    email = json["email"];      
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["restaurantID"] = restaurantID;
    data["name"] = name;
    data["imageUrl"] = imageUrl;
    data["email"] = email;
    return data;
  }
}