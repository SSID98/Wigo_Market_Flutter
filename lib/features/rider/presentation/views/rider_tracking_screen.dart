import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wigo_flutter/features/rider/presentation/views/delivery_detail_screen.dart';

import '../../../../core/constants/app_colors.dart';
import '../../models/delivery.dart';
import '../../viewmodels/delivery_task_viewmodel.dart';
import '../widgets/delivery_detail_card.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({super.key});

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  bool _isDetailsVisible = false;

  @override
  Widget build(BuildContext context) {
    final deliveryTaskState = ref.watch(deliveryTaskProvider);
    final isWeb = MediaQuery.of(context).size.width > 800;
    final Delivery ongoingDelivery = deliveryTaskState.deliveries.when(
      data:
          (list) => list.firstWhere(
            (d) => d.status == 'On-going',
            orElse: () => list.first,
          ),
      loading: () => throw StateError('deliveries still loading'),
      error: (_, __) => throw StateError('deliveries error'),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          Text(
            "Tracking",
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: isWeb ? 24 : 16,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Track your current delivery, manage route and  Drop Offs",
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w400,
              fontSize: isWeb ? 18 : 12,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(height: 20),
          if (isWeb)
            _buildWebLayout(ongoingDelivery)
          else
            _buildMobileLayout(ongoingDelivery),
        ],
      ),
    );
  }

  Widget _buildWebLayout(Delivery ongoingDelivery) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: LiveTrackingMap(
              onPressed: () {
                setState(() {
                  _isDetailsVisible = true;
                });
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(children: [const FindDestinationCard()]),
          ),
          _isDetailsVisible
              ? DeliveryDetailCard(delivery: ongoingDelivery)
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(Delivery ongoingDelivery) {
    return Column(
      children: [
        const SizedBox(height: 15),
        LiveTrackingMap(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        DeliveryDetailScreen(delivery: ongoingDelivery),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        const FindDestinationCard(),
      ],
    );
  }
}

// --- 1. Find Destination Card Widget (Search Input) ---
class FindDestinationCard extends StatelessWidget {
  const FindDestinationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Choose Destination',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Icon(Icons.search, color: Colors.grey),
        ],
      ),
    );
  }
}

class LiveTrackingMap extends StatefulWidget {
  const LiveTrackingMap({super.key, required this.onPressed});

  final void Function()? onPressed;

  @override
  State<LiveTrackingMap> createState() => _LiveTrackingMapState();
}

class _LiveTrackingMapState extends State<LiveTrackingMap> {
  GoogleMapController? _mapController;

  // Default camera position: Lagos, Nigeria (a common starting point)
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(6.5244, 3.3792),
    zoom: 12,
  );

  // State variables for the user's current location and markers
  LatLng? _currentLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _checkLocationPermissions();
  }

  // 1. Check Permissions and Get Location
  Future<void> _checkLocationPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      print('Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could show a message
        print('Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      print('Location permissions are permanently denied');
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // Permissions granted, now get the position
    _getCurrentLocation();
  }

  // 2. Get the Current Position and Center the Map
  void _getCurrentLocation() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      if (!mounted) return;

      final newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentLocation = newLocation;
        _markers = _buildMarkers(newLocation);
      });

      // Center the map on the new location
      _mapController?.animateCamera(CameraUpdate.newLatLng(newLocation));
    });
  }

  // 3. Build the Markers (Currently only the driver)
  Set<Marker> _buildMarkers(LatLng driverLocation) {
    // You can customize the icon to a car or a custom image later
    return {
      Marker(
        markerId: const MarkerId('driverLocation'),
        position: driverLocation,
        infoWindow: const InfoWindow(title: 'Your Current Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      // Future markers will go here (Pickup and Delivery)
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_currentLocation == null) {
      // Show loading indicator until location is fetched
      return Container(
        color: Colors.grey[200],
        alignment: Alignment.center,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Fetching location and loading map...'),
          ],
        ),
      );
    }

    return Column(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: _currentLocation!, // Use the real initial location
            zoom: 14.0, // Zoomed in a bit more
          ),
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            // Ensure map is centered on current location on load
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(_currentLocation!),
            );
          },
          markers: _markers,
          // Optional: Add a button to recenter the map on the user's location
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(onPressed: widget.onPressed, child: null),
      ],
    );
  }
}
