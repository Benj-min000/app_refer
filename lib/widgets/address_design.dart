import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/address_changer.dart';
import 'package:user_app/mainScreens/placed_order_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/models/address.dart';

import 'package:user_app/global/global.dart';

import 'package:fluttertoast/fluttertoast.dart';

// import '../maps/maps.dart';

class AddressDesign extends StatefulWidget {
  final Address? model;
  final int? curretIndex;
  final int? value;
  final String? addressID;
  final double? totolAmmount;
  final String? sellerUID;

  const AddressDesign(
      {super.key,
        this.model,
        this.curretIndex,
        this.value,
        this.addressID,
        this.totolAmmount,
        this.sellerUID});

  @override
  State<AddressDesign> createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Address"),
        content: const Text("Are you sure you want to delete this address?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(sharedPreferences!.getString("uid"))
                    .collection("userAddress")
                    .doc(widget.addressID)
                    .delete();

                Fluttertoast.showToast(msg: "Address deleted successfully");
              } catch (e) {
                Fluttertoast.showToast(msg: "Error: $e");
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressChanger>(context);
    final bool isSelected = widget.value == addressProvider.count;

    return InkWell(
      onTap: () {
        addressProvider.displayResult(widget.value!,
            addressText: widget.model!.fullAddress.toString());
      },
      borderRadius: BorderRadius.circular(16),
      child: Stack( // Wrap everything in a Stack
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.redAccent,
                    size: 32,
                  ),
                  title: Row(
                    children: [
                      Text(
                        widget.model!.label.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),

                      const SizedBox(width: 16),

                      GestureDetector(
                        onTap: () => _showDeleteDialog(context),
                        child: const Icon(
                          Icons.delete_rounded, 
                          color: Colors.redAccent, 
                          size: 22
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        widget.model!.flatNumber!.isNotEmpty 
                          ? "Building: ${widget.model!.houseNumber}, Flat: ${widget.model!.flatNumber}" 
                          : "Building: ${widget.model!.houseNumber}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text("${widget.model!.city}, ${widget.model!.state}"),
                      Text(
                        widget.model!.fullAddress.toString(),
                        style: TextStyle(color: Colors.black.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                  trailing: Radio<int>(
                    value: widget.value!,
                    groupValue: addressProvider.count,
                    activeColor: Colors.redAccent,
                    onChanged: (val) {
                      if (val != null) {
                        addressProvider.displayResult(val,
                            addressText: widget.model?.fullAddress ?? "");
                      }
                    },
                  ),
                ),
                
                if (isSelected) ...[ 
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          // LAST WORKED HERE

                          // Map<String, double>? coords = await LocationService.getUserCurrentCoordinates();
                          // if (!mounted) return;
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (_) => MapScreen(
                          //         initialLat: coords?['lat'],
                          //         initialLng: coords?['lng'],
                          //       )
                          //     ),
                          //   );
                        },
                        icon: const Icon(Icons.map_outlined, size: 18),
                        label: const Text("See in Maps"),
                        style: TextButton.styleFrom(foregroundColor: Colors.blue),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacedOrderScreen(
                                addressID: widget.addressID,
                                totolAmmount: widget.totolAmmount,
                                sellerUID: widget.sellerUID,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Proceed to Order"),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}