import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<String> separateItemIDs(List<dynamic> userCart) {
  return userCart.map((item) {
    List<String> parts = item.toString().split(':');
    return parts.length >= 3 ? parts[2] : '';
  }).toList();
}

List<int> separateItemQuantities(List<dynamic> userCart) {
  return userCart.map((item) {
    List<String> parts = item.toString().split(':');
    return parts.length >= 4 ? int.parse(parts[3]) : 1;
  }).toList();
}

Future<void> addItemToCart(String? itemID, String? menuID, String? restaurantID, BuildContext context, int itemCounter) async {
  final String uid = firebaseAuth.currentUser!.uid;
  final cartRef = FirebaseFirestore.instance.collection("users").doc(uid).collection("carts");
 
  var existingCart = await cartRef.get();
  if (existingCart.docs.isNotEmpty) {
    String storeInCart = existingCart.docs.first.get("restaurantID");
    if (storeInCart != restaurantID) {
      Fluttertoast.showToast(msg: "You can only order from one restuarant at a time.");
      return; 
    }
  }

  await cartRef.doc(itemID).set({
      "itemID": itemID,
      "menuID": menuID,
      "restaurantID": restaurantID,
      "quantity": itemCounter,
      "publishedDate": DateTime.now(),
    }).then((value) {
      List<String> tempCartList = getUserPref<List<String>>("userCart") ?? [];
    
      String cartItem = "$restaurantID:$menuID:$itemID:$itemCounter";
      
      tempCartList.removeWhere((item) => item.contains("$restaurantID:$menuID:$itemID:"));
      
      tempCartList.add(cartItem);

      saveUserPref<List<String>>("userCart", tempCartList);

      Fluttertoast.showToast(msg: "Item Added Successfully.");

      Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemsNumber();
  });
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
    saveUserPref<List<String>>("userCart", []);

    if (context.mounted) {
      Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
      Fluttertoast.showToast(msg: "Cart Cleared.");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error clearing cart: $e");
  }
}

Future<void> removeItemFromCart(BuildContext context, String itemID) async {
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
        .where("itemID", isEqualTo: itemID)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      Fluttertoast.showToast(msg: "Item not found in cart.");
      return;
    }
    
    await snapshot.docs.first.reference.delete();
    
    List<String>? userCart = getUserPref<List<String>>("userCart");
    if (userCart != null) {
      userCart.removeWhere((item) => item.startsWith("$itemID:"));
      saveUserPref<List<String>>("userCart", userCart);
    }
    
    if (context.mounted) {
      Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
      Fluttertoast.showToast(msg: "Item removed from cart.");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error removing item: $e");
  }
}

Future<void> incrementCartItemQuantity(BuildContext context, String itemID) async {
  final User? currentUser = firebaseAuth.currentUser;
  if (currentUser == null) return;

  try {
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .collection("carts")
        .where("itemID", isEqualTo: itemID)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return;

    final doc = snapshot.docs.first;
    final int currentQuantity = doc.get("quantity") ?? 1;

    if (currentQuantity >= 9) {
      Fluttertoast.showToast(msg: "Maximum quantity reached");
      return;
    }

    final int newQuantity = currentQuantity + 1;
    await doc.reference.update({"quantity": newQuantity});

    // Update local pref
    List<String>? userCart = getUserPref<List<String>>("userCart");
    if (userCart != null) {
      final String restaurantID = doc.get("restaurantID");
      final String menuID = doc.get("menuID");
      userCart.removeWhere((item) => item.contains("$restaurantID:$menuID:$itemID:"));
      userCart.add("$restaurantID:$menuID:$itemID:$newQuantity");
      saveUserPref<List<String>>("userCart", userCart);
    }

    if (context.mounted) {
      Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error updating quantity: $e");
  }
}

Future<void> decrementCartItemQuantity(BuildContext context, String itemID) async {
  final User? currentUser = firebaseAuth.currentUser;
  if (currentUser == null) return;

  try {
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .collection("carts")
        .where("itemID", isEqualTo: itemID)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return;

    final doc = snapshot.docs.first;
    final int currentQuantity = doc.get("quantity") ?? 1;

    if (currentQuantity <= 1) { return; }

    final int newQuantity = currentQuantity - 1;
    await doc.reference.update({"quantity": newQuantity});

    // Update local pref
    List<String>? userCart = getUserPref<List<String>>("userCart");
    if (userCart != null) {
      final String restaurantID = doc.get("restaurantID");
      final String menuID = doc.get("menuID");
      userCart.removeWhere((item) => item.contains("$restaurantID:$menuID:$itemID:"));
      userCart.add("$restaurantID:$menuID:$itemID:$newQuantity");
      saveUserPref<List<String>>("userCart", userCart);
    }

    if (context.mounted) {
      Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error updating quantity: $e");
  }
}
