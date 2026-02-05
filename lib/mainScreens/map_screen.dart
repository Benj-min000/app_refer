import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:user_app/services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:user_app/localization/locale_provider.dart';

import 'package:user_app/extensions/context_translate_ext.dart';
import 'package:user_app/widgets/loading_dialog.dart';

class MapScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final bool isSightSeeing;

  const MapScreen({super.key, this.initialLat, this.initialLng, this.isSightSeeing = false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;

  String _currentAddress = "";

  late LatLng _pickedLocation;
  
  // List of search suggestions
  List<dynamic> _suggestions = [];

  final String _googleMapsApiKey = LocationService.googleMapsApiKey;

  void _refreshCamera() {
    _mapController.animateCamera(
    CameraUpdate.newLatLng(
      LatLng(widget.initialLat ?? 0.0, widget.initialLng ?? 0.0),
    )
    );
  }

  // Logic to fetch suggestions as user types
  void _getSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }
    
    final url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_googleMapsApiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        _suggestions = json.decode(response.body)['predictions'];
      });
    }
  }

  // Logic to handle clicking a suggestion
  void _handleSuggestionClick(String placeId) async {
    final url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_googleMapsApiKey";
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final lat = data['result']['geometry']['location']['lat'];
      final lng = data['result']['geometry']['location']['lng'];
      final newPos = LatLng(lat, lng);

      _mapController.animateCamera(CameraUpdate.newLatLngZoom(newPos, 16));
      setState(() {
        _suggestions = [];
        _pickedLocation = newPos;
        _currentAddress = data['result']['formatted_address'];
      });
    }
  }

  void _reverseGeocode(LatLng location) async {
    try {
      final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
      final languageCode = localeProvider.locale.languageCode;
      
      final result = await LocationService.getUserLocationAddressFromGoogle(
        location.latitude, 
        location.longitude, 
        languageCode,
      );
      setState(() {
        _currentAddress = result['fullAddress'] ?? context.t.unknownLocation;
      });
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(message: context.t.errorReverseGeo(e)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize with passed coordinates if available, otherwise use default
    _pickedLocation = LatLng(
      // Google HQ coords
      widget.initialLat ?? 37.4220, 
      widget.initialLng ?? -122.0841,
    );
    
    // If we have coordinates, reverse geocoding immediately
    if (widget.initialLat != null && widget.initialLng != null) {
      _reverseGeocode(_pickedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents map jumping when keyboard opens
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _pickedLocation, zoom: 15),
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: (position) => _pickedLocation = position.target,
            onCameraIdle: () => _reverseGeocode(_pickedLocation),
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          ),

          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 35),
              child: Icon(Icons.location_on, size: 45, color: Colors.red),
            ),
          ),

          Positioned(
            top: 70,
            left: 15,
            right: 15,
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: context.t.searchAddress,
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15),
                    ),
                    onChanged: (value) => _getSuggestions(value),
                  ),
                ),
                if (_suggestions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(maxHeight: 240),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _suggestions.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1, 
                          indent: 50, // Starts the line after the icon for a cleaner look
                          color: Colors.grey.shade200,
                        ),
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.blueGrey,
                              radius: 16,
                              child: Icon(Icons.location_on, size: 16, color: Colors.white),
                            ),
                            title: Text(
                              _suggestions[index]['description'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            subtitle: index == 0 
                                ? Text(context.t.suggestedMatch, style: TextStyle(fontSize: 11, color: Colors.blue))
                                : null,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            hoverColor: Colors.blue.shade50,
                            onTap: () => _handleSuggestionClick(_suggestions[index]['place_id']),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                  ),
                  child: Text(
                    _currentAddress,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 55,
                      width: 140,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 24,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          foregroundColor: Colors.white, 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                        ),
                        onPressed: () => Navigator.pop(context),
                        label: Text(context.t.goBack, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    
                    if (widget.isSightSeeing == false) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 55, 
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.check, size: 24),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 2,
                            ),
                            onPressed: () async {
                              final fullData = await LocationService.getUserLocationAddressFromGoogle(
                                _pickedLocation.latitude, 
                                _pickedLocation.longitude, 
                                localeProvider.locale.languageCode,
                              );
                              if (mounted) Navigator.pop(context, fullData);
                            },
                            label: Text(context.t.confirmContinue, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ] else 
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 55, 
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.refresh, size: 24),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 2,
                            ),
                            onPressed: () async {
                              _refreshCamera();
                            },
                            label: Text(context.t.refreshLocation, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}