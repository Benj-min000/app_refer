import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class LocationService {
  static String get googleMapsApiKey {
    const key = String.fromEnvironment("MAPS_API_KEY");
    if (key.isEmpty) {
      throw Exception("MAPS_API_KEY is not defined. Ensure you passed it via --dart-define.");
    }
    return key;
  }

  static Future<Map<String, dynamic>> getUserLocationAddressFromGoogle(
    double lat, 
    double lon,
    {String langCode = 'en'}
  ) async { 
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&language=$langCode&key=$googleMapsApiKey';
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

        String city = findComponent('locality');
        if (city.isEmpty) {
          city = findComponent('sublocality');
        }
        if (city.isEmpty) {
          city = findComponent('administrative_area_level_2');
        }

        return {
          'fullAddress': result['formatted_address'],
          'houseNumber': findComponent('street_number'),
          'flatNumber': findComponent('subpremise'),
          'subpremise': findComponent('subpremise'),
          'road': findComponent('route'),
          'city': city,
          'state': findComponent('administrative_area_level_1'),
          'country': findComponent('country'),
          'postalCode': findComponent('postal_code'),
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

  static Future<Map<String, dynamic>> fetchUserCurrentLocation({String langCode = 'en'}) async {
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

      final mapData = await getUserLocationAddressFromGoogle(
        position.latitude, 
        position.longitude, 
        langCode: langCode
      );

      return {
        'fullAddress': mapData['fullAddress'],
        'houseNumber': mapData['houseNumber'],
        'flatNumber': mapData['flatNumber'],
        'subpremise': mapData['subpremise'],
        'road': mapData['road'],
        'city': mapData['city'],
        'state': mapData['state'],
        'country': mapData['country'],
        'postalCode': mapData['postalCode'],
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
