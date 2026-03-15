import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:user_app/providers/address_provider.dart';
import 'package:user_app/providers/locale_provider.dart';
import 'package:user_app/providers/amount_provider.dart';
import 'package:user_app/assistant_methods/stripe_payment.dart';
import 'package:user_app/assistant_methods/assistant_methods.dart';

import 'package:user_app/global/global.dart';

import 'package:user_app/models/address.dart';
import 'package:user_app/services/location_service.dart';

import 'package:user_app/screens/address_screen.dart';
import 'package:user_app/screens/home_screen.dart';

import 'package:user_app/widgets/unified_app_bar.dart';
import 'package:user_app/widgets/address_design.dart';
import 'package:user_app/widgets/unified_snackbar.dart';

//  Payment method

enum _PaymentMethod { cash, stripe }

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final String _orderID =
      FirebaseFirestore.instance.collection("orders").doc().id;

  String _restaurantID = "";
  String _orderType = "delivery";
  String? _restaurantAddress;

  _PaymentMethod? _selectedPayment;

  bool _isLoading = true;
  bool _isProcessing = false;

  List<Address> _userAddresses = [];
  String _gpsLabel = "Finding location...";
  Map<String, dynamic> _gpsData = {};

  //  Lifecycle

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _fetchGps();
    await Future.wait([
      _loadRestaurantFromCart(),
      _loadUserAddresses(),
    ]);
  }

  Future<void> _fetchGps() async {
    try {
      final lang = Provider.of<LocaleProvider>(context, listen: false)
          .locale
          .languageCode;
      final data =
          await LocationService.fetchUserCurrentLocation(langCode: lang);
      if (mounted) {
        setState(() {
          _gpsData = data;
          _gpsLabel = data['fullAddress'] ?? 'Location found';
        });
      }
    } catch (_) {
      if (mounted) setState(() => _gpsLabel = "Unable to get location");
    }
  }

  Future<void> _loadRestaurantFromCart() async {
    if (currentUid == null) return;
    try {
      final snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUid)
          .collection("carts")
          .limit(1)
          .get();

      if (snap.docs.isNotEmpty) {
        _restaurantID = snap.docs.first.data()['restaurantID'] ?? '';
        await _loadRestaurantAddress();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _loadRestaurantAddress() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection("restaurants")
          .doc(_restaurantID)
          .collection("addresses")
          .limit(1)
          .get();

      if (snap.docs.isNotEmpty) {
        setState(() => _restaurantAddress =
            snap.docs.first.data()['fullAddress'] ?? "Address not available");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _loadUserAddresses() async {
    if (currentUid == null) return;
    try {
      final snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUid)
          .collection("addresses")
          .get();

      final List<Address> list = [
        // Index 0 — current GPS location (never saved to Firestore)
        Address(
          label: "Current Location",
          fullAddress: _gpsLabel,
          lat: _gpsData['lat']?.toString() ?? '0.0',
          lng: _gpsData['lng']?.toString() ?? '0.0',
          road: _gpsData['road'] ?? '',
          houseNumber: _gpsData['houseNumber'] ?? '',
          postalCode: _gpsData['postalCode'] ?? '',
          city: _gpsData['city'] ?? '',
          state: _gpsData['state'] ?? '',
          country: _gpsData['country'] ?? '',
        ),
      ];

      for (final doc in snap.docs) {
        final data = doc.data();
        data['addressID'] = doc.id;
        list.add(Address.fromJson(data));
      }

      setState(() {
        _userAddresses = list;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() => _isLoading = false);
    }
  }

  //  Validation & ordering

  bool _validate() {
    if (_orderType == "delivery") {
      final ap = Provider.of<AddressProvider>(context, listen: false);
      final idx = ap.count;
      // -1 = GPS selected, 0+ = saved address index
      if (idx < -1 || (idx >= 0 && idx >= _userAddresses.length - 1)) {
        unifiedSnackBar("Please select a delivery address", error: true);
        return false;
      }
    }
    if (_selectedPayment == null) {
      unifiedSnackBar("Please select a payment method", error: true);
      return false;
    }
    return true;
  }

  /// Builds the address map that is embedded directly on the order document.
  /// When the user picks GPS (index -1) we embed the live data without
  /// saving it as a new address document.
  Map<String, dynamic> _buildEmbeddedAddress() {
    if (_orderType == "pickup") {
      return {"type": "pickup", "address": _restaurantAddress ?? ""};
    }

    final ap = Provider.of<AddressProvider>(context, listen: false);
    final idx = ap.count;

    if (idx == -1) {
      // GPS — embed raw, do NOT write to users/{uid}/addresses
      return {
        "type": "gps",
        "label": "Current Location",
        "fullAddress": _gpsLabel,
        "road": _gpsData['road'] ?? '',
        "houseNumber": _gpsData['houseNumber'] ?? '',
        "flatNumber": _gpsData['flatNumber'] ?? _gpsData['subpremise'] ?? '',
        "postalCode": _gpsData['postalCode'] ?? '',
        "city": _gpsData['city'] ?? '',
        "state": _gpsData['state'] ?? '',
        "country": _gpsData['country'] ?? '',
        "lat": _gpsData['lat']?.toString() ?? '0.0',
        "lng": _gpsData['lng']?.toString() ?? '0.0',
      };
    }

    // Saved address — embed a copy (addressID kept for reference)
    final addr = _userAddresses[idx + 1];
    return {
      "type": "saved",
      "addressID": addr.addressID ?? '',
      "label": addr.label ?? '',
      "fullAddress": addr.fullAddress ?? '',
      "road": addr.road ?? '',
      "houseNumber": addr.houseNumber ?? '',
      "flatNumber": addr.flatNumber ?? '',
      "postalCode": addr.postalCode ?? '',
      "city": addr.city ?? '',
      "state": addr.state ?? '',
      "country": addr.country ?? '',
      "lat": addr.lat ?? '0.0',
      "lng": addr.lng ?? '0.0',
    };
  }

  double _deliveryFee(double subtotal) {
    if (_orderType != "delivery") return 0;
    if (subtotal >= 200) return 0;
    if (subtotal >= 100) return 9.99;
    return 14.99;
  }

  Future<void> _placeOrder() async {
    if (!_validate()) return;
    setState(() => _isProcessing = true);

    try {
      final amountProvider =
          Provider.of<AmountProvider>(context, listen: false);
      final subtotal = amountProvider.totalAmount;
      final fee = _deliveryFee(subtotal);
      final total = subtotal + fee;

      final cartItems = getUserPref<List<String>>("userCart") ?? [];
      final embeddedAddress = _buildEmbeddedAddress();
      final paymentLabel =
          _selectedPayment == _PaymentMethod.cash ? "cash" : "stripe";

      final Map<String, dynamic> orderBase = {
        "orderID": _orderID,
        "userID": currentUid,
        "restaurantID": _restaurantID,
        "itemIDs": cartItems,
        "riderID": "",
        "orderType": _orderType,
        "paymentMethod": paymentLabel,
        "subtotal": subtotal.toStringAsFixed(2),
        "originalAmount": amountProvider.originalAmount.toStringAsFixed(2),
        "totalSavings": amountProvider.totalSavings.toStringAsFixed(2),
        "deliveryFee": fee.toStringAsFixed(2),
        "totalAmount": total.toStringAsFixed(2),
        "address": embeddedAddress,
        "orderTime": Timestamp.now(),
        "status": "Pending",
        "isSuccess": false,
      };

      if (_selectedPayment == _PaymentMethod.cash) {
        await _finaliseOrder(orderBase, "cash");
      } else {
        final paymentType = await processStripePayment(total);
        if (paymentType != null) {
          await _finaliseOrder(
              {...orderBase, "paymentMethod": paymentType}, paymentType);
        }
      }
    } catch (e) {
      if (!mounted) return;
      unifiedSnackBar("Error: ${e.toString()}", error: true);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _finaliseOrder(
      Map<String, dynamic> data, String paymentDetails) async {
    final finalData = {
      ...data,
      "isSuccess": true,
      "paymentDetails": paymentDetails,
    };

    // Write order to top-level collection + user sub-collection
    await Future.wait([
      FirebaseFirestore.instance
          .collection("orders")
          .doc(_orderID)
          .set(finalData),
      FirebaseFirestore.instance
          .collection("users")
          .doc(currentUid)
          .collection("orders")
          .doc(_orderID)
          .set(finalData),
    ]);

    if (mounted) {
      await clearCartNow(context);
      Provider.of<AmountProvider>(context, listen: false).reset();
    }

    if (!mounted) return;
    unifiedSnackBar("Order placed successfully!");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  //  Build

  @override
  Widget build(BuildContext context) {
    final amountProvider = Provider.of<AmountProvider>(context);
    final subtotal = amountProvider.totalAmount;
    final fee = _deliveryFee(subtotal);
    final total = subtotal + fee;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6FB),
      appBar: UnifiedAppBar(
        title: "Place Order",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.redAccent))
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  Order summary card
                  _SectionLabel(label: "Order Summary"),
                  const SizedBox(height: 10),
                  _SummaryCard(
                    subtotal: subtotal,
                    fee: fee,
                    total: total,
                    orderType: _orderType,
                  ),

                  const SizedBox(height: 24),

                  //  Order type
                  _SectionLabel(label: "Order Type"),
                  const SizedBox(height: 10),
                  _OrderTypeSelector(
                    selected: _orderType,
                    onChanged: (v) => setState(() => _orderType = v),
                  ),

                  const SizedBox(height: 24),

                  //  Address / pickup
                  if (_orderType == "delivery") ...[
                    _SectionLabel(label: "Delivery Address"),
                    const SizedBox(height: 10),
                    if (_userAddresses.isEmpty)
                      _InfoTile(
                          icon: Icons.location_searching,
                          text: "Loading addresses...")
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _userAddresses.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return AddressDesign(
                              model: _userAddresses[0],
                              value: -1,
                              isCurrentLocationCard: true,
                            );
                          }
                          return AddressDesign(
                            model: _userAddresses[index],
                            value: index - 1,
                            addressID: _userAddresses[index].addressID,
                          );
                        },
                      ),
                    const SizedBox(height: 8),
                    _AddAddressButton(onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddressScreen()),
                      );
                      await _loadUserAddresses();
                    }),
                  ],

                  if (_orderType == "pickup") ...[
                    _SectionLabel(label: "Pickup Location"),
                    const SizedBox(height: 10),
                    _InfoTile(
                      icon: Icons.storefront_rounded,
                      text:
                          _restaurantAddress ?? "Loading restaurant address...",
                    ),
                  ],

                  const SizedBox(height: 24),

                  //  Payment
                  _SectionLabel(label: "Payment Method"),
                  const SizedBox(height: 10),
                  _PaymentSelector(
                    selected: _selectedPayment,
                    onChanged: (v) => setState(() => _selectedPayment = v),
                  ),

                  const SizedBox(height: 32),

                  //  Place order button
                  _PlaceOrderButton(
                    isProcessing: _isProcessing,
                    selectedPayment: _selectedPayment,
                    total: total,
                    onPressed: _placeOrder,
                  ),
                ],
              ),
            ),
    );
  }
}

