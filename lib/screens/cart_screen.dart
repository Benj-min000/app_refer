import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/screens/address_screen.dart';
import 'package:user_app/models/items.dart';
import 'package:user_app/screens/place_order_screen.dart';
import 'package:user_app/widgets/cart_item_design.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/assistant_methods/total_ammount.dart';
import 'package:user_app/widgets/text_widget_header.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/global/global.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  num totalAmount = 0;

  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmmount>(context, listen: false).displayTotolAmmount(0);
  }

  Future<void> _clearCart() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => circularProgress(),
    );
    
    await clearCartNow(context);

    if (!mounted) return;
    Navigator.pop(context);
    Fluttertoast.showToast(msg: "Cart has been cleared");
  }

  void _proceedToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaceOrderScreen(
          totalAmount: totalAmount.toDouble(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = sharedPreferences!.getString("uid");

    return Scaffold(
      appBar: UnifiedAppBar(
        title: "Shopping Cart",
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("carts")
            .snapshots(),
        builder: (context, cartSnapshot) {
          if (cartSnapshot.hasError) {
            return Center(
              child: Text("Error loading cart: ${cartSnapshot.error}"),
            );
          }

          if (cartSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: circularProgress());
          }

          if (!cartSnapshot.hasData || cartSnapshot.data!.docs.isEmpty) {
            return _buildEmptyCart();
          }

          return _buildCartContent(cartSnapshot);
        },
      ),
      floatingActionButton: _buildFloatingButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyCart() {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: TextWidgetHeader(title: "My Cart List"),
        ),
        const SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  "Your cart is empty!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartContent(AsyncSnapshot<QuerySnapshot> cartSnapshot) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: TextWidgetHeader(title: "My Cart List"),
        ),
        SliverToBoxAdapter(
          child: Consumer2<TotalAmmount, CartItemCounter>(
            builder: (context, amountProvider, cartProvider, _) {
              if (cartProvider.count == 0) return const SizedBox.shrink();
              
              return Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Price:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${amountProvider.tAmmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        _buildCartItems(cartSnapshot),
      ],
    );
  }

  Widget _buildCartItems(AsyncSnapshot<QuerySnapshot> cartSnapshot) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final cartDoc = cartSnapshot.data!.docs[index];
          final cartData = cartDoc.data() as Map<String, dynamic>;

          final String itemID = cartData['itemID'] ?? '';
          final String menuID = cartData['menuID'] ?? '';
          final String storeID = cartData['storeID'] ?? '';
          final int quantity = cartData['quantity'] ?? 1;

          if (itemID.isEmpty || menuID.isEmpty || storeID.isEmpty) {
            return const SizedBox.shrink();
          }

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("stores")
                .doc(storeID)
                .collection("menus")
                .doc(menuID)
                .collection("items")
                .doc(itemID)
                .get(),
            builder: (context, itemSnapshot) {
              if (itemSnapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (itemSnapshot.hasError || 
                  !itemSnapshot.hasData || 
                  !itemSnapshot.data!.exists) {
                return const SizedBox.shrink();
              }

              final Items model = Items.fromJson(
                itemSnapshot.data!.data() as Map<String, dynamic>,
              );

              model.itemID = itemID;
              model.menuID = menuID;
              model.storeID = storeID;
      
              if (index == 0) {
                totalAmount = 0;
              }

              totalAmount += (model.price ?? 0) * quantity;

              if (index == cartSnapshot.data!.docs.length - 1) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    Provider.of<TotalAmmount>(context, listen: false)
                        .displayTotolAmmount(totalAmount.toDouble());
                  }
                });
              }

              return CartItemDesign(
                model: model,
                context: context,
                quanNumber: quantity,
              );
            },
          );
        },
        childCount: cartSnapshot.data?.docs.length ?? 0,
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton.extended(
            heroTag: 'clearCart',
            onPressed: _clearCart,
            backgroundColor: Theme.of(context).primaryColor,
            icon: const Icon(Icons.clear_all, color: Colors.white),
            label: const Text(
              "Clear Cart",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FloatingActionButton.extended(
            heroTag: 'checkout',
            onPressed: _proceedToCheckout,
            backgroundColor: Colors.redAccent,
            icon: const Icon(Icons.navigate_next, color: Colors.white),
            label: const Text(
              "Checkout",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}