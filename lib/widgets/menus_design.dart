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
  @override
  Widget build(BuildContext context) {
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
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Divider(
              height: 4,
              thickness: 3,
              color: Colors.grey[300],
            ),
            Image.network(
              widget.model!.imageUrl ?? "No Image",
              height: 220,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.model!.title ?? "No Title",
              style: const TextStyle(
                  color: Colors.pinkAccent, fontSize: 20, fontFamily: "Train"),
            ),
            Text(
              widget.model!.info ?? "No Info",
              style: const TextStyle(
                  color: Colors.grey, fontSize: 20, fontFamily: "Train"),
            ),
            Divider(
              height: 4,
              thickness: 2,
              color: Colors.grey[300],
            )
          ]),
        ),
      ),
    );
  }
}
