import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final String googleMapsApiKey = "AIzaSyB8ddVBv7Ash6VkOqZ772T6iRM4YBh6uag";

  static Future<Map<String, dynamic>> getUserLocationAddressFromGoogle(
    double lat, 
    double lon, 
    String languageCode,
  ) async {    
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&language=$languageCode&key=$googleMapsApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final result = data['results'][0];
        final List components = result['address_components'];

        String findComponent(String type) {
          final match = components.firstWhere(
            (entry) => (entry['types'] as List).contains(type),
            orElse: () => null,
          );
          return match != null ? match['long_name'] : '';
        }

        return {
          'fullAddress': result['formatted_address'],
          'houseNumber': findComponent('street_number'),
          'subpremise': findComponent('subpremise'),
          'road': findComponent('route'),
          'city': findComponent('locality').isNotEmpty 
                  ? findComponent('locality') 
                  : findComponent('administrative_area_level_2'),
          'state': findComponent('administrative_area_level_1'),
          'postCode': findComponent('postal_code'),
          'lat': lat,
          'lng': lon,
        };
      } else {
        throw Exception('Google API Error: ${data['status']} - ${data['error_message'] ?? ''}');
      }
    } else {
      throw Exception('Server error Google Maps: ${response.statusCode}');
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

      final mapData = await getUserLocationAddressFromGoogle(position.latitude, position.longitude, languageCode);

      return {
        'fullAddress': mapData['fullAddress'],
        'houseNumber': mapData['houseNumber'],
        'subpremise': mapData['subpremise'],
        'road': mapData['road'],
        'city': mapData['city'],
        'state': mapData['state'],
        'postCode': mapData['postCode'],
        'lat': mapData['lat'],
        'lng': mapData['lng'],
      };

    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Map<String, double>?> getUserCurrentCoordinates() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high)
      );

      return {
        'lat': position.latitude,
        'lng': position.longitude,
      };
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
