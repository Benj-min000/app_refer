import 'package:flutter/material.dart';
import 'package:user_app/extensions/context_translate_ext.dart';

class HomeCategoryItem {
  final IconData icon;
  final String label;

  HomeCategoryItem({required this.icon, required this.label});
}

List<HomeCategoryItem> getHomeCategories(BuildContext context) {
  final t = context.t;

  return [
    HomeCategoryItem(icon: Icons.fastfood, label: t.categoryFood),
    HomeCategoryItem(icon: Icons.store, label: t.categoryGrocery),
    HomeCategoryItem(icon: Icons.local_cafe, label: t.categoryCafe),
    HomeCategoryItem(icon: Icons.liquor, label: t.categoryAlcohol),
    HomeCategoryItem(icon: Icons.cake, label: t.categoryDessert),
    HomeCategoryItem(icon: Icons.delivery_dining, label: t.categoryDelivery),
    HomeCategoryItem(icon: Icons.pets, label: t.categoryPets),
    HomeCategoryItem(icon: Icons.phonelink, label: t.categoryElectronics),
    HomeCategoryItem(icon: Icons.home, label: t.categoryHousehold),
    HomeCategoryItem(icon: Icons.more_horiz, label: t.categoryMore),
  ];
}

