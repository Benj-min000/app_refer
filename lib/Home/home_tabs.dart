import 'package:flutter/material.dart';
import 'package:user_app/extensions/context_translate_ext.dart';

class HomeTab {
  final String label;

  HomeTab({required this.label});
}

List<HomeTab> getHomeTabs(BuildContext context) {
  final t = context.t;

  return [
    HomeTab(label: t.tabFoodDelivery), 
    HomeTab(label: t.tabPickup),      
    HomeTab(label: t.tabGroceryShopping), 
    HomeTab(label: t.tabGifting),       
    HomeTab(label: t.tabBenefits),       
  ];
}