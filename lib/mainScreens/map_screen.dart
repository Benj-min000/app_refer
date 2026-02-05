import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/services/location_service.dart'; // Using your existing service

class MapScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const MapScreen({super.key, this.initialLat, this.initialLng});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  String _currentAddress = "Select location...";
  late LatLng _pickedLocation; // Default
  
  List<dynamic> _suggestions = [];
  final String _googleMapsApiKey = LocationService.googleMapsApiKey;

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
      // Reusing your existing LocationService logic
      final result = await LocationService.getUserLocationAddressFromGoogle(
        location.latitude, 
        location.longitude, 
        "en" // You can pass your dynamic languageCode here
      );
      setState(() {
        _currentAddress = result['fullAddress'] ?? "Unknown Location";
      });
    } catch (e) {
      debugPrint("Error reverse geocoding: $e");
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
    
    // If we have coordinates, start reverse geocoding immediately
    if (widget.initialLat != null && widget.initialLng != null) {
      _reverseGeocode(_pickedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    decoration: const InputDecoration(
                      hintText: 'Search address...',
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
                                ? const Text("Suggested match", style: TextStyle(fontSize: 11, color: Colors.blue))
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
            top: 40,
            left: 20,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95), // Slightly transparent
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  "Go Back",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                  ),
                  child: Text(_currentAddress, 
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  onPressed: () async {
                    // Fetch full data one last time to ensure all fields (postcode, etc) are current
                    final fullData = await LocationService.getUserLocationAddressFromGoogle(
                      _pickedLocation.latitude, 
                      _pickedLocation.longitude, 
                      "en"
                    );
                    
                    if (mounted) Navigator.pop(context, fullData);
                  },
                  child: const Text("Confirm & Continue", 
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}