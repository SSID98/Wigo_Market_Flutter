import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';
import 'package:wigo_flutter/shared/widgets/custom_banner.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/shimmer_widget.dart';
import '../../models/map_models.dart';
import '../../models/tracking_state.dart';
import '../../viewmodels/tracking_viewmodel.dart';
import 'delivery_detail_panel.dart';

class TrackingScreen extends HookConsumerWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trackingProvider);
    final notifier = ref.read(trackingProvider.notifier);
    final isWeb = context.isWeb;
    final mapController = useRef<MapboxMap?>(null);
    final circleMgr = useRef<CircleAnnotationManager?>(null);
    final deliveryPolylineMgr = useRef<PolylineAnnotationManager?>(null);
    final searchPolylineMgr = useRef<PolylineAnnotationManager?>(null);
    final pickupAnnotation = useRef<CircleAnnotation?>(null);
    final deliveryAnnotation = useRef<CircleAnnotation?>(null);
    final searchAnnotation = useRef<CircleAnnotation?>(null);
    final hasCalledOnMapReady = useRef<bool>(false);
    final viewportState = useState<ViewportState>(const IdleViewportState());

    useEffect(() {
      Future.microtask(() => notifier.initialize());
      return null;
    }, const []);

    final lifecycleState = useAppLifecycleState();
    useEffect(() {
      if (lifecycleState == AppLifecycleState.resumed &&
          (!state.isLocationPermissionGranted ||
              !state.isLocationServiceEnabled)) {
        notifier.recheckLocationPermission();
      }
      return null;
    }, [lifecycleState]);

    Future<void> handleSatelliteToggle() async {
      final ctrl = mapController.value;
      if (ctrl == null) return;
      final willBeSatellite = !state.isSatelliteMode;
      notifier.toggleSatellite();
      final newStyle = willBeSatellite
          ? MapboxStyles.SATELLITE_STREETS
          : MapboxStyles.MAPBOX_STREETS;
      try {
        await ctrl.loadStyleURI(newStyle);
      } catch (_) {}
    }

    Future<void> handleReturnToLocation() async {
      _activateFollowPuck(viewportState);
    }

    ref.listen(trackingProvider.select((s) => s.pickupGeoPoint), (_, pt) {
      final mgr = circleMgr.value;
      if (pt == null || mgr == null) return;
      Future.microtask(
        () => _updateCircle(
          mgr,
          pickupAnnotation,
          pt,
          AppColors.textBlue.toARGB32(),
          radius: 12,
        ),
      );
    });

    ref.listen(trackingProvider.select((s) => s.deliveryGeoPoint), (_, pt) {
      final mgr = circleMgr.value;
      if (pt == null || mgr == null) return;
      Future.microtask(
        () => _updateCircle(
          mgr,
          deliveryAnnotation,
          pt,
          AppColors.textRed.toARGB32(),
          radius: 12,
        ),
      );
    });

    ref.listen(trackingProvider.select((s) => s.currentRoute), (_, route) {
      final mgr = deliveryPolylineMgr.value;
      if (route == null || mgr == null) return;
      Future.microtask(
        () => _drawPolylineOnManager(
          mgr,
          route,
          AppColors.primaryDarkGreen.toARGB32(),
        ),
      );
    });

    ref.listen(trackingProvider.select((s) => s.searchedGeoPoint), (_, pt) {
      final mgr = circleMgr.value;
      if (mgr == null) return;
      Future.microtask(
        () => pt == null
            ? _clearAnnotation(mgr, searchAnnotation)
            : _updateCircle(
                mgr,
                searchAnnotation,
                pt,
                Colors.purple.toARGB32(),
                radius: 10,
              ),
      );
    });

    ref.listen(trackingProvider.select((s) => s.searchRouteInfo), (_, info) {
      Future.microtask(() async {
        if (info == null) {
          await _clearPolylineManager(searchPolylineMgr.value);
          _activateFollowPuck(viewportState);
          return;
        }
        _exitFollowPuck(viewportState);
        await _drawPolylineOnManager(
          searchPolylineMgr.value!,
          info.route,
          AppColors.textBlack.toARGB32(),
        );

        final s = ref.read(trackingProvider);
        final loc = s.riderLocation;
        final dest = s.searchedGeoPoint;
        final ctrl = mapController.value;
        if (loc != null && dest != null && ctrl != null) {
          final midLat = (loc.lat + dest.lat) / 2;
          final midLng = (loc.lng + dest.lng) / 2;
          final maxDiff = max(
            (loc.lat - dest.lat).abs(),
            (loc.lng - dest.lng).abs(),
          );
          final zoom = maxDiff < 0.005
              ? 15.0
              : maxDiff < 0.02
              ? 13.0
              : maxDiff < 0.1
              ? 11.0
              : 9.0;
          await ctrl.easeTo(
            CameraOptions(
              center: Point(coordinates: Position(midLng, midLat)),
              zoom: zoom,
            ),
            MapAnimationOptions(duration: 400),
          );
        }
      });
    });

    ref.listen(trackingProvider.select((s) => s.actionError), (_, err) {
      if (err == null || !context.mounted) return;
      showErrorBanner(err, context);
      notifier.clearActionFeedback();
    });

    ref.listen(trackingProvider.select((s) => s.actionSuccess), (_, msg) {
      if (msg == null || !context.mounted) return;
      showSuccessBanner(msg, context);
      notifier.clearActionFeedback();
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isWeb),
          Expanded(
            child: state.isInitializing
                ? (isWeb ? _buildWebShimmer() : _buildMobileShimmer())
                : (!state.isLocationPermissionGranted ||
                      !state.isLocationServiceEnabled)
                ? _buildLocationError(context, state, notifier, isWeb)
                : isWeb
                ? _buildWebLayout(
                    context,
                    ref,
                    state,
                    notifier,
                    mapController,
                    circleMgr,
                    pickupAnnotation,
                    deliveryAnnotation,
                    searchAnnotation,
                    handleSatelliteToggle,
                    handleReturnToLocation,
                    hasCalledOnMapReady,
                    viewportState,
                    deliveryPolylineMgr,
                    searchPolylineMgr,
                  )
                : _buildMobileLayout(
                    context,
                    ref,
                    state,
                    notifier,
                    mapController,
                    circleMgr,
                    pickupAnnotation,
                    deliveryAnnotation,
                    searchAnnotation,
                    handleSatelliteToggle,
                    handleReturnToLocation,
                    hasCalledOnMapReady,
                    viewportState,
                    deliveryPolylineMgr,
                    searchPolylineMgr,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isWeb) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isWeb ? 40 : 12, 20, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tracking',
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: isWeb ? 24 : 18,
              color: AppColors.textBlackGrey,
            ),
          ),
          Text(
            'Track your current delivery, manage route and Drop Offs',
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w400,
              fontSize: isWeb ? 14 : 12,
              color: AppColors.textBlackGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebLayout(
    BuildContext context,
    WidgetRef ref,
    TrackingState state,
    TrackingViewModel notifier,
    ObjectRef<MapboxMap?> mapController,
    ObjectRef<CircleAnnotationManager?> circleMgr,
    ObjectRef<CircleAnnotation?> pickupAnnotation,
    ObjectRef<CircleAnnotation?> deliveryAnnotation,
    ObjectRef<CircleAnnotation?> searchAnnotation,
    Future<void> Function() onSatelliteToggle,
    Future<void> Function() onReturnToLocation,
    ObjectRef<bool> hasCalledOnMapReady,
    ValueNotifier<ViewportState> viewportState,
    ObjectRef<PolylineAnnotationManager?> deliveryPolylineMgr,
    ObjectRef<PolylineAnnotationManager?> searchPolylineMgr,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  _buildMap(
                    context,
                    ref,
                    state,
                    notifier,
                    mapController,
                    circleMgr,
                    pickupAnnotation,
                    deliveryAnnotation,
                    searchAnnotation,
                    onSatelliteToggle,
                    onReturnToLocation,
                    hasCalledOnMapReady,
                    viewportState,
                    deliveryPolylineMgr,
                    searchPolylineMgr,
                  ),

                  Positioned(top: 16, right: 16, child: _buildLegend()),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 320,
            child: Column(
              children: [
                if (state.searchRouteInfo != null) ...[
                  _buildSearchRouteInfo(state, notifier),
                  const SizedBox(height: 12),
                ] else ...[
                  _buildSearchCard(context, state, notifier),
                  if (state.isSearchRouteFetching)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(
                        color: AppColors.primaryDarkGreen,
                      ),
                    ),
                  const SizedBox(height: 12),
                ],
                if (state.phase.isAwaitingConfirmation)
                  _buildAwaitingCard()
                else if (state.isDetailsPanelOpen && state.activeOrder != null)
                  Expanded(
                    child: DeliveryDetailPanel(
                      delivery: state.activeOrder!,
                      phase: state.phase,
                      etaText: _etaDisplay(state),
                      isActionLoading: state.isActionLoading,
                      onMarkPickedUp: () => notifier.markPickedUp(),
                      onMarkInTransit: () => notifier.markInTransit(),
                      onConfirmDelivery: () => notifier.confirmDelivery(),
                      onClose: () => notifier.setDetailsPanel(false),
                    ),
                  )
                else if (state.activeOrder != null && !state.phase.isTerminal)
                  _buildViewDetailsButton(context, state, notifier),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    TrackingState state,
    TrackingViewModel notifier,
    ObjectRef<MapboxMap?> mapController,
    ObjectRef<CircleAnnotationManager?> circleMgr,
    ObjectRef<CircleAnnotation?> pickupAnnotation,
    ObjectRef<CircleAnnotation?> deliveryAnnotation,
    ObjectRef<CircleAnnotation?> searchAnnotation,
    Future<void> Function() onSatelliteToggle,
    Future<void> Function() onReturnToLocation,
    ObjectRef<bool> hasCalledOnMapReady,
    ValueNotifier<ViewportState> viewportState,
    ObjectRef<PolylineAnnotationManager?> deliveryPolylineMgr,
    ObjectRef<PolylineAnnotationManager?> searchPolylineMgr,
  ) {
    return Stack(
      children: [
        Positioned.fill(
          child: _buildMap(
            context,
            ref,
            state,
            notifier,
            mapController,
            circleMgr,
            pickupAnnotation,
            deliveryAnnotation,
            searchAnnotation,
            onSatelliteToggle,
            onReturnToLocation,
            hasCalledOnMapReady,
            viewportState,
            deliveryPolylineMgr,
            searchPolylineMgr,
          ),
        ),
        Positioned(top: 16, right: 22, child: _buildLegend()),
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 0,
          right: 0,
          child: state.isInitializing
              ? _buildMobileBottomCardShimmer()
              : _buildMobileBottomCard(context, state, notifier),
        ),
      ],
    );
  }

  static void _activateFollowPuck(ValueNotifier<ViewportState> viewportState) {
    viewportState.value = FollowPuckViewportState(
      zoom: 15.0,
      pitch: 0.0,
      bearing: FollowPuckViewportStateBearingHeading(),
    );
  }

  static void _exitFollowPuck(ValueNotifier<ViewportState> viewportState) {
    viewportState.value = const IdleViewportState();
  }

  Widget _buildMap(
    BuildContext context,
    WidgetRef ref,
    TrackingState state,
    TrackingViewModel notifier,
    ObjectRef<MapboxMap?> mapController,
    ObjectRef<CircleAnnotationManager?> circleMgr,
    ObjectRef<CircleAnnotation?> pickupAnnotation,
    ObjectRef<CircleAnnotation?> deliveryAnnotation,
    ObjectRef<CircleAnnotation?> searchAnnotation,
    Future<void> Function() onSatelliteToggle,
    Future<void> Function() onReturnToLocation,
    ObjectRef<bool> hasCalledOnMapReady,
    ValueNotifier<ViewportState> viewportState,
    ObjectRef<PolylineAnnotationManager?> deliveryPolylineMgr,
    ObjectRef<PolylineAnnotationManager?> searchPolylineMgr,
  ) {
    return Card(
      shadowColor: Colors.white70.withValues(alpha: 0.06),
      color: AppColors.backgroundWhite,
      elevation: 1,
      margin: EdgeInsets.fromLTRB(12, 0, 12, 150),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              MapWidget(
                key: const ValueKey('trackingMap'),
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
                  searchAnnotation.value = null;

                  circleMgr.value = await ctrl.annotations
                      .createCircleAnnotationManager();
                  deliveryPolylineMgr.value = await ctrl.annotations
                      .createPolylineAnnotationManager();
                  searchPolylineMgr.value = await ctrl.annotations
                      .createPolylineAnnotationManager();
                  await ctrl.location.updateSettings(
                    await _locationSettingsAsync(),
                  );

                  final s = ref.read(trackingProvider);

                  if (s.pickupGeoPoint != null) {
                    await _updateCircle(
                      circleMgr.value!,
                      pickupAnnotation,
                      s.pickupGeoPoint!,
                      AppColors.textBlue.toARGB32(),
                      radius: 12,
                    );
                  }
                  if (s.deliveryGeoPoint != null) {
                    await _updateCircle(
                      circleMgr.value!,
                      deliveryAnnotation,
                      s.deliveryGeoPoint!,
                      AppColors.textRed.toARGB32(),
                      radius: 12,
                    );
                  }
                  if (s.searchedGeoPoint != null) {
                    await _updateCircle(
                      circleMgr.value!,
                      searchAnnotation,
                      s.searchedGeoPoint!,
                      Colors.purple.toARGB32(),
                      radius: 10,
                    );
                  }
                  if (s.currentRoute != null) {
                    await _drawPolylineOnManager(
                      deliveryPolylineMgr.value!,
                      s.currentRoute!,
                      AppColors.primaryDarkGreen.toARGB32(),
                    );
                  }
                  if (s.searchRouteInfo != null) {
                    await _drawPolylineOnManager(
                      searchPolylineMgr.value!,
                      s.searchRouteInfo!.route,
                      Colors.blue.shade700.toARGB32(),
                    );
                  }

                  if (s.searchRouteInfo == null) {
                    _activateFollowPuck(viewportState);
                  }

                  if (!hasCalledOnMapReady.value) {
                    hasCalledOnMapReady.value = true;
                    await notifier.onMapReady();
                  }
                },
              ),
              if (state.currentRoute != null ||
                  state.etaText != null ||
                  state.searchRouteInfo != null)
                Positioned(top: 16, left: 16, child: _buildEtaChip(state)),

              Positioned(
                bottom: 80,
                right: 16,
                child: _buildMapControls(
                  state,
                  onSatelliteToggle,
                  onReturnToLocation,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _legendItem(AppColors.primaryDarkGreen, 'Current Location'),
          const SizedBox(height: 4),
          _legendItem(Colors.purple, 'Searched Location'),
          const SizedBox(height: 4),
          _legendItem(AppColors.textBlue, 'Pickup Location'),
          const SizedBox(height: 4),
          _legendItem(AppColors.textRed, 'Delivery Location'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.hind(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlackGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildMapControls(
    TrackingState state,
    Future<void> Function() onSatelliteToggle,
    Future<void> Function() onReturnToLocation,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Satellite toggle
        _mapFab(
          icon: state.isSatelliteMode
              ? Icons.map_outlined
              : Icons.satellite_alt,
          tooltip: state.isSatelliteMode ? 'Street view' : 'Satellite view',
          onTap: onSatelliteToggle,
        ),
        const SizedBox(height: 8),

        _mapFab(
          icon: Icons.my_location,
          tooltip: 'My location',
          onTap: onReturnToLocation,
        ),
      ],
    );
  }

  Widget _mapFab({
    required IconData icon,
    required String tooltip,
    required Future<void> Function() onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 20, color: AppColors.textBlackGrey),
        ),
      ),
    );
  }

  String _etaDisplay(TrackingState state) {
    if (state.etaText != null && state.etaText!.isNotEmpty) {
      return state.etaText!;
    }
    if (state.searchRouteInfo != null) return state.searchRouteInfo!.etaText;
    final secs = state.currentRoute?.durationSeconds;
    if (secs == null) return '';
    if (secs < 60) return '< 1 min';
    final mins = (secs / 60).ceil();
    return '$mins min${mins == 1 ? '' : 's'}';
  }

  Widget _buildEtaChip(TrackingState state) {
    final etaStr = _etaDisplay(state);
    if (etaStr.isEmpty) return const SizedBox.shrink();

    final destLabel = state.nextStop == 'pickup'
        ? (state.activeOrder?.pickupStoreName.isNotEmpty == true
              ? state.activeOrder!.pickupStoreName
              : 'Pickup')
        : state.nextStop == 'dropoff'
        ? 'Delivery'
        : state.searchRouteInfo != null
        ? state.searchRouteInfo!.address
        : state.phase.destinationLabel(state.activeOrder);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Arrival in $etaStr',
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppColors.textBlackGrey,
            ),
          ),
          if (destLabel.isNotEmpty)
            Text(
              destLabel,
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: AppColors.textOrange,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchRouteInfo(
    TrackingState state,
    TrackingViewModel notifier,
  ) {
    final info = state.searchRouteInfo!;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.directions_car,
            size: 20,
            color: AppColors.primaryDarkGreen,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                info.etaText,
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.textBlackGrey,
                ),
              ),
              Text(
                info.distanceText,
                style: GoogleFonts.hind(
                  fontSize: 12,
                  color: AppColors.textBodyText,
                ),
              ),
            ],
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: notifier.clearSearchRoute,
            icon: const Icon(Icons.close, size: 14),
            label: Text('Clear', style: GoogleFonts.hind(fontSize: 13)),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textBodyText,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard(
    BuildContext context,
    TrackingState state,
    TrackingViewModel notifier,
  ) {
    return Card(
      color: AppColors.backgroundWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.radio_button_unchecked,
                  size: 20,
                  color: AppColors.textBodyText,
                ),
                const SizedBox(width: 8),
                Text(
                  'Find the next Destination',
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                const SizedBox(width: 4),
                AppAssets.icons.noDeliveryTask.svg(height: 30),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              onTap: () => notifier.setSearchExpanded(true),
              onChanged: notifier.onSearchQueryChanged,
              controller: TextEditingController(text: state.searchQuery)
                ..selection = TextSelection.collapsed(
                  offset: state.searchQuery.length,
                ),
              style: GoogleFonts.hind(
                fontSize: 14,
                color: AppColors.textBlackGrey,
              ),
              decoration: InputDecoration(
                hintText: 'Choose Destination...',
                hintStyle: GoogleFonts.hind(
                  fontSize: 14,
                  color: AppColors.textBodyText,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: AppAssets.icons.search.svg(),
                ),
                suffixIcon: state.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: notifier.clearSearch,
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                filled: true,
                fillColor: AppColors.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (state.isSearchLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            else if (state.searchSuggestions.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.searchSuggestions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final pred = state.searchSuggestions[i];
                  return InkWell(
                    onTap: () => notifier.onPlaceSelected(pred, context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: AppColors.textBodyText,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              pred.description,
                              style: GoogleFonts.hind(
                                fontSize: 13,
                                color: AppColors.textBlackGrey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryDarkGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Your location',
                  style: GoogleFonts.hind(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textBlackGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileBottomCard(
    BuildContext context,
    TrackingState state,
    TrackingViewModel notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            if (state.phase.isAwaitingConfirmation)
              _buildAwaitingCard()
            else if (state.searchRouteInfo != null) ...[
              _buildSearchRouteInfo(state, notifier),
              if (state.activeOrder != null && !state.phase.isTerminal) ...[
                const SizedBox(height: 12),
                _buildViewDetailsButton(context, state, notifier),
              ],
            ] else ...[
              _buildSearchCard(context, state, notifier),
              if (state.isSearchRouteFetching)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: LinearProgressIndicator(
                    color: AppColors.primaryDarkGreen,
                  ),
                ),
              if (state.activeOrder != null && !state.phase.isTerminal) ...[
                const SizedBox(height: 12),
                _buildViewDetailsButton(context, state, notifier),
              ],
            ],
          ],
        ),
      ),
    );
  }

  void _openMobileDetailSheet(
    BuildContext context,
    TrackingState state,
    TrackingViewModel notifier,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: DeliveryDetailPanel(
                      delivery: state.activeOrder!,
                      phase: state.phase,
                      etaText: _etaDisplay(state),
                      isActionLoading: state.isActionLoading,
                      onMarkPickedUp: () async {
                        final ok = await notifier.markPickedUp();
                        if (ok && context.mounted) Navigator.pop(context);
                      },
                      onMarkInTransit: () async {
                        final ok = await notifier.markInTransit();
                        if (ok && context.mounted) Navigator.pop(context);
                      },
                      onConfirmDelivery: () async {
                        await notifier.confirmDelivery();
                        if (context.mounted) Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAwaitingCard() {
    return Card(
      color: AppColors.backgroundWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.clampBgColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.primaryDarkGreen,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Delivery Handed Off!',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Waiting for the customer to confirm receipt. '
              'You will be credited as soon as they confirm.',
              textAlign: TextAlign.center,
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.textBodyText,
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primaryDarkGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewDetailsButton(
    BuildContext context,
    TrackingState state,
    TrackingViewModel notifier,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _openMobileDetailSheet(context, state, notifier),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.clampBgColor,
          foregroundColor: AppColors.textDarkDarkerGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 0,
        ),
        child: Text(
          'View Details',
          style: GoogleFonts.hind(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildWebShimmer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: AppShimmer(
              child: Block(height: double.infinity, radius: 12),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppShimmer(
              child: Column(
                children: const [
                  Block(height: 160, radius: 10),
                  SizedBox(height: 12),
                  Block(height: 280, radius: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileShimmer() {
    return const AppShimmer(child: Block(height: double.infinity, radius: 0));
  }

  static Future<Uint8List> _greenPuckBytes() async {
    const int size = 44;
    const double half = size / 2.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // White border ring
    canvas.drawCircle(
      const Offset(half, half),
      half,
      Paint()..color = AppColors.primaryDarkGreen.withValues(alpha: 0.4),
    );
    // Green fill
    canvas.drawCircle(
      const Offset(half, half),
      half - 4,
      Paint()..color = AppColors.primaryDarkGreen,
    );
    // Subtle inner highlight for depth
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

  static Future<LocationComponentSettings> _locationSettingsAsync() async {
    final puck = await _greenPuckBytes();
    return LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
      pulsingColor: AppColors.primaryDarkGreen.toARGB32(),
      pulsingMaxRadius: 70.0,
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

  Future<void> _clearAnnotation(
    CircleAnnotationManager mgr,
    ObjectRef<CircleAnnotation?> ref,
  ) async {
    try {
      if (ref.value != null) {
        await mgr.delete(ref.value!);
        ref.value = null;
      }
    } catch (_) {}
  }

  static Future<void> _drawPolylineOnManager(
    PolylineAnnotationManager mgr,
    RiderRoute route,
    int color,
  ) async {
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
          lineColor: color,
          lineWidth: 4.5,
          lineJoin: LineJoin.ROUND,
        ),
      );
    } catch (_) {}
  }

  static Future<void> _clearPolylineManager(
    PolylineAnnotationManager? mgr,
  ) async {
    if (mgr == null) return;
    try {
      await mgr.deleteAll();
    } catch (_) {}
  }

  Widget _buildLocationError(
    BuildContext context,
    TrackingState state,
    TrackingViewModel notifier,
    bool isWeb,
  ) {
    final serviceOff = !state.isLocationServiceEnabled;
    final deniedForever = state.isLocationDeniedForever;

    final icon = serviceOff ? Icons.location_off : Icons.location_disabled;
    final title = serviceOff
        ? 'Location Services Off'
        : deniedForever
        ? 'Location Access Denied'
        : 'Location Permission Required';
    final message = serviceOff
        ? 'Turn on your device location to show your position and delivery routes.'
        : deniedForever
        ? 'Location access was permanently denied. Enable it in your app settings to continue.'
        : 'This app needs your location to show your position and plot delivery routes.';
    final buttonLabel = serviceOff
        ? 'Open Location Settings'
        : 'Open App Settings';

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isWeb ? 120 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.clampBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.primaryDarkGreen),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: GoogleFonts.hind(
                fontSize: isWeb ? 22 : 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: GoogleFonts.hind(
                fontSize: isWeb ? 15 : 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textBodyText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  serviceOff
                      ? await Geolocator.openLocationSettings()
                      : await Geolocator.openAppSettings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDarkGreen,
                  foregroundColor: AppColors.backgroundWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: Text(
                  buttonLabel,
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: notifier.recheckLocationPermission,
              child: Text(
                'Try Again',
                style: GoogleFonts.hind(
                  fontSize: 14,
                  color: AppColors.primaryDarkGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileBottomCardShimmer() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: AppShimmer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Block(width: 40, height: 4, radius: 2),
            const SizedBox(height: 12),
            const Block(height: 130, radius: 10),
            const SizedBox(height: 12),
            const Block(height: 48, radius: 8),
          ],
        ),
      ),
    );
  }
}
