import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:user_app/global/global.dart';

class AddressChanger extends ChangeNotifier {
  int _counter = -1; // Default to -1 for "Current Location"
  Map<String, dynamic> _selectedAddress = {};
  int _totalSavedAddresses = 0;

  // Storing Address coordinates
  double? _lat;
  double? _lng;

  int get count => _counter;
  Map<String, dynamic> get selectedAddress => _selectedAddress;
  int get totalSavedAddresses => _totalSavedAddresses;

  double? get lat => _lat;
  double? get lng => _lng;

  Future<void> displayResult(int newValue, {Map<String, dynamic> address = const {}, double? lat, double? lng}) async {
    _counter = newValue;
    _selectedAddress = address;
    _lat = lat;
    _lng = lng;
    notifyListeners();

    await saveUserPref<int>('selected_address_index', newValue);
    await saveUserPref<String>('selected_address_map', json.encode(address));

    if (lat != null && lng != null) {
      await saveUserPref<double>('selected_lat', lat);
      await saveUserPref<double>('selected_lng', lng);
    }
  }

  Future<void> loadSavedAddress() async {    
    _counter = getUserPref<int>('selected_address_index') ?? -1;
    
    String? addressJson = getUserPref<String>('selected_address_map');
    if (addressJson != null) {
      _selectedAddress = json.decode(addressJson);
    } else {
      _selectedAddress = {}; 
    }

    _lat = getUserPref<double>('selected_lat');
    _lng = getUserPref<double>('selected_lng');
    
    notifyListeners();
  }

  void setTotalSavedAddresses(int count) {
    if (_totalSavedAddresses == count) return;
    _totalSavedAddresses = count;
    notifyListeners();
  }

  void reset() {
    _totalSavedAddresses = 0;
    notifyListeners();
  }
}