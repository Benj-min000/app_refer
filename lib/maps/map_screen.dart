import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MegaApp Map")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(52.2297, 21.0122), // Warsaw
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

            // ID from Gradle KTS
            userAgentPackageName: 'com.megaapp.user_app',
          ),
          const MarkerLayer(
            markers: [
              Marker(
                point: LatLng(52.2297, 21.0122),
                width: 80,
                height: 80,
                child: Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}