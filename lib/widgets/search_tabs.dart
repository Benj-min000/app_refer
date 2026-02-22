import 'package:flutter/material.dart';
import 'package:user_app/extensions/context_translate_ext.dart';

class SearchTab {
  final String label;

  SearchTab({required this.label});
}

List<SearchTab> getSearchTabs(BuildContext context) {
  final t = context.t;
  return [
    SearchTab(label: t.searchAll), 
    SearchTab(label: t.searchRestaurants), 
    SearchTab(label: t.searchFood),    
    SearchTab(label: t.searchStores),
  ];
}