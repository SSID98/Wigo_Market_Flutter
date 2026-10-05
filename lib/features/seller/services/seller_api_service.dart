import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/feedback_models/response_status_model.dart';
import '../../../core/network/network.dart';
import '../models/order_details_model.dart';
import '../models/order_enums.dart';
import '../models/seller_analytics_model.dart';

class SellerApiService {
  final NetworkService _networkService;

  SellerApiService(this._networkService);

  ///Product Management
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

  ///Order Management
  Future<ResponseStatusModel<OrdersPage>> getOrders({
    String category = 'all',
    String? status,
    String? orderType,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? search,
    String sortBy = 'date',
    String sortOrder = 'desc',
    int page = 1,
    int limit = 10,
  }) {
    return _networkService.request<OrdersPage>(
      () => _networkService.get(
        '/store/orders',
        query: {
          'category': category,
          if (status != null && status.isNotEmpty) 'status': status,
          if (orderType != null && orderType.isNotEmpty) 'orderType': orderType,
          if (dateFrom != null) 'dateFrom': dateFrom.toIso8601String(),
          if (dateTo != null) 'dateTo': dateTo.toIso8601String(),
          if (search != null && search.isNotEmpty) 'search': search,
          'sortBy': sortBy,
          'sortOrder': sortOrder,
          'page': page,
          'limit': limit,
        },
      ),
      parser: (json) =>
          OrdersPage.fromJson(Map<String, dynamic>.from(json['data'] as Map)),
    );
  }

  Future<ResponseStatusModel<OrderDetail>> getOrderDetail(String id) {
    return _networkService.request<OrderDetail>(
      () => _networkService.get('/store/orders/$id'),
      parser: (json) =>
          OrderDetail.fromJson(Map<String, dynamic>.from(json['data'] as Map)),
    );
  }

  Future<ResponseStatusModel<JsonMap>> updateOrderStatus(
    String id,
    OrderFilter status, {
    String? reason,
  }) {
    return _networkService.request<JsonMap>(
      () => _networkService.put(
        '/store/orders/$id/status',
        data: {
          'status': status.toJsonString,
          if (reason != null && reason.isNotEmpty) 'reason': reason,
        },
      ),
      parser: (json) => Map<String, dynamic>.from(json['data'] as Map),
    );
  }

  Future<ResponseStatusModel<ContactCustomerResult>> contactCustomer(
    String orderId,
    String message,
  ) {
    return _networkService.request<ContactCustomerResult>(
      () => _networkService.post(
        '/store/orders/$orderId/contact',
        data: {'message': message},
      ),
      parser: (json) => ContactCustomerResult.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      ),
    );
  }
}

final sellerApiServiceProvider = Provider<SellerApiService>((ref) {
  return SellerApiService(ref.read(networkServiceProvider));
});
