class Address {
  String? label;
  String? houseNumber;
  String? flatNumber;
  String? city;
  String? state;
  String? fullAddress;
  String? lat;
  String? lng;

  Address(
      {this.label,
      this.houseNumber,
      this.flatNumber,
      this.city,
      this.state,
      this.fullAddress,
      this.lat, 
      this.lng});

  Address.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    flatNumber = json['flatNumber'];
    houseNumber = json['houseNumber'];
    city = json['city'];
    state = json['state'];
    fullAddress = json['fullAddress'];
    lat = json['lat'];
    lng = json['lng'];
  }

  String get longitude => '';

  String get lattitude => '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['label'] = label;
    data['houseNumber'] = houseNumber;
    data['flatNumber'] = flatNumber;
    data['city'] = city;
    data['state'] = state;
    data['fullAddress'] = fullAddress;
    data['lat'] = lat;
    data['lng'] = lng;

    return data;
  }
}
