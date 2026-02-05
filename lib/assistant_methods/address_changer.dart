import 'package:flutter/material.dart';

class AddressChanger extends ChangeNotifier {
  int _counter = -1; // Default to -1 for "Current Location"
  String _selectedAddress = ""; // Stores the actual address text
  int _totalSavedAddresses = 0;

  int get count => _counter;
  String get selectedAddress => _selectedAddress;

  int get totalSavedAddresses => _totalSavedAddresses;

  // Added a parameter to accept the address string
  void displayResult(int newValue, {String addressText = ""}) {
    _counter = newValue;
    _selectedAddress = addressText;
    notifyListeners();
  }

  void setTotalSavedAddresses(int count) {
    _totalSavedAddresses = count;
    notifyListeners();
  }

  String get nextAddressLabel => "Address ${_totalSavedAddresses + 1}";
}