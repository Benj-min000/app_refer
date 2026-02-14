import 'package:flutter/material.dart';

class StatusBanner extends StatelessWidget {
  final bool? status;
  final String? orderStatus;

  const StatusBanner({super.key, this.status, this.orderStatus});

  @override
  Widget build(BuildContext context) {
    String message;
    IconData? iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "Successful" : message = "UnsuccessFul";

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pinkAccent, Colors.redAccent],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            orderStatus == "ended"
                ? "Parcel Delivered $message"
                : "Order Placed $message",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.green,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}