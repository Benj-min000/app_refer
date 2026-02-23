import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:user_app/models/items.dart';
import 'package:user_app/screens/place_order_screen.dart';

import 'package:user_app/assistant_methods/total_amount.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';

import 'package:user_app/widgets/cart_item_design.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/unified_app_bar.dart';

import 'package:user_app/global/global.dart';
import 'package:user_app/extensions/context_translate_ext.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  void initState() {
    super.initState();

    Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
  }

  Future<void> _clearCart() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => circularProgress(),
    );
    
    await clearCartNow(context);

    if (!mounted) return;
    Provider.of<TotalAmount>(context, listen: false).reset();
    Navigator.pop(context);
    Fluttertoast.showToast(msg: context.t.cartCleared);
  }

  void _proceedToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaceOrderScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: UnifiedAppBar(
        title: t.myCart,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUid)
            .collection("carts")
            .snapshots(),
        builder: (context, cartSnapshot) {
          if (cartSnapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "Error loading cart",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
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
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  "Your cart is empty!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Add items to get started",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
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
        SliverToBoxAdapter(
          child: Consumer<TotalAmount>(
            builder: (context, amountProvider, _) {
              if (amountProvider.totalAmount <= 0) return const SizedBox.shrink();
              
              return Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (amountProvider.totalSavings > 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Original Total:", style: TextStyle(fontSize: 14, color: Colors.white70)),
                          Text("${amountProvider.originalAmount.toStringAsFixed(2)}zł",
                            style: const TextStyle(fontSize: 14, color: Colors.white70, decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("You Save:", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12)),
                            child: Text("- ${amountProvider.totalSavings.toStringAsFixed(2)}zł",
                              style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white38, height: 24, thickness: 1),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text("${amountProvider.totalAmount.toStringAsFixed(2)}zł",
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        _buildCartItems(cartSnapshot),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildCartItems(AsyncSnapshot<QuerySnapshot> cartSnapshot) {
    final docs = cartSnapshot.data!.docs;
    double tempTotal = 0;
    double tempOriginal = 0;
    double tempSavings = 0;
    int loadedCount = 0;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final cartData = docs[index].data() as Map<String, dynamic>;
          final int quantity = cartData['quantity'] ?? 1;

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("restaurants").doc(cartData['restaurantID'])
                .collection("menus").doc(cartData['menuID'])
                .collection("items").doc(cartData['itemID'])
                .get(),
            builder: (context, itemSnapshot) {
              if (!itemSnapshot.hasData || !itemSnapshot.data!.exists) {
                return const SizedBox.shrink();
              }

              final Items model = Items.fromJson(
                  itemSnapshot.data!.data() as Map<String, dynamic>);
              model.itemID = cartData['itemID'];
              model.menuID = cartData['menuID'];
              model.restaurantID = cartData['restaurantID'];

              final pricePerItem = model.hasDiscount
                  ? model.discountedPrice
                  : (model.price ?? 0);
              final originalPricePerItem = model.price ?? 0;

              // Only add to totals once per item per snapshot
              if (itemSnapshot.connectionState == ConnectionState.done) {
                loadedCount++;
                tempTotal += pricePerItem * quantity;
                tempOriginal += originalPricePerItem * quantity;
                if (model.hasDiscount) {
                  tempSavings += (originalPricePerItem - pricePerItem) * quantity;
                }

                if (loadedCount == docs.length) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      Provider.of<TotalAmount>(context, listen: false)
                          .setAmounts(tempTotal, tempOriginal, tempSavings);
                    }
                  });
                }
              }

              return CartItemDesign(
                  model: model, context: context, quanNumber: quantity);
            },
          );
        },
        childCount: docs.length,
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _clearCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red.shade300),
                ),
                elevation: 2,
              ),
              icon: const Icon(Icons.delete),
              label: const Text(
                "Clear Cart",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _proceedToCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              icon: const Icon(Icons.shopping_bag),
              label: const Text(
                "Proceed to Checkout",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}