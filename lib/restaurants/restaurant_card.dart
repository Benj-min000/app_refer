import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/models/items.dart';
import 'package:user_app/screens/item_details_screen.dart';
import 'package:user_app/assistant_methods/favorites_methods.dart';

class RestaurantCard extends StatefulWidget {
  final String storeID;
  final String storeName;

  const RestaurantCard({
    required this.storeID,
    required this.storeName,
    super.key,
  });

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("stores")
          .doc(widget.storeID)
          .collection("menus")
          .limit(1)
          .snapshots(),
      builder: (context, menuSnapshot) {
        if (!menuSnapshot.hasData || menuSnapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        String menuID = menuSnapshot.data!.docs.first.id;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("stores")
              .doc(widget.storeID)
              .collection("menus")
              .doc(menuID)
              .collection("items")
              .limit(10)
              .snapshots(),
          builder: (context, itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (itemSnapshot.data!.docs.isEmpty) {
              return const SizedBox.shrink();
            }

            return SizedBox(
              height: 340,
              child: PageView.builder(
                itemCount: itemSnapshot.data!.docs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  var doc = itemSnapshot.data!.docs[index];
                  Items item = Items.fromJson(doc.data() as Map<String, dynamic>);
                  item.itemID = doc.id;
                  item.menuID = menuID;
                  item.storeID = widget.storeID;

                  return _buildItemCard(context, item);
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildItemCard(BuildContext context, Items item) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItemDetailsScreen(model: item),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 310,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: const Color(0xFFE2E2E2)),
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Item Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          // Image
                          (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                              ? Image.network(
                                  item.imageUrl!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  color: Colors.black.withValues(alpha: 0.25),
                                  colorBlendMode: BlendMode.darken,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Icon(Icons.restaurant, size: 60, color: Colors.grey[500]),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: Icon(Icons.restaurant, size: 60, color: Colors.grey[500]),
                                ),
                          
                          // Content overlay
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title ?? 'Unknown Item',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black45,
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            widget.storeName,
                                            style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.9),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              shadows: const [
                                                Shadow(
                                                  color: Colors.black45,
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Likes badge
                                    if (item.likes != null && item.likes! > 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withValues(alpha: 0.85),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.favorite, color: Colors.white, size: 16),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${item.likes}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                
                                // Tags
                                if (item.tags != null && item.tags!.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 6.0,
                                    runSpacing: 4.0,
                                    children: item.tags!.take(3).map((tag) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withValues(alpha: 0.95),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.local_offer, color: Colors.white, size: 13),
                                            const SizedBox(width: 4),
                                            Text(
                                              tag,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.only(top: 35, left: 12, right: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.restaurant_menu, size: 24, color: Colors.black87),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            item.info ?? 'Delicious food',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        // Price with discount
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (item.hasDiscount) ...[
                              Text(
                                '₹${item.price!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[800],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                '₹${item.discountedPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.red.shade600,
                                ),
                              ),
                            ] else
                              Text(
                                '₹${item.price?.toStringAsFixed(2) ?? '0.00'}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue,
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
          
          // Favorite button
          Positioned(
            top: 10,
            right: 10,
            child: StreamBuilder<bool>(
              stream: isFavoriteStream(item.itemID ?? ''),
              builder: (context, snapshot) {
                bool isFavorite = snapshot.data ?? false;
                
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8),
                    iconSize: 28,
                    onPressed: () {
                      if (item.itemID != null && item.menuID != null && item.storeID != null) {
                        toggleFavorite(item.storeID!, item.menuID!, item.itemID!);
                      }
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                      color: isFavorite ? Colors.red : Colors.white,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 8,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Discount badge
          if (item.hasDiscount)
            Positioned(
              top: 200,
              left: 30,
              right: 30,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade600, Colors.red.shade400],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.discount, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '${item.discount!.toInt()}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '• Save ₹${item.savedAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}