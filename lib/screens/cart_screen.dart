import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:user_app/models/items.dart';
import 'package:user_app/screens/place_order_screen.dart';

import 'package:user_app/assistant_methods/total_ammount.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';

import 'package:user_app/widgets/cart_item_design.dart';
import 'package:user_app/widgets/progress_bar.dart';
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
  num originalAmount = 0;
  num totalSavings = 0;

  @override
  void initState() {
    super.initState();
    // Total amount displayed
    totalAmount = 0;
    // Original amount before the discounts calculations
    originalAmount = 0;
    // Total savings from the discounts
    totalSavings = 0;
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
          originalAmount: originalAmount.toDouble(),
          totalAmount: totalAmount.toDouble(),
          totalSavings: totalSavings.toDouble(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = sharedPreferences!.getString("uid");

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: UnifiedAppBar(
        title: "My Cart",
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
            .doc(userId)
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
          child: Consumer2<TotalAmmount, CartItemCounter>(
            builder: (context, amountProvider, cartProvider, _) {
              if (cartProvider.count == 0) return const SizedBox.shrink();
              
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
                    if (totalSavings > 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Original Total:",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            "₹${originalAmount.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "You Save:",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "- ₹${totalSavings.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white38, height: 24, thickness: 1),
                    ],
                    
                    // Final total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "₹${amountProvider.tAmmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        _buildCartItems(cartSnapshot),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
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
          final String restaurantID = cartData['restaurantID'] ?? '';
          final int quantity = cartData['quantity'] ?? 1;

          if (itemID.isEmpty || menuID.isEmpty || restaurantID.isEmpty) {
            return const SizedBox.shrink();
          }

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("restaurants")
                .doc(restaurantID)
                .collection("menus")
                .doc(menuID)
                .collection("items")
                .doc(itemID)
                .get(),
            builder: (context, itemSnapshot) {
              if (itemSnapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.blue.shade400,
                      ),
                    ),
                  ),
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
              model.restaurantID = restaurantID;
      
              // Calculate totals considering discounts
              if (index == 0) {
                totalAmount = 0;
                originalAmount = 0;
                totalSavings = 0;
              }

              final pricePerItem = model.hasDiscount 
                  ? model.discountedPrice 
                  : (model.price ?? 0);
              final originalPricePerItem = model.price ?? 0;
              
              totalAmount += pricePerItem * quantity;
              originalAmount += originalPricePerItem * quantity;
              
              if (model.hasDiscount) {
                totalSavings += (originalPricePerItem - pricePerItem) * quantity;
              }

              // Update provider after last item
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