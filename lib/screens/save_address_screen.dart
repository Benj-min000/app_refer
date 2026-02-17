import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:user_app/global/global.dart';
import 'package:user_app/models/address.dart';
import 'package:user_app/services/location_service.dart';

import 'package:provider/provider.dart';

import 'package:user_app/widgets/custom_text_field.dart';

import "package:user_app/screens/map_screen.dart";
import 'package:user_app/widgets/error_dialog.dart';
import 'package:user_app/assistant_methods/address_changer.dart';
import 'package:user_app/widgets/unified_app_bar.dart';

class SaveAddressScreen extends StatefulWidget {
  const SaveAddressScreen({super.key});

  @override
  State<SaveAddressScreen> createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  final TextEditingController _addressLabel = TextEditingController();
  final TextEditingController _houseNumber = TextEditingController();
  final TextEditingController _flatNumber = TextEditingController();
  final TextEditingController _postCode = TextEditingController();
  final TextEditingController _street = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _completeAddress = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  double lat = 0.0;
  double lng = 0.0; 

  @override
  void initState() {
    super.initState();
    int totalAddressCount = Provider.of<AddressChanger>(context, listen: false).totalSavedAddresses;
    _addressLabel.text = "Address ${totalAddressCount + 1}";
  }

  bool _isAddressFetched = false;

  void _assignAddressData(Map<String, dynamic> result) {
    setState(() {
      _city.text = result['city'] ?? '';
      _state.text = result['state'] ?? '';
      _postCode.text = result['postCode'] ?? '';
      _street.text = result['road'] ?? '';
      _houseNumber.text = result['houseNumber'] ?? '';

      String sub = result['subpremise'] ?? '';
      _flatNumber.text = sub.isNotEmpty ? "Apt $sub" : "";

      _completeAddress.text = result['fullAddress'] ?? '';

      // Latitude and Longitude from the map/GPS
      lat = result['lat'] ?? 0.0;
      lng = result['lng'] ?? 0.0;

      _isAddressFetched = true;
    });
  }

  void _handleMapResult() async {
    Map<String, double>? coords = await LocationService.getUserCurrentCoordinates();

    if (!mounted) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreen(
          initialLat: coords?['lat'],
          initialLng: coords?['lng'],
        )
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      _assignAddressData(result);
    }
  }

  Future<void> formValidation() async {
    if (!formKey.currentState!.validate()) {
      return; 
    }

    if (lat == 0.0 || lng == 0.0 || _completeAddress.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const ErrorDialog(message: "Please select a location on the map first."),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final model = Address(
        label: _addressLabel.text.trim(),
        country: _completeAddress.text.trim().split(',').last,
        state: _state.text.trim(),
        city: _city.text.trim(),
        road: _street.text.trim(),
        postalCode: _postCode.text.trim(),
        houseNumber: _houseNumber.text.trim(),
        flatNumber: _flatNumber.text.trim(),
        fullAddress: _completeAddress.text.trim(),
        lat: lat.toString(),
        lng: lng.toString(),
      ).toJson();

      await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUid)
        .collection("addresses")
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(model);

    if (mounted) {
      Fluttertoast.showToast(msg: "New Address has been saved.");
        Navigator.pop(context);
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error: $error");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _addressLabel.dispose();
    _houseNumber.dispose();
    _flatNumber.dispose();
    _postCode.dispose();
    _street.dispose();
    _city.dispose();
    _state.dispose();
    _completeAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final List<CustomTextField> addressFields = [
      CustomTextField(hintText: "Address Label (Home/Work)", controller: _addressLabel, isObsecure: false),
      CustomTextField(hintText: "City", controller: _city, isObsecure: false),
      CustomTextField(hintText: "State", controller: _state, isObsecure: false),
      CustomTextField(hintText: "Street", controller: _street, isObsecure: false),
      CustomTextField(hintText: "House/Building Number", controller: _houseNumber, isObsecure: false),
      CustomTextField(hintText: "Flat / Apartment Number (Optional)", controller: _flatNumber, isObsecure: false),
      CustomTextField(hintText: "Postal Code", controller: _postCode, isObsecure: false),
      CustomTextField(hintText: "Complete Address", controller: _completeAddress, isObsecure: false),
    ];

    return Scaffold(
      appBar: UnifiedAppBar(title: "I-Eat"),
      floatingActionButton: _isAddressFetched 
        ? FloatingActionButton.extended(
            onPressed: isLoading ? null : () => formValidation(),
            label: const Text("Save Now", style: TextStyle(color: Colors.white,  fontWeight: FontWeight.bold, fontSize: 15)),
            icon: const Icon(Icons.save, color: Colors.white),
            backgroundColor: Colors.cyan,
          ) 
        : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLoading) const LinearProgressIndicator(color: Colors.cyan),
            
            // Use a SizedBox to force the Column to take full width for horizontal centering
            SizedBox(
              width: double.infinity, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),

                  const Text(
                    "Add New Address",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  
                  const SizedBox(height: 15),

                  ElevatedButton.icon(
                    onPressed: _handleMapResult,
                    icon: const Icon(Icons.location_on, color: Colors.redAccent, size: 22),
                    label: const Text(
                      "Find your location on Google Maps",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (_isAddressFetched) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Divider(thickness: 1),
                    ),
                    Text(
                      "Verify & Refine Details", 
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 20),

                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: addressFields.map((field) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: field,
                          )).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ] else ...[
                    // Initial state view
                    const SizedBox(height: 60),
                    const Icon(Icons.map_outlined, size: 120, color: Colors.grey),
                    const SizedBox(height: 10),
                    const Text(
                      "Map selection is required to continue", 
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}