import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SmallMapCard extends StatelessWidget {
  final LatLng location;

  const SmallMapCard(
      {super.key, required this.location}); // Example: Cairo, Egypt

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 250, // Adjust map height
        width: double.infinity, // Make it responsive
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FlutterMap(
            options: MapOptions(
              initialCenter: location, // Set initial center
              initialZoom: 14, // Set zoom level
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 40,
                    height: 40,
                    point: location,
                    child: const Icon(Icons.location_pin,
                        color: Colors.red, size: 40),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
