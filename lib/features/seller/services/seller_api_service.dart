import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/feedback_models/response_status_model.dart';
import '../../../core/network/network.dart';

class SellerApiService {
  final NetworkService _networkService;

  SellerApiService(this._networkService);

  Future<ResponseStatusModel<JsonMap>> getSpecSchemas({String? categoryId}) {
    return _networkService.request<JsonMap>(
      () => _networkService.get(
        '/product/spec-schemas',
        query: categoryId != null ? {'category': categoryId} : null,
      ),
      parser: (json) => Map<String, dynamic>.from(json['data'] as Map),
    );
  }

  Future<ResponseStatusModel<JsonMap>> createProduct(
    Map<String, dynamic> payload,
  ) {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/product/create-product', data: payload),
      parser: (json) => Map<String, dynamic>.from(json['data'] as Map),
    );
  }

  Future<ResponseStatusModel<JsonMap>> getCategories() {
    return _networkService.request<JsonMap>(
      () => _networkService.get('/product/categories', query: {'tree': true}),
      parser: (json) => Map<String, dynamic>.from(json['data'] as Map),
    );
  }

  Future<ResponseStatusModel<JsonMap>> createCategory(
    Map<String, dynamic> payload,
  ) {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/product/create-category', data: payload),
      parser: (json) => Map<String, dynamic>.from(json['data'] as Map),
    );
  }
}

final sellerApiServiceProvider = Provider<SellerApiService>((ref) {
  return SellerApiService(ref.read(networkServiceProvider));
});
