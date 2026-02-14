import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/order_card.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/unified_app_bar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UnifiedAppBar(
        title: "Order History",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(sharedPreferences?.getString("uid"))
            .collection("orders")
            .where("status", isEqualTo: "ended")
            .orderBy("orderTime", descending: true)
            .snapshots(),
        builder: (c, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (c, index) {
              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("items")
                    .where("itemID",
                    whereIn: separateItemIDs(
                        (snapshot.data?.docs[index].data()
                        as Map<String, dynamic>)["itemIDs"]))
                    .where("orderedBy",
                    whereIn: (snapshot.data?.docs[index].data()
                    as Map<String, dynamic>)["uid"])
                    .orderBy("publishedDate", descending: true)
                    .get(),
                builder: (c, snap) {
                  return snap.hasData
                      ? OrderCard(
                    itemCount: snap.data?.docs.length,
                    data: snap.data?.docs,
                    orderID: snapshot.data?.docs[index].id,
                    seperateQuantitiesList:
                    separateItemQuantities(
                        (snapshot.data?.docs[index].data()
                        as Map<String, dynamic>)[
                        "itemIDs"]),
                  )
                      : Center(
                    child: circularProgress(),
                  );
                },
              );
            },
          )
              : Center(
            child: circularProgress(),
          );
        },
      ),
    );
  }
}