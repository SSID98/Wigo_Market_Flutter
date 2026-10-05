import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/local/session_manager.dart';
import '../models/map_models.dart';
import '../models/tracking_state.dart';
import '../service/map_api_service.dart';
import '../service/rider_api_service.dart';

const _broadcastInterval = Duration(seconds: 10);
const _minBroadcastInterval = Duration(seconds: 5);
const _heartbeatInterval = Duration(seconds: 25);
const _maxReconnectDelay = Duration(seconds: 30);
const _uuid = Uuid();
DateTime? _lastSearchRouteRefresh;

class TrackingViewModel extends StateNotifier<TrackingState> {
  final RiderApiService _riderApi;
  final MapsApiService _mapsApi;
  final SessionManager _session;

  StreamSubscription<Position>? _positionSub;
  Timer? _broadcastTimer;
  DateTime? _lastBroadcast;

  WebSocketChannel? _wsChannel;
  StreamSubscription? _wsSub;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;

  Timer? _searchDebounce;
  String _searchSessionToken = _uuid.v4();
  StreamSubscription<ServiceStatus>? _serviceStatusSub;

  TrackingViewModel(this._riderApi, this._mapsApi, this._session)
    : super(const TrackingState());

  Future<void> initialize() async {
    await Future.wait([_requestPermission(), _fetchActiveOrder()]);
    state = state.copyWith(isInitializing: false);
    _startGps();
    _listenToServiceStatus();
  }

  Future<void> onMapReady() async {
    if (state.activeOrder == null) return;
    await _fetchRoute();
    _connectWebSocket();
  }

