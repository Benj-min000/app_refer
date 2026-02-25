import 'package:flutter/material.dart';
import 'package:user_app/models/restaurants.dart';
import 'package:user_app/screens/menus_screen.dart';

class RestaurantDesignWidget extends StatelessWidget {
  final Restaurants? model;
  const RestaurantDesignWidget({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    final bool hasImage = model?.bannerUrl != null && model!.bannerUrl!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => MenusScreen(model: model)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner image
              SizedBox(
                height: 180,
                width: double.infinity,
                child: hasImage
                    ? Image.network(
                        model!.bannerUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: Colors.grey[100],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Restaurant avatar
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.deepOrangeAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.deepOrangeAccent.withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.restaurant_rounded, color: Colors.deepOrangeAccent, size: 22),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model?.name ?? 'Unknown Restaurant',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1D2E),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // if (model?.address != null && model!.address!.isNotEmpty) ...[
                          //   const SizedBox(height: 2),
                          //   Row(
                          //     children: [
                          //       Icon(Icons.location_on_rounded, size: 12, color: Colors.grey[500]),
                          //       const SizedBox(width: 2),
                          //       Flexible(
                          //         child: Text(
                          //           model!.address!,
                          //           style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          //           maxLines: 1,
                          //           overflow: TextOverflow.ellipsis,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ],
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.deepOrangeAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Text('View', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.deepOrangeAccent)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 18, color:Colors.deepOrangeAccent),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Icon(Icons.store_rounded, size: 48, color: Colors.grey[400]),
      ),
    );
  }
}