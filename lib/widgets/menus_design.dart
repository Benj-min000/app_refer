import 'package:flutter/material.dart';
import 'package:user_app/models/menus.dart';
import 'package:user_app/screens/items_screen.dart';

class MenusDesignWidget extends StatelessWidget {
  final Menus? model;
  final BuildContext? context;
  const MenusDesignWidget({super.key, this.model, this.context});

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
            MaterialPageRoute(builder: (_) => ItemsScreen(model: model)),
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
              // Banner
              SizedBox(
                height: 160,
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
                                color: Colors.orange,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model?.title ?? 'Untitled Menu',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1D2E),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (model?.description != null && model!.description!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              model!.description!,
                              style: TextStyle(fontSize: 13, color: Colors.grey[500], height: 1.4),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Text('Browse', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.orange)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.orange),
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
        child: Icon(Icons.restaurant_menu_rounded, size: 48, color: Colors.grey[400]),
      ),
    );
  }
}