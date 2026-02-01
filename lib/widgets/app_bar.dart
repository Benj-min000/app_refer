import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/mainScreens/cart_screen.dart';

class MyAppbar extends StatefulWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  final String? sellerUID;

  const MyAppbar({super.key, this.bottom, this.sellerUID});

  @override
  Size get preferredSize => bottom == null
      ? Size.fromHeight(AppBar().preferredSize.height)
      : Size.fromHeight(80 + AppBar().preferredSize.height);

  @override
  State<MyAppbar> createState() => _MyAppbarState();
}

class _MyAppbarState extends State<MyAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.redAccent],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text(
        "I-Eat",
        style: TextStyle(fontSize: 45, fontFamily: "Signatra"),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CartScreen(sellerUID: widget.sellerUID),
                  ),
                );
              },
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
            Positioned(
              right: 4,
              top: 3,
              child: Consumer<CartItemCounter>(
                builder: (context, counter, child) {
                  return counter.count > 0
                      ? Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.brightness_1,
                          size: 20, color: Colors.white),
                      Text(
                        counter.count.toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                      : const SizedBox();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
