import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/screens/home_screen.dart';

class PlacedOrderScreen extends StatefulWidget {
  final String? addressID;
  final double? totolAmmount;

  const PlacedOrderScreen(
      {super.key, required this.addressID, required this.totolAmmount});

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {
  String orderTime = DateTime.now().microsecondsSinceEpoch.toString();
  String orderID = "";
  String? sellerID;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    orderID = FirebaseFirestore.instance.collection("orders").doc().id;
    getSellerUIDFromCart();
  }

  Future<void> getSellerUIDFromCart() async {
    try {
      String? uid = sharedPreferences!.getString("uid");
      if (uid == null) return;

      var cartSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("carts")
        .limit(1)
        .get();

      if (cartSnapshot.docs.isNotEmpty) {
        var cartData = cartSnapshot.docs.first.data();
        setState(() {
          sellerID = cartData['sellerID'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error getting sellerID: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void addOrderDetails() {
    writeOrderDetailsForUser({
      "addressID": widget.addressID,
      "totolAmmount": widget.totolAmmount,
      "orderedBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "orderTime": orderTime,
      "isSuccess": true,
      "sellerID": sellerID,
      "riderID": "",
      "status": "normal",
      "orderID": orderID,
    });

    writeOrderDetailsForSeller({
      "addressID": widget.addressID,
      "totolAmmount": widget.totolAmmount,
      "orderedBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on Delivery",
      "orderTime": orderID,
      "isSuccess": true,
      "sellerID": sellerID,
      "riderID": "",
      "status": "normal",
      "orderID": orderID,
    }).whenComplete(() {

      if (!mounted) return;
      clearCartNow(context);

      setState(() {
        orderID = "";
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const HomeScreen()));
        Fluttertoast.showToast(
            msg: "Congratulations, Order has been placed Successfully");
      });
    });
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
      .collection("users")
      .doc(sharedPreferences!.getString("uid"))
      .collection("orders")
      .doc(orderID)
      .set(data);
  }

  Future writeOrderDetailsForSeller(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
      .collection("orders")
      .doc(orderID)
      .set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.red],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("assets/images/delivery.jpg"),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              addOrderDetails();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Place order'),
          )
        ]),
      ),
    );
  }
}