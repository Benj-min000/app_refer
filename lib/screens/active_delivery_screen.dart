// lib/screens/active_delivery_screen.dart
//
// Shows:
//  - Google Map with encoded polyline route (from Cloud Function / Google Directions)
//  - Rider marker, store marker, customer marker
//  - Live ETA from Firestore (updated by Cloud Function every GPS update)
//  - Order details: items list, addresses, rider note, payment method
//  - Status stepper + action button per step
//  - Navigate button (opens Google Maps / Waze)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/rider_provider.dart';
import '../models/delivery_model.dart';
import '../utils/app_theme.dart';

class ActiveDeliveryScreen extends StatefulWidget {
  const ActiveDeliveryScreen({super.key});
  @override
  State<ActiveDeliveryScreen> createState() => _ActiveDeliveryScreenState();
}

class _ActiveDeliveryScreenState extends State<ActiveDeliveryScreen> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Consumer<RiderProvider>(
      builder: (context, provider, _) {
        final delivery = provider.activeDelivery;
        final order    = provider.activeOrder;

        if (delivery == null) {
          return const Scaffold(
            backgroundColor: AppTheme.background,
            body: Center(
                child: CircularProgressIndicator(color: AppTheme.primary)),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: Stack(children: [
            // ── Map (top 50%) ────────────────────────────────────────────
            _MapSection(
              delivery: delivery,
              onMapCreated: (c) => _mapController = c,
            ),
            // ── Bottom panel (scrollable) ────────────────────────────────
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _BottomPanel(
                delivery: delivery,
                order: order,
                provider: provider,
              ),
            ),
            // ── Top bar ──────────────────────────────────────────────────
            _TopBar(orderId: delivery.orderId, eta: delivery.eta),
          ]),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAP SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _MapSection extends StatefulWidget {
  final DeliveryModel delivery;
  final Function(GoogleMapController) onMapCreated;
  const _MapSection({required this.delivery, required this.onMapCreated});

  @override
  State<_MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<_MapSection> {
  Set<Polyline> _polylines = {};
  GoogleMapController? _controller;

  @override
  void didUpdateWidget(_MapSection old) {
    super.didUpdateWidget(old);
    // When Cloud Function writes a new polyline, rebuild it
    if (widget.delivery.route?.encodedPolyline !=
        old.delivery.route?.encodedPolyline) {
      _buildPolyline();
    }
    // Pan map to rider when location updates
    _panToRider();
  }

  void _buildPolyline() {
    final encoded = widget.delivery.route?.encodedPolyline;
    if (encoded == null || encoded.isEmpty) return;

    final points = _decodePolyline(encoded);
    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: AppTheme.primary,
          width: 5,
          patterns: [],
        ),
      };
    });
  }

  void _panToRider() {
    final loc = widget.delivery.riderLocation;
    if (loc == null || _controller == null) return;
    _controller!.animateCamera(
      CameraUpdate.newLatLng(LatLng(loc.lat, loc.lng)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.delivery;
    final riderLoc = d.riderLocation;

    final markers = <Marker>{
      // Store / pickup
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(d.pickup.lat, d.pickup.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: '🏪 Restaurant',
          snippet: d.storeAddress ?? 'Pickup location',
        ),
      ),
      // Customer / dropoff
      Marker(
        markerId: const MarkerId('dropoff'),
        position: LatLng(d.dropoff.lat, d.dropoff.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: '🏠 Customer',
          snippet: d.customerAddress ?? 'Drop-off location',
        ),
      ),
      // Rider (live)
      if (riderLoc != null)
        Marker(
          markerId: const MarkerId('rider'),
          position: LatLng(riderLoc.lat, riderLoc.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure),
          rotation: riderLoc.heading ?? 0,
          infoWindow: const InfoWindow(title: '🛵 You'),
          flat: true,
        ),
    };

    // Initial camera: midpoint
    final midLat = (d.pickup.lat + d.dropoff.lat) / 2;
    final midLng = (d.pickup.lng + d.dropoff.lng) / 2;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.50,
      child: GoogleMap(
        onMapCreated: (c) {
          _controller = c;
          widget.onMapCreated(c);
          // Build polyline once map is ready
          _buildPolyline();
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(midLat, midLng),
          zoom: 13.5,
        ),
        markers: markers,
        polylines: _polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        mapType: MapType.normal,
        style: _darkMapStyle,
      ),
    );
  }

  /// Decode Google's encoded polyline format into LatLng list
  List<LatLng> _decodePolyline(String encoded) {
    final result = <LatLng>[];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result0 = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result0 |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dLat = ((result0 & 1) != 0 ? ~(result0 >> 1) : (result0 >> 1));
      lat += dLat;

      shift = 0;
      result0 = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result0 |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dLng = ((result0 & 1) != 0 ? ~(result0 >> 1) : (result0 >> 1));
      lng += dLng;

      result.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return result;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP BAR — order ID + live ETA
// ─────────────────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final String orderId;
  final EtaData? eta;
  const _TopBar({required this.orderId, this.eta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 12, right: 12, bottom: 8,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.background, Colors.transparent],
        ),
      ),
      child: Row(children: [
        // Back
        _GlassButton(
          child: const Icon(Icons.arrow_back,
              color: AppTheme.textPrimary, size: 20),
          onTap: () => Navigator.pushNamed(context, '/home'),
        ),
        const SizedBox(width: 8),
        // Order ID
        _GlassButton(
          child: Text(
            'Order #${orderId.substring(0, 8).toUpperCase()}',
            style: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13),
          ),
          onTap: null,
        ),
        const Spacer(),
        // ETA badge
        if (eta != null)
          _GlassButton(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.schedule,
                  color: AppTheme.primary, size: 14),
              const SizedBox(width: 4),
              Text(
                '${eta!.minMinutes}–${eta!.maxMinutes} min',
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              // Show source indicator
              if (eta!.source == 'GOOGLE_DIRECTIONS') ...[
                const SizedBox(width: 4),
                const Icon(Icons.my_location,
                    color: AppTheme.primary, size: 10),
              ],
            ]),
            onTap: null,
          ),
      ]),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _GlassButton({required this.child, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surface.withOpacity(0.92),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM PANEL
// ─────────────────────────────────────────────────────────────────────────────
class _BottomPanel extends StatelessWidget {
  final DeliveryModel delivery;
  final OrderModel? order;
  final RiderProvider provider;
  const _BottomPanel({
    required this.delivery, required this.order, required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 36, height: 4,
            decoration: BoxDecoration(
              color: AppTheme.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Status stepper
          _StatusStepper(status: delivery.status),
          const Divider(color: AppTheme.divider, height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              // Current action card
              _ActionCard(delivery: delivery, provider: provider),
              const SizedBox(height: 14),

              // Order details
              if (order != null) ...[
                _OrderDetailsCard(order: order!),
                const SizedBox(height: 14),
              ],

              // Navigate button
              _NavigateButton(delivery: delivery),
              const SizedBox(height: 16),
            ]),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATUS STEPPER
// ─────────────────────────────────────────────────────────────────────────────
class _StatusStepper extends StatelessWidget {
  final String status;
  const _StatusStepper({required this.status});

  static const _steps = [
    {'key': 'ASSIGNED',   'label': 'Assigned'},
    {'key': 'AT_STORE',   'label': 'At Store'},
    {'key': 'PICKED_UP',  'label': 'Picked Up'},
    {'key': 'DELIVERED',  'label': 'Delivered'},
  ];

  int _index(String s) {
    switch (s) {
      case 'ASSIGNED':   return 0;
      case 'AT_STORE':   return 1;
      case 'PICKED_UP':
      case 'DELIVERING': return 2;
      case 'DELIVERED':  return 3;
      default:           return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cur = _index(status);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Expanded(
              child: Container(
                height: 2,
                color: i ~/ 2 < cur ? AppTheme.primary : AppTheme.divider,
              ),
            );
          }
          final si = i ~/ 2;
          final done = si <= cur;
          final active = si == cur;
          return Column(children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: done ? AppTheme.primary : AppTheme.surfaceLight,
                shape: BoxShape.circle,
                border: active
                    ? Border.all(color: AppTheme.primary, width: 2)
                    : null,
              ),
              child: Center(
                child: done && !active
                    ? const Icon(Icons.check,
                        size: 14, color: Colors.black)
                    : Text('${si + 1}',
                        style: TextStyle(
                          color: active
                              ? AppTheme.primary
                              : AppTheme.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        )),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _steps[si]['label']!,
              style: TextStyle(
                color: done
                    ? AppTheme.textPrimary
                    : AppTheme.textSecondary,
                fontSize: 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ]);
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ACTION CARD — current step instruction + button
// ─────────────────────────────────────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final DeliveryModel delivery;
  final RiderProvider provider;
  const _ActionCard({required this.delivery, required this.provider});

  @override
  Widget build(BuildContext context) {
    final cfg = _config(delivery.status);
    final color = cfg['color'] as Color;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(children: [
        Icon(cfg['icon'] as IconData, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cfg['title'] as String,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 15)),
            Text(cfg['subtitle'] as String,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 12)),
          ],
        )),
        if (cfg['nextStatus'] != null)
          ElevatedButton(
            onPressed: provider.isLoading
                ? null
                : () => _onTap(context, cfg['nextStatus'] as String),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: provider.isLoading
                ? const SizedBox(
                    width: 16, height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.black))
                : Text(cfg['btnLabel'] as String,
                    style: const TextStyle(fontSize: 13)),
          ),
      ]),
    );
  }

  Map<String, dynamic> _config(String status) {
    switch (status) {
      case 'ASSIGNED':
        return {
          'icon': Icons.directions_bike,
          'color': AppTheme.info,
          'title': 'Head to Restaurant',
          'subtitle': 'Navigate to pick up the order',
          'nextStatus': 'AT_STORE',
          'btnLabel': "I'm Here",
        };
      case 'AT_STORE':
        return {
          'icon': Icons.store,
          'color': AppTheme.warning,
          'title': 'At Restaurant',
          'subtitle': 'Wait for order to be ready',
          'nextStatus': 'PICKED_UP',
          'btnLabel': 'Picked Up',
        };
      case 'PICKED_UP':
      case 'DELIVERING':
        return {
          'icon': Icons.delivery_dining,
          'color': AppTheme.primary,
          'title': 'Delivering',
          'subtitle': 'Head to customer location',
          'nextStatus': 'DELIVERED',
          'btnLabel': 'Delivered ✓',
        };
      default:
        return {
          'icon': Icons.schedule,
          'color': AppTheme.textSecondary,
          'title': 'Processing',
          'subtitle': 'Please wait...',
          'nextStatus': null,
          'btnLabel': '',
        };
    }
  }

  void _onTap(BuildContext context, String nextStatus) {
    if (nextStatus == 'DELIVERED') {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: const Text('Confirm Delivery',
              style: TextStyle(color: AppTheme.textPrimary)),
          content: const Text(
              'Did you hand the order to the customer?',
              style: TextStyle(color: AppTheme.textSecondary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(color: AppTheme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                provider.updateStatus(nextStatus);
              },
              child: const Text('Yes, Delivered'),
            ),
          ],
        ),
      );
    } else {
      provider.updateStatus(nextStatus);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ORDER DETAILS CARD — items + addresses + rider note + payment
// ─────────────────────────────────────────────────────────────────────────────
class _OrderDetailsCard extends StatefulWidget {
  final OrderModel order;
  const _OrderDetailsCard({required this.order});
  @override
  State<_OrderDetailsCard> createState() => _OrderDetailsCardState();
}

class _OrderDetailsCardState extends State<_OrderDetailsCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: [
        // Header — tap to expand/collapse
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              const Icon(Icons.receipt_long_outlined,
                  color: AppTheme.textSecondary, size: 18),
              const SizedBox(width: 8),
              const Text('Order Details',
                  style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
              const Spacer(),
              // Payment badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (order.paymentMethod == 'CARD'
                          ? AppTheme.primary
                          : AppTheme.warning)
                      .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(
                    order.paymentMethod == 'CARD'
                        ? Icons.credit_card
                        : Icons.payments_outlined,
                    size: 12,
                    color: order.paymentMethod == 'CARD'
                        ? AppTheme.primary
                        : AppTheme.warning,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    order.paymentMethod == 'CARD'
                        ? 'Card Paid'
                        : 'Cash: zł${order.finalTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: order.paymentMethod == 'CARD'
                          ? AppTheme.primary
                          : AppTheme.warning,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
              ),
              const SizedBox(width: 6),
              Icon(
                _expanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppTheme.textSecondary, size: 18,
              ),
            ]),
          ),
        ),

        if (_expanded) ...[
          const Divider(color: AppTheme.divider, height: 1),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              // ── Items list ────────────────────────────────────────
              ...order.items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(children: [
                  Container(
                    width: 26, height: 26,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text('${item.quantity}',
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          )),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                      if (item.displayOptions.isNotEmpty)
                        Text(item.displayOptions,
                            style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 11)),
                    ],
                  )),
                  Text('zł ${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 12)),
                ]),
              )),

              const Divider(color: AppTheme.divider, height: 20),

              // ── Addresses ─────────────────────────────────────────
              _AddressRow(
                icon: Icons.store_outlined,
                iconColor: AppTheme.info,
                label: order.storeName,
                address: order.storeAddress ?? '',
                phone: order.storePhone,
              ),
              const SizedBox(height: 10),
              _AddressRow(
                icon: Icons.person_outline,
                iconColor: AppTheme.primary,
                label: order.customerName,
                address: order.deliveryAddress,
                phone: order.customerPhone,
              ),

              // ── Rider note ────────────────────────────────────────
              if (order.riderNote != null &&
                  order.riderNote!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppTheme.warning.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          color: AppTheme.warning, size: 15),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(order.riderNote!,
                            style: const TextStyle(
                                color: AppTheme.warning,
                                fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ],

              // ── Cutlery ───────────────────────────────────────────
              if (order.cutleryRequested == true) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🍴', style: TextStyle(fontSize: 12)),
                      SizedBox(width: 6),
                      Text('Cutlery requested',
                          style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ]),
          ),
        ],
      ]),
    );
  }
}

