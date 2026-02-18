import 'dart:async';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:user_app/screens/save_address_screen.dart';
import 'package:user_app/models/address.dart';
import 'package:user_app/widgets/address_design.dart';
import 'package:user_app/assistant_methods/address_changer.dart';

import 'package:user_app/widgets/progress_bar.dart';

import 'package:user_app/global/global.dart';

import "package:user_app/services/location_service.dart";
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/locale_provider.dart';

import 'package:user_app/extensions/context_translate_ext.dart';
import 'package:user_app/widgets/unified_app_bar.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String _gpsLocation = "";
  Map<String, dynamic> _gpsMapData = {};

  Locale? _lastLocale;

  int? _lastAddressIndex;

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        _updateAddress();
      }
    });
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Listening for changing the language
    final localeProvider = Provider.of<LocaleProvider>(context);

    // Listening for chaning the address
    final addressProvider = Provider.of<AddressChanger>(context);

    if (_lastLocale != localeProvider.locale || 
      _lastAddressIndex != addressProvider.count) {
    
      _lastLocale = localeProvider.locale;
      _lastAddressIndex = addressProvider.count;

      _updateAddress();
    }
  }

  void _updateAddress() async {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final languageCode = localeProvider.locale.languageCode;

    if (mounted) {
      setState(() {
        _gpsLocation = context.t.findingLocalization; 
      });
    }

    try {
      final gpsData = await LocationService.fetchUserCurrentLocation(langCode: languageCode);
      if (mounted) {
        setState(() {
          _gpsMapData = gpsData;
          _gpsLocation = gpsData['fullAddress'];
        });
      }
    } catch (e) {
      if (mounted) setState(() => _gpsLocation = context.t.errorAddressNotFound);
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UnifiedAppBar(
        title: "Address Manager",
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new, 
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SaveAddressScreen()));
        },
        label: const Text("Add New Address", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue,
        icon: const Icon(
          Icons.add_location,
          size: 26,
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),

          Consumer<AddressChanger>(builder: (context, address, c) {
            return Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(currentUid)
                  .collection("addresses")
                  .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: circularProgress());
                  }
                  int savedAddressesCount = snapshot.data!.docs.length;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    address.setTotalSavedAddresses(savedAddressesCount);
                  });
                  
                  return ListView.builder(
                    itemCount: savedAddressesCount + 2,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return AddressDesign(
                          value: -1, // Unique ID for GPS selection
                          isCurrentLocationCard: true,
                          model: Address(
                            fullAddress: _gpsLocation, 
                            lat: _gpsMapData['lat']?.toString() ?? '0.0',
                            lng: _gpsMapData['lng']?.toString() ?? '0.0',
                            road: _gpsMapData['road'] ?? '',
                            houseNumber: _gpsMapData['houseNumber'] ?? '',
                            flatNumber: _gpsMapData['flatNumber'] ?? _gpsMapData['subpremise'],
                            postalCode: _gpsMapData['postalCode'] ?? '',
                            city: _gpsMapData['city'] ?? '',
                            state: _gpsMapData['state'] ?? '',
                            country: _gpsMapData['country'] ?? '',
                            label: "Current Location",
                          ),
                        );
                      }

                      if (index == savedAddressesCount + 1) {
                        return const SizedBox(height: 80);
                      }

                      int dataIndex = index - 1;
                      final docSnapshot = snapshot.data!.docs[dataIndex];
                      
                      return AddressDesign(
                        value: dataIndex,
                        addressID: docSnapshot.id,
                        model: Address.fromJson(
                          docSnapshot.data()! as Map<String, dynamic>
                        ),
                      );
                    },
                  );
                },
              ),
            );
          })
        ],
      ),
    );
  }
}
