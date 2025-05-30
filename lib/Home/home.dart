import 'package:flutter/material.dart';

import '../cake/cakeItems.dart';
import '../restaurent/restaurent1.dart';
import '../restaurent/restaurent2.dart';
import '../restaurent/restaurent3.dart';
import '../restaurent/restaurent4.dart';
import '../restaurent/restaurent5.dart';
import 'HomeLargeItems.dart';
import 'HomePageItems3.dart';
import 'HomePageMediumItems.dart';
import 'HomepageItems4.dart';

void main(List<String> args) {
  runApp(const MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _DiningPagePageState();
}

class _DiningPagePageState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  final String _location = "동래구 충렬대로428번가길 19";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 6,
        initialIndex: 2, // Default selected: 장보기·쇼핑
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 📍 Location + Search
              Container(
                padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 12),
                color: Colors.redAccent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _location,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.search),
                          hintText: 'Search for food or stores...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 🗂️ Horizontal TabBar
              const TabBar(
                isScrollable: true,
                labelColor: Colors.redAccent,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.redAccent,
                tabs: [
                  Tab(text: '음식배달'),
                  Tab(text: '가게배달'),
                  Tab(text: '장보기·쇼핑'),
                  Tab(text: '픽업'),
                  Tab(text: '선물하기'),
                  Tab(text: '혜택'),
                ],
              ),

              const SizedBox(height: 16),

              // 🧭 Category Grid
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    categoryBox(Icons.fastfood, "음식"),
                    categoryBox(Icons.store, "마트"),
                    categoryBox(Icons.local_cafe, "카페"),
                    categoryBox(Icons.liquor, "주류"),
                    categoryBox(Icons.cake, "디저트"),
                    categoryBox(Icons.delivery_dining, "배달"),
                    categoryBox(Icons.pets, "반려"),
                    categoryBox(Icons.phonelink, "전자"),
                    categoryBox(Icons.home, "생활"),
                    categoryBox(Icons.more_horiz, "더보기"),
                  ],
                ),
              ),

              // 🖼️ Your Existing Widgets (unchanged)
              const SizedBox(height: 250, width: double.infinity, child: HomeLargeItems()),
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Text('EXPLORE',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 126, 126, 126))),
              ),
              const SizedBox(height: 180, width: double.infinity, child: HomeMediumItems()),
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Text('WHATS ON YOUR MIND?',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 126, 126, 126))),
              ),
              const SizedBox(height: 100, width: double.infinity, child: HomePageItems3()),
              const SizedBox(height: 100, width: double.infinity, child: HomePageItems4()),
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Text('IN THE SPOTLIGHT',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 126, 126, 126))),
              ),
              const SizedBox(height: 220, width: double.infinity, child: CakeItems1()),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('OUR RESTAURENTS',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 126, 126, 126))),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('FEATURES',
                    style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 126, 126, 126))),
              ),
              const SizedBox(height: 300, width: double.infinity, child: Restaurent1()),
              const SizedBox(height: 300, width: double.infinity, child: Restaurent2()),
              const SizedBox(height: 300, width: double.infinity, child: Restaurent3()),
              const SizedBox(height: 300, width: double.infinity, child: Restaurent4()),
              const SizedBox(height: 300, width: double.infinity, child: Restaurent5()),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryBox(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.redAccent.shade100,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
