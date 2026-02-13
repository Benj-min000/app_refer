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
          child: Column(children: [
            Divider(height: 50, thickness: 3,color: Colors.grey[300],
            ),
            Image.network(
              widget.model!.avatar!,
              height: 220,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.model!.name!,
              style: const TextStyle(
                  color: Colors.pinkAccent, fontSize: 20, fontFamily: "Train"),
            ),
            Text(
              widget.model!.email!,
              style: const TextStyle(
                  color: Colors.grey, fontSize: 20, fontFamily: "Train"),
            ),
            Divider(
              height: 50,
              thickness: 2,
              color: Colors.grey[300],
            )
          ]),
        ),
      ),
    );
  }
}