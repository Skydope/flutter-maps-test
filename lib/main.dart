import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bolívar Map',
      theme: ThemeData(useMaterial3: true),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();

  bool devMode = true; // después lo apagamos

  // 📍 Plaza Mitre - Bolívar (aprox, centro urbano real)
  static const LatLng plazaMitre = LatLng(
    -36.23030544196618,
    -61.113839650414725,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: plazaMitre,
          initialZoom: 18, // zoom tipo Google Maps
          maxZoom: 50,
          minZoom: 3,
          onTap: devMode
              ? (tapPosition, latLng) {
                  debugPrint(
                    '📍 TAP -> LAT: ${latLng.latitude}, LNG: ${latLng.longitude}',
                  );
                }
              : null,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.bolivar_map',
          ),
        ],
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 🐞 DEV MODE
          FloatingActionButton.extended(
            heroTag: 'dev',
            backgroundColor: devMode ? Colors.red : Colors.grey,
            icon: const Icon(Icons.bug_report),
            label: Text(devMode ? 'DEV ON' : 'DEV OFF'),
            onPressed: () {
              setState(() {
                devMode = !devMode;
              });
            },
          ),

          const SizedBox(height: 12),

          // 📍 Volver al centro
          FloatingActionButton(
            heroTag: 'center',
            tooltip: 'Ir a Plaza Mitre',
            child: const Icon(Icons.my_location),
            onPressed: () {
              mapController.move(plazaMitre, 16);
            },
          ),
        ],
      ),
    );
  }
}
