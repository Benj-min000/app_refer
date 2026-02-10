class HomePageItem {
  final String imageUrl;
  final String name;

  const HomePageItem(this.name, this.imageUrl);
}

int homePageItemsLenght() {
  return homePageItems.length;
}

List<HomePageItem> getHomePageItems(int index) {
  if (index >= 0 && index < homePageItems.length) {
    return homePageItems[index];
  }
  return [];
}

List<List<HomePageItem>> homePageItems = [
  [
    HomePageItem('Jalebi', 'assets/images/jalebi.webp'),
    HomePageItem('Kaju Barfi', 'assets/images/kajubarfi.jpeg'),
    HomePageItem('Gulab Jamun', 'assets/images/gulabjamun.jpeg'),
    HomePageItem('Soft Drinks', 'assets/images/softdrink.png'),
    HomePageItem('Laddoo', 'assets/images/laddoo.jpeg'),
  ],
  [
    HomePageItem('Shake', 'assets/images/shake.jpeg'),
    HomePageItem('Pastries', 'assets/images/pastries.jpeg'),
    HomePageItem('Momos', 'assets/images/momos.jpeg'),
    HomePageItem('Chocolate', 'assets/images/chokolate.jpeg'),
    HomePageItem('Pizza', 'assets/images/pizza1.jpeg'),
  ],
];