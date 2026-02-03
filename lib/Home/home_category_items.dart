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
    HomeCategoryItem(icon: Icons.percent, label: t.categoryDiscounts),
    HomeCategoryItem(icon: Icons.kebab_dining, label: t.categoryPork),
    HomeCategoryItem(icon: Icons.set_meal, label: t.categoryTonkatsuSashimi),
    HomeCategoryItem(icon: Icons.local_pizza, label: t.categoryPizza),
    HomeCategoryItem(icon: Icons.soup_kitchen, label: t.categoryStew),
    HomeCategoryItem(icon: Icons.restaurant, label: t.categoryChinese),
    HomeCategoryItem(icon: Icons.lunch_dining, label: t.categoryChicken),
    HomeCategoryItem(icon: Icons.rice_bowl, label: t.categoryKorean),
    HomeCategoryItem(icon: Icons.ramen_dining, label: t.categoryOneBowl),
    HomeCategoryItem(icon: Icons.percent_outlined, label: t.categoryPichupDiscount),
  ];
}

