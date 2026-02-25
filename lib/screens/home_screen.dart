import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:user_app/Home/home.dart';
import 'package:user_app/models/restaurants.dart';
import 'package:user_app/widgets/notification_icon.dart';
import 'package:user_app/widgets/restaurants_design.dart';
import 'package:user_app/widgets/my_drower.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/widgets/unified_bottom_bar.dart';
import 'package:user_app/screens/orders_screen.dart';
import 'package:user_app/screens/search_screen.dart';
import "package:user_app/screens/favorites_screen.dart";
import 'package:user_app/widgets/cart_icon.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:provider/provider.dart';

final List<String> _sliderImages = List.generate(28, (index) => "assets/images/slider/$index.jpg");

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;

  void _onBottomNavTap(int index) {
    if (index == _currentPageIndex) return;
    setState(() => _currentPageIndex = index);

    final Map<int, Widget> routes = {
      1: const OrdersScreen(),
      2: const SearchScreen(initialText: ''),
      3: const FavoritesScreen(),
    };

    if (routes.containsKey(index)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => routes[index]!),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
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
                icon: const Icon(Icons.menu_open, color: Colors.white, size: 28),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
          actions: [
            const CartIconWidget(),
            const NotificationIconWidget(),
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
                      child: CarouselSlider.builder(
                        itemCount: _sliderImages.length,
                        itemBuilder: (context, index, realIndex) {
                          return AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  _sliderImages[index],
                                  fit: BoxFit.cover,
                                  cacheWidth: 400,
                                  cacheHeight: 300,
                                  filterQuality: FilterQuality.low,
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 240,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.2,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                          enableInfiniteScroll: true,
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
              stream: FirebaseFirestore.instance
                  .collection("restaurants")
                  .where("status", isEqualTo: "Active")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(child: Center(child: circularProgress()));
                }
                if (snapshot.hasError) {
                  return const SliverToBoxAdapter(child: Center(child: Text("Error loading restaurants")));
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const SliverToBoxAdapter(child: Center(child: Text("No restaurants available")));
                }

                return SliverMasonryGrid.count(
                  crossAxisCount: 1,
                  itemBuilder: (context, index) {
                    try {
                      var doc = snapshot.data!.docs[index];
                      Restaurants rModel = Restaurants.fromJson(doc.data() as Map<String, dynamic>);
                      rModel.restaurantID = doc.id;

                      return RestaurantDesignWidget(model: rModel);
                    } catch (e) {
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