class _AddressRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String address;
  final String? phone;
  const _AddressRow({
    required this.icon, required this.iconColor,
    required this.label, required this.address, this.phone,
  });
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: iconColor, size: 18),
      const SizedBox(width: 10),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
          Text(address,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      )),
      if (phone != null)
        GestureDetector(
          onTap: () async {
            final uri = Uri.parse('tel:$phone');
            if (await canLaunchUrl(uri)) launchUrl(uri);
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.phone,
                color: AppTheme.primary, size: 16),
          ),
        ),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NAVIGATE BUTTON — opens Google Maps with correct target
// ─────────────────────────────────────────────────────────────────────────────
class _NavigateButton extends StatelessWidget {
  final DeliveryModel delivery;
  const _NavigateButton({required this.delivery});

  @override
  Widget build(BuildContext context) {
    final isToStore = delivery.routePhase == 'TO_PICKUP';
    final target = isToStore ? delivery.pickup : delivery.dropoff;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _navigate(target.lat, target.lng),
        icon: const Icon(Icons.navigation, size: 18),
        label: Text(isToStore
            ? 'Navigate to Restaurant'
            : 'Navigate to Customer'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primary,
          side: const BorderSide(color: AppTheme.primary),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  void _navigate(double lat, double lng) async {
    // Try Google Maps app first, fallback to browser
    final gMaps = Uri.parse(
        'google.navigation:q=$lat,$lng&mode=d');
    final browser = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');
    if (await canLaunchUrl(gMaps)) {
      await launchUrl(gMaps);
    } else {
      await launchUrl(browser,
          mode: LaunchMode.externalApplication);
    }
  }
}

// Dark Google Map style
const String _darkMapStyle = '''
[{"elementType":"geometry","stylers":[{"color":"#1d2c4d"}]},
{"elementType":"labels.text.fill","stylers":[{"color":"#8ec3b9"}]},
{"elementType":"labels.text.stroke","stylers":[{"color":"#1a3646"}]},
{"featureType":"road","elementType":"geometry","stylers":[{"color":"#304a7d"}]},
{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#255763"}]},
{"featureType":"water","elementType":"geometry","stylers":[{"color":"#0e1626"}]}]
''';
