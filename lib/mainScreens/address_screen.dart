import 'dart:async';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:user_app/mainScreens/save_address_screen.dart';
import 'package:user_app/models/address.dart';
import 'package:user_app/widgets/address_design.dart';
import 'package:user_app/assistant_methods/address_changer.dart';

import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/simple_Appbar.dart';

import 'package:user_app/global/global.dart';

import "package:user_app/services/location_service.dart";
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/locale_provider.dart';

import 'package:user_app/extensions/context_translate_ext.dart';


class AddressScreen extends StatefulWidget {
  final double? totolAmmount;
  final String? sellerUID;

  const AddressScreen({super.key, this.totolAmmount, this.sellerUID});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  // Address found automatically
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
          _gpsLocation = gpsData['fullAddress'] ?? context.t.findingLocalization;
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
      appBar: SimpleAppBar(
        title: "I-Eat",
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SaveAddressScreen()));
        },
        label: const Text("Add New Address", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.redAccent,
        icon: const Icon(
          Icons.add_location,
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Address Manager", 
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.black54,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    offset: const Offset(2, 2), 
                    blurRadius: 4,        
                  ),
                ],
              ),
            )
          ),
          Consumer<AddressChanger>(builder: (context, address, c) {
            return Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(sharedPreferences!.getString("uid"))
                  .collection("userAddress")
                  .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: circularProgress());
                  }
                  int savedAddressesCount = snapshot.data!.docs.length;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Provider.of<AddressChanger>(context, listen: false)
                      .setTotalSavedAddresses(savedAddressesCount);
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
                            postalCode: _gpsMapData['postalCode'] ?? '',
                            city: _gpsMapData['city'] ?? '',
                            state: _gpsMapData['state'] ?? '',
                            country: _gpsMapData['country'] ?? '',
                            label: "Current Location",
                          ),
                          addressID: "current_gps",
                          totolAmmount: widget.totolAmmount,
                          sellerUID: widget.sellerUID,
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
                        totolAmmount: widget.totolAmmount,
                        sellerUID: widget.sellerUID,
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
