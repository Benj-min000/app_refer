import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // 1. Controller for Google Maps
  late GoogleMapController mapController;

  // 2. Define the initial position (Warsaw)
  final LatLng _initialCenter = const LatLng(52.2297, 21.0122);

  // 3. Define your Markers
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('warsaw_marker'),
      position: LatLng(52.2297, 21.0122),
      infoWindow: InfoWindow(title: 'Warsaw', snippet: 'Capital of Poland'),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MegaApp Google Map"),
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        // Connect the controller
        onMapCreated: _onMapCreated,
        
        // Use the API Key from your Manifest automatically
        initialCameraPosition: CameraPosition(
          target: _initialCenter,
          zoom: 13.0,
        ),
        
        // Add your markers here
        markers: _markers,
        
        // Enabling these requires location permissions in AndroidManifest
        myLocationEnabled: true, 
        myLocationButtonEnabled: true,
        
        // Optional: Map styling
        mapType: MapType.normal,
      ),
    );
  }
}