import 'package:flutter/material.dart';
import 'package:user_app/screens/items_screen.dart';
import 'package:user_app/models/menus.dart';

class MenusDesignWidget extends StatefulWidget {
  final Menus? model;
  final BuildContext? context;

  const MenusDesignWidget({super.key, this.model, this.context});

  @override
  State<MenusDesignWidget> createState() => _MenusDesignWidgetState();
}

class _MenusDesignWidgetState extends State<MenusDesignWidget> {
  
  Widget _buildImagePlaceholder(String message) {
    return Container(
      height: 220,
      width: double.infinity,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 60, color: Colors.grey[400]),
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
          MaterialPageRoute(
            builder: (_) => ItemsScreen(model: widget.model)
          )
        );
      },
      splashColor: Colors.pinkAccent,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              
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
                        return _buildImagePlaceholder('Menu image unavailable');
                      },
                    )
                  : _buildImagePlaceholder('No image provided'),

              const SizedBox(height: 10),
              
              Text(
                widget.model?.title ?? "No Title",
                style: const TextStyle(
                    color: Colors.pinkAccent, fontSize: 20, fontFamily: "Train"),
              ),
              Text(
                widget.model?.info ?? "No Info",
                style: const TextStyle(
                    color: Colors.grey, fontSize: 16, fontFamily: "Train"),
              ),
              
              Divider(
                height: 4,
                thickness: 2,
                color: Colors.grey[300],
              )
            ],
          ),
        ),
      ),
    );
  }
}