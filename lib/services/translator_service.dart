import 'package:translator/translator.dart';
import "package:flutter/material.dart";

class TranslationService {
  static Future<Map<String, dynamic>> translateAddressData(Map<String, dynamic> mapData, String targetLang) async {
    final translator = GoogleTranslator();

    // Define which fields actually need translation (skip lat, lng, postCode)
    List<String> keysToTranslate = ['fullAddress', 'city', 'state', 'country'];

    // Create a copy of the map to modify
    Map<String, dynamic> translatedMap = Map.from(mapData);

    // Run all translations in parallel
    await Future.wait(keysToTranslate.map((key) async {
      if (mapData[key] != null && mapData[key].toString().isNotEmpty) {
        var translation = await translator.translate(mapData[key], to: targetLang);
        translatedMap[key] = translation.text;
      }
    }));

    return translatedMap;
  }

  static Future<String> formatAndTranslateAddress(Map<String, dynamic> addressMap, String targetLang) async {
    if (addressMap.isEmpty) return "";

    // debugPrint("DEBUG addressMap: $addressMap");

    String road = addressMap['road'] ?? addressMap['street'] ?? addressMap['route'] ?? "";
    if (road.isEmpty && addressMap['fullAddress'] != null) {
      road = addressMap['fullAddress'].toString().split(',').first;
    }

    String houseNumber = addressMap['houseNumber'] ?? "";
    String postalCode = addressMap['postalCode'] ?? "";
    String city = addressMap['city'] ?? ""; 
    String state = addressMap['state'] ?? "";
    String country = addressMap['country'] ?? "";

    try {
      final translator = GoogleTranslator();

      final results = await Future.wait([
        translator.translate(state, from: 'auto', to: targetLang),
        translator.translate(country, from: 'auto', to: targetLang),
      ]);

      String tState = results[0].text;
      String tCountry = results[1].text;

      List<String> parts = [];
      
      String streetLine = road;
      if (houseNumber.isNotEmpty && !road.contains(houseNumber)) {
        streetLine += " $houseNumber";
      }
      if (streetLine.trim().isNotEmpty) parts.add(streetLine.trim());

      String cityLine = postalCode.isNotEmpty ? "$postalCode $city" : city;
      if (cityLine.trim().isNotEmpty) parts.add(cityLine.trim());

      if (tState.isNotEmpty && tState.toLowerCase() != city.toLowerCase()) parts.add(tState.trim());

      if (tCountry.isNotEmpty) parts.add(tCountry.trim());

      return parts.join(", ");

    } catch (e) {
      debugPrint("Translation Error: $e");
      // Original data returned if there's any problems
      return addressMap['fullAddress'] ?? 
        "${road.isNotEmpty ? '$road $houseNumber, ' : ''}$city, $state, $country".trim();
    }
  }
}