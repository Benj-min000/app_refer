class Stores {
  String? storeID;
  String? name;
  String? email;
  String? avatar;

  Stores({
    required this.storeID,
    required this.name,
    required this.avatar,
    required this.email,
  });

  Stores.fromJson(Map<String, dynamic> json) {
    storeID = json["storeID"];    
    name = json["name"];       
    avatar = json["avatar"]; 
    email = json["email"];      
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["storeID"] = storeID;
    data["name"] = name;
    data["avatar"] = avatar;
    data["email"] = email;
    return data;
  }
}