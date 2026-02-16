import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_app/models/address.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/shipment_address_design.dart';
import 'package:user_app/widgets/status_banner.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import '../global/global.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String? orderID;

  const OrderDetailsScreen({super.key, this.orderID});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String orderStatus = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: UnifiedAppBar(
        title: "Order Details",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUid)
            .collection("orders")
            .doc(widget.orderID)
            .get(),
        builder: (c, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: circularProgress());
          }

          Map<String, dynamic> dataMap = snapshot.data!.data()! as Map<String, dynamic>;
          orderStatus = dataMap["status"]?.toString() ?? "normal";

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Banner
                StatusBanner(
                  status: dataMap["isSuccess"] ?? false,
                  orderStatus: orderStatus,
                ),

                const SizedBox(height: 16),

                // Order Summary Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order Summary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Amount",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            "₹${dataMap["totalAmount"]?.toStringAsFixed(2) ?? '0.00'}",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Divider(height: 1, color: Colors.grey[200]),
                      const SizedBox(height: 16),

                      _buildInfoRow(
                        "Order ID",
                        "#${widget.orderID?.substring(0, 12)}...",
                        Icons.receipt_long,
                      ),
                      const SizedBox(height: 12),

                      _buildInfoRow(
                        "Order Type",
                        dataMap["orderType"] == "pickup" ? "Pickup" : "Delivery",
                        dataMap["orderType"] == "pickup" ? Icons.store : Icons.delivery_dining,
                      ),
                      const SizedBox(height: 12),

                      _buildInfoRow(
                        "Ordered At",
                      _formatOrderTime(dataMap["orderTime"]),
                        Icons.access_time,
                      ),
                      const SizedBox(height: 12),

                      _buildInfoRow(
                        "Payment",
                        dataMap["paymentDetails"] ?? "Cash on Delivery",
                        Icons.payment,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: orderStatus == "ended"
                        ? Image.asset(
                            'assets/images/delivered.jpg',
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/state.jpg',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                if (dataMap["orderType"] != "pickup" && dataMap["addressID"] != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Delivery Address",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("users")
                        .doc(currentUid)
                        .collection("addresses")
                        .doc(dataMap["addressID"])
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(child: circularProgress()),
                          ),
                        );
                      }

                      if (!snapshot.data!.exists) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              "Address not found",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        );
                      }

                      return ShipmentAddressDesign(
                        model: Address.fromJson(
                          snapshot.data!.data()! as Map<String, dynamic>,
                        ),
                      );
                    },
                  ),
                ],

                if (dataMap["orderType"] == "pickup") ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Pickup Location",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.store,
                            color: Colors.blue.shade700,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pick up from store",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Show this order at the counter",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatOrderTime(dynamic orderTime) {
    try {
      DateTime dateTime;
      
      if (orderTime is Timestamp) {
        dateTime = orderTime.toDate();
      } else if (orderTime is String) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(orderTime));
      } else if (orderTime is int) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(orderTime);
      } else {
        return "Unknown";
      }
      return DateFormat("dd MMM yyyy, hh:mm a").format(dateTime);
    } catch (e) {
      print("Error formatting order time: $e");
      return "Unknown";
    }
  }
}