import 'package:flutter/material.dart';

import 'package:user_app/screens/search_screen.dart';
import 'package:user_app/cake/cakeItemsModel.dart';

class CakeItems extends StatefulWidget {
  const CakeItems({super.key});

  @override
  State<CakeItems> createState() => _CakeItemsState();
}

class _CakeItemsState extends State<CakeItems> {
  @override
  Widget build(BuildContext context) {
    final cakeItemList = getCakeItemList();

    return PageView.builder(
      itemCount: cakeItemList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        final item = cakeItemList[index];

        return InkWell(
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (_) => SearchScreen(initialText: item.name)));
          },
          child: Stack(
            children: [ 
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(cakeItemList[index].cakeImageLink),
                    fit: BoxFit.cover
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.43),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.cakeDiscount != null && item.cakeDiscount!.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF008CFF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child:Text(
                                    item.cakeDiscount!,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item.cakeRating,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Icon(Icons.star, color: Colors.white, size: 16),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  constraints: const BoxConstraints(), 
                  padding: const EdgeInsets.all(8), // Adjust this for how close to the edge you want
                  iconSize: 32,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_border_outlined, 
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 10)], // Helps visibility on light images
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}