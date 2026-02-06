class Address {
  String? label;
  String? road;
  String? houseNumber;
  String? flatNumber;
  String? postalCode;
  String? city;
  String? state;
  String? country;
  String? fullAddress;
  String? lat;
  String? lng;

  Address({
    this.label,
    this.road,
    this.houseNumber,
    this.flatNumber,
    this.postalCode,
    this.city,
    this.state,
    this.country,
    this.fullAddress,
    this.lat,
    this.lng,
  });

  Address copyWith({
    String? label,
    String? road,
    String? houseNumber,
    String? flatNumber,
    String? postalCode,
    String? city,
    String? state,
    String? country,
    String? fullAddress,
    String? lat,
    String? lng,
  }) {
    return Address(
      label: label ?? this.label,
      road: road ?? this.road,
      houseNumber: houseNumber ?? this.houseNumber,
      flatNumber: flatNumber ?? this.flatNumber,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      fullAddress: fullAddress ?? this.fullAddress,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Address.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    road = json['road'] ?? json['street'] ?? json['route'];
    flatNumber = json['flatNumber'];
    houseNumber = json['houseNumber'];
    postalCode = json['postalCode'] ?? json['postcode'] ?? json['zip_code'];
    city = json['city'];
    state = json['state'];
    country = json['country'] ?? "Poland";
    fullAddress = json['fullAddress'];
    lat = json['lat']?.toString();
    lng = json['lng']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['label'] = label;
    data['road'] = road;
    data['houseNumber'] = houseNumber;
    data['flatNumber'] = flatNumber;
    data['postalCode'] = postalCode; 
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['fullAddress'] = fullAddress;
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}