import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:user_app/models/restaurants.dart';
import 'package:user_app/models/items.dart';
import 'package:user_app/models/home_page_items.dart';

import 'package:user_app/Home/HomePageItems.dart';
import 'package:user_app/Home/home_tabs.dart';

import 'package:user_app/widgets/restaurant_card.dart';
import 'package:user_app/widgets/address_header.dart';
import 'package:user_app/widgets/my_drower.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/widgets/unified_bottom_bar.dart';
import 'package:user_app/widgets/cart_icon.dart';
import 'package:user_app/widgets/notification_icon.dart';
import 'package:user_app/widgets/progress_bar.dart';

import 'package:user_app/screens/orders_screen.dart';
import 'package:user_app/screens/search_screen.dart';
import 'package:user_app/screens/favorites_screen.dart';
import 'package:user_app/screens/item_details_screen.dart';
import 'package:user_app/screens/menus_screen.dart';

import 'package:user_app/providers/cart_provider.dart';
import 'package:user_app/providers/locale_provider.dart';
import 'package:user_app/extensions/context_translate_ext.dart';
import 'package:user_app/global/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ── Bottom nav ─────────────────────────────────────────────────────────────
  int _currentPageIndex = 0;

  // ── Home content state ─────────────────────────────────────────────────────
  final PageController _promoPageController =
      PageController(viewportFraction: 0.92);
  int _selectedTabIndex = 0;
  bool _showAllCategories = false;
  int _currentPromoPage = 0;
  Locale? _lastLocale;

  @override
  void initState() {
    super.initState();
    Provider.of<CartProvider>(context, listen: false).loadCart();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localeProvider = Provider.of<LocaleProvider>(context);
    if (_lastLocale != localeProvider.locale) {
      _lastLocale = localeProvider.locale;
    }
  }

  @override
  void dispose() {
    _promoPageController.dispose();
    super.dispose();
  }

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
          context, MaterialPageRoute(builder: (_) => routes[index]!));
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tabs = getHomeTabs(context);
    final selectedTab = tabs[_selectedTabIndex];
    final hasMore = selectedTab.categories.length > 10;
    final displayedCategories = _showAllCategories
        ? selectedTab.categories
        : selectedTab.categories.take(10).toList();

    return Listener(
      onPointerDown: (_) {
        final focus = FocusScope.of(context);
        if (!focus.hasPrimaryFocus && focus.focusedChild != null) {
          focus.unfocus();
        }
      },
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          backgroundColor: const Color(0xFFF6F6FB),
          appBar: UnifiedAppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_open,
                    color: Colors.white, size: 28),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: const [
              CartIconWidget(),
              NotificationIconWidget(),
            ],
          ),
          drawer: MyDrawer(),
          bottomNavigationBar: UnifiedBottomNavigationBar(
            currentIndex: _currentPageIndex,
            onTap: _onBottomNavTap,
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ─────────────────────────────────────
                    _buildHeader(context),

                    // ── Tab bar ────────────────────────────────────
                    _buildTabBar(context, tabs),

                    // ── Category grid ──────────────────────────────
                    _buildCategoryGrid(
                        context, displayedCategories, hasMore, selectedTab),

                    const SizedBox(height: 4),

                    // ── Live promotions ────────────────────────────
                    _PromotionsBanner(
                      pageController: _promoPageController,
                      currentPage: _currentPromoPage,
                      onPageChanged: (i) =>
                          setState(() => _currentPromoPage = i),
                    ),

                    // ── Order again ────────────────────────────────
                    // Order again — only shown if user has past orders
                    const _OrderAgainSection(),

                    // ── Top restaurants ────────────────────────────
                    _buildSectionHeader(
                      context,
                      'Top Restaurants',
                      Icons.stars_rounded,
                      color: Colors.amber.shade700,
                      subtitle: "Highly rated near you",
                    ),
                    const SizedBox(
                      height: 170,
                      child: _TopRatedRestaurants(),
                    ),

                    // ── What's on your mind ────────────────────────
                    _buildSectionHeader(
                      context,
                      "What's on your mind?",
                      Icons.restaurant_menu_rounded,
                      color: Colors.deepOrange,
                    ),
                    ...List.generate(
                      homePageItemsLenght(),
                      (index) => SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: HomePageItems(itemsIndex: index),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ── Spotlight section header ────────────────────
                    _buildSectionHeader(
                      context,
                      'In the Spotlight',
                      Icons.local_fire_department_rounded,
                      color: Colors.redAccent,
                      subtitle: "All open restaurants",
                    ),
                  ],
                ),
              ),

              // ── Restaurants sliver grid ────────────────────────────
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("restaurants")
                    .where("status", isEqualTo: "Active")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                        child: Center(child: circularProgress()));
                  }
                  if (snapshot.hasError) {
                    return const SliverToBoxAdapter(
                        child: Center(
                            child: Text("Error loading restaurants")));
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return SliverToBoxAdapter(
                      child: _RestaurantPlaceholder(),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final doc = snapshot.data!.docs[index];
                          try {
                            Restaurants rModel = Restaurants.fromJson(
                                doc.data() as Map<String, dynamic>);
                            rModel.restaurantID = doc.id;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SizedBox(
                                  height: 280,
                                  child: RestaurantCard(
                                    restaurantID: doc.id,
                                    restaurantName:
                                        rModel.name ?? 'Unknown',
                                  ),
                                ),
                              ),
                            );
                          } catch (_) {
                            return const SizedBox.shrink();
                          }
                        },
                        childCount: snapshot.data!.docs.length,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header (flat red, no gradient) ────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AddressHeader(),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    const SearchScreen(initialText: ''),
                transitionDuration: const Duration(milliseconds: 400),
                reverseTransitionDuration:
                    const Duration(milliseconds: 300),
                transitionsBuilder: (_, animation, __, child) =>
                    ScaleTransition(
                  scale: CurvedAnimation(
                      parent: animation, curve: Curves.easeOutQuart),
                  alignment: Alignment.topCenter,
                  child:
                      FadeTransition(opacity: animation, child: child),
                ),
              ));
              if (!mounted) return;
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded,
                      color: Colors.redAccent, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    context.l10n.hintSearch,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab bar ────────────────────────────────────────────────────────────────

  Widget _buildTabBar(BuildContext context, List tabs) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        labelColor: Colors.redAccent,
        labelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        unselectedLabelColor: Colors.grey[500],
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        indicatorColor: Colors.redAccent,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 3,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        tabs: tabs.map((tab) => Tab(text: tab.label)).toList(),
        onTap: (index) => setState(() {
          _selectedTabIndex = index;
          _showAllCategories = false;
        }),
      ),
    );
  }

  // ── Category grid ──────────────────────────────────────────────────────────

  Widget _buildCategoryGrid(BuildContext context, List displayedCategories,
      bool hasMore, selectedTab) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 0.72,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            itemCount: displayedCategories.length,
            itemBuilder: (context, index) =>
                _buildCategoryItem(context, displayedCategories[index]),
          ),
          if (hasMore) ...[
            const SizedBox(height: 8),
            Divider(height: 1, color: Colors.grey[100]),
            InkWell(
              onTap: () => setState(
                  () => _showAllCategories = !_showAllCategories),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _showAllCategories
                          ? 'Show Less'
                          : context.l10n.seeMore(selectedTab.label),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _showAllCategories
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, HomeCategoryItem category) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchScreen(
            initialText: '',
            categoryFilter: category.label,
            initialTabIndex: 2,
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Icon(category.icon,
                  size: 26, color: Colors.redAccent),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 28,
            child: Center(
              child: Text(
                category.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section header ─────────────────────────────────────────────────────────

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    Color color = Colors.redAccent,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        letterSpacing: 0.1)),
                if (subtitle != null)
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Promotions banner carousel ────────────────────────────────────────────────

class _PromotionsBanner extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const _PromotionsBanner({
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  bool _isLive(Map<String, dynamic> data) {
    if (data['isActive'] != true) return false;
    final now = DateTime.now();
    final start = _toDate(data['startDate']);
    final end = _toDate(data['endDate']);
    if (start == null || end == null) return false;
    return now.isAfter(start) && now.isBefore(end);
  }

  DateTime? _toDate(dynamic raw) {
    if (raw is Timestamp) return raw.toDate();
    if (raw is DateTime) return raw;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collectionGroup('promotions')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox(height: 8);

        final liveDocs = snapshot.data!.docs
            .where((doc) =>
                _isLive(doc.data() as Map<String, dynamic>))
            .toList();

        if (liveDocs.isEmpty) {
          return _buildEmptyBanner();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.local_offer_rounded,
                        size: 14, color: Colors.redAccent),
                  ),
                  const SizedBox(width: 8),
                  const Text("Offers & Promotions",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        const Text("Live",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 160,
              child: PageView.builder(
                controller: pageController,
                itemCount: liveDocs.length,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  final data =
                      liveDocs[index].data() as Map<String, dynamic>;
                  final String? bannerUrl =
                      (data['bannerUrl'] as String?)?.isNotEmpty == true
                          ? data['bannerUrl'] as String
                          : null;
                  final String title =
                      data['title']?.toString() ?? '';
                  final String description =
                      data['description']?.toString() ?? '';
                  final String restaurantID =
                      data['restaurantID']?.toString() ?? '';

                  return GestureDetector(
                    onTap: () {
                      if (restaurantID.isEmpty) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MenusScreen(
                            model: Restaurants(
                              restaurantID: restaurantID,
                              name: '',
                              logoUrl: '',
                              bannerUrl: '',
                              email: '',
                              status: '',
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade100,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (bannerUrl != null)
                            Image.network(bannerUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _placeholder())
                          else
                            _placeholder(),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black
                                      .withValues(alpha: 0.6),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 14,
                            right: 14,
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                if (title.isNotEmpty)
                                  Text(title,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight:
                                              FontWeight.w800),
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis),
                                if (description.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(description,
                                      style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.85),
                                          fontSize: 11),
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (liveDocs.length > 1) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(liveDocs.length, (i) {
                  final bool active = i == currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.redAccent
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _placeholder() => Container(
        color: Colors.grey.shade100,
        child: const Center(
          child: Icon(Icons.campaign_rounded,
              size: 48, color: Color(0xFFDDDDDD)),
        ),
      );
}

// ── Order again — recent items row ────────────────────────────────────────────

class _RecentItemsRow extends StatelessWidget {
  const _RecentItemsRow();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .collection('orders')
          .orderBy('orderTime', descending: true)
          .limit(3)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const _SkeletonRow();
        }

        final List<String> rawItemIDs = [];
        for (final doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>;
          rawItemIDs.addAll(
              List<String>.from(data['itemIDs'] ?? []));
          if (rawItemIDs.length >= 8) break;
        }

        if (rawItemIDs.isEmpty) return const _SkeletonRow();

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchItems(rawItemIDs.take(8).toList()),
          builder: (context, snap) {
            if (!snap.hasData || snap.data!.isEmpty) {
              return const _SkeletonRow();
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              itemCount: snap.data!.length,
              itemBuilder: (context, index) =>
                  _RecentItemCard(data: snap.data![index]),
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchItems(
      List<String> rawIDs) async {
    final List<Map<String, dynamic>> results = [];
    final Set<String> seen = {};

    for (final raw in rawIDs) {
      final parts = raw.split(':');
      if (parts.length < 3) continue;
      if (seen.contains(parts[2])) continue;
      seen.add(parts[2]);
      try {
        final snap = await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(parts[0])
            .collection('menus')
            .doc(parts[1])
            .collection('items')
            .doc(parts[2])
            .get();
        if (snap.exists) {
          results
              .add({...snap.data()!, '_restaurantID': parts[0]});
        }
      } catch (_) {}
    }
    return results;
  }
}

class _RecentItemCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _RecentItemCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final url = (data['imageUrl'] ?? '') as String;
    final title = (data['title'] ?? '') as String;
    final price =
        (data['price'] as num?)?.toStringAsFixed(2) ?? '';

    return GestureDetector(
      onTap: () {
        final item = Items.fromJson(data);
        item.itemID = data['itemID'] ?? '';
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ItemDetailsScreen(model: item)));
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14)),
              child: SizedBox(
                height: 80,
                width: double.infinity,
                child: url.isNotEmpty
                    ? Image.network(url, fit: BoxFit.cover)
                    : Container(
                        color: Colors.grey.shade100,
                        child: Icon(Icons.fastfood_rounded,
                            color: Colors.grey.shade300,
                            size: 32)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('$price zł',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.redAccent)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 10,
                      width: 80,
                      color: Colors.grey.shade200),
                  const SizedBox(height: 4),
                  Container(
                      height: 8,
                      width: 50,
                      color: Colors.grey.shade200),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Order Again section — only rendered if user has past orders ───────────────

class _OrderAgainSection extends StatelessWidget {
  const _OrderAgainSection();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .collection('orders')
          .orderBy('orderTime', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        // Still loading — render nothing so layout doesn't jump
        if (!snapshot.hasData) return const SizedBox.shrink();

        // No orders yet — skip the section entirely
        if (snapshot.data!.docs.isEmpty) return const SizedBox.shrink();

        // User has at least one order — show section
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.replay_rounded,
                        size: 16, color: Colors.redAccent),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Order Again",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                              letterSpacing: 0.1)),
                      Text("Your recent favourites",
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 160, child: _RecentItemsRow()),
          ],
        );
      },
    );
  }
}

// ── Promotions empty placeholder ──────────────────────────────────────────────

Widget _buildEmptyBanner() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.local_offer_rounded,
                  size: 14, color: Colors.redAccent),
            ),
            const SizedBox(width: 8),
            const Text("Offers & Promotions",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87)),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade200,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.campaign_outlined,
                  size: 36, color: Colors.grey.shade300),
              const SizedBox(height: 10),
              Text("Promotion banners are displayed here",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade400)),
              const SizedBox(height: 4),
              Text("No active promotions right now",
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade400)),
            ],
          ),
        ),
      ),
    ],
  );
}

