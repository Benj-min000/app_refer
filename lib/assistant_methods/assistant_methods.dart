import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/global/global.dart';

List<String> separateOrderItemIds(orderId) {
  List<String> separateItemIdsList = [], defaultItemList = [];
  defaultItemList = List<String>.from(orderId);

  for (int i = 0; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;
    separateItemIdsList.add(getItemId);
  }
  return separateItemIdsList;
}

Future<void> addItemToCart(String? foodItemId, BuildContext context, int itemCounter) async {
  final String uid = firebaseAuth.currentUser!.uid;

  await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("carts")
      .doc(foodItemId)
      .set({
    "productId": foodItemId,
    "quantity": itemCounter,
    "addedAt": DateTime.now(),
  }).then((value) {

    Fluttertoast.showToast(msg: "Item Added Successfully. ");

    Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemsNumber();
  });
}

List<String> separateOrderItemQuantities(orderId) {
  List<String> separateItemQuantityList = [];
  List<String> defaultItemList = [];

  defaultItemList = List<String>.from(orderId);

  for (int i = 1; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();

    List<String> listItemCharacters = item.split(":").toList();

    var quanNumber = int.parse(listItemCharacters[1].toString());

    separateItemQuantityList.add(quanNumber.toString());
  }

  return separateItemQuantityList;
}

Future<void> clearCartNow(context) async {
  final String uid = firebaseAuth.currentUser!.uid;
  var snapshot = await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("carts")
      .get();
  WriteBatch batch = FirebaseFirestore.instance.batch();
  for (var doc in snapshot.docs) {
    batch.delete(doc.reference);
  }
  await batch.commit().then((value) {
    Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
    Fluttertoast.showToast(msg: "Cart Cleared.");
  });
}
