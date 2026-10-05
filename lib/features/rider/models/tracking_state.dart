import 'delivery_model.dart';
import 'map_models.dart';

class SearchRouteInfo {
  final String address;
  final RiderRoute route;

  const SearchRouteInfo({required this.address, required this.route});

  int get durationMinutes => route.durationMinutes;

  double get distanceKm => route.distanceKm;

  String get etaText {
    final mins = durationMinutes;
    return mins < 1 ? '< 1 min' : '$mins min${mins == 1 ? '' : 's'}';
  }

  String get distanceText => distanceKm >= 1
      ? '${distanceKm.toStringAsFixed(1)} km'
      : '${(distanceKm * 1000).toStringAsFixed(0)} m';
}

enum TrackingPhase {
  idle,
  toPickup,
  pickedUp,
  toDelivery,
  awaitingCustomerConfirmation,
  delivered,
}

extension TrackingPhaseX on TrackingPhase {
  bool get hasActiveOrder =>
      this != TrackingPhase.idle && this != TrackingPhase.delivered;

  bool get isTerminal =>
      this == TrackingPhase.delivered || this == TrackingPhase.idle;

  bool get isAwaitingConfirmation =>
      this == TrackingPhase.awaitingCustomerConfirmation;

  String get nextActionLabel {
    switch (this) {
      case TrackingPhase.toPickup:
        return 'Mark as Picked Up';
      case TrackingPhase.pickedUp:
        return 'Mark as In Transit';
      case TrackingPhase.toDelivery:
        return 'Confirm Delivery';
      default:
        return '';
    }
  }

  String get phaseLabel {
    switch (this) {
      case TrackingPhase.idle:
        return 'No active delivery';
      case TrackingPhase.toPickup:
        return 'En route to pickup';
      case TrackingPhase.pickedUp:
        return 'At pickup — ready to collect';
      case TrackingPhase.toDelivery:
        return 'Out for delivery';
      case TrackingPhase.awaitingCustomerConfirmation:
        return 'Awaiting customer confirmation';
      case TrackingPhase.delivered:
        return 'Delivered';
    }
  }

  String destinationLabel(Delivery? order) {
    switch (this) {
      case TrackingPhase.toPickup:
      case TrackingPhase.pickedUp:
        return order?.pickupStoreName.isNotEmpty == true
            ? order!.pickupStoreName
            : 'Pickup Location';
      case TrackingPhase.toDelivery:
        return 'Delivery Location';
      default:
        return '';
    }
  }
}

const _undef = Object();

class TrackingState {
  final Delivery? activeOrder;
  final TrackingPhase phase;
  final GeoPoint? riderLocation;
  final GeoPoint? pickupGeoPoint;
  final GeoPoint? deliveryGeoPoint;
  final RiderRoute? currentRoute;
  final String? etaText;
  final int? etaSeconds;
  final String? nextStop;
  final bool isDetailsPanelOpen;
  final bool isLocationPermissionGranted;
  final bool isRouteLoading;
  final String? routeError;
  final bool isActionLoading;
  final String? actionError;
  final String? actionSuccess;
  final bool isInitializing;
  final String searchQuery;
  final List<PlacePrediction> searchSuggestions;
  final bool isSearchLoading;
  final bool isSearchExpanded;
  final GeoPoint? searchedGeoPoint;
  final String? searchedAddress;
  final bool isSatelliteMode;
  final SearchRouteInfo? searchRouteInfo;
  final bool isSearchRouteFetching;
  final bool isLocationServiceEnabled;
  final bool isLocationDeniedForever;

  const TrackingState({
    this.activeOrder,
    this.phase = TrackingPhase.idle,
    this.riderLocation,
    this.pickupGeoPoint,
    this.deliveryGeoPoint,
    this.currentRoute,
    this.etaText,
    this.etaSeconds,
    this.nextStop,
    this.isDetailsPanelOpen = false,
    this.isLocationPermissionGranted = false,
    this.isRouteLoading = false,
    this.routeError,
    this.isActionLoading = false,
    this.actionError,
    this.actionSuccess,
    this.isInitializing = true,
    this.searchQuery = '',
    this.searchSuggestions = const [],
    this.isSearchLoading = false,
    this.isSearchExpanded = false,
    this.searchedGeoPoint,
    this.searchedAddress,
    this.isSatelliteMode = false,
    this.searchRouteInfo,
    this.isSearchRouteFetching = false,
    this.isLocationServiceEnabled = true,
    this.isLocationDeniedForever = false,
  });