//  Sub-widgets

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
        letterSpacing: 0.1,
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final double subtotal, fee, total;
  final String orderType;

  const _SummaryCard({
    required this.subtotal,
    required this.fee,
    required this.total,
    required this.orderType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          _Row(label: "Subtotal", value: "${subtotal.toStringAsFixed(2)} zł"),
          const SizedBox(height: 8),
          _Row(
            label: "Delivery Fee",
            value: orderType == "pickup"
                ? "—"
                : fee == 0
                    ? "Free"
                    : "${fee.toStringAsFixed(2)} zł",
            valueColor: fee == 0 && orderType == "delivery"
                ? const Color(0xFF00C48C)
                : null,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFF0F0F0)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              Text(
                "${total.toStringAsFixed(2)} zł",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.redAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const _Row({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black87)),
      ],
    );
  }
}

class _OrderTypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _OrderTypeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _TypeTile(
          icon: Icons.delivery_dining_rounded,
          label: "Delivery",
          value: "delivery",
          selected: selected,
          onTap: () => onChanged("delivery"),
        )),
        const SizedBox(width: 12),
        Expanded(
            child: _TypeTile(
          icon: Icons.storefront_rounded,
          label: "Pickup",
          value: "pickup",
          selected: selected,
          onTap: () => onChanged("pickup"),
        )),
      ],
    );
  }
}

