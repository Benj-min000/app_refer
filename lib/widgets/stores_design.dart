import 'package:flutter/material.dart';
import 'package:user_app/screens/menus_screen.dart';
import 'package:user_app/models/stores.dart';

class StoreDesignWidget extends StatefulWidget {
  final Stores? model;
  final BuildContext? context;
  
  const StoreDesignWidget({super.key, this.model, this.context});

  @override
  State<StoreDesignWidget> createState() => _StoreDesignWidgetState();
}

class _StoreDesignWidgetState extends State<StoreDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MenusScreen(model: widget.model)
          )
        );
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 50,
                thickness: 3,
                color: Colors.grey[300],
              ),
              // Safe image loading with null check
              (widget.model?.avatar != null && widget.model!.avatar!.isNotEmpty)
                  ? Image.network(
                      widget.model!.avatar!,
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
                        print('Error loading store image: $error');
                        return Container(
                          height: 220,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.store,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Image not available',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 220,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.store,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No image',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                  fontSize: 20,
                  fontFamily: "Train",
                ),
              ),
              Divider(
                height: 50,
                thickness: 2,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}