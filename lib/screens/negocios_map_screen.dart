import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class NegociosMapScreen extends StatefulWidget {
  const NegociosMapScreen({super.key});

  @override
  State<NegociosMapScreen> createState() => _NegociosMapScreenState();
}

class _NegociosMapScreenState extends State<NegociosMapScreen> {
  final MapController mapController = MapController();
  static const LatLng bolivarCenter = LatLng(-36.2303, -61.1138);

  List<Marker> _markers = [];
  bool _isLoading = false;
  String _selectedCategory = 'Comercios';

  final Map<String, String> _categories = {
    'Comercios': 'node["shop"](around:2000,-36.2303,-61.1138);',
    'Salud':
        'node["amenity"="pharmacy"](around:2000,-36.2303,-61.1138);node["amenity"="hospital"](around:2000,-36.2303,-61.1138);',
    'Gastronomía':
        'node["amenity"="restaurant"](around:2000,-36.2303,-61.1138);node["amenity"="cafe"](around:2000,-36.2303,-61.1138);',
    'Educación': 'node["amenity"="school"](around:2000,-36.2303,-61.1138);',
    'Bancos': 'node["amenity"="bank"](around:2000,-36.2303,-61.1138);',
  };

  @override
  void initState() {
    super.initState();
    _fetchOverpassData(_categories['Comercios']!);
  }

  Future<void> _fetchOverpassData(String queryBody) async {
    setState(() {
      _isLoading = true;
      _markers = [];
    });

    try {
      final url = Uri.parse('https://overpass-api.de/api/interpreter');
      final query = '[out:json];($queryBody);out center;';

      final response = await http.post(url, body: {'data': query});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final elements = data['elements'] as List;

        final newMarkers = elements.map((el) {
          final double lat = el['lat'] ?? el['center']['lat'];
          final double lon = el['lon'] ?? el['center']['lon'];
          final String name = el['tags']?['name'] ?? 'Sin nombre';
          final String type =
              el['tags']?['shop'] ?? el['tags']?['amenity'] ?? 'Lugar';

          return Marker(
            point: LatLng(lat, lon),
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () => _showPlaceInfo(name, type),
              child: _getMarkerIcon(_selectedCategory),
            ),
          );
        }).toList();

        if (mounted) {
          setState(() {
            _markers = newMarkers;
          });
        }
      } else {
        debugPrint('Error fetching Overpass data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error cargando mapa: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _getMarkerIcon(String category) {
    IconData iconData;
    Color color;

    switch (category) {
      case 'Salud':
        iconData = Icons.local_hospital;
        color = Colors.red;
        break;
      case 'Gastronomía':
        iconData = Icons.restaurant;
        color = Colors.orange;
        break;
      case 'Educación':
        iconData = Icons.school;
        color = Colors.blue;
        break;
      case 'Bancos':
        iconData = Icons.account_balance;
        color = Colors.green;
        break;
      default:
        iconData = Icons.store;
        color = Colors.purple;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
        ],
      ),
      child: Icon(iconData, color: color, size: 24),
    );
  }

  void _showPlaceInfo(String name, String type) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Chip(label: Text(type.toUpperCase())),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 8),
                Text('Ubicación real (OpenStreetMap)'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa en Vivo'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _categories.keys.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = cat);
                        _fetchOverpassData(_categories[cat]!);
                      }
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: bolivarCenter,
              initialZoom: 15,
              minZoom: 12,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'ar.gob.bolivar.digital.app', // Unique User Agent to avoid blocking
                // Adding additional headers can also help if strictly enforced
                additionalOptions: const {
                  'User-Agent':
                      'BolivarDigitalDemo/1.0 (ar.gob.bolivar.digital.app)',
                },
              ),
              MarkerLayer(markers: _markers),
            ],
          ),
          if (_isLoading)
            Positioned(
              top: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text('Cargando ${_selectedCategory.toLowerCase()}...'),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                mapController.move(bolivarCenter, 15);
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
