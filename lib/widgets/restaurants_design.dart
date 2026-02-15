import 'package:flutter/material.dart';
import 'package:user_app/screens/menus_screen.dart';
import 'package:user_app/models/restaurants.dart';

class RestaurantDesignWidget extends StatefulWidget {
  final Restaurants? model;

  const RestaurantDesignWidget({super.key, this.model});

  @override
  State<RestaurantDesignWidget> createState() => _RestaurantDesignWidgetState();
}

class _RestaurantDesignWidgetState extends State<RestaurantDesignWidget> {
  
  // Extracted placeholder to avoid code duplication
  Widget _buildImagePlaceholder(String message) {
    return Container(
      height: 220,
      width: double.infinity,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.store, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValidUrl = widget.model?.imageUrl != null && 
                             widget.model!.imageUrl!.isNotEmpty;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MenusScreen(model: widget.model))
        );
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(height: 50, thickness: 3, color: Colors.grey[300]),
              
              hasValidUrl
                  ? Image.network(
                      widget.model!.imageUrl!,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 220,
                          color: Colors.grey[100],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder('Image not available');
                      },
                    )
                  : _buildImagePlaceholder('No image provided'),

              const SizedBox(height: 10),
              
              Text(
                widget.model?.name ?? 'Unknown Store',
                style: const TextStyle(
                  color: Colors.pinkAccent,
                  fontSize: 20,
                  fontFamily: "Train",
                ),
              ),
              Text(
                widget.model?.email ?? '',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14, // Reduced slightly for better hierarchy
                  fontFamily: "Train",
                ),
              ),
              
              Divider(height: 50, thickness: 2, color: Colors.grey[300]),
            ],
          ),
        ),
      ),
    );
  }
}