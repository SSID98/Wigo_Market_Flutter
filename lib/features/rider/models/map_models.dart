import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GeoPoint {
  final double lat;
  final double lng;

  const GeoPoint({required this.lat, required this.lng});

  factory GeoPoint.fromJson(Map<String, dynamic> json) => GeoPoint(
    lat: (json['lat'] as num).toDouble(),
    lng: (json['lng'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};

  List<double> get geoJsonCoords => [lng, lat];
}

class PlacePrediction {
  final String placeId;
  final String description;

  const PlacePrediction({required this.placeId, required this.description});

  factory PlacePrediction.fromJson(Map<String, dynamic> json) =>
      PlacePrediction(
        placeId: json['placeId'] as String? ?? '',
        description: json['description'] as String? ?? '',
      );
}

class PlaceDetails {
  final double lat;
  final double lng;
  final String formattedAddress;
  final String? placeId;

  const PlaceDetails({
    required this.lat,
    required this.lng,
    required this.formattedAddress,
    this.placeId,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) => PlaceDetails(
    lat: (json['lat'] as num).toDouble(),
    lng: (json['lng'] as num).toDouble(),
    formattedAddress: json['formattedAddress'] as String? ?? '',
    placeId: json['placeId'] as String?,
  );

  GeoPoint get geoPoint => GeoPoint(lat: lat, lng: lng);
}

class DistanceResult {
  final double distanceKm;
  final int durationMinutes;

  const DistanceResult({
    required this.distanceKm,
    required this.durationMinutes,
  });

  double get estimatedFeeNgn {
    if (distanceKm <= 5) return 1200;
    return 1200 + ((distanceKm - 5).ceil() * 100);
  }

  factory DistanceResult.fromJson(Map<String, dynamic> json) {
    final d = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;
    return DistanceResult(
      distanceKm: (d['distanceKm'] ?? d['distance_km'] ?? 0 as num).toDouble(),
      durationMinutes:
          (d['durationMinutes'] ?? d['duration_minutes'] ?? 0 as num).toInt(),
    );
  }
}

class RiderRoute {
  final String encodedPolyline;
  final List<GeoPoint> decodedPoints;

  final double distanceMeters;

  final int durationSeconds;

  final DateTime? estimatedArrival;

  const RiderRoute({
    required this.encodedPolyline,
    required this.decodedPoints,
    required this.distanceMeters,
    required this.durationSeconds,
    this.estimatedArrival,
  });

  int get durationMinutes => (durationSeconds / 60).ceil();

  double get distanceKm => distanceMeters / 1000;

  factory RiderRoute.fromRouteEndpoint(Map<String, dynamic> data) {
    final route = data['route'] as Map<String, dynamic>? ?? {};
    return RiderRoute._build(
      polyline: route['polyline'] as String? ?? '',
      distanceMeters: (route['distance'] as num? ?? 0).toDouble(),
      durationSeconds: (route['duration'] as num? ?? 0).toInt(),
      estimatedArrivalStr: data['estimatedArrival'] as String?,
    );
  }

  factory RiderRoute.fromUpdateReroute(Map<String, dynamic> route) {
    return RiderRoute._build(
      polyline: route['polyline'] as String? ?? '',
      distanceMeters: (route['distance'] as num? ?? 0).toDouble(),
      durationSeconds: (route['duration'] as num? ?? 0).toInt(),
      estimatedArrivalStr: route['estimatedArrival'] as String?,
    );
  }

  factory RiderRoute.fromMapboxDirections({
    required String polyline,
    required double distanceMeters,
    required int durationSeconds,
  }) {
    return RiderRoute._build(
      polyline: polyline,
      distanceMeters: distanceMeters,
      durationSeconds: durationSeconds,
      estimatedArrivalStr: null,
    );
  }

  factory RiderRoute._build({
    required String polyline,
    required double distanceMeters,
    required int durationSeconds,
    String? estimatedArrivalStr,
  }) {
    final decoded = polyline.isEmpty
        ? <GeoPoint>[]
        : PolylinePoints.decodePolyline(
            polyline,
          ).map((p) => GeoPoint(lat: p.latitude, lng: p.longitude)).toList();
    return RiderRoute(
      encodedPolyline: polyline,
      decodedPoints: decoded,
      distanceMeters: distanceMeters,
      durationSeconds: durationSeconds,
      estimatedArrival: estimatedArrivalStr != null
          ? DateTime.tryParse(estimatedArrivalStr)
          : null,
    );
  }
}

class LocationEta {
  final int seconds;
  final String text;

  const LocationEta({required this.seconds, required this.text});

  factory LocationEta.fromJson(Map<String, dynamic> json) => LocationEta(
    seconds: (json['seconds'] as num? ?? 0).toInt(),
    text: json['text'] as String? ?? '',
  );
}

class LocationUpdateResponse {
  final double latitude;
  final double longitude;
  final String? address;
  final double accuracy;
  final String? status;
  final LocationEta? eta;

  final String? nextStop;

  final bool rerouted;

  final RiderRoute? newRoute;

  const LocationUpdateResponse({
    required this.latitude,
    required this.longitude,
    this.address,
    required this.accuracy,
    this.status,
    this.eta,
    this.nextStop,
    required this.rerouted,
    this.newRoute,
  });

  factory LocationUpdateResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final location = data['location'] as Map<String, dynamic>? ?? {};
    final etaMap = data['eta'] as Map<String, dynamic>?;
    final rerouted = data['rerouted'] as bool? ?? false;
    final routeMap = data['route'] as Map<String, dynamic>?;

    return LocationUpdateResponse(
      latitude: (location['latitude'] as num? ?? 0).toDouble(),
      longitude: (location['longitude'] as num? ?? 0).toDouble(),
      address: location['address'] as String?,
      accuracy: (location['accuracy'] as num? ?? 0).toDouble(),
      status: data['status'] as String?,
      eta: etaMap != null ? LocationEta.fromJson(etaMap) : null,
      nextStop: data['nextStop'] as String?,
      rerouted: rerouted,
      newRoute: (rerouted && routeMap != null)
          ? RiderRoute.fromUpdateReroute(routeMap)
          : null,
    );
  }
}
