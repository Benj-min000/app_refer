import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/assistant_methods/address_changer.dart';
import 'package:user_app/assistant_methods/locale_provider.dart';
import 'package:user_app/assistant_methods/total_amount.dart';

import 'package:user_app/global/global.dart';

import 'package:user_app/models/address.dart';
import 'package:user_app/services/location_service.dart';

import 'package:user_app/screens/home_screen.dart';
import 'package:user_app/screens/address_screen.dart';
import 'package:user_app/screens/payment_screen.dart';

import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/widgets/address_design.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  String orderID = "";
  String restaurantID = "";
  String orderType = "delivery";
  String? restaurantAddress;
  bool isLoading = true;
  List<Address> userAddresses = [];
  
  // GPS location data
  String _gpsLocation = "Finding location...";
  Map<String, dynamic> _gpsMapData = {};

  @override
  void initState() {
    super.initState();
    orderID = FirebaseFirestore.instance.collection("orders").doc().id;
    _initializeOrderScreen();
  }

  Future<void> _initializeOrderScreen() async {
    await _fetchCurrentLocation();
    await Future.wait([
      _getRestaurantIDFromCart(),
      _loadUserAddresses(),
    ]);
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
      final gpsData = await LocationService.fetchUserCurrentLocation(
        langCode: localeProvider.locale.languageCode,
      );
      if (mounted) {
        setState(() {
          _gpsMapData = gpsData;
          _gpsLocation = gpsData['fullAddress'] ?? 'Location found';
        });
      }
    } catch (e) {
      if (mounted) setState(() => _gpsLocation = "Error: Unable to get location");
    }
  }

  Future<void> _getRestaurantIDFromCart() async {
    try {
      if (currentUid == null) return;

      var cartSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUid)
          .collection("carts")
          .limit(1)
          .get();

      if (cartSnapshot.docs.isNotEmpty) {
        setState(() => restaurantID = cartSnapshot.docs.first.data()['restaurantID']);
        await _loadRestaurantAddress();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _loadRestaurantAddress() async {    
    try {
      var addressSnapshot = await FirebaseFirestore.instance
          .collection("restaurants")
          .doc(restaurantID)
          .collection("addresses")
          .limit(1)
          .get();
      
      if (addressSnapshot.docs.isNotEmpty) {
        setState(() => restaurantAddress = addressSnapshot.docs.first.data()['fullAddress'] ?? "Store address not available");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _loadUserAddresses() async {
    try {
      if (currentUid == null) return;

      var addressSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUid)
          .collection("addresses")
          .get();
      
      List<Address> addresses = [
        Address(
          label: "Current Location",
          fullAddress: _gpsLocation,
          lat: _gpsMapData['lat']?.toString() ?? '0.0',
          lng: _gpsMapData['lng']?.toString() ?? '0.0',
          road: _gpsMapData['road'] ?? '',
          houseNumber: _gpsMapData['houseNumber'] ?? '',
          postalCode: _gpsMapData['postalCode'] ?? '',
          city: _gpsMapData['city'] ?? '',
          state: _gpsMapData['state'] ?? '',
          country: _gpsMapData['country'] ?? '',
        ),
      ];
      
      for (var doc in addressSnapshot.docs) {
        var addressData = doc.data();
        addressData['addressID'] = doc.id;
        addresses.add(Address.fromJson(addressData));
      }

      setState(() {
        userAddresses = addresses;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() => isLoading = false);
    }
  }

  bool _validateOrder() {
    if (orderType == "delivery") {
      final addressProvider = Provider.of<AddressChanger>(context, listen: false);
      // -1 current location is selected 
      // > 0 saved address is selected
      if (addressProvider.count < -1 || 
          (addressProvider.count >= 0 && addressProvider.count >= userAddresses.length - 1)) {
        Fluttertoast.showToast(msg: "Please select a delivery address");
        return false;
      }
    }
    return true;
  }

  Future<void> _proceedToPayment() async {
    if (!_validateOrder()) return;

    try {
      final addressProvider = Provider.of<AddressChanger>(context, listen: false);
      final amountProvider = Provider.of<TotalAmount>(context, listen: false);

      String? addressID;
      
      if (orderType == "delivery") {
        int selectedIndex = addressProvider.count;
        
        if (selectedIndex == -1) {
          final tempRef = FirebaseFirestore.instance
            .collection("users")
            .doc(currentUid)
            .collection("addresses")
            .doc();
          
          addressID = tempRef.id;
          
          await tempRef.set({
            'label': 'Last Order Location - ${DateTime.now().toString().substring(0, 16)}',
            'road': _gpsMapData['road'] ?? '',
            'houseNumber': _gpsMapData['houseNumber'] ?? '',
            'flatNumber': _gpsMapData['flatNumber'] ?? _gpsMapData['subpremise'],
            'postalCode': _gpsMapData['postalCode'] ?? '',
            'city': _gpsMapData['city'] ?? '',
            'state': _gpsMapData['state'] ?? '',
            'country': _gpsMapData['country'] ?? '',
            'fullAddress': _gpsLocation,
            'lat': _gpsMapData['lat']?.toString() ?? '0.0',
            'lng': _gpsMapData['lng']?.toString() ?? '0.0',
          });          
        } else if (selectedIndex >= 0) {
          // Use saved address
          int addressIndex = selectedIndex + 1;
          if (addressIndex < userAddresses.length) {
            addressID = userAddresses[addressIndex].addressID;
          }
        }
        if (addressID == null || addressID.isEmpty) {
          throw Exception("Unable to determine delivery address");
        }
      } else {
        addressID = "pickup";
      }

      final List<String> cartItems = getUserPref<List<String>>("userCart") ?? [];
      final double deliveryFee = orderType == "delivery"
          ? _calculateDeliveryFee(amountProvider.totalAmount)
          : 0.0;
      final double totalWithDelivery = amountProvider.totalAmount + deliveryFee;

      Map<String, dynamic> orderData = {
        "orderID": orderID,
        "userID": currentUid,
        "addressID": addressID,
        "restaurantID": restaurantID,
        "itemIDs": cartItems,
        "riderID": "",
        "orderType": orderType,

        "totalAmount": amountProvider.totalAmount.toStringAsFixed(2),
        "originalAmount": amountProvider.originalAmount.toStringAsFixed(2),
        "totalSavings": amountProvider.totalSavings.toStringAsFixed(2),
        "deliveryFee": deliveryFee.toStringAsFixed(2),

        "orderTime": Timestamp.now(),
        "isSuccess": false,
        "status": "normal",
      };

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentScreen(
            orderData: orderData,
            amount: totalWithDelivery,
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
  }

  double _calculateDeliveryFee(double orderTotal) {    
    if (orderTotal >= 200) return 0;
    if (orderTotal >= 100) return 9.99;
    return 14.99;
  }

  @override
  Widget build(BuildContext context) {
    final amountProvider = Provider.of<TotalAmount>(context);
    final deliveryFee = orderType == "delivery"
        ? _calculateDeliveryFee(amountProvider.totalAmount)
        : 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: UnifiedAppBar(
        title: "Place Order!",
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            );
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Summary
                  Card(
                    color: Colors.grey[50],
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Order Summary",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Subtotal:",
                                style: TextStyle(fontSize: 14),

                              ),

                              Text(
                                "₹${amountProvider.totalAmount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                              if (deliveryFee > 0) ...[
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Delivery Fee:"),
                                    Text("₹${deliveryFee.toStringAsFixed(2)}"),
                                  ],
                                ),
                              ] else ...[
                                const SizedBox(height: 4),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Delivery Fee:"),
                                    Text("Free", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Total:",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(
                                    "₹${(amountProvider.totalAmount + deliveryFee).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent),
                                  ),
                                ],
                              ),                     
                            ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Order Type",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Card(
                    color: Colors.grey[50],
                    elevation: 2,
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text("Delivery"),
                          subtitle: const Text("Get it delivered to your address"),
                          value: "delivery",
                          groupValue: orderType,
                          onChanged: (value) => setState(() => orderType = value!),
                        ),
                        RadioListTile<String>(
                          title: const Text("Pickup"),
                          subtitle: const Text("Collect from store"),
                          value: "pickup",
                          groupValue: orderType,
                          onChanged: (value) => setState(() => orderType = value!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (orderType == "delivery") ...[
                    const Text(
                      "Select Delivery Address",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    if (userAddresses.isEmpty)
                      Card(
                        color: Colors.grey[50],
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Loading addresses...",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userAddresses.length,
                        itemBuilder: (context, index) {
                          // First item (index 0) is current location with value -1
                          if (index == 0) {
                            return AddressDesign(
                              model: userAddresses[0],
                              value: -1,
                              isCurrentLocationCard: true,
                            );
                          }
                          
                          return AddressDesign(
                            model: userAddresses[index],
                            value: index - 1,
                            addressID: userAddresses[index].addressID,
                          );
                        },
                      ),

                    Center(
                      child: Text(
                        "or add new location...",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Divider(thickness: 2,),

                    ListTile(
                      leading: const Icon(Icons.add_location_alt, color: Colors.blueAccent),
                      title: const Text("Address Manager"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () { 
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddressScreen()
                          ),
                        );
                      },
                    ),
                  ],

                  if (orderType == "pickup" && restaurantAddress != null) ...[
                    const Text(
                      "Pickup Location",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      color: Colors.grey[50],
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.restaurant, color: Colors.redAccent),
                        title: const Text("Restaurant Address"),
                        subtitle: Text(restaurantAddress!),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _proceedToPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Continue to Payment",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}