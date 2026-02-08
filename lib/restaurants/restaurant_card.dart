import 'package:flutter/material.dart';
import 'package:user_app/models/restaurant_model.dart';
import 'package:user_app/screens/search_screen.dart';

class Restaurant extends StatefulWidget {
  final int restaurantIndex;

  const Restaurant({required this.restaurantIndex, super.key});

  @override
  State<Restaurant> createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  @override
  Widget build(BuildContext context) {
    final list = getRestaurantsList();
    final rowIdx = widget.restaurantIndex;
    final restaurants = list[rowIdx];

    return PageView.builder(
      itemCount: restaurants.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int colIdx) {
        final item = restaurants[colIdx];

        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SearchScreen(initialText: item.name)),
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
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withValues(alpha: 0.43),
                                BlendMode.darken,
                              ),
                              image: AssetImage(item.imageUrl),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            item.rating.toStringAsFixed(1),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const Icon(Icons.star, color: Colors.white, size: 16),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 6.0, 
                                  runSpacing: 4.0, 
                                  children: item.tags.map((tag) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withValues(alpha: 0.9), 
                                        borderRadius: BorderRadius.circular(20), 
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.energy_savings_leaf, color: Colors.white, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            tag,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35, left: 12, right: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.access_alarm_rounded, size: 20, color: Colors.black87),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                '${item.deliveryTime} • ${item.distanceTo}',
                                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              item.displayPrice,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  constraints: const BoxConstraints(), 
                  padding: const EdgeInsets.all(8), // Adjust this for how close to the edge you want
                  iconSize: 32,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_border_outlined, 
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 10)], // Helps visibility on light images
                  ),
                ),
              ),

              Positioned(
                top: 190,
                left: 30,
                right: 30,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF008CFF),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.percent_sharp, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.discount,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}