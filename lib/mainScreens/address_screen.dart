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
import "package:user_app/services/translator_service.dart";

class AddressScreen extends StatefulWidget {
  final double? totolAmmount;
  final String? sellerUID;

  const AddressScreen({super.key, this.totolAmmount, this.sellerUID});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String _location = "";
  Map<String, dynamic> _currentMapData = {};

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
    final addressProvider = Provider.of<AddressChanger>(context, listen: false);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final languageCode = localeProvider.locale.languageCode;

    Map<String, dynamic> dataToProcess;
    // Check if the user has selected a saved address (index >= 0)
    if (addressProvider.count >= 0) {
      dataToProcess = addressProvider.selectedAddress;
    } 
    else {
      if (mounted) setState(() => _location = context.t.findingLocalization);
    
      try {
        dataToProcess = await LocationService.fetchUserCurrentLocation();
      } 
      catch (e) {
        if (mounted) setState(() => _location = context.t.errorAddressNotFound);
        return;
      }
    }

    _currentMapData = dataToProcess;

    String finalAddress = await TranslationService.formatAndTranslateAddress(dataToProcess, languageCode);
    
    if (mounted) {
      setState(() {
        _location = finalAddress;
      });
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
              "Select Address", 
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
                      if (index == 0) return _buildCurrentLocationCard(address);
                      if (index == savedAddressesCount + 1) {
                        return const SizedBox(height: 80);
                      }

                      int dataIndex = index - 1;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: AddressDesign(
                            curretIndex: address.count,
                            value: dataIndex,
                            addressID: snapshot.data!.docs[dataIndex].id,
                            totolAmmount: widget.totolAmmount,
                            sellerUID: widget.sellerUID,
                            model: Address.fromJson(
                              snapshot.data!.docs[dataIndex].data()!
                                as Map<String, dynamic>),
                          ),
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

  Widget _buildCurrentLocationCard(AddressChanger address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            "Ship to current location?",
            style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              splashColor: Colors.transparent,
              onTap: () {
                if (_location != context.t.findingLocalization && 
                    _location != context.t.errorAddressNotFound) {
                  address.displayResult(-1, address: _currentMapData);
                  _updateAddress();
                }
              },
              leading: const Icon(Icons.my_location, color: Colors.blue, size: 30),
              title: const Text("Use Current Location", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: address.count == -1 
                ? Text(_location) 
                : null,
              trailing: Radio<int>(
                value: -1,
                groupValue: address.count,
                activeColor: Colors.redAccent,
                onChanged: (val) {
                  if (_location != context.t.findingLocalization && 
                      _location != context.t.errorAddressNotFound) {
                    address.displayResult(val!, address: _currentMapData);
                    _updateAddress();
                  }
                },
              ),
            ),
          ),
        ),
        const Divider(thickness: 1, color: Colors.black12),
        const Padding(
          padding: EdgeInsets.only(left: 8.0, top: 10, bottom: 15),
          child: Text(
            "Saved Addresses",
            style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
