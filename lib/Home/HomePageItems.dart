import 'package:flutter/material.dart';
import 'package:user_app/screens/search_screen.dart';
import 'package:user_app/models/home_page_items.dart';

class HomePageItems extends StatelessWidget {
  final int itemsIndex;
  const HomePageItems({required this.itemsIndex, super.key});

  @override
  Widget build(BuildContext context) {
    final items = getHomePageItems(itemsIndex);

    return Material(
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, 
          childAspectRatio: 0.8, 
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return CategoryItem(item: items[index]);
        },
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final HomePageItem item;

  const CategoryItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchScreen(initialText: item.name),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), 
                image: DecorationImage(
                  image: AssetImage(item.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.name,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}