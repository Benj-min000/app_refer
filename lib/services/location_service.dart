import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<String> getUserLocationAddressFromOSM(
    double lat, 
    double lon, 
    String languageCode
  ) async {

    final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon';
    
    final response = await http.get(
      Uri.parse(url), 
      headers: {
      'User-Agent': 'AppRefer_Flutter_App_v1.0',
      'Accept-Language': languageCode,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['display_name'];
    } 
    else {
      throw Exception('Server error OSM: ${response.statusCode}');
    }
  }

  static Future<String> fetchUserLocationAddress(String languageCode) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      return await getUserLocationAddressFromOSM(position.latitude, position.longitude, languageCode);
    } catch (e) {
      return "Unexpected error occured: $e";
    }
  }

  static Future<Map<String, dynamic>> fetchUserLocationAddressParts(String languageCode) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

    // 3. Get full address from OSM
    final fullAddress = await getUserLocationAddressFromOSM(position.latitude, position.longitude, languageCode);

    // 4. Split address into parts
    final parts = fullAddress.split(',');

    // 5. Return structured map
    return {
      'fullAddress': fullAddress,
      'flatNumber': parts.isNotEmpty ? parts[0].trim() : '',
      'city': parts.length > 1 ? parts[1].trim() : '',
      'state': parts.length > 2 ? parts[2].trim() : '',
      'lat': position.latitude,
      'lng': position.longitude,
    };
  }

}