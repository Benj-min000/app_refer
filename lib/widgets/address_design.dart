import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/address_changer.dart';
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
  final bool isCurrentLocationCard;

  const AddressDesign(
      {super.key,
        this.model,
        this.value,
        this.addressID,
        this.isCurrentLocationCard = false,
      });

  @override
  State<AddressDesign> createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {

  late Future<String> _translationFuture;

  void _selectAddress(AddressChanger addressProvider) {
    Map<String, dynamic> addressData = widget.model?.toJson() ?? {};
    if (widget.isCurrentLocationCard) {
      // The current GPS location
      addressProvider.displayResult(widget.value!, address: addressData);
    } else {
      // The saved addresses
      addressProvider.displayResult(
        widget.value!,
        address: addressData,
        lat: double.tryParse(widget.model?.lat ?? '0.0') ?? 0.0,
        lng: double.tryParse(widget.model?.lng ?? '0.0') ?? 0.0,
      );
    }
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
              trailing: Radio<int>(
                value: widget.value!,
                groupValue: addressProvider.count,
                activeColor: Colors.redAccent,
                onChanged: (val) => _selectAddress(addressProvider),
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
            Text("Flat Number: ${widget.model?.flatNumber ?? ''}"),
            Text("Address: $translatedAddress", 
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
                icon: const Icon(Icons.map_outlined, size: 24),
                label: const Text(
                  "See in Maps",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              if (!widget.isCurrentLocationCard)
                _buildDeleteButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return TextButton.icon(
      icon: const Icon(
        Icons.delete_forever,
        color: Colors.redAccent,
        size: 24,
      ),
      label: Text(
        "Delete",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold
        ),
      ),
      onPressed: () {
        _showDeleteConfirmation();
      },
    );
  }

  void _showDeleteConfirmation() {   
    final addressProvider = Provider.of<AddressChanger>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.zero,
        elevation: 4,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.delete_outline, color: Colors.white, size: 48),
                  SizedBox(height: 8),
                  Text(
                    'Remove Address',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Are you sure you want to remove ${widget.model!.label ?? 'this Address'}?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                    ),
                  ),

                  const SizedBox(height: 40,),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.grey.shade400),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              try {
                                await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(currentUid)
                                  .collection("addresses")
                                  .doc(widget.addressID)
                                  .delete();
                                
                                addressProvider.displayResult(-1, address: {});

                                Fluttertoast.showToast(msg: "Address deleted successfully");
                              } catch (e) {
                                Fluttertoast.showToast(msg: "Error: $e");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              'Remove',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}