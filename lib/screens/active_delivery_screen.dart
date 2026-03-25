// lib/screens/active_delivery_screen.dart
//
// Shows the rider's active order with a Google Map, status stepper,
// action button, order details, and navigation.
//
// Works with:
//   provider.activeOrder  — Map<String, dynamic> from orders/{id}
//   provider.updateOrderStatus(orderID, newStatus)
//
// Status strings match customer app exactly:
//   In Progress → rider heads to restaurant
//   Ready       → rider picked up, heading to customer
//   Delivered   → order complete

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/utils/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rider_app/providers/rider_provider.dart';
import 'package:rider_app/utils/app_theme.dart';

class ActiveDeliveryScreen extends StatefulWidget {
  const ActiveDeliveryScreen({super.key});

  @override
  State<ActiveDeliveryScreen> createState() =>
      _ActiveDeliveryScreenState();
}

class _ActiveDeliveryScreenState extends State<ActiveDeliveryScreen> {
  late GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Consumer<RiderProvider>(
      builder: (context, provider, _) {
        final order = provider.activeOrder;

        if (order == null) {
          return const Scaffold(
            backgroundColor: AppTheme.background,
            body: Center(
              child: CircularProgressIndicator(
                  color: AppTheme.primary),
            ),
          );
        }

        final String status =
            order['status']?.toString() ?? 'In Progress';
        final String orderID =
            order['orderID']?.toString() ?? '';

        return Scaffold(
          backgroundColor: AppTheme.background,
          body: Stack(
            children: [
              // ── Map ──────────────────────────────────────────────
              _MapSection(
                order: order,
                onMapCreated: (c) => _mapController = c,
              ),

              // ── Bottom panel ─────────────────────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _BottomPanel(
                  order: order,
                  status: status,
                  orderID: orderID,
                  provider: provider,
                ),
              ),

              // ── Top bar ──────────────────────────────────────────
              _TopBar(orderID: orderID, status: status),
            ],
          ),
        );
      },
    );
  }
}

// ── Map section ───────────────────────────────────────────────────────────────

class _MapSection extends StatefulWidget {
  final Map<String, dynamic> order;
  final Function(GoogleMapController) onMapCreated;

  const _MapSection(
      {required this.order, required this.onMapCreated});

