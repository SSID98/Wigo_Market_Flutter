import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/feedback_models/response_status_model.dart';
import '../../../core/network/network.dart';
import '../models/seller_analytics_model.dart';

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

  Future<ResponseStatusModel<SellerAnalytics>> getAnalytics({
    String period = 'today,weekly,monthly',
  }) {
    return _networkService.request<SellerAnalytics>(
      () => _networkService.get('store/analytics', query: {'period': period}),
      parser: (json) =>
          SellerAnalytics.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Future<ResponseStatusModel<JsonMap>> getMyProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? categoryId,
    String sort = 'newest',
  }) {
    return _networkService.request<JsonMap>(
      () => _networkService.get(
        '/product/get-products',
        query: {
          'mine': true,
          'page': page,
          'limit': limit,
          'includeVariants': true,
          if (search != null && search.isNotEmpty) 'search': search,
          if (status != null && status != 'all') 'status': status,
          if (categoryId != null) 'category': categoryId,
          'sort': sort,
        },
      ),

      parser: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  Future<ResponseStatusModel<JsonMap>> getProductDetail(String id) {
    return _networkService.request<JsonMap>(
      () => _networkService.get('/product/$id'),
      parser: (json) => Map<String, dynamic>.from(json['data'] as Map),
    );
  }

  Future<ResponseStatusModel<JsonMap>> updateProduct(
    String id,
    Map<String, dynamic> payload,
  ) {
    return _networkService.request<JsonMap>(
      () => _networkService.put('/product/$id', data: payload),
      parser: (json) => Map<String, dynamic>.from(json['data'] as Map),
    );
  }

  Future<ResponseStatusModel<JsonMap>> deleteProduct(String id) {
    return _networkService.request<JsonMap>(
      () => _networkService.delete('/product/$id'),
      parser: (json) => Map<String, dynamic>.from(json['data'] as Map),
    );
  }

  Future<ResponseStatusModel<JsonMap>> bulkProductAction({
    required String action,
    required List<String> ids,
  }) {
    return _networkService.request<JsonMap>(
      () => _networkService.post(
        '/product/bulk',
        data: {'action': action, 'ids': ids},
      ),
      parser: (json) => Map<String, dynamic>.from(json['data'] as Map),
    );
  }

  Future<ResponseStatusModel<JsonMap>> getProductReviews(
    String productId, {
    int page = 1,
    int limit = 5,
    String sort = 'recent',
    int? ratingFilter,
  }) {
    return _networkService.request<JsonMap>(
      () => _networkService.get(
        '/product/$productId/reviews',
        query: {
          'page': page,
          'limit': limit,
          'sort': sort,
          if (ratingFilter != null) 'rating': ratingFilter,
        },
      ),
      parser: (json) => Map<String, dynamic>.from(json as Map),
    );
  }
}

final sellerApiServiceProvider = Provider<SellerApiService>((ref) {
  return SellerApiService(ref.read(networkServiceProvider));
});
