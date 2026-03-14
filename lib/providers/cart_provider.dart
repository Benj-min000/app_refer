import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/global/global.dart';

class CartProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  /// Call once after login and after any cart mutation
  /// to sync the badge count with Firestore.
  Future<void> loadCart() async {
    if (currentUid == null) {
      if (_count == 0) return;
      _count = 0;
      notifyListeners();
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUid)
        .collection("carts")
        .count()
        .get();

    final newCount = snapshot.count ?? 0;
    if (_count == newCount) return;
    _count = newCount;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}