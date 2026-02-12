import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<String> separateOrderItemIds(orderIdList) {
  if (orderIdList == null) {
    return <String>[];
  }

  return List<String>.from(orderIdList).map((item) {
    var pos = item.lastIndexOf(":");
    return (pos != -1) ? item.substring(0, pos) : item;
  }).toList();
}

Future<void> addItemToCart(String? itemID, String? menuID, String? sellerID, BuildContext context, int itemCounter) async {
  final String uid = firebaseAuth.currentUser!.uid;
  final cartRef = FirebaseFirestore.instance.collection("users").doc(uid).collection("carts");
 
  var existingCart = await cartRef.get();

  if (existingCart.docs.isNotEmpty) {
    String sellerInCart = existingCart.docs.first.get("sellerID");
    if (sellerInCart != sellerID) {
      Fluttertoast.showToast(msg: "You can only order from one seller at a time.");
      return; 
    }
  }

  await cartRef.doc(itemID).set({
      "itemID": itemID,
      "menuID": menuID,
      "sellerID": sellerID, 
      "quantity": itemCounter,
      "publishedDate": DateTime.now(),
    }).then((value) {

      List<String> tempCartList = sharedPreferences!.getStringList("userCart") ?? [];
      tempCartList.add("$itemID:$itemCounter"); 
      sharedPreferences!.setStringList("userCart", tempCartList);

      Fluttertoast.showToast(msg: "Item Added Successfully.");

      Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemsNumber();
  });
}

List<String> separateOrderItemQuantities(orderIdList) {
  List<String> quantities = [];
  for (var item in List<String>.from(orderIdList)) {
    List<String> parts = item.split(":");
    if (parts.length > 1) {
      quantities.add(parts[1]);
    }
  }
  return quantities;
}

Future<void> clearCartNow(BuildContext context) async {
  final User? currentUser = firebaseAuth.currentUser;
  
  if (currentUser == null) {
    Fluttertoast.showToast(msg: "User not logged in.");
    return;
  }

  final String uid = currentUser.uid;

  try {
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("carts")
        .get();
    if (snapshot.docs.isEmpty) {
      Fluttertoast.showToast(msg: "Cart is already empty.");
      return;
    }

    WriteBatch batch = FirebaseFirestore.instance.batch();
    
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
    sharedPreferences!.setStringList("userCart", []);

    if (context.mounted) {
      Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
      Fluttertoast.showToast(msg: "Cart Cleared.");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error clearing cart: $e");
  }
}