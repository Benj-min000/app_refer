import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Map<String, dynamic>> getUserLocationAddressFromOSM(
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
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      // The 'address' field in OSM is a nested Map with clean keys
      final addressInfo = data['address'] as Map<String, dynamic>;

      return {
        'fullAddress': data['display_name'], // The long string
        'houseNumber': addressInfo['house_number'] ?? '',
        'road': addressInfo['road'] ?? '',
        'city': addressInfo['city'] ?? addressInfo['town'] ?? addressInfo['village'] ?? '',
        'state': addressInfo['state'] ?? '',
        'postcode': addressInfo['postcode'] ?? '',
      };
    } else {
      throw Exception('Server error OSM: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> fetchUserLocationAddress(String languageCode) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw "Location services are disabled. Please turn on GPS.";
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw "Location permissions are denied.";
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw "Location permissions are permanently denied. We cannot fetch your address.";
      }

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      
      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

      final osmData = await getUserLocationAddressFromOSM(position.latitude, position.longitude, languageCode);

      return {
        'fullAddress': osmData['fullAddress'],
        'houseNumber': osmData['houseNumber'],
        'road': osmData['road'],
        'city': osmData['city'],
        'state': osmData['state'],
        'lat': position.latitude,
        'lng': position.longitude,
      };

    } catch (e) {
      throw Exception(e.toString());
    }
  }
}