import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:user_app/global/global.dart';
import 'package:user_app/models/address.dart';
import 'package:user_app/widgets/simple_Appbar.dart';
import 'package:user_app/widgets/text_field.dart';

import "package:user_app/services/location_service.dart";
import 'package:provider/provider.dart';
import 'package:user_app/localization/locale_provider.dart';

class SaveAddressScreen extends StatefulWidget {
  const SaveAddressScreen({super.key});

  @override
  State<SaveAddressScreen> createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _flatNumber = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _completeAddress = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  double lat = 0.0;
  double lng = 0.0; 

  /// Fetches user's current location and updates text fields
  Future<void> getUserLocationAddress() async {
    setState(() => isLoading = true);
    
    try {
      // Get language code from Provider
      final languageCode =
          Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;

      // Fetch full address and split into parts from LocationService
      final Map<String, dynamic> addressParts =  await LocationService.fetchUserLocationAddress(languageCode);

      if (!mounted) return;

      setState(() {
        _locationController.text = addressParts['fullAddress'] ?? '';
        _completeAddress.text = addressParts['fullAddress'] ?? '';
        _flatNumber.text = addressParts['flatNumber'] ?? '';
        _city.text = addressParts['city'] ?? '';
        _state.text = addressParts['state'] ?? '';

        lat = addressParts['lat'] ?? 0.0;
        lng = addressParts['lng'] ?? 0.0;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _phoneNumber.dispose();
    _flatNumber.dispose();
    _city.dispose();
    _state.dispose();
    _completeAddress.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "I-Eat",
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //save address info
          if (formKey.currentState!.validate()) {
            final model = Address(
              name: _name.text.trim(),
              state: _state.text.trim(),
              fullAddress: _completeAddress.text.trim(),
              phoneNumber: _phoneNumber.text.trim(),
              flatNumber: _flatNumber.text.trim(),
              city: _city.text.trim(),
              lat: lat.toString(),
              lng: lng.toString(),
              // locationController: _locationController.text.trim(),
            ).toJson();

            FirebaseFirestore.instance
                .collection("users")
                .doc(sharedPreferences!.getString("uid"))
                .collection("userAddress")
                .doc(DateTime.now().millisecondsSinceEpoch.toString())
                .set(model)
                .then((value) {
              Fluttertoast.showToast(msg: "New Address has been saved.");

              formKey.currentState!.reset();
            });
          }
        },
        label: const Text("Save Now"),
        icon: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 6,
            ),
            const Align(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Save New Address :",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person_pin_circle,
                color: Colors.black,
                size: 35,
              ),
              title: SizedBox(
                width: 250,
                child: const TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  // controller: _locationController,
                  decoration: InputDecoration(
                      hintText: "What's your address",
                      hintStyle: TextStyle(color: Colors.black)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              onPressed: () {
                //get current location
                getUserLocationAddress();
              },
              icon: const Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: Colors.cyan)))),
              label: const Text(
                "Get my address",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  MyTextField(
                    hint: "Name",
                    controller: _name,
                  ),
                  MyTextField(
                    hint: "Phone Number",
                    controller: _phoneNumber,
                  ),
                  MyTextField(
                    hint: "City",
                    controller: _city,
                  ),
                  MyTextField(
                    hint: "State",
                    controller: _state,
                  ),
                  MyTextField(
                    hint: "Address Line",
                    controller: _flatNumber,
                  ),
                  MyTextField(
                    hint: "Complete Address",
                    controller: _completeAddress,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
