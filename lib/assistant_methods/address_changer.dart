import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Added a parameter to accept the address string
  Future<void> displayResult(int newValue, {Map<String, dynamic> address = const {}, double? lat, double? lng}) async {
    _counter = newValue;
    _selectedAddress = address;
    _lat = lat;
    _lng = lng;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_address_index', newValue);
    await prefs.setString('selected_address_map', json.encode(address));

    if (lat != null && lng != null) {
      await prefs.setDouble('selected_lat', lat);
      await prefs.setDouble('selected_lng', lng);
    }
  }

  Future<void> loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    
    _counter = prefs.getInt('selected_address_index') ?? -1;
    
    String? addressJson = prefs.getString('selected_address_map');
    if (addressJson != null) {
      _selectedAddress = json.decode(addressJson);
    } else {
      _selectedAddress = {}; 
    }

    _lat = prefs.getDouble('selected_lat');
    _lng = prefs.getDouble('selected_lng');
    
    notifyListeners();
  }

  void setTotalSavedAddresses(int count) {
    _totalSavedAddresses = count;
    notifyListeners();
  }
}