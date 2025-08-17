# I-Eat — Baemin-Style Delivery App (Flutter)

A feature-first Flutter app inspired by **배달의민족 (Baemin)**: friendly pastel UI, 5-tab bottom navigation, location-aware home, category → restaurant → menu flow, cart & orders, favorites, multilingual UI, and pickup map.

- Flutter, Provider, easy_localization, SharedPreferences, Geolocator/Geocoding  
- Firebase Core/Firestore ready (optional to switch on)  
- Stripe SDK already wired (optional)

---

## 1) Features at a glance

- **Baemin look**: mint `#2AC1BC`, sky blue `#00BFFF`, rounded cards, soft shadows, airy spacing
- **Bottom nav (5)**: 홈 / 장보기·쇼핑 / 찜 / 주문내역 / 마이배민
- **Home top tabs (5)**: 음식배달 · 가게배달 · 장보기·쇼핑 · 픽업 · 선물하기
- **Categories (8)** for 음식배달 & 가게배달: 한그릇, 치킨, 중식, 돈까스·회, 피자, 패스트푸드, 찜·탕, 족발·보쌈
- **Restaurant list → Restaurant detail (sections)**: 인기 메뉴 / SET 메뉴 / 나홀로
- **Menu cards** with sizes/prices; add to cart
- **Favorites (찜)**: reusable heart button; works on every card
- **Localization**: ko/en/pl/uk (instant switch with Language screen)
- **Pickup**: map + nearby list (markers from restaurant `location`)

---

## 2) App architecture & navigation

### Root: `AppShell` (BottomNavigationBar + IndexedStack)
Preserves state across tabs.

1. 홈 → `HomeScreen(initialTabIndex: 0)` (음식배달)  
2. 장보기·쇼핑 → `HomeScreen(initialTabIndex: 2)`  
3. 찜 → `FavoritesScreen`  
4. 주문내역 → `HistoryScreen`  
5. 마이배민 → `MyPageScreen`

> Splash routes to **AppShell**, not directly to Home.

**HomeScreen** top area:

- Location bar (GPS + manual input)
- Search (“찾는 메뉴가 뭐에요?”)
- TabBar: 음식배달 / 가게배달 / 장보기·쇼핑 / 픽업 / 선물하기

---

## 3) Folder structure (feature-first)

lib/
main.dart
app/
theme.dart
routes.dart
constants.dart
core/
services/
local_storage.dart
models/
restaurant.dart
menu_item.dart
features/
home/
presentation/
home_screen.dart
language/
presentation/
language_selection_screen.dart
favorites/
data/
favorites_repository.dart
presentation/widgets/
favorite_button.dart
state/
favorites_provider.dart
fooddelivery/
presentation/
food_delivery_screen.dart
restaurant_delivery_screen.dart
shopping_screen.dart
pickup_screen.dart
gift_screen.dart
categories/
korean_screen.dart
chicken_screen.dart
chinese_screen.dart
cutlet_sushi_screen.dart
pizza_screen.dart
fastfood_screen.dart
stew_screen.dart
jokbal_screen.dart
restaurant_details/
restaurant_menu_screen.dart
widgets/
restaurant_card.dart
menu_card.dart
dev/
seed_data.dart
seed_screen.dart
assets/translations/
en.json
ko.json
pl.json
uk.json



> You can keep existing `lib/mainScreens/*` while migrating gradually to `features/*`.

---

## 4) Styling — “배민 스타일”

- **Primary accent:** `#2AC1BC` (mint), **Secondary:** `#00BFFF`
- **Neutrals:** bg `#F7F7F7`, card `#FFFFFF`, text `#111` / `#666`
- **Shapes:** 12–16 radius on cards/images/buttons
- **Shadows:** soft, subtle (blur 6–12)
- **Spacing:** screen padding 16–20, card inner 12–16
- **Restaurant Card pattern:** big image, bold name, info row (★ rating • ETA • fee), heart in top-right

---

## 5) Localization (easy_localization)

- Wrap `runApp` with `EasyLocalization` (ko/en/pl/uk)
- Put translations in `assets/translations/*.json`
- Use `.tr()` everywhere: tab labels, bottom nav, buttons, etc.
- `LanguageSelectionScreen` switches locale instantly.

