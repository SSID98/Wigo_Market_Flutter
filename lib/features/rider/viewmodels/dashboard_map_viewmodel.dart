import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';

import '../models/delivery_model.dart';
import '../models/map_models.dart';
import '../service/rider_api_service.dart';

const _dashUndef = Object();

class DashboardMapState {
  final GeoPoint? riderLocation;
  final Delivery? activeOrder;
  final bool isLoadingOrder;
  final bool isLocationPermissionGranted;
  final RiderRoute? route;
  final bool isInitializing;
  final bool isRouteLoading;
  final bool isLocationServiceEnabled;
  final bool isLocationDeniedForever;

  const DashboardMapState({
    this.riderLocation,
    this.activeOrder,
    this.isLoadingOrder = true,
    this.isLocationPermissionGranted = false,
    this.route,
    this.isRouteLoading = false,
    this.isInitializing = true,
    this.isLocationServiceEnabled = true,
    this.isLocationDeniedForever = false,
  });

  DashboardMapState copyWith({
    Object? riderLocation = _dashUndef,
    Object? activeOrder = _dashUndef,
    bool? isLoadingOrder,
    bool? isLocationPermissionGranted,
    Object? route = _dashUndef,
    bool? isRouteLoading,
    bool? isInitializing,
    bool? isLocationServiceEnabled,
    bool? isLocationDeniedForever,
  }) {
    return DashboardMapState(
      riderLocation: identical(riderLocation, _dashUndef)
          ? this.riderLocation
          : riderLocation as GeoPoint?,
      activeOrder: identical(activeOrder, _dashUndef)
          ? this.activeOrder
          : activeOrder as Delivery?,
      isLoadingOrder: isLoadingOrder ?? this.isLoadingOrder,
      isLocationPermissionGranted:
          isLocationPermissionGranted ?? this.isLocationPermissionGranted,
      isLocationServiceEnabled:
          isLocationServiceEnabled ?? this.isLocationServiceEnabled,
      isLocationDeniedForever:
          isLocationDeniedForever ?? this.isLocationDeniedForever,
      route: identical(route, _dashUndef) ? this.route : route as RiderRoute?,
      isRouteLoading: isRouteLoading ?? this.isRouteLoading,
      isInitializing: isInitializing ?? this.isInitializing,
    );
  }
}

class DashboardMapViewModel extends StateNotifier<DashboardMapState> {
  final RiderApiService _riderApi;
  StreamSubscription<Position>? _positionSub;
  StreamSubscription<ServiceStatus>? _serviceStatusSub;

  DashboardMapViewModel(this._riderApi) : super(const DashboardMapState()) {
    _init();
  }

  Future<void> _init() async {
    await Future.wait([_requestPermission(), _fetchActiveOrder()]);
    state = state.copyWith(isInitializing: false);
    _startGps();
    _listenToServiceStatus();
  }

  Future<void> _requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        state = state.copyWith(
          isLocationServiceEnabled: false,
          isLocationPermissionGranted: false,
        );
      }
      return;
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    if (mounted) {
      state = state.copyWith(
        isLocationServiceEnabled: true,
        isLocationPermissionGranted:
            perm == LocationPermission.always ||
            perm == LocationPermission.whileInUse,
        isLocationDeniedForever: perm == LocationPermission.deniedForever,
      );
    }
  }

  Future<void> recheckLocationPermission() async {
    await _requestPermission();
    if (state.isLocationPermissionGranted &&
        state.isLocationServiceEnabled &&
        _positionSub == null) {
      _startGps();
    }
  }

  void _listenToServiceStatus() {
    try {
      _serviceStatusSub = Geolocator.getServiceStatusStream().listen((status) {
        if (!mounted) return;
        final enabled = status == ServiceStatus.enabled;
        state = state.copyWith(isLocationServiceEnabled: enabled);
        if (enabled &&
            state.isLocationPermissionGranted &&
            _positionSub == null) {
          _startGps();
        }
        if (!enabled) {
          _positionSub?.cancel();
          _positionSub = null;
        }
      });
    } catch (_) {}
  }

  Future<void> _fetchActiveOrder() async {
    try {
      final result = await _riderApi.getActiveOrder();
      if (!mounted) return;

      final order = result.isSuccess ? result.data : null;
      state = state.copyWith(activeOrder: order);

      if (order != null) await _fetchRoute(order);
    } catch (_) {}
  }

  Future<void> _fetchRoute(Delivery order) async {
    final startLat = state.riderLocation?.lat ?? order.pickupGeoPoint?.lat;
    final startLng = state.riderLocation?.lng ?? order.pickupGeoPoint?.lng;
    if (startLat == null || startLng == null) return;

    state = state.copyWith(isRouteLoading: true);
    try {
      final result = await _riderApi.getRoute(
        orderId: order.id,
        startLat: startLat,
        startLng: startLng,
      );
      if (!mounted) return;

      if (result.isSuccess && result.data != null) {
        final data = result.data!['data'] as Map<String, dynamic>? ?? {};
        final route = RiderRoute.fromRouteEndpoint(data);
        state = state.copyWith(isRouteLoading: false, route: route);
      } else {
        state = state.copyWith(isRouteLoading: false);
      }
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(isRouteLoading: false);
    }
  }

  void _startGps() {
    if (!state.isLocationPermissionGranted) return;

    Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
          ),
        )
        .then((pos) {
          if (!mounted) return;
          state = state.copyWith(
            riderLocation: GeoPoint(lat: pos.latitude, lng: pos.longitude),
          );
        })
        .catchError((_) {});

    _positionSub =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            distanceFilter: 30,
          ),
        ).listen((pos) {
          if (!mounted) return;
          state = state.copyWith(
            riderLocation: GeoPoint(lat: pos.latitude, lng: pos.longitude),
          );
        });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _serviceStatusSub?.cancel();
    super.dispose();
  }
}

final dashboardMapProvider =
    StateNotifierProvider.autoDispose<DashboardMapViewModel, DashboardMapState>(
      (ref) => DashboardMapViewModel(ref.read(riderApiServiceProvider)),
    );
