import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:user_app/models/items.dart';
import 'package:user_app/models/menus.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/widgets/items_design.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/text_widget_header.dart';
import 'package:user_app/screens/cart_screen.dart';

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
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28), // Change to any icon you like
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.shopping_bag,
                color: Colors.white,
                size: 28,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(2.0, 2.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CartScreen()),
                );
              },
            ),
          ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: TextWidgetHeader(
                title: "Items's of ${widget.model!.title}"),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
              .collection("sellers")
              .doc(widget.model!.sellerID)
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
                      iModel.sellerID = widget.model!.sellerID;

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
