import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/global/global.dart';

class CartItemCounter extends ChangeNotifier {
  int cartListItemCounter = 0;

  int get count => cartListItemCounter;

  Future<void> displayCartListItemsNumber() async {
    final String? uid = firebaseAuth.currentUser?.uid;

    if (uid != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("carts")
          .get();

      cartListItemCounter = snapshot.docs.length;
    } else {
      cartListItemCounter = 0;
    }

    notifyListeners();
  }
}