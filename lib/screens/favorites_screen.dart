import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/models/items.dart';
import 'package:user_app/screens/home_screen.dart';
import 'package:user_app/screens/orders_screen.dart';
import 'package:user_app/screens/search_screen.dart';
import 'package:user_app/screens/item_details_screen.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/widgets/unified_bottom_bar.dart';
import 'package:user_app/widgets/my_drower.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/assistant_methods/favorites_methods.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _currentPageIndex = 3;

  void _onBottomNavTap(int index) {
    if (index == _currentPageIndex) return;
    setState(() => _currentPageIndex = index);

    final Map<int, Widget> routes = {
      0: const HomeScreen(),
      1: const OrdersScreen(),
      2: const SearchScreen(initialText: ''),
    };

    if (routes.containsKey(index)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => routes[index]!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: UnifiedAppBar(
          title: "Favorites",
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu_open,
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
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
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
              .collection("favorites")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text("Error loading favorites",
                        style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  ],
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: circularProgress());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildEmpty();
            }

            return _buildFavoritesList(snapshot.data!.docs);
          },
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_outline, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No favorites yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap the heart icon on any item to save it here",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<QueryDocumentSnapshot> docs) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final favData = docs[index].data() as Map<String, dynamic>;
        final String restaurantID = favData['restaurantID'] ?? '';
        final String menuID = favData['menuID'] ?? '';
        final String itemID = favData['itemID'] ?? '';

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
            if (!itemSnapshot.hasData || !itemSnapshot.data!.exists) {
              return const SizedBox.shrink();
            }

            final Items item = Items.fromJson(
                itemSnapshot.data!.data() as Map<String, dynamic>);
            item.itemID = itemID;
            item.menuID = menuID;
            item.restaurantID = restaurantID;

            return _buildFavoriteCard(item);
          },
        );
      },
    );
  }

  Widget _buildFavoriteCard(Items item) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemDetailsScreen(model: item)),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                          ? Image.network(
                              item.imageUrl!,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _imageFallback(),
                            )
                          : _imageFallback(),
                    ),
                    if (item.hasDiscount)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${item.discount!.toInt()}% OFF',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title ?? 'Unknown Item',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Unfavorite button
                          StreamBuilder<bool>(
                            stream: isFavoriteStream(item.itemID ?? ''),
                            builder: (context, snapshot) {
                              return IconButton(
                                icon: Icon(
                                  snapshot.data == true
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                  size: 32,
                                ),
                                onPressed: () {
                                  if (item.itemID != null &&
                                      item.menuID != null &&
                                      item.restaurantID != null) {
                                    toggleFavorite(item.restaurantID!,
                                        item.menuID!, item.itemID!);
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),

                      if (item.tags != null && item.tags!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          children: item.tags!.take(2).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color:
                                        Colors.green.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w600),
                              ),
                            );
                          }).toList(),
                        ),
                      ],

                      const SizedBox(height: 8),

                      // Price
                      Row(
                        children: [
                          if (item.hasDiscount) ...[
                            Text(
                              '${item.price!.toStringAsFixed(2)} zł',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${item.discountedPrice.toStringAsFixed(2)} zł',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ] else
                            Text(
                              '${item.price?.toStringAsFixed(2) ?? '0.00'} zł',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageFallback() => Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.restaurant, size: 40, color: Colors.grey),
      );
}