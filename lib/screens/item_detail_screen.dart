import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:number_inc_dec/number_inc_dec.dart";
import "package:user_app/models/items.dart";
import "package:user_app/assistant_methods/assistant_methods.dart";
import 'package:user_app/screens/cart_screen.dart';
import "package:user_app/widgets/unified_app_bar.dart";

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;
  const ItemDetailsScreen({super.key, this.model});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: UnifiedAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            int itemCounter = int.parse(counterTextEditingController.text);
            addItemToCart(
              widget.model!.itemID, 
              widget.model!.menuID,
              widget.model!.storeID,
              context, 
              itemCounter
            );
            Fluttertoast.showToast(msg: "Added to Cart");
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [Colors.redAccent, Colors.pinkAccent],
              ),
            ),
            child: const Center(
              child: Text(
                "ADD TO CART",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Image.network(
                widget.model!.thumbnailUrl.toString(),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.model!.title.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        "₹${widget.model!.price}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 28,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    widget.model!.description.toString(),
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "Quantity",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: NumberInputPrefabbed.roundedButtons(
                            controller: counterTextEditingController,
                            incDecBgColor: Colors.pinkAccent,
                            min: 1,
                            max: 9,
                            initialValue: 1,
                            buttonArrangement: ButtonArrangement.incRightDecLeft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}