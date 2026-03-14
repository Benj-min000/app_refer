import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/screens/home_screen.dart';
import 'package:user_app/screens/favorites_screen.dart';
import 'package:user_app/widgets/unified_bottom_bar.dart';
import 'package:user_app/screens/search_screen.dart';
import 'package:user_app/widgets/my_drower.dart';
import 'package:user_app/screens/order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  int _currentPageIndex = 1;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    if (index == _currentPageIndex) return;
    setState(() => _currentPageIndex = index);
    final Map<int, Widget> routes = {
      0: const HomeScreen(),
      2: const SearchScreen(initialText: ''),
      3: const FavoritesScreen(),
    };
    if (routes.containsKey(index)) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => routes[index]!));
    }
  }

  Future<List<DocumentSnapshot>> _fetchOrderItems(
      DocumentSnapshot orderDoc) async {
    final orderData = orderDoc.data() as Map<String, dynamic>;
    final itemIDs = orderData['itemIDs'] as List<dynamic>;
    final List<DocumentSnapshot> allItems = [];
    final Map<String, List<String>> menuItemsMap = {};

    for (final item in itemIDs) {
      final parts = item.toString().split(':');
      if (parts.length >= 3) {
        final key = "${parts[0]}:${parts[1]}";
        menuItemsMap.putIfAbsent(key, () => []).add(parts[2]);
      }
    }

    for (final entry in menuItemsMap.entries) {
      final pathParts = entry.key.split(':');
      try {
        final snap = await FirebaseFirestore.instance
            .collection("restaurants")
            .doc(pathParts[0])
            .collection("menus")
            .doc(pathParts[1])
            .collection("items")
            .where(FieldPath.documentId, whereIn: entry.value)
            .get();
        allItems.addAll(snap.docs);
      } catch (e) {
        debugPrint("Error fetching items: $e");
      }
    }
    return allItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6FB),
      appBar: UnifiedAppBar(
        title: "Your Orders",
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu_open,
              color: Colors.white,
              size: 28,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(2, 2),
                  blurRadius: 6,
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
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.redAccent,
              unselectedLabelColor: Colors.grey.shade500,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              indicatorColor: Colors.redAccent,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: "Active"),
                Tab(text: "Delivered"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _OrderList(
                  statuses: const ["Pending", "In Progress", "Ready"],
                  emptyMessage: "No active orders",
                  emptySubtitle: "Your current orders will appear here",
                  fetchItems: _fetchOrderItems,
                ),
                _OrderList(
                  statuses: const ["Delivered"],
                  emptyMessage: "No past orders",
                  emptySubtitle: "Your delivered orders will appear here",
                  fetchItems: _fetchOrderItems,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<String> statuses;
  final String emptyMessage, emptySubtitle;
  final Future<List<DocumentSnapshot>> Function(DocumentSnapshot) fetchItems;

  const _OrderList({
    required this.statuses,
    required this.emptyMessage,
    required this.emptySubtitle,
    required this.fetchItems,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(currentUid)
          .collection("orders")
          .where("status", whereIn: statuses)
          .orderBy("orderTime", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: circularProgress());
        }
        if (snapshot.data!.docs.isEmpty) {
          return _EmptyState(message: emptyMessage, subtitle: emptySubtitle);
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final orderDoc = snapshot.data!.docs[index];
            final orderData = orderDoc.data() as Map<String, dynamic>;
            final status = orderData["status"]?.toString() ?? "Pending";

            return FutureBuilder<List<DocumentSnapshot>>(
              future: fetchItems(orderDoc),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Center(child: circularProgress()),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _OrderListItem(
                    orderID: orderDoc.id,
                    orderData: orderData,
                    status: status,
                    items: snap.data!,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _OrderListItem extends StatelessWidget {
  final String orderID, status;
  final Map<String, dynamic> orderData;
  final List<DocumentSnapshot> items;

  const _OrderListItem({
    required this.orderID,
    required this.orderData,
    required this.status,
    required this.items,
  });

  static const List<String> _stepValues = [
    "Pending",
    "In Progress",
    "Ready",
    "Delivered",
  ];

  static const List<String> _stepLabels = [
    "Processing",
    "Accepted",
    "On the Way",
    "Delivered",
  ];

  int get _currentStep {
    final idx = _stepValues.indexOf(status);
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    final int step = _currentStep;
    final String total = "${orderData["totalAmount"] ?? "0.00"} zł";
    final String orderType =
        orderData["orderType"] == "pickup" ? "Pickup" : "Delivery";

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(orderID: orderID),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "#${orderID.substring(0, 10)}...",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  _MiniStatusBadge(status: status),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  SizedBox(
                    height: 48,
                    child: Row(
                      children: items.take(3).map((doc) {
                        final d = doc.data() as Map<String, dynamic>;
                        final url = (d['imageUrl'] ?? '') as String;
                        return Container(
                          width: 48,
                          height: 48,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: url.isNotEmpty
                              ? Image.network(url, fit: BoxFit.cover)
                              : Icon(Icons.fastfood_rounded,
                                  color: Colors.grey.shade300, size: 22),
                        );
                      }).toList(),
                    ),
                  ),
                  if (items.length > 3) ...[
                    const SizedBox(width: 6),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100,
                      ),
                      child: Center(
                        child: Text(
                          "+${items.length - 3}",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade500),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(total,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.redAccent)),
                      Text(orderType,
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Divider(height: 1, color: Colors.grey.shade100),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _stepLabels[step],
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.redAccent),
                  ),
                  const SizedBox(height: 8),
                  _MiniProgressBar(currentStep: step),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniProgressBar extends StatelessWidget {
  final int currentStep;
  const _MiniProgressBar({required this.currentStep});

  static const int _total = 4;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_total, (i) {
        final bool done = i <= currentStep;
        final bool isLast = i == _total - 1;
        return Expanded(
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? Colors.redAccent : Colors.grey.shade200,
                  border: i == currentStep
                      ? Border.all(
                          color: Colors.redAccent.withValues(alpha: 0.3),
                          width: 3)
                      : null,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 2,
                    color: i < currentStep
                        ? Colors.redAccent
                        : Colors.grey.shade200,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _MiniStatusBadge extends StatelessWidget {
  final String status;
  const _MiniStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (status) {
      'Pending' => (const Color(0xFFFEF3C7), const Color(0xFFD97706)),
      'In Progress' => (
          Colors.redAccent.withValues(alpha: 0.1),
          Colors.redAccent
        ),
      'Ready' => (Colors.blue.shade50, Colors.blue.shade700),
      'Delivered' => (
          const Color(0xFF00C48C).withValues(alpha: 0.1),
          const Color(0xFF00C48C)
        ),
      _ => (Colors.grey.shade100, Colors.grey.shade500),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status,
          style:
              TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message, subtitle;
  const _EmptyState({required this.message, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined,
              size: 72, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text(message,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