**pubspec (assets)**:
```yaml
flutter:
  assets:
    - assets/translations/
6) Favorites (찜) — reusable system
FavoritesProvider (SharedPreferences) stores favorite restaurant IDs

FavoriteButton(restaurantId) reads provider state and toggles

Works offline; later you can swap to Firestore with the same widget API.

Register provider:


ChangeNotifierProvider(create: (_) => FavoritesProvider()..load()),
Use on a card:


Positioned(
  right: 4, top: 4,
  child: FavoriteButton(restaurantId: restaurant.id),
)
7) Categories, restaurants, menus — naming & UX rules
Categories (8):
한그릇(korean), 치킨(chicken), 중식(chinese), 돈까스·회(cutlet_sushi), 피자(pizza),
패스트푸드(fastfood), 찜·탕(stew), 족발·보쌈(jokbal)

Naming rules:

Restaurant IDs: {category}{index} → pizza1, chinese2, korean3…

Menu IDs: {category}_menu{index} → pizza_menu1, chinese_menu3…

UX flow:

Home → select 음식배달 or 가게배달 → category grid

Tap category → restaurant list (pizza1, pizza2…)

Tap restaurant → RestaurantMenuScreen

Header: hero image, name, badges, ★rating, ETA, fee

Tabs (chips): 인기 메뉴, SET 메뉴, 나홀로 (and optionally “사장님 추천”)

List: MenuCard with title/subtitle, image, size/price list

“+ 담기” → Cart

8) Data model (local & Firestore-friendly)

class Restaurant {
  final String id;           // "pizza1"
  final String category;     // "pizza"
  final String name;         // "pizza1"
  final String heroImage;    // asset or URL
  final double rating;       // e.g. 4.8
  final String eta;          // "47~62분"
  final int deliveryFee;     // e.g. 0 or 3000
  final List<String> badges; // ["인기1위","사장님 추천"]
  final GeoPoint? location;  // for Pickup map
  final List<MenuSection> sections;
}

class MenuSection {
  final String title;        // "인기 메뉴" / "SET 메뉴" / "나홀로"
  final List<MenuItem> items;
}

class MenuItem {
  final String id;           // "pizza_menu1"
  final String title;        // readable name
  final String subtitle;     // short description
  final String image;        // asset / URL
  final List<SizePrice> prices;
}

class SizePrice {
  final String label;        // "[SIZE 小] 2~3인" or "[나홀로] 1인"
  final int price;           // 22900
}
9) Firestore schema (optional; switchable)
Collections:

bash

/categories/{id}
/restaurants/{restaurantId}
/users/{uid}/favorites/{restaurantId}
/orders/{orderId} or /users/{uid}/orders/{orderId}
Indexes:

restaurants(category ASC, name ASC)

Rules:

Public read for categories/restaurants

Favorites readable/writable by owner

Orders readable by owner; writes controlled/validated

10) Pickup tab
google_maps_flutter on top, centers on user location

Restaurant markers from restaurants.location (GeoPoint)

Marker tap → restaurant card/detail

Below map: nearby list

For “nearby” queries at scale, use geohash (GeoFlutterFire)

11) Dev seeder (dummy data)
lib/dev/seed_data.dart — creates categories & restaurants with isSeeded: true

lib/dev/seed_screen.dart — Seed / Wipe buttons

Adds categories + 2 restaurants per category with menus

Wipes seeded docs only

12) Setup
Permissions:

Android: ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION, android:usesCleartextTraffic="true"

iOS: NSLocationWhenInUseUsageDescription

Localization:

Add translations to assets/translations/

.tr() for all user-facing strings

Run:


flutter pub get
flutter run
13) Reuseable components
FavoriteButton(restaurantId) — heart toggle

RestaurantCard(restaurant) — image, name, info, heart, onTap → details

MenuCard(menuItem) — text, image, size/price list, “+ 담기”

CategoriesChipsBar — horizontal chips

14) History & reorder
Order JSON example:


{
  "menuId": "pizza_menu1",
  "menuName": "하우스 스페셜 피자 1",
  "basePrice": 17900,
  "quantity": 2,
  "chosenOptions": [],
  "chosenGroupItems": [{"group":"SIZE","item":"[SIZE 中] 3~4인","price":6000}],
  "finalPriceEach": 23900,
  "finalPriceTotal": 47800
}
15) Best practices & growth
JSON keys for all strings → .tr() everywhere

Feature-first folders

Providers per feature

Repositories to abstract storage

Cached images, pagination

Auth guard if using cloud favorites/orders

16) Roadmap
Cart redesign

History redesign

Firestore integration for restaurants/menus

Migrate local Favorites → Firestore

MyPage sub-screens

Promotions/hero banners

Geohash-based nearby queries for Pickup

17) Troubleshooting
Language doesn’t change → check EasyLocalization wrapper

Location fails → check permissions

Favorites not saved → ensure FavoritesProvider loads before UI

Seeder no-op → check Firebase init & Firestore rules
## 6) Current situation
Fixing gettinglocation



