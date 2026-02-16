import 'package:flutter/material.dart';

class TotalAmount extends ChangeNotifier {
  double _totalAmount = 0;    // Final price after discounts
  double _originalAmount = 0; // Price before discounts
  double _totalSavings = 0;   // How much was saved

  double get totalAmount => _totalAmount;
  double get originalAmount => _originalAmount;
  double get totalSavings => _totalSavings;

  void setAmounts(double total, double original, double savings) {
    if (_totalAmount == total && 
        _originalAmount == original && 
        _totalSavings == savings) return;

    _totalAmount = total;
    _originalAmount = original;
    _totalSavings = savings;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  @override
  void reset() {
    _totalAmount = 0;
    _originalAmount = 0;
    _totalSavings = 0;
    notifyListeners();
  }
}
