import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/screens/cart_screen.dart';

class CartIconWidget extends StatelessWidget {
  const CartIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartItemCounter>(
      builder: (context, counter, _) {
        return IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartScreen()),
          ),
          icon: Badge(
            isLabelVisible: counter.count > 0,
            label: Text(counter.count > 99 ? '99+' : '${counter.count}'),
            backgroundColor: Colors.red,
            child: const Icon(
              Icons.shopping_bag,
              color: Colors.white,
              size: 28,
              shadows: [
                Shadow(
                  color: Color(0x66000000),
                  offset: Offset(2.0, 2.0),
                  blurRadius: 4.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}