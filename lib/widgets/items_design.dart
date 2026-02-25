import 'package:flutter/material.dart';
import 'package:user_app/models/items.dart';
import 'package:user_app/screens/item_details_screen.dart';

class ItemsDesignWidget extends StatelessWidget {
  final Items? model;
  final BuildContext? context;
  const ItemsDesignWidget({super.key, this.model, this.context});

  @override
  Widget build(BuildContext context) {
    final bool hasImage = model?.imageUrl != null && model!.imageUrl!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ItemDetailsScreen(model: model)),
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
              // Image with badges
              Stack(
                children: [
                  SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: hasImage
                        ? Image.network(
                            model!.imageUrl!,
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
                                    color: Colors.orange,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => _placeholder(),
                          )
                        : _placeholder(),
                  ),

                  // Discount badge
                  if (model?.hasDiscount == true)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '-${model!.discount!.toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),

                  // Likes badge
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.favorite_rounded, size: 18, color: Colors.redAccent),
                          const SizedBox(width: 4),
                          Text(
                            '${model?.likes ?? 0}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                               Text(
                                model?.title ?? 'Untitled Item',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1D2E),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(width: 10),

                              // Tags
                              if (model!.tags != null && model!.tags!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6.0,
                                  runSpacing: 4.0,
                                  children: model!.tags!.take(3).map((tag) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withValues(alpha: 0.95),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.local_offer, color: Colors.white, size: 13),
                                          const SizedBox(width: 4),
                                          Text(
                                            tag,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                         
                          if (model?.shortInfo != null && model!.shortInfo!.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(
                              model!.shortInfo!,
                              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],

                          const SizedBox(height: 10),

                          // Price
                          Row(
                            children: [
                              Text(
                                'PLN ${model?.discountedPrice.toStringAsFixed(2) ?? '0.00'}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.orange,
                                ),
                              ),
                              if (model?.hasDiscount == true) ...[
                                const SizedBox(width: 8),
                                Text(
                                  'PLN ${model!.price!.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Text('Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.orange)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.orange),
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
        child: Icon(Icons.fastfood_rounded, size: 48, color: Colors.grey[400]),
      ),
    );
  }
}