class _TypeTile extends StatelessWidget {
  final IconData icon;
  final String label, value, selected;
  final VoidCallback onTap;

  const _TypeTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = selected == value;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color:
              active ? Colors.redAccent.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? Colors.redAccent : const Color(0xFFEEEEEE),
            width: active ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 28, color: active ? Colors.redAccent : Colors.grey[400]),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: active ? Colors.redAccent : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child:
                Text(text, style: const TextStyle(fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _AddAddressButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddAddressButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: Colors.redAccent.withValues(alpha: 0.4),
              style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location_alt_rounded,
                color: Colors.redAccent, size: 18),
            const SizedBox(width: 8),
            const Text(
              "Add or manage addresses",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentSelector extends StatelessWidget {
  final _PaymentMethod? selected;
  final ValueChanged<_PaymentMethod> onChanged;
  const _PaymentSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PaymentTile(
          icon: Icons.payments_rounded,
          label: "Cash on Delivery",
          subtitle: "Pay when your order arrives",
          value: _PaymentMethod.cash,
          selected: selected,
          onTap: () => onChanged(_PaymentMethod.cash),
        ),
        const SizedBox(height: 10),
        _PaymentTile(
          icon: Icons.credit_card_rounded,
          label: "Pay by Card",
          subtitle: "Secure payment via Stripe",
          value: _PaymentMethod.stripe,
          selected: selected,
          onTap: () => onChanged(_PaymentMethod.stripe),
        ),
      ],
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final IconData icon;
  final String label, subtitle;
  final _PaymentMethod value;
  final _PaymentMethod? selected;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = selected == value;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color:
              active ? Colors.redAccent.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? Colors.redAccent : const Color(0xFFEEEEEE),
            width: active ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: active
                    ? Colors.redAccent.withValues(alpha: 0.12)
                    : const Color(0xFFF6F6FB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: active ? Colors.redAccent : Colors.grey[400],
                  size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: active ? Colors.redAccent : Colors.black87)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: active ? Colors.redAccent : Colors.grey.shade300,
                    width: 2),
                color: active ? Colors.redAccent : Colors.transparent,
              ),
              child: active
                  ? const Icon(Icons.check_rounded,
                      size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceOrderButton extends StatelessWidget {
  final bool isProcessing;
  final _PaymentMethod? selectedPayment;
  final double total;
  final VoidCallback onPressed;

  const _PlaceOrderButton({
    required this.isProcessing,
    required this.selectedPayment,
    required this.total,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final label = selectedPayment == _PaymentMethod.cash
        ? "Place Order"
        : selectedPayment == _PaymentMethod.stripe
            ? "Pay ${total.toStringAsFixed(2)} zł"
            : "Select Payment Method";

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isProcessing ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.redAccent.withValues(alpha: 0.5),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: isProcessing
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white),
              )
            : Text(
                label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
      ),
    );
  }
}
