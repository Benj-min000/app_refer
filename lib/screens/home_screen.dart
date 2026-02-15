import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:user_app/Home/home.dart';
import 'package:user_app/models/restaurants.dart';
import 'package:user_app/screens/cart_screen.dart';
import 'package:user_app/widgets/restaurants_design.dart';
import 'package:user_app/widgets/my_drower.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/screens/notification_screen.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/widgets/unified_bottom_bar.dart';

import 'package:user_app/screens/orders_screen.dart';
import 'package:user_app/screens/search_screen.dart';
import "package:user_app/screens/favorites_screen.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final items = List.generate(28, (index) => "assets/images/slider/$index.jpg");
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onBottomNavTap(int index) {
    if (index == _currentPageIndex) return;
    
    setState(() {
      _currentPageIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrdersScreen()),
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

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseAuth.instance.currentUser?.uid != null
                ? FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("notifications")
                    .where("isRead", isEqualTo: false)
                    .snapshots()
                : const Stream.empty(),
              builder: (context, snapshot) {
                int unreadCount = snapshot.hasData ? snapshot.data!.docs.length : 0;

                return IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => const NotificationScreen())
                    );
                  },
                  icon: Badge(
                    isLabelVisible: unreadCount > 0,
                    label: Text(
                      unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.notifications, 
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
                  ),
                );
              }
            ),
          ],
        ),

        bottomNavigationBar: UnifiedBottomNavigationBar(
          currentIndex: _currentPageIndex,
          onTap: _onBottomNavTap,
        ),

        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const Home(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      child: CarouselSlider(
                        items: items.map((imagePath) {
                          return Center(
                            child: SizedBox(
                              width: 360,
                              height: 240,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.all(4.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 300,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.2,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration: const Duration(milliseconds: 600),
                          viewportFraction: 0.8,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Text(
                      "Restaurants",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
                
              ),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("restaurants").snapshots(),
              builder: (context, snapshot) {
                // Loading state
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Center(child: circularProgress()),
                  );
                }

                // Error state
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading restaurants',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Empty state
                if (snapshot.data!.docs.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.store_outlined, size: 80, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              'No restaurants available',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Check back later for new restaurants',
                              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // Data state
                return SliverMasonryGrid.count(
                  crossAxisCount: 1,
                  itemBuilder: (context, index) {
                    try {
                      var doc = snapshot.data!.docs[index];
                      Restaurants rModel = Restaurants.fromJson(doc.data() as Map<String, dynamic>);
                      rModel.restaurantID = doc.id;

                      return RestaurantDesignWidget(
                        model: rModel,
                      );
                    } catch (e) {
                      print('Error loading store at index $index: $e');
                      return const SizedBox.shrink();
                    }
                  },
                  childCount: snapshot.data!.docs.length,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
