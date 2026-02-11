import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/screens/address_screen.dart';
import 'package:user_app/models/items.dart';
import 'package:user_app/widgets/cart_item_design.dart';
import 'package:user_app/widgets/progress_bar.dart';

import 'package:user_app/assistant_methods/total_ammount.dart';
import 'package:user_app/widgets/text_widget_header.dart';
import 'package:user_app/widgets/unified_app_bar.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;
  const CartScreen({super.key, this.sellerUID});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantityList;

  num totolAmmount = 0;

  @override
  void initState() {
    super.initState();
    totolAmmount = 0;
    Provider.of<TotalAmmount>(context, listen: false).displayTotolAmmount(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UnifiedAppBar(
        title: "Shopping Cart",
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new, 
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
        actions: [],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: 'btn1',
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => circularProgress(),
                );
                await clearCartNow(context);

                if (!mounted) return;
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Cart has been cleared");
              },
              label: const Text(
                "Clear Cart",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              icon: const Icon(
                Icons.clear_all, 
                color: Colors.white, 
                size: 28
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              heroTag: 'btn2',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddressScreen(
                      totolAmmount: totolAmmount.toDouble(),
                      sellerUID: widget.sellerUID,
                    )
                  )
                );
              },
              label: const Text(
                "Checkout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
              backgroundColor: Colors.redAccent,
              icon: const Icon(
                Icons.navigate_next, 
                color: Colors.white, 
                size: 28
              ),
            ),
          ),
        ],
      ),
      // body: CustomScrollView(
      //   slivers: [
      //     SliverPersistentHeader(
      //       pinned: true,
      //       delegate: TextWidgetHeader(title: "My Cart List"),
      //     ),
      //     SliverToBoxAdapter(
      //       child: Consumer2<TotalAmmount, CartItemCounter>(
      //         builder: (context, amountProvidr, cartProvider, c) {
      //           return Padding(
      //             padding: const EdgeInsets.all(8),
      //             child: Center(
      //               child: cartProvider.count == 0
      //                 ? Container()
      //                 : Text(
      //                   "Total Price: ${amountProvidr.tAmmount.toString()}",
      //                   style: const TextStyle(
      //                     color: Colors.black,
      //                     fontSize: 18,
      //                     fontWeight: FontWeight.w500
      //                   ),
      //                 ),
      //             ),
      //           );
      //         },
      //       ),
      //     ),
          
      //     StreamBuilder<QuerySnapshot>(
      //       stream: FirebaseFirestore.instance
      //         .collection("items")
      //         .where("itemId")
      //         .orderBy("publishedDate", descending: true)
      //         .snapshots(),
      //       builder: (context, snapshot) {
      //         return !snapshot.hasData
      //           ? SliverToBoxAdapter(
      //               child: Center(
      //                 child: circularProgress(),
      //               ),
      //             )
      //           : snapshot.data!.docs.isEmpty
      //               ? Container()
      //               : SliverList(
      //                   delegate: SliverChildBuilderDelegate(
      //                       (context, index) {
      //                   Items model = Items.fromJson(
      //                     snapshot.data!.docs[index].data()!
      //                         as Map<String, dynamic>,
      //                   );
      //                   if (index == 0) {
      //                     totolAmmount = 0;
      //                     totolAmmount = totolAmmount +
      //                         (model.price! *
      //                             separateItemQuantityList![index]);
      //                   } else {
      //                     totolAmmount = totolAmmount +
      //                         (model.price! *
      //                             separateItemQuantityList![index]);
      //                   }

      //                   if (snapshot.data!.docs.length - 1 == index) {
      //                     WidgetsBinding.instance
      //                         .addPostFrameCallback((timeStamp) {
      //                       Provider.of<TotalAmmount>(context,
      //                               listen: false)
      //                           .displayTotolAmmount(
      //                               totolAmmount.toDouble());
      //                     });
      //                   }

      //                   return CartItemDesign(
      //                     model: model,
      //                     context: context,
      //                     quanNumber: separateItemQuantityList![index],
      //                   );
      //                 },
      //                 childCount: snapshot.hasData
      //                     ? snapshot.data!.docs.length
      //                     : 0));
      //       }),
      //   ],
      // ),
    );
  }
}
