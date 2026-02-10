import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/address_changer.dart';
import 'package:user_app/screens/placed_order_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/models/address.dart';

import 'package:user_app/global/global.dart';

import 'package:fluttertoast/fluttertoast.dart';
import "package:user_app/screens/map_screen.dart";
import 'package:user_app/services/translator_service.dart';
import 'package:user_app/assistant_methods/locale_provider.dart';
// import 'package:user_app/extensions/context_translate_ext.dart';

class AddressDesign extends StatefulWidget {
  final Address? model;
  final int? value;
  final String? addressID;
  final double? totolAmmount;
  final String? sellerUID;
  final bool isCurrentLocationCard;

  const AddressDesign(
      {super.key,
        this.model,
        this.value,
        this.addressID,
        this.totolAmmount,
        this.sellerUID,
        this.isCurrentLocationCard = false,
      });

  @override
  State<AddressDesign> createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {

  late Future<String> _translationFuture;

  void _selectAddress(AddressChanger addressProvider) {
    if (widget.isCurrentLocationCard) {
      // The current GPS location
      addressProvider.displayResult(widget.value!, address: widget.model?.toJson() ?? {});
    } else {
      // The saved addresses
      Map<String, dynamic> addressData = widget.model?.toJson() ?? {};
      addressProvider.displayResult(
        widget.value!,
        address: addressData,
        lat: double.tryParse(widget.model?.lat ?? '0.0') ?? 0.0,
        lng: double.tryParse(widget.model?.lng ?? '0.0') ?? 0.0,
      );
    }
  }
  
  // ----------------
  // ADD TRANSLATION
  // ----------------
  void _showDeleteDialog(BuildContext context) {
    final addressProvider = Provider.of<AddressChanger>(context, listen: false);
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
                
                addressProvider.displayResult(-1, address: {});

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
  void initState() {
    super.initState();
    
    // Initializing the address translation
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final languageCode = localeProvider.locale.languageCode;
    
    _translationFuture = TranslationService.formatAndTranslateAddress(
      widget.model!.toJson(), 
      languageCode
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressChanger>();
    final isSelected = widget.value == addressProvider.count;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isSelected ? Border.all(color: Colors.redAccent, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            ListTile(
              onTap: () => _selectAddress(addressProvider),
              leading: Icon(
                widget.isCurrentLocationCard ? Icons.my_location : Icons.location_on_rounded,
                color: widget.isCurrentLocationCard ? Colors.blue : Colors.redAccent,
                size: 30,
              ),
              title: Text(
                widget.isCurrentLocationCard ? "Use Current Location" : (widget.model?.label ?? "Address"),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle:(widget.isCurrentLocationCard && !isSelected) 
                ? null 
                : _buildSubtitle(),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.isCurrentLocationCard)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 24),
                      onPressed: () => _showDeleteDialog(context),
                    ),
                  Radio<int>(
                    value: widget.value!,
                    groupValue: addressProvider.count,
                    activeColor: Colors.redAccent,
                    onChanged: (val) => _selectAddress(addressProvider),
                  ),
                ],
              ),
            ),
            if (isSelected) _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    if (widget.isCurrentLocationCard) {
      return Text(widget.model?.fullAddress ?? '');
    }

    return FutureBuilder<String>(
      future: _translationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Translating...");
        }

        if (snapshot.hasError) {
          return Text("Error loading address");
        }

        final translatedAddress = snapshot.data ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Building: ${widget.model?.houseNumber ?? ''}"),
            Text(translatedAddress, 
              style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        const Divider(height: 1, indent: 16, endIndent: 16),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen(
                    initialLat: double.tryParse(widget.model?.lat ?? '0.0') ?? 0.0,
                    initialLng: double.tryParse(widget.model?.lng ?? '0.0') ?? 0.0,
                    isSightSeeing: true,
                  )));
                },
                icon: const Icon(Icons.map_outlined, size: 18),
                label: const Text("See in Maps"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PlacedOrderScreen(
                    addressID: widget.addressID,
                    totolAmmount: widget.totolAmmount,
                    sellerUID: widget.sellerUID,
                  )));
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
        ),
      ],
    );
  }
}