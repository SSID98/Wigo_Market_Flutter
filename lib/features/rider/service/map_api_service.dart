import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/feedback_models/response_status_model.dart';
import '../../../core/network/network.dart';
import '../models/map_models.dart';

class MapsApiService {
  final NetworkService _networkService;

  MapsApiService(this._networkService);

  Future<ResponseStatusModel<List<PlacePrediction>>> autocomplete({
    required String input,
    required String sessionToken,
  }) async {
    return _networkService.request<List<PlacePrediction>>(
      () => _networkService.get(
        '/maps/places/autocomplete',
        query: {'input': input, 'sessiontoken': sessionToken},
      ),
      parser: (data) {
        final preds = data['data'] as List<dynamic>? ?? [];
        return preds
            .map(
              (p) =>
                  PlacePrediction.fromJson(Map<String, dynamic>.from(p as Map)),
            )
            .toList();
      },
    );
  }

  Future<ResponseStatusModel<PlaceDetails>> placeDetails({
    required String placeId,
    required String sessionToken,
  }) async {
    return _networkService.request<PlaceDetails>(
      () => _networkService.get(
        '/maps/places/details',
        query: {'placeId': placeId, 'sessiontoken': sessionToken},
      ),
      parser: (data) =>
          PlaceDetails.fromJson(Map<String, dynamic>.from(data['data'] as Map)),
    );
  }

  Future<ResponseStatusModel<PlaceDetails>> geocode(String address) async {
    return _networkService.request<PlaceDetails>(
      () => _networkService.get('/maps/geocode', query: {'address': address}),
      parser: (data) =>
          PlaceDetails.fromJson(Map<String, dynamic>.from(data['data'] as Map)),
    );
  }

  Future<ResponseStatusModel<PlaceDetails>> reverseGeocode({
    required double lat,
    required double lng,
  }) async {
    return _networkService.request<PlaceDetails>(
      () => _networkService.get(
        '/maps/reverse-geocode',
        query: {'lat': lat, 'lng': lng},
      ),
      parser: (data) =>
          PlaceDetails.fromJson(Map<String, dynamic>.from(data['data'] as Map)),
    );
  }

  Future<ResponseStatusModel<DistanceResult>> getDistance({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) async {
    return _networkService.request<DistanceResult>(
      () => _networkService.get(
        '/maps/distance',
        query: {
          'originLat': originLat,
          'originLng': originLng,
          'destLat': destLat,
          'destLng': destLng,
        },
      ),
      parser: (data) => DistanceResult.fromJson(data),
    );
  }
}

final mapsApiServiceProvider = Provider<MapsApiService>((ref) {
  return MapsApiService(ref.read(networkServiceProvider));
});
