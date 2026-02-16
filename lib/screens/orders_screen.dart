import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/order_card.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/screens/home_screen.dart';
import "package:user_app/screens/favorites_screen.dart";
import 'package:user_app/widgets/unified_bottom_bar.dart';
import 'package:user_app/screens/search_screen.dart';
import 'package:user_app/widgets/my_drower.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _currentPageIndex = 1;

  void _onBottomNavTap(int index) {
    if (index == _currentPageIndex) return;
    
    setState(() {
      _currentPageIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SearchScreen(initialText: '')),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FavoritesScreen()),
        );
        break;
    }
  }

  Future<List<DocumentSnapshot>> _fetchOrderItems(DocumentSnapshot orderDoc) async {
    final orderData = orderDoc.data() as Map<String, dynamic>;
    final itemIDs = orderData['itemIDs'] as List<dynamic>;
    List<DocumentSnapshot> allItems = [];
    
    // Group items by menu to minimize queries
    // Format: "restaurantID:menuID:itemID:quantity"
    Map<String, List<String>> menuItemsMap = {};
    
    for (var item in itemIDs) {
      List<String> parts = item.toString().split(':');
      if (parts.length >= 3) {
        String restaurantID = parts[0];
        String menuID = parts[1];
        String itemID = parts[2];
        
        String menuKey = "$restaurantID:$menuID";
        if (!menuItemsMap.containsKey(menuKey)) {
          menuItemsMap[menuKey] = [];
        }
        menuItemsMap[menuKey]!.add(itemID);
      }
    }
    
    // Fetch items for each menu
    for (var entry in menuItemsMap.entries) {
      List<String> pathParts = entry.key.split(':');
      String restaurantID = pathParts[0];
      String menuID = pathParts[1];
      List<String> itemIDs = entry.value;
      
      try {
        var snapshot = await FirebaseFirestore.instance
            .collection("restaurants")
            .doc(restaurantID)
            .collection("menus")
            .doc(menuID)
            .collection("items")
            .where(FieldPath.documentId, whereIn: itemIDs)
            .get();
        
        allItems.addAll(snapshot.docs);
      } catch (e) {
        print("Error fetching items from menu $menuID: $e");
      }
    }
    print(allItems);
    return allItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: UnifiedAppBar(
        title: "Your Orders",
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.menu_open, 
                color: Colors.white, 
                size: 28,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: Offset(2.0, 2.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: UnifiedBottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: _onBottomNavTap,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUid)
            .collection("orders")
            .where("status", isEqualTo: "normal")
            .orderBy("orderTime", descending: true)
            .snapshots(),
        builder: (c, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: circularProgress());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No orders yet",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your order history will appear here",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (c, index) {
              final orderDoc = snapshot.data!.docs[index];
              final orderData = orderDoc.data() as Map<String, dynamic>;
              
              return FutureBuilder<List<DocumentSnapshot>>(
                future: _fetchOrderItems(orderDoc),
                builder: (c, snap) {
                  if (!snap.hasData) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: circularProgress()),
                      ),
                    );
                  }

                  if (snap.data!.isEmpty) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Order items not found",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OrderCard(
                      itemCount: snap.data!.length,
                      data: snap.data!,
                      orderID: orderDoc.id,
                      seperateQuantitiesList: separateItemQuantities(
                        orderData["itemIDs"] as List<dynamic>
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}