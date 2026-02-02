import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<String> getCurrentAddressFromOSM(
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

  static Future<String> fetchCurrentAddress(String languageCode) async {
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

      return await getCurrentAddressFromOSM(position.latitude, position.longitude, languageCode);
    } catch (e) {
      return "Unexpected error occured: $e";
    }
  }
}