  @override
  State<_MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<_MapSection> {
  late GoogleMapController? _controller;

  /// Extract lat/lng from the embedded address map.
  /// Falls back to Kraków centre if coordinates are missing.
  LatLng _addressLatLng(dynamic addressData) {
    if (addressData is Map) {
      final lat =
          double.tryParse(addressData['lat']?.toString() ?? '');
      final lng =
          double.tryParse(addressData['lng']?.toString() ?? '');
      if (lat != null && lng != null) return LatLng(lat, lng);
    }
    return const LatLng(50.0647, 19.9450); // Kraków fallback
  }

  @override
  Widget build(BuildContext context) {
    final address = widget.order['address'];
    final dropoff = _addressLatLng(address);

    // Restaurant lat/lng — stored on order if available
    final double restLat = double.tryParse(
            widget.order['restaurantLat']?.toString() ?? '') ??
        dropoff.latitude;
    final double restLng = double.tryParse(
            widget.order['restaurantLng']?.toString() ?? '') ??
        dropoff.longitude;
    final pickup = LatLng(restLat, restLng);

    final midLat = (pickup.latitude + dropoff.latitude) / 2;
    final midLng = (pickup.longitude + dropoff.longitude) / 2;

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('pickup'),
        position: pickup,
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(
          title: '🏪 Restaurant',
          snippet: widget.order['restaurantName']
                  ?.toString() ??
              'Pickup',
        ),
      ),
      Marker(
        markerId: const MarkerId('dropoff'),
        position: dropoff,
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(
          title: '🏠 Customer',
          snippet: 'Drop-off location',
        ),
      ),
    };

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.50,
      child: GoogleMap(
        onMapCreated: (c) {
          _controller = c;
          widget.onMapCreated(c);
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(midLat, midLng),
          zoom: 13.5,
        ),
        markers: markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        mapType: MapType.normal,
        style: _darkMapStyle,
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String orderID;
  final String status;

  const _TopBar({required this.orderID, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 12,
        right: 12,
        bottom: 8,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.background, Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          _GlassButton(
            onTap: () => Navigator.pushNamed(context, '/home'),
            child: const Icon(Icons.arrow_back_rounded,
                color: AppTheme.textPrimary, size: 20),
          ),
          const SizedBox(width: 8),
          _GlassButton(
            onTap: null,
            child: Text(
              '#${orderID.length >= 8 ? orderID.substring(0, 8).toUpperCase() : orderID}',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const Spacer(),
          _GlassButton(
            onTap: null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  status,
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surface.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}

// ── Bottom panel ──────────────────────────────────────────────────────────────

class _BottomPanel extends StatelessWidget {
  final Map<String, dynamic> order;
  final String status;
  final String orderID;
  final RiderProvider provider;

  const _BottomPanel({
    required this.order,
    required this.status,
    required this.orderID,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin:
                  const EdgeInsets.only(top: 10, bottom: 6),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Status stepper
            _StatusStepper(status: status),

            const Divider(
                color: AppTheme.divider, height: 20),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Action card
                  _ActionCard(
                    status: status,
                    orderID: orderID,
                    provider: provider,
                  ),
                  const SizedBox(height: 14),

                  // Order details
                  _OrderDetailsCard(order: order),
                  const SizedBox(height: 14),

                  // Navigate button
                  _NavigateButton(order: order, status: status),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            SizedBox(
                height:
                    MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }
}

// ── Status stepper ────────────────────────────────────────────────────────────
// Uses customer app status strings: In Progress → Ready → Delivered

class _StatusStepper extends StatelessWidget {
  final String status;
  const _StatusStepper({required this.status});

  static const List<Map<String, String>> _steps = [
    {'key': 'In Progress', 'label': 'Heading\nto Store'},
    {'key': 'Ready', 'label': 'Picked\nUp'},
    {'key': 'Delivered', 'label': 'Delivered'},
  ];

  int _currentIndex(String s) {
    switch (s) {
      case 'In Progress':
        return 0;
      case 'Ready':
        return 1;
      case 'Delivered':
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cur = _currentIndex(status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Expanded(
              child: Container(
                height: 2,
                color: i ~/ 2 < cur
                    ? AppTheme.primary
                    : AppTheme.divider,
              ),
            );
          }
          final si = i ~/ 2;
          final done = si <= cur;
          final active = si == cur;

          return Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: done
                      ? AppTheme.primary
                      : AppTheme.surfaceLight,
                  shape: BoxShape.circle,
                  border: active
                      ? Border.all(
                          color: AppTheme.primary, width: 2)
                      : null,
                ),
                child: Center(
                  child: done && !active
                      ? const Icon(Icons.check_rounded,
                          size: 14, color: Colors.white)
                      : Text(
                          '${si + 1}',
                          style: TextStyle(
                            color: active
                                ? AppTheme.primary
                                : AppTheme.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _steps[si]['label']!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: done
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary,
                  fontSize: 10,
                  fontWeight: active
                      ? FontWeight.w700
                      : FontWeight.normal,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ── Action card ───────────────────────────────────────────────────────────────

class _ActionCard extends StatelessWidget {
  final String status;
  final String orderID;
  final RiderProvider provider;

  const _ActionCard({
    required this.status,
    required this.orderID,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final cfg = _config(status);
    final color = cfg['color'] as Color;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(cfg['icon'] as IconData,
              color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cfg['title'] as String,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  cfg['subtitle'] as String,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (cfg['nextStatus'] != null) ...[
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : () => _onTap(
                      context, cfg['nextStatus'] as String),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: provider.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white),
                    )
                  : Text(
                      cfg['btnLabel'] as String,
                      style: const TextStyle(fontSize: 13),
                    ),
            ),
          ],
        ],
      ),
    );
  }

  // Maps customer app status strings to UI config
  Map<String, dynamic> _config(String status) {
    switch (status) {
      case 'In Progress':
        return {
          'icon': Icons.directions_bike_rounded,
          'color': AppTheme.info,
          'title': 'Head to Restaurant',
          'subtitle': 'Navigate to pick up the order',
          'nextStatus': AppConstants.statusReady,
          'btnLabel': 'Picked Up',
        };
      case 'Ready':
        return {
          'icon': Icons.delivery_dining_rounded,
          'color': AppTheme.primary,
          'title': 'Delivering',
          'subtitle': 'Head to the customer location',
          'nextStatus': AppConstants.statusDelivered,
          'btnLabel': 'Delivered ✓',
        };
      case 'Delivered':
        return {
          'icon': Icons.check_circle_rounded,
          'color': AppTheme.accent,
          'title': 'Order Delivered',
          'subtitle': 'Great work!',
          'nextStatus': null,
          'btnLabel': '',
        };
      default:
        return {
          'icon': Icons.schedule_rounded,
          'color': AppTheme.textSecondary,
          'title': 'Processing',
          'subtitle': 'Please wait...',
          'nextStatus': null,
          'btnLabel': '',
        };
    }
  }

  void _onTap(BuildContext context, String nextStatus) {
    if (nextStatus == AppConstants.statusDelivered) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: const Text('Confirm Delivery',
              style:
                  TextStyle(color: AppTheme.textPrimary)),
          content: const Text(
            'Did you hand the order to the customer?',
            style:
                TextStyle(color: AppTheme.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(
                      color: AppTheme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                provider.updateOrderStatus(
                    orderID, nextStatus);
              },
              child: const Text('Yes, Delivered'),
            ),
          ],
        ),
      );
    } else {
      provider.updateOrderStatus(orderID, nextStatus);
    }
  }
}

// ── Order details card ────────────────────────────────────────────────────────

class _OrderDetailsCard extends StatefulWidget {
  final Map<String, dynamic> order;
  const _OrderDetailsCard({required this.order});

  @override
  State<_OrderDetailsCard> createState() =>
      _OrderDetailsCardState();
}

class _OrderDetailsCardState
    extends State<_OrderDetailsCard> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final String restaurantName =
        order['restaurantName']?.toString() ?? 'Restaurant';
    final String total =
        '${order['totalAmount'] ?? '0.00'} zł';
    final String orderType =
        order['orderType']?.toString() ?? 'delivery';
    final String paymentMethod =
        order['paymentMethod']?.toString() ?? 'cash';
    final bool isCash =
        paymentMethod == 'cash' || paymentMethod == 'Cash';

    // Delivery address
    final addr = order['address'];
    String deliveryAddress = 'Address not available';
    if (addr is Map) {
      deliveryAddress =
          addr['fullAddress']?.toString() ??
              addr['address']?.toString() ??
              'Address not available';
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () =>
                setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long_outlined,
                      color: AppTheme.textSecondary,
                      size: 18),
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
                      color: (isCash
                              ? AppTheme.warning
                              : AppTheme.primary)
                          .withValues(alpha: 0.15),
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCash
                              ? Icons.payments_outlined
                              : Icons.credit_card_rounded,
                          size: 12,
                          color: isCash
                              ? AppTheme.warning
                              : AppTheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isCash
                              ? 'Cash: $total'
                              : 'Card Paid',
                          style: TextStyle(
                            color: isCash
                                ? AppTheme.warning
                                : AppTheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.textSecondary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          if (_expanded) ...[
            const Divider(
                color: AppTheme.divider, height: 1),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // Restaurant row
                  _InfoRow(
                    icon: Icons.store_outlined,
                    iconColor: AppTheme.info,
                    label: restaurantName,
                    subtitle: orderType == 'pickup'
                        ? 'Pickup order'
                        : 'Delivery order',
                  ),
                  const SizedBox(height: 10),

                  // Delivery address row
                  if (orderType != 'pickup')
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      iconColor: AppTheme.primary,
                      label: 'Delivery Address',
                      subtitle: deliveryAddress,
                    ),

                  if (orderType == 'pickup')
                    const _InfoRow(
                      icon: Icons.storefront_rounded,
                      iconColor: AppTheme.primary,
                      label: 'Pickup',
                      subtitle:
                          'Customer collects from store',
                    ),

                  const Divider(
                      color: AppTheme.divider, height: 20),

                  // Total
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Order Total',
                          style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13)),
                      Text(
                        total,
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
              Text(subtitle,
                  style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Navigate button ───────────────────────────────────────────────────────────

class _NavigateButton extends StatelessWidget {
  final Map<String, dynamic> order;
  final String status;

  const _NavigateButton(
      {required this.order, required this.status});

  @override
  Widget build(BuildContext context) {
    // Before pickup → navigate to restaurant
    // After pickup → navigate to customer
    final bool toRestaurant = status == 'In Progress';

    double? lat;
    double? lng;
    String label;

    if (toRestaurant) {
      lat = double.tryParse(
          order['restaurantLat']?.toString() ?? '');
      lng = double.tryParse(
          order['restaurantLng']?.toString() ?? '');
      label = 'Navigate to Restaurant';
    } else {
      final addr = order['address'];
      if (addr is Map) {
        lat = double.tryParse(addr['lat']?.toString() ?? '');
        lng = double.tryParse(addr['lng']?.toString() ?? '');
      }
      label = 'Navigate to Customer';
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: (lat != null && lng != null)
            ? () => _navigate(lat!, lng!)
            : null,
        icon: const Icon(Icons.navigation_rounded, size: 18),
        label: Text(label),
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

  Future<void> _navigate(double lat, double lng) async {
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

// ── Dark map style ────────────────────────────────────────────────────────────

const String _darkMapStyle = '''
[{"elementType":"geometry","stylers":[{"color":"#1d2c4d"}]},
{"elementType":"labels.text.fill","stylers":[{"color":"#8ec3b9"}]},
{"elementType":"labels.text.stroke","stylers":[{"color":"#1a3646"}]},
{"featureType":"road","elementType":"geometry","stylers":[{"color":"#304a7d"}]},
{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#255763"}]},
{"featureType":"water","elementType":"geometry","stylers":[{"color":"#0e1626"}]}]
''';