import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../shared/widgets/shimmer_widget.dart';
import '../../../models/map_models.dart';
import '../../../viewmodels/dashboard_map_viewmodel.dart';
import '../../../viewmodels/global_navigation_viewmodel.dart';

class DashboardMapWidget extends HookConsumerWidget {
  const DashboardMapWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardMapProvider);
    final isWeb = context.isWeb;
    final mapController = useRef<MapboxMap?>(null);
    final circleMgr = useRef<CircleAnnotationManager?>(null);
    final pickupAnnotation = useRef<CircleAnnotation?>(null);
    final deliveryAnnotation = useRef<CircleAnnotation?>(null);
    final viewportState = useState<ViewportState>(const IdleViewportState());
    final deliveryPolylineMgr = useRef<PolylineAnnotationManager?>(null);

    ref.listen(dashboardMapProvider.select((s) => s.route), (_, route) {
      final mgr = deliveryPolylineMgr.value;
      if (route == null || mgr == null) return;
      Future.microtask(() async {
        try {
          await mgr.deleteAll();
          if (route.decodedPoints.isEmpty) return;
          await mgr.create(
            PolylineAnnotationOptions(
              geometry: LineString(
                coordinates: route.decodedPoints
                    .map((p) => Position(p.lng, p.lat))
                    .toList(),
              ),
              lineColor: AppColors.primaryDarkGreen.toARGB32(),
              lineWidth: 3.0,
              lineJoin: LineJoin.ROUND,
            ),
          );
        } catch (_) {}
      });
    });

    final lifecycleState = useAppLifecycleState();
    useEffect(() {
      if (lifecycleState == AppLifecycleState.resumed) {
        ref.read(dashboardMapProvider.notifier).recheckLocationPermission();
      }
      return null;
    }, [lifecycleState]);

    return Card(
      shadowColor: Colors.white70.withValues(alpha: 0.06),
      color: AppColors.backgroundWhite,
      elevation: 1,
      margin: EdgeInsets.only(top: isWeb ? 18 : 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: isWeb ? 18 : 12,
                bottom: 8,
                left: 2,
              ),
              child: Text(
                'Current Location',
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: AppColors.textBlackGrey,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child:
                    (!state.isLocationPermissionGranted ||
                        !state.isLocationServiceEnabled)
                    ? _buildLocationErrorPlaceholder(state)
                    : Stack(
                        children: [
                          Positioned.fill(
                            child: MapWidget(
                              key: const ValueKey('dashboardMap'),
                              styleUri: MapboxStyles.MAPBOX_STREETS,
                              viewport: viewportState.value,
                              onMapCreated: (MapboxMap ctrl) {
                                mapController.value = ctrl;
                              },
                              onStyleLoadedListener: (_) async {
                                final ctrl = mapController.value;
                                if (ctrl == null) return;

                                pickupAnnotation.value = null;
                                deliveryAnnotation.value = null;

                                circleMgr.value = await ctrl.annotations
                                    .createCircleAnnotationManager();
                                deliveryPolylineMgr.value = await ctrl
                                    .annotations
                                    .createPolylineAnnotationManager();

                                await ctrl.location.updateSettings(
                                  await _locationSettings(),
                                );

                                final s = ref.read(dashboardMapProvider);

                                if (s.activeOrder?.pickupGeoPoint != null) {
                                  await _updateCircle(
                                    circleMgr.value!,
                                    pickupAnnotation,
                                    s.activeOrder!.pickupGeoPoint!,
                                    AppColors.textOrange.toARGB32(),
                                    radius: 10,
                                  );
                                }
                                if (s.activeOrder?.dropoffGeoPoint != null) {
                                  await _updateCircle(
                                    circleMgr.value!,
                                    deliveryAnnotation,
                                    s.activeOrder!.dropoffGeoPoint!,
                                    AppColors.textRed.toARGB32(),
                                    radius: 10,
                                  );
                                }
                                if (s.route != null) {
                                  try {
                                    await deliveryPolylineMgr.value!
                                        .deleteAll();
                                    if (s.route!.decodedPoints.isNotEmpty) {
                                      await deliveryPolylineMgr.value!.create(
                                        PolylineAnnotationOptions(
                                          geometry: LineString(
                                            coordinates: s.route!.decodedPoints
                                                .map(
                                                  (p) => Position(p.lng, p.lat),
                                                )
                                                .toList(),
                                          ),
                                          lineColor: AppColors.primaryDarkGreen
                                              .toARGB32(),
                                          lineWidth: 3.0,
                                          lineJoin: LineJoin.ROUND,
                                        ),
                                      );
                                    }
                                  } catch (_) {}
                                }
                                viewportState.value = FollowPuckViewportState(
                                  zoom: 15.0,
                                  pitch: 0.0,
                                  bearing:
                                      FollowPuckViewportStateBearingHeading(),
                                );
                              },
                            ),
                          ),

                          if (!state.isLoadingOrder &&
                              state.activeOrder != null)
                            Positioned(
                              top: 12,
                              left: 12,
                              child: _buildEtaChip(state),
                            ),

                          if (state.riderLocation != null)
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.08,
                                      ),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryDarkGreen,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Your location',
                                      style: GoogleFonts.hind(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textBlackGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          if (state.isInitializing)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: const AppShimmer(
                                  child: Block(height: 200, radius: 10),
                                ),
                              ),
                            ),

                          if (!state.isLoadingOrder &&
                              state.activeOrder != null &&
                              state.isRouteLoading)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: const AppShimmer(
                                  child: Block(height: 200, radius: 10),
                                ),
                              ),
                            ),

                          if (!state.isLoadingOrder &&
                              state.activeOrder != null)
                            Positioned.fill(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () => ref
                                    .read(
                                      globalNavigationViewModelProvider
                                          .notifier,
                                    )
                                    .setIndex(2),
                              ),
                            ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationErrorPlaceholder(DashboardMapState state) {
    final serviceOff = !state.isLocationServiceEnabled;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            serviceOff ? Icons.location_off : Icons.location_disabled,
            size: 32,
            color: AppColors.textBodyText,
          ),
          const SizedBox(height: 8),
          Text(
            serviceOff
                ? 'Location services are off'
                : 'Location access required',
            style: GoogleFonts.hind(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textBodyText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () async {
              serviceOff
                  ? await Geolocator.openLocationSettings()
                  : await Geolocator.openAppSettings();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryDarkGreen,
            ),
            child: Text(
              serviceOff ? 'Enable Location' : 'Open Settings',
              style: GoogleFonts.hind(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEtaChip(DashboardMapState state) {
    String etaStr = '';

    if (state.route != null) {
      final mins = state.route!.durationMinutes;
      etaStr = 'Arrival in $mins min${mins == 1 ? '' : 's'}';
    } else if (state.activeOrder?.estimatedDeliveryTime != null) {
      final diff = state.activeOrder!.estimatedDeliveryTime!.difference(
        DateTime.now(),
      );
      if (!diff.isNegative) {
        final mins = diff.inMinutes.clamp(0, 9999);
        etaStr = 'Arrival in $mins min${mins == 1 ? '' : 's'}';
      } else {
        etaStr = 'Arriving soon';
      }
    }

    if (etaStr.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            etaStr,
            style: GoogleFonts.hind(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlackGrey,
            ),
          ),
          if (state.activeOrder?.pickupStoreName.isNotEmpty == true)
            Text(
              state.activeOrder!.pickupStoreName,
              style: GoogleFonts.hind(
                fontSize: 11,
                color: AppColors.textOrange,
              ),
            ),
        ],
      ),
    );
  }

  static Future<Uint8List> _greenPuckBytes() async {
    const int size = 44;
    const double half = size / 2.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawCircle(
      const Offset(half, half),
      half,
      Paint()..color = AppColors.primaryDarkGreen.withValues(alpha: .4),
    );
    canvas.drawCircle(
      const Offset(half, half),
      half - 4,
      Paint()..color = AppColors.primaryDarkGreen,
    );
    canvas.drawCircle(
      const Offset(half, half),
      6,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
        ..style = PaintingStyle.fill,
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List();
  }

  static Future<LocationComponentSettings> _locationSettings() async {
    final puck = await _greenPuckBytes();
    return LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
      pulsingColor: AppColors.primaryDarkGreen.toARGB32(),
      pulsingMaxRadius: 50.0,
      showAccuracyRing: true,
      accuracyRingColor: AppColors.primaryDarkGreen
          .withValues(alpha: 0.15)
          .toARGB32(),
      locationPuck: LocationPuck(
        locationPuck2D: LocationPuck2D(topImage: puck),
      ),
    );
  }

  Future<void> _updateCircle(
    CircleAnnotationManager mgr,
    ObjectRef<CircleAnnotation?> ref,
    GeoPoint point,
    int color, {
    double radius = 10,
  }) async {
    try {
      if (ref.value != null) await mgr.delete(ref.value!);
      ref.value = await mgr.create(
        CircleAnnotationOptions(
          geometry: Point(coordinates: Position(point.lng, point.lat)),
          circleRadius: radius,
          circleColor: color,
          circleStrokeColor: Colors.white.toARGB32(),
          circleStrokeWidth: 2.0,
        ),
      );
    } catch (_) {}
  }
}
