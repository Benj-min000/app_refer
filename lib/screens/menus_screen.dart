import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:user_app/models/menus.dart';
import 'package:user_app/widgets/menus_design.dart';
import 'package:user_app/widgets/progress_bar.dart';

import 'package:user_app/models/restaurants.dart';
import 'package:user_app/widgets/unified_app_bar.dart';

class MenusScreen extends StatefulWidget {
  final Restaurants? model;
  const MenusScreen({super.key, this.model});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UnifiedAppBar(
        title: "${widget.model!.name} Menus",
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new, 
            size: 28,
            color: Colors.white,
          )
        ),
      ),
      body: CustomScrollView(
        slivers: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
              .collection("restaurants")
              .doc(widget.model!.restaurantID)
              .collection("menus")
              .orderBy("publishedDate", descending: true)
              .snapshots(),
            builder: (context, snapshot) {
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

                    Menus mModel = Menus.fromJson(doc.data()! as Map<String, dynamic>);
                    mModel.menuID = doc.id;               
                    mModel.restaurantID = widget.model!.restaurantID;

                    return MenusDesignWidget(
                      model: mModel,
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
