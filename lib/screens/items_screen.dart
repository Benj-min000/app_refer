import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:user_app/models/items.dart';
import 'package:user_app/models/menus.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/widgets/items_design.dart';
import 'package:user_app/widgets/progress_bar.dart';

class ItemsScreen extends StatefulWidget {
  final Menus? model;
  const ItemsScreen({super.key, this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UnifiedAppBar(
        title: "Items ${widget.model!.title}",
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
              .collection("restaurants")
              .doc(widget.model!.restaurantID)
              .collection("menus")
              .doc(widget.model!.menuID)
              .collection("items")
              .orderBy("publishedDate", descending: true)
              .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(child: Text("Error: ${snapshot.error}")),
                );
              }

              if (!snapshot.hasData) {
                return SliverToBoxAdapter(child: circularProgress());
              }

              if (snapshot.data!.docs.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text("No items found in this menu.")),
                );
              }
              return !snapshot.hasData
                ? SliverToBoxAdapter(
                    child: Center(
                      child: circularProgress(),
                    ),
                  )
                : SliverMasonryGrid.count(
                    crossAxisCount: 1,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      Items iModel = Items.fromJson(doc.data()! as Map<String, dynamic>);

                      iModel.itemID = doc.id;
                      iModel.menuID = widget.model!.menuID;
                      iModel.restaurantID = widget.model!.restaurantID;

                      return ItemsDesignWidget(
                        model: iModel,
                        context: context,
                      );
                    },
                    childCount: snapshot.data!.docs.length);
            },
          ),
        ],
      ),
    );
  }
}