  TrackingState copyWith({
    Object? activeOrder = _undef,
    TrackingPhase? phase,
    Object? riderLocation = _undef,
    Object? pickupGeoPoint = _undef,
    Object? deliveryGeoPoint = _undef,
    Object? currentRoute = _undef,
    Object? etaText = _undef,
    Object? etaSeconds = _undef,
    Object? nextStop = _undef,
    bool? isDetailsPanelOpen,
    bool? isLocationPermissionGranted,
    bool? isRouteLoading,
    Object? routeError = _undef,
    bool? isActionLoading,
    Object? actionError = _undef,
    Object? actionSuccess = _undef,
    bool? isInitializing,
    String? searchQuery,
    List<PlacePrediction>? searchSuggestions,
    bool? isSearchLoading,
    bool? isSearchExpanded,
    Object? searchedGeoPoint = _undef,
    Object? searchedAddress = _undef,
    bool? isSatelliteMode,
    Object? searchRouteInfo = _undef,
    bool? isSearchRouteFetching,
    bool? isLocationServiceEnabled,
    bool? isLocationDeniedForever,
  }) {
    return TrackingState(
      activeOrder: identical(activeOrder, _undef)
          ? this.activeOrder
          : activeOrder as Delivery?,
      phase: phase ?? this.phase,
      riderLocation: identical(riderLocation, _undef)
          ? this.riderLocation
          : riderLocation as GeoPoint?,
      pickupGeoPoint: identical(pickupGeoPoint, _undef)
          ? this.pickupGeoPoint
          : pickupGeoPoint as GeoPoint?,
      deliveryGeoPoint: identical(deliveryGeoPoint, _undef)
          ? this.deliveryGeoPoint
          : deliveryGeoPoint as GeoPoint?,
      currentRoute: identical(currentRoute, _undef)
          ? this.currentRoute
          : currentRoute as RiderRoute?,
      etaText: identical(etaText, _undef) ? this.etaText : etaText as String?,
      etaSeconds: identical(etaSeconds, _undef)
          ? this.etaSeconds
          : etaSeconds as int?,
      nextStop: identical(nextStop, _undef)
          ? this.nextStop
          : nextStop as String?,
      isDetailsPanelOpen: isDetailsPanelOpen ?? this.isDetailsPanelOpen,
      isLocationPermissionGranted:
          isLocationPermissionGranted ?? this.isLocationPermissionGranted,
      isRouteLoading: isRouteLoading ?? this.isRouteLoading,
      routeError: identical(routeError, _undef)
          ? this.routeError
          : routeError as String?,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      actionError: identical(actionError, _undef)
          ? this.actionError
          : actionError as String?,
      actionSuccess: identical(actionSuccess, _undef)
          ? this.actionSuccess
          : actionSuccess as String?,
      isInitializing: isInitializing ?? this.isInitializing,
      searchQuery: searchQuery ?? this.searchQuery,
      searchSuggestions: searchSuggestions ?? this.searchSuggestions,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      isSearchExpanded: isSearchExpanded ?? this.isSearchExpanded,
      searchedGeoPoint: identical(searchedGeoPoint, _undef)
          ? this.searchedGeoPoint
          : searchedGeoPoint as GeoPoint?,
      searchedAddress: identical(searchedAddress, _undef)
          ? this.searchedAddress
          : searchedAddress as String?,
      isSatelliteMode: isSatelliteMode ?? this.isSatelliteMode,
      searchRouteInfo: identical(searchRouteInfo, _undef)
          ? this.searchRouteInfo
          : searchRouteInfo as SearchRouteInfo?,
      isSearchRouteFetching:
          isSearchRouteFetching ?? this.isSearchRouteFetching,
      isLocationServiceEnabled:
          isLocationServiceEnabled ?? this.isLocationServiceEnabled,
      isLocationDeniedForever:
          isLocationDeniedForever ?? this.isLocationDeniedForever,
    );
  }
}
