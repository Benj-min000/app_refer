import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/global/global.dart';

class CartItemCounter extends ChangeNotifier {
  int _cartListItemCounter = 0;

  int get count => _cartListItemCounter = 0;

  Future<void> displayCartListItemsNumber() async {

    if (currentUid != null) {
      AggregateQuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUid)
          .collection("carts")
          .count()
          .get();

      int newCount = snapshot.count ?? 0;

      if (_cartListItemCounter == newCount) return;

      _cartListItemCounter = newCount;
    } else {
      if (_cartListItemCounter == 0) return;
      _cartListItemCounter = 0;
    }
    notifyListeners();
  }

  void reset() {
    _cartListItemCounter = 0;
    notifyListeners();
  }
}