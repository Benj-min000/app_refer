import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_app/global/global.dart';

Future<void> toggleFavorite(String restaurantID, String menuID, String itemID) async {
  if (currentUid == null) {
    Fluttertoast.showToast(msg: "Please login to add favorites");
    return;
  }
  
  DocumentReference favoriteRef = FirebaseFirestore.instance
      .collection("users")
      .doc(currentUid)
      .collection("favorites")
      .doc(itemID);

  DocumentReference itemRef = FirebaseFirestore.instance
      .collection("restaurants")
      .doc(restaurantID)
      .collection("menus")
      .doc(menuID)
      .collection("items")
      .doc(itemID);

  try {
    DocumentSnapshot favoriteDoc = await favoriteRef.get();

    if (favoriteDoc.exists) {
      // Remove from favorites
      await favoriteRef.delete();
      
      // Decrement likes count
      await itemRef.update({
        'likes': FieldValue.increment(-1),
      });
      
      Fluttertoast.showToast(msg: "Removed from favorites");
    } else {
      // Add to favorites
      await favoriteRef.set({
        'itemID': itemID,
        'restaurantID': restaurantID,
        'menuID': menuID,
        'addedAt': Timestamp.now(),
      });
      
      // Increment likes count
      await itemRef.update({
        'likes': FieldValue.increment(1),
      });
      
      Fluttertoast.showToast(msg: "Added to favorites");
    }
  } catch (e) {
    print("Error toggling favorite: $e");
    Fluttertoast.showToast(msg: "Error updating favorites");
  }
}

Stream<bool> isFavoriteStream(String itemID) {
  if (currentUid == null) {
    return Stream.value(false);
  }

  return FirebaseFirestore.instance
    .collection("users")
    .doc(currentUid)
    .collection("favorites")
    .doc(itemID)
    .snapshots()
    .map((doc) => doc.exists);
}

Stream<int> itemLikesStream(String restaurantID, String menuID, String itemID) {
  return FirebaseFirestore.instance
    .collection("restaurants")
    .doc(restaurantID)
    .collection("menus")
    .doc(menuID)
    .collection("items")
    .doc(itemID)
    .snapshots()
    .map((doc) {
      if (doc.exists && doc.data() != null) {
        // Access the likes field, defaulting to 0 if it doesn't exist
        return (doc.data() as Map<String, dynamic>)['likes'] ?? 0;
      }
      return 0;
    });
}

