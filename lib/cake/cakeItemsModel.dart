class CakeItemsModel {
  final String cakeImageLink;
  final String? cakeDiscount;
  final String name;
  final String cakeRating;

  CakeItemsModel({
    required this.cakeImageLink,
    this.cakeDiscount,
    required this.name,
    required this.cakeRating
  });
}

List<CakeItemsModel> getCakeItemList () {
  return [
    CakeItemsModel(
        cakeImageLink: 'assets/images/cake1.jpeg',
        name: 'Cake Brown Factory',
        cakeRating: '4.0',
        cakeDiscount: '10% OFF up to 150'),
    CakeItemsModel(
        cakeImageLink: 'assets/images/cake2.jpeg',
        name: 'Binze Cake',
        cakeRating: '3.9',
        cakeDiscount: '20% OFF up to 100'),
    CakeItemsModel(
        cakeImageLink: 'assets/images/cake3.jpeg',
        name: 'Cake Brand  ',
        cakeRating: '4.0',
        cakeDiscount: '30% OFF up to 250'),
  ];
}