import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:user_app/Home/home.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/models/sellers.dart';
import 'package:user_app/widgets/sellers_design.dart';
import 'package:user_app/widgets/my_drower.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/screens/language_selection_screen.dart';
import 'package:user_app/screens/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final items = List.generate(28, (index) => "assets/images/slider/$index.jpg");

  @override
  void initState() {
    super.initState();
    clearCartNow(context);
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
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
          title: const Text(
            "I-Eat",
            style: TextStyle(fontFamily: "Signatra", fontSize: 40),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.language,
                color: Colors.white,
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
                      builder: (_) => LanguageSelectionScreen()),
                );
              },
            ),

            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => NotificationScreen(),)
                );
              },
              icon: Badge(
                label: const Text(
                  "3", // Number of notifications
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                backgroundColor: Colors.red,
                isLabelVisible: true, // If '0' this needs to be changed to false
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
            )
          ],
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
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("sellers").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Center(child: circularProgress()),
                  );
                }

                return SliverMasonryGrid.count(
                  crossAxisCount: 1, // Number of columns
                  itemBuilder: (context, index) {
                    Sellers sModel = Sellers.fromJson(
                      snapshot.data!.docs[index].data() as Map<String, dynamic>,
                    );
                    return SellersDesignWidget(
                      model: sModel,
                      context: context,
                    );
                  },
                  childCount: snapshot.data!.docs.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
