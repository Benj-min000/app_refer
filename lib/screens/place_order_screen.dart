import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';
import 'package:user_app/assistant_methods/address_changer.dart';
import 'package:user_app/assistant_methods/locale_provider.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/screens/home_screen.dart';
import 'package:user_app/models/address.dart';
import 'package:user_app/widgets/address_design.dart';
import 'package:user_app/services/location_service.dart';
import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/screens/address_screen.dart';

class PlaceOrderScreen extends StatefulWidget {
  final double? originalAmount;
  final double? totalAmount;
  final double? totalSavings;

  const PlaceOrderScreen({
    super.key, 
    required this.originalAmount, 
    required this.totalAmount,
    required this.totalSavings,
  });

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  String orderID = "";
  String? storeID;
  String orderType = "delivery"; // "delivery" or "pickup"
  String? storeAddress;
  bool isLoading = true;
  bool isPlacingOrder = false;
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
      _getStoreIDFromCart(),
      _loadUserAddresses(),
    ]);
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
      final languageCode = localeProvider.locale.languageCode;
      
      final gpsData = await LocationService.fetchUserCurrentLocation(langCode: languageCode);
      if (mounted) {
        setState(() {
          _gpsMapData = gpsData;
          _gpsLocation = gpsData['fullAddress'] ?? 'Location found';
        });
      }
    } catch (e) {
      print("Error fetching GPS location: $e");
      if (mounted) {
        setState(() {
          _gpsLocation = "Error: Unable to get location";
        });
      }
    }
  }

  Future<void> _getStoreIDFromCart() async {
    try {
      String? uid = sharedPreferences!.getString("uid");
      if (uid == null) return;

      var cartSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("carts")
          .limit(1)
          .get();

      if (cartSnapshot.docs.isNotEmpty) {
        var cartData = cartSnapshot.docs.first.data();
        setState(() {
          storeID = cartData['storeID'];
        });
        await _loadStoreAddress();
      }
    } catch (e) {
      print("Error getting storeID: $e");
    }
  }

  Future<void> _loadStoreAddress() async {
    if (storeID == null) return;
    
    try {
      var storeDoc = await FirebaseFirestore.instance
          .collection("stores")
          .doc(storeID)
          .get();
      
      if (storeDoc.exists) {
        var storeData = storeDoc.data();
        setState(() {
          storeAddress = storeData?['address'] ?? "Store address not available";
        });
      }
    } catch (e) {
      print("Error loading store address: $e");
    }
  }

  Future<void> _loadUserAddresses() async {
    try {
      String? uid = sharedPreferences!.getString("uid");
      if (uid == null) return;

      var addressSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("addresses")
          .get();

      List<Address> addresses = [];
      
      addresses.add(Address(
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
      ));
      
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
      print("Error loading addresses: $e");
      setState(() {
        isLoading = false;
      });
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

  Future<void> _placeOrder() async {
    if (!_validateOrder()) return;

    setState(() {
      isPlacingOrder = true;
    });

    try {
      final addressProvider = Provider.of<AddressChanger>(context, listen: false);

      String? addressID;
      Map<String, dynamic> addressData = {};
      
      if (orderType == "delivery") {
        int selectedIndex = addressProvider.count;
        
        if (selectedIndex == -1) {
          String uid = sharedPreferences!.getString("uid")!;
          DocumentReference tempAddressRef = FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .collection("addresses")
              .doc();
          
          addressID = tempAddressRef.id;
          
          addressData = {
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
          };
          
          // Save the address document
          await tempAddressRef.set(addressData);
          
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

      List<String> cartItems = sharedPreferences!.getStringList("userCart") ?? [];

      Map<String, dynamic> orderData = {
        "addressID": addressID,
        "userID": sharedPreferences!.getString("uid"),
        "itemIDs": cartItems,
        "totalAmount": widget.totalAmount,
        "paymentDetails": "Cash on Delivery",
        "orderTime": Timestamp.now(),
        "isSuccess": true,
        "storeID": storeID,
        "riderID": "",
        "status": "normal",
        "orderID": orderID,
        "orderType": orderType,
      };

      await _writeOrderDetailsForUser(orderData);
      await _writeOrderDetailsForStore(orderData);

      if (!mounted) return;

      await clearCartNow(context);

      if (!mounted) return;

      Fluttertoast.showToast(
          msg: "Order placed successfully",
          backgroundColor: Colors.green);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      print("Error placing order: $e");
      Fluttertoast.showToast(
          msg: "Failed to place order. Please try again.",
          backgroundColor: Colors.red);
      setState(() {
        isPlacingOrder = false;
      });
    }
  }

  Future<void> _writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
      .collection("users")
      .doc(sharedPreferences!.getString("uid"))
      .collection("orders")
      .doc(orderID)
      .set(data);
  }

  Future<void> _writeOrderDetailsForStore(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
      .collection("orders")
      .doc(orderID)
      .set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UnifiedAppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pop(context);
              },
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
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Order Summary",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Amount:"),
                              Text(
                                "\$${widget.totalAmount?.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text("Delivery"),
                          subtitle: const Text("Get it delivered to your address"),
                          value: "delivery",
                          groupValue: orderType,
                          onChanged: (value) {
                            setState(() {
                              orderType = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text("Pickup"),
                          subtitle: const Text("Collect from store"),
                          value: "pickup",
                          groupValue: orderType,
                          onChanged: (value) {
                            setState(() {
                              orderType = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (orderType == "delivery") ...[
                    const Text(
                      "Select Delivery Address",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (userAddresses.isEmpty)
                      Card(
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
                              value: -1, // Use -1 for current location like AddressScreen
                              isCurrentLocationCard: true,
                            );
                          }
                          
                          // Saved addresses start from index 1, with values 0, 1, 2...
                          return AddressDesign(
                            model: userAddresses[index],
                            value: index - 1, // Adjust value to match AddressScreen pattern
                            addressID: userAddresses[index].addressID,
                          );
                        },
                      ),
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
                  if (orderType == "pickup" && storeAddress != null) ...[
                    const Text(
                      "Pickup Location",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.store, color: Colors.redAccent),
                        title: const Text("Store Address"),
                        subtitle: Text(storeAddress!),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    "Payment Method",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.payment, color: Colors.redAccent),
                      title: const Text("Cash on Delivery"),
                      subtitle: const Text("Payment processing will be added later"),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isPlacingOrder ? null : _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isPlacingOrder
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Place Order",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}