  Future<void> _requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = state.copyWith(
        isLocationServiceEnabled: false,
        isLocationPermissionGranted: false,
      );
      return;
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    state = state.copyWith(
      isLocationServiceEnabled: true,
      isLocationPermissionGranted:
          perm == LocationPermission.always ||
          perm == LocationPermission.whileInUse,
      isLocationDeniedForever: perm == LocationPermission.deniedForever,
    );
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
    } catch (_) {
      // getServiceStatusStream not supported on all platforms — safe to ignore.
    }
  }

  Future<void> _fetchActiveOrder() async {
    try {
      final result = await _riderApi.getActiveOrder();
      if (!mounted || !result.isSuccess) return;

      final order = result.data;
      if (order == null) return;

      state = state.copyWith(
        activeOrder: order,
        phase: _phaseFrom(order.deliveryStatus),
        pickupGeoPoint: order.pickupGeoPoint,
        deliveryGeoPoint: order.dropoffGeoPoint,
      );
    } catch (_) {
      // Silent — rider simply has no active order.
    }
  }

  TrackingPhase _phaseFrom(String deliveryStatus) {
    switch (deliveryStatus) {
      case 'assigned':
        return TrackingPhase.toPickup;
      case 'picked_up':
        return TrackingPhase.pickedUp;
      case 'in_transit':
        return TrackingPhase.toDelivery;
      case 'delivered':
        return TrackingPhase.delivered;
      default:
        return TrackingPhase.idle;
    }
  }

  Future<void> _fetchRoute() async {
    final origin = state.riderLocation;
    final order = state.activeOrder;
    if (origin == null || order == null) return;

    state = state.copyWith(isRouteLoading: true, routeError: null);
    try {
      final result = await _riderApi.getRoute(
        orderId: order.id,
        startLat: origin.lat,
        startLng: origin.lng,
      );
      if (!mounted) return;

      if (result.isSuccess && result.data != null) {
        final data = result.data!['data'] as Map<String, dynamic>? ?? {};
        final route = RiderRoute.fromRouteEndpoint(data);
        state = state.copyWith(isRouteLoading: false, currentRoute: route);
      } else {
        state = state.copyWith(
          isRouteLoading: false,
          routeError: 'Could not load route. Check your connection.',
        );
      }
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(
        isRouteLoading: false,
        routeError: 'Could not load route.',
      );
    }
  }

  Future<RiderRoute?> _getDirectRoute(GeoPoint origin, GeoPoint dest) async {
    final token = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
    if (token.isEmpty) return null;

    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.mapbox.com/directions/v5/mapbox/driving/'
        '${origin.lng},${origin.lat};${dest.lng},${dest.lat}',
        queryParameters: {
          'geometries': 'polyline',
          'steps': false,
          'overview': 'full',
          'access_token': token,
        },
      );
      if (response.statusCode != 200) return null;

      final data = response.data as Map<String, dynamic>;
      final routes = data['routes'] as List?;
      if (routes == null || routes.isEmpty) return null;

      final r = routes.first as Map<String, dynamic>;
      return RiderRoute.fromMapboxDirections(
        polyline: r['geometry'] as String? ?? '',
        distanceMeters: (r['distance'] as num? ?? 0).toDouble(),
        durationSeconds: (r['duration'] as num? ?? 0).toInt(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _fetchSearchRoute(GeoPoint dest, String address) async {
    final origin = state.riderLocation;
    if (origin == null) {
      state = state.copyWith(isSearchRouteFetching: false);
      return;
    }
    try {
      final route = await _getDirectRoute(origin, dest);
      if (!mounted) return;
      state = state.copyWith(
        isSearchRouteFetching: false,
        searchRouteInfo: route != null
            ? SearchRouteInfo(address: address, route: route)
            : null,
      );
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(isSearchRouteFetching: false);
    }
  }

  void clearSearchRoute() {
    state = state.copyWith(
      searchRouteInfo: null,
      searchedGeoPoint: null,
      searchedAddress: null,
      searchQuery: '',
    );
  }

  void _startGps() {
    if (!state.isLocationPermissionGranted) return;

    Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        )
        .then((pos) {
          if (mounted) _onPosition(pos);
        })
        .catchError((_) {
          // Silent — stream will pick it up when the device moves.
        });

    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(_onPosition);
  }

  void _onPosition(Position pos) {
    final point = GeoPoint(lat: pos.latitude, lng: pos.longitude);
    state = state.copyWith(riderLocation: point);
    _scheduleBroadcast(pos);
    _maybeRefreshSearchRoute();
  }

  void _maybeRefreshSearchRoute() {
    if (state.activeOrder != null) return;
    final dest = state.searchedGeoPoint;
    final info = state.searchRouteInfo;
    if (dest == null || info == null) return;

    final now = DateTime.now();
    if (_lastSearchRouteRefresh != null &&
        now.difference(_lastSearchRouteRefresh!) <
            const Duration(seconds: 60)) {
      return;
    }
    _lastSearchRouteRefresh = now;
    _fetchSearchRoute(dest, state.searchedAddress ?? info.address);
  }

  void _scheduleBroadcast(Position pos) {
    final now = DateTime.now();
    if (_lastBroadcast != null &&
        now.difference(_lastBroadcast!) < _minBroadcastInterval) {
      return;
    }

    _broadcastTimer?.cancel();
    _broadcastTimer = Timer(_broadcastInterval, () => _broadcast(pos));
  }

  Future<void> _broadcast(Position pos) async {
    final orderId = state.activeOrder?.id;
    if (orderId == null) return;

    _lastBroadcast = DateTime.now();
    try {
      final result = await _riderApi.updateLocation(
        orderId: orderId,
        latitude: pos.latitude,
        longitude: pos.longitude,
        accuracy: pos.accuracy,
        speed: pos.speed < 0 ? 0 : pos.speed,
        heading: pos.heading < 0 ? 0 : pos.heading,
      );
      if (!mounted || !result.isSuccess || result.data == null) return;

      final update = result.data!;

      if (update.eta != null) {
        state = state.copyWith(
          etaText: update.eta!.text,
          etaSeconds: update.eta!.seconds,
          nextStop: update.nextStop,
        );
      } else if (update.nextStop != null) {
        state = state.copyWith(nextStop: update.nextStop);
      }

      if (update.rerouted && update.newRoute != null) {
        state = state.copyWith(currentRoute: update.newRoute);
      }
    } catch (_) {
      // Best-effort; silent failure.
    }
  }

  void toggleSatellite() =>
      state = state.copyWith(isSatelliteMode: !state.isSatelliteMode);

  Future<void> _connectWebSocket() async {
    final token = _session.accessToken;
    if (token == null) return;

    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    if (baseUrl.isEmpty) return;

    final httpUri = Uri.tryParse(baseUrl);
    if (httpUri == null) return;

    final wsScheme = httpUri.scheme == 'https' ? 'wss' : 'ws';

    final wsUri = Uri(
      scheme: wsScheme,
      host: httpUri.host,
      port: (httpUri.port == 80 || httpUri.port == 443 || httpUri.port == 0)
          ? null
          : httpUri.port,
      path: '/ws/location',
      queryParameters: {'token': token},
    );

    try {
      _wsChannel = WebSocketChannel.connect(wsUri);
      _wsSub = _wsChannel!.stream.listen(
        _onWsMessage,
        onDone: _scheduleWsReconnect,
        onError: (_) => _scheduleWsReconnect(),
        cancelOnError: false,
      );
      _startHeartbeat();
    } catch (_) {
      _scheduleWsReconnect();
    }
  }

  void _onWsMessage(dynamic raw) {
    _reconnectAttempts = 0;
    try {
      final msg = jsonDecode(raw as String) as Map<String, dynamic>;
      final type = msg['type'] as String? ?? '';
      final data = msg['data'] as Map<String, dynamic>? ?? {};

      switch (type) {
        case 'order_assigned':
          _fetchActiveOrder();
          break;

        case 'order_status_update':
          final status = data['status'] as String?;
          if (status == 'delivered' &&
              state.phase == TrackingPhase.awaitingCustomerConfirmation) {
            if (!mounted) return;
            state = state.copyWith(
              phase: TrackingPhase.delivered,
              currentRoute: null,
              actionSuccess: 'Payment confirmed and credited to your wallet!',
            );
            _cleanupAfterDelivery();
          }
          break;

        case 'location_ack':
          break;

        case 'error':
          final code = data['code'] as String?;
          if (code == 'AUTH_INVALID' || code == 'AUTH_REQUIRED') {
            _wsChannel?.sink.close();
          }
          break;

        case 'system_message':
          break;
      }
    } catch (_) {}
  }

  void _wsSend(Map<String, dynamic> data) {
    try {
      _wsChannel?.sink.add(jsonEncode(data));
    } catch (_) {}
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      _wsSend({
        'type': 'heartbeat',
        'data': {'timestamp': DateTime.now().toIso8601String()},
      });
    });
  }

  void _scheduleWsReconnect() {
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    final delay = Duration(
      seconds: min(
        _maxReconnectDelay.inSeconds,
        pow(2, _reconnectAttempts).toInt(),
      ),
    );
    _reconnectAttempts++;
    _reconnectTimer = Timer(delay, _connectWebSocket);
  }

  void toggleDetailsPanel() =>
      state = state.copyWith(isDetailsPanelOpen: !state.isDetailsPanelOpen);

  void setDetailsPanel(bool open) =>
      state = state.copyWith(isDetailsPanelOpen: open);

  Future<bool> markPickedUp() async {
    final success = await _advanceStatus('picked_up', TrackingPhase.pickedUp);
    if (success) {
      await _fetchRoute();
    }
    return success;
  }

  Future<bool> markInTransit() =>
      _advanceStatus('in_transit', TrackingPhase.toDelivery);

  Future<bool> _advanceStatus(String apiStatus, TrackingPhase nextPhase) async {
    final orderId = state.activeOrder?.id;
    if (orderId == null) return false;

    state = state.copyWith(isActionLoading: true, actionError: null);
    try {
      final result = await _riderApi.updateOrderStatus(
        orderId: orderId,
        status: apiStatus,
      );
      if (!mounted) return false;

      if (result.isSuccess) {
        state = state.copyWith(isActionLoading: false, phase: nextPhase);
        return true;
      } else {
        state = state.copyWith(
          isActionLoading: false,
          actionError: result.errorDescription ?? 'Failed to update status.',
        );
        return false;
      }
    } catch (_) {
      if (!mounted) return false;
      state = state.copyWith(
        isActionLoading: false,
        actionError: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  Future<bool> confirmDelivery() async {
    final orderId = state.activeOrder?.id;
    if (orderId == null) return false;

    state = state.copyWith(isActionLoading: true, actionError: null);
    try {
      final result = await _riderApi.confirmDelivery(orderId);
      if (!mounted) return false;

      if (result.isSuccess && result.data != null) {
        final d = result.data!;

        if (d.isAwaitingCustomer) {
          state = state.copyWith(
            isActionLoading: false,
            phase: TrackingPhase.awaitingCustomerConfirmation,
            isDetailsPanelOpen: false,
          );
          return true;
        }

        if (d.credited) {
          final amount = d.amount.toStringAsFixed(2);
          state = state.copyWith(
            isActionLoading: false,
            phase: TrackingPhase.delivered,
            currentRoute: null,
            isDetailsPanelOpen: false,
            actionSuccess:
                'Delivery complete! ₦$amount credited to your wallet.',
          );
          _cleanupAfterDelivery();
          return true;
        }

        state = state.copyWith(
          isActionLoading: false,
          actionError: result.errorDescription ?? 'Confirmation failed.',
        );
        return false;
      } else {
        state = state.copyWith(
          isActionLoading: false,
          actionError: result.errorDescription ?? 'Failed to confirm delivery.',
        );
        return false;
      }
    } catch (_) {
      if (!mounted) return false;
      state = state.copyWith(
        isActionLoading: false,
        actionError: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  void _cleanupAfterDelivery() {
    _broadcastTimer?.cancel();
    _heartbeatTimer?.cancel();
    _wsChannel?.sink.close();
  }

  void setSearchExpanded(bool expanded) {
    if (expanded) _searchSessionToken = _uuid.v4();
    state = state.copyWith(
      isSearchExpanded: expanded,
      searchSuggestions: expanded ? state.searchSuggestions : [],
      searchQuery: expanded ? state.searchQuery : '',
    );
  }

  void onSearchQueryChanged(String query) {
    state = state.copyWith(searchQuery: query);
    _searchDebounce?.cancel();
    if (query.trim().length < 3) {
      state = state.copyWith(searchSuggestions: []);
      return;
    }
    _searchDebounce = Timer(
      const Duration(milliseconds: 300),
      () => _suggest(query),
    );
  }

  Future<void> _suggest(String query) async {
    state = state.copyWith(isSearchLoading: true);
    try {
      final result = await _mapsApi.autocomplete(
        input: query,
        sessionToken: _searchSessionToken,
      );
      if (!mounted) return;
      state = state.copyWith(
        isSearchLoading: false,
        searchSuggestions: result.isSuccess ? (result.data ?? []) : [],
      );
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(isSearchLoading: false, searchSuggestions: []);
    }
  }

  Future<void> onPlaceSelected(
    PlacePrediction prediction,
    BuildContext context,
  ) async {
    FocusScope.of(context).unfocus();

    try {
      final result = await _mapsApi.placeDetails(
        placeId: prediction.placeId,
        sessionToken: _searchSessionToken,
      );
      _searchSessionToken = _uuid.v4();
      if (!mounted || !result.isSuccess || result.data == null) return;

      final dest = result.data!.geoPoint;
      final address = result.data!.formattedAddress;

      state = state.copyWith(
        isSearchExpanded: false,
        searchQuery: address,
        searchSuggestions: [],
        searchedGeoPoint: dest,
        searchedAddress: address,
        isSearchRouteFetching: true,
        searchRouteInfo: null,
      );

      await _fetchSearchRoute(dest, address);
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(isSearchRouteFetching: false);
    }
  }

  void clearSearch() {
    state = state.copyWith(
      isSearchExpanded: false,
      searchQuery: '',
      searchSuggestions: [],
      searchedGeoPoint: null,
      searchedAddress: null,
    );
    _searchSessionToken = _uuid.v4();
  }

  void clearActionFeedback() =>
      state = state.copyWith(actionError: null, actionSuccess: null);

  @override
  void dispose() {
    _positionSub?.cancel();
    _broadcastTimer?.cancel();
    _wsSub?.cancel();
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _searchDebounce?.cancel();
    _serviceStatusSub?.cancel();
    _wsChannel?.sink.close();
    super.dispose();
  }
}

final trackingProvider =
    StateNotifierProvider.autoDispose<TrackingViewModel, TrackingState>(
      (ref) => TrackingViewModel(
        ref.read(riderApiServiceProvider),
        ref.read(mapsApiServiceProvider),
        ref.read(sessionManagerProvider),
      ),
    );
