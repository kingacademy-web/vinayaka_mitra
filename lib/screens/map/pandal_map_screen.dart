import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/pandal.dart';
import '../../services/firebase_service.dart';

class PandalMapScreen extends StatefulWidget {
  const PandalMapScreen({super.key});

  @override
  State<PandalMapScreen> createState() => _PandalMapScreenState();
}

class _PandalMapScreenState extends State<PandalMapScreen> {
  final FirebaseService _service = FirebaseService();
  GoogleMapController? _mapController;
  LatLng _center = const LatLng(17.4116, 78.4619); // Hyderabad Central
  Set<Marker> _markers = {};
  List<Pandal> _pandals = [];
  bool _isListView = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _locateUser();
  }

  Future<void> _locateUser() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      ).timeout(const Duration(seconds: 4));
      _center = LatLng(pos.latitude, pos.longitude);
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_center, 13));
      if (mounted) setState(() {});
    } catch (_) {}
  }

  Future<void> _loadData() async {
    final list = await _service.getPandals();
    final markers = list.map((p) {
      final isImmersion = p.type == 'immersion';
      return Marker(
        markerId: MarkerId(p.id),
        position: LatLng(p.lat, p.lng),
        infoWindow: InfoWindow(
          title: p.name,
          snippet: '${p.idolHeight} • ${p.specialAttraction}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isImmersion ? BitmapDescriptor.hueAzure : BitmapDescriptor.hueOrange,
        ),
      );
    }).toSet();

    setState(() {
      _pandals = list;
      _markers = markers;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('పందల్ & నిమజ్జన ఘాట్‌లు'),
        actions: [
          IconButton(
            tooltip: _isListView ? 'మ్యాప్ వ్యూ' : 'లిస్ట్ వ్యూ',
            icon: Icon(_isListView ? Icons.map : Icons.list),
            onPressed: () => setState(() => _isListView = !_isListView),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.saffron))
          : _isListView
              ? _buildListView(isDark)
              : _buildMapView(isDark),
    );
  }

  Widget _buildMapView(bool isDark) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: _center, zoom: 12),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (c) => _mapController = c,
        ),
        // Legend Overlay
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.darkSurface : Colors.white).withOpacity(0.92),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text('పందల్', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text('నిమజ్జనం', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView(bool isDark) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _pandals.length,
      itemBuilder: (context, index) {
        final p = _pandals[index];
        final isImmersion = p.type == 'immersion';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isImmersion
                            ? Colors.blue.withOpacity(0.15)
                            : AppColors.saffron.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isImmersion ? '🌊 నిమజ్జన ఘాట్' : '🪔 పందల్',
                        style: TextStyle(
                          color: isImmersion ? Colors.blue.shade800 : AppColors.deepGold,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      p.idolHeight,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  p.name,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  p.address,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: AppColors.saffron),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        p.specialAttraction,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                if (p.contact != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 14, color: AppColors.greenAuspicious),
                      const SizedBox(width: 6),
                      Text(
                        p.contact!,
                        style: const TextStyle(fontSize: 12, color: AppColors.greenAuspicious),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