// ── Restaurant empty placeholder ──────────────────────────────────────────────

class _RestaurantPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront_outlined,
                size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text("Restaurants are displayed here",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400)),
            const SizedBox(height: 4),
            Text("No restaurants are open right now",
                style: TextStyle(
                    fontSize: 12, color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }
}

// ── Top Rated Restaurants horizontal scroll ───────────────────────────────────

class _TopRatedRestaurants extends StatelessWidget {
  const _TopRatedRestaurants();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('restaurants')
          .where('status', isEqualTo: 'active')
          .where('avgRating', isGreaterThan: 0)
          .orderBy('avgRating', descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        // Still loading
        if (!snapshot.hasData) {
          return const _TopRatedSkeleton();
        }

        final docs = snapshot.data!.docs;

        // No rated restaurants yet — show placeholder
        if (docs.isEmpty) {
          return const _TopRatedSkeleton(isEmpty: true);
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final String restaurantID = docs[index].id;
            final String name = (data['name'] as String?) ?? 'Restaurant';
            final String logoUrl = (data['logoUrl'] as String?) ?? '';
            final double avgRating =
                ((data['avgRating'] as num?) ?? 0).toDouble();
            final int totalRatings =
                (data['totalRatings'] as int?) ?? 0;

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MenusScreen(
                    model: Restaurants(
                      restaurantID: restaurantID,
                      name: name,
                      logoUrl: logoUrl,
                      bannerUrl: '',
                      email: '',
                      status: '',
                    ),
                  ),
                ),
              ),
              child: Container(
                width: 130,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      margin: const EdgeInsets.only(top: 14),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade100,
                        border: Border.all(
                            color: const Color(0xFFEEEEEE)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: logoUrl.isNotEmpty
                          ? Image.network(logoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _logoFallback())
                          : _logoFallback(),
                    ),

                    const SizedBox(height: 8),

                    // Name
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const Spacer(),

                    // Rating badge
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: avgRating >= 4
                            ? const Color(0xFF00C48C)
                                .withValues(alpha: 0.1)
                            : avgRating >= 3
                                ? Colors.amber
                                    .withValues(alpha: 0.1)
                                : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: avgRating >= 4
                              ? const Color(0xFF00C48C)
                                  .withValues(alpha: 0.3)
                              : avgRating >= 3
                                  ? Colors.amber
                                      .withValues(alpha: 0.3)
                                  : Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 12,
                            color: avgRating >= 4
                                ? const Color(0xFF00C48C)
                                : avgRating >= 3
                                    ? Colors.amber.shade700
                                    : Colors.grey.shade400,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            avgRating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: avgRating >= 4
                                  ? const Color(0xFF00C48C)
                                  : avgRating >= 3
                                      ? Colors.amber.shade700
                                      : Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '($totalRatings)',
                            style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _logoFallback() => Container(
        color: Colors.grey.shade100,
        child: Icon(Icons.restaurant_rounded,
            color: Colors.grey.shade300, size: 26),
      );
}

// ── Skeleton / empty state for top rated ─────────────────────────────────────

class _TopRatedSkeleton extends StatelessWidget {
  final bool isEmpty;
  const _TopRatedSkeleton({this.isEmpty = false});

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,
        itemBuilder: (_, __) => Container(
          width: 130,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                  height: 10,
                  width: 80,
                  color: Colors.grey.shade100),
              const SizedBox(height: 6),
              Container(
                  height: 8,
                  width: 50,
                  color: Colors.grey.shade100),
            ],
          ),
        ),
      );
    }

    // Loading shimmer-style
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 10),
            Container(
                height: 10, width: 80, color: Colors.grey.shade200),
            const SizedBox(height: 6),
            Container(
                height: 8, width: 50, color: Colors.grey.shade200),
          ],
        ),
      ),
    );
  }
}