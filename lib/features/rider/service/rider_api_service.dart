import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/feedback_models/response_status_model.dart';
import '../../../core/network/network.dart';
import '../../../shared/models/bank_model.dart';
import '../models/delivery_model.dart';
import '../models/earning_history_model.dart';
import '../models/earning_overview_model.dart';
import '../models/map_models.dart';

class RiderApiService {
  final NetworkService _networkService;

  RiderApiService(this._networkService);

  ///All Orders/Delivery Endpoints
  Future<ResponseStatusModel<OrdersResponse>> getOrders({
    int page = 1,
    int limit = 10,
    String tab = 'all',
  }) async {
    return _networkService.request<OrdersResponse>(
      () => _networkService.get(
        '/delivery-agent/orders',
        query: {'page': page, 'limit': limit, 'tab': tab},
      ),
      parser: (json) => OrdersResponse.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      ),
    );
  }

  Future<ResponseStatusModel<OrdersResponse>> getAvailableOrders({
    int page = 1,
    int limit = 10,
  }) async {
    return _networkService.request<OrdersResponse>(
      () => _networkService.get(
        '/delivery-agent/orders/available',
        query: {'page': page, 'limit': limit},
      ),
      parser: (json) => OrdersResponse.fromJson(json["data"]),
    );
  }

  Future<ResponseStatusModel<OrdersResponse>> getMyDeliveries({
    int page = 1,
    int limit = 10,
    String? tab,
    String? status,
  }) async {
    return _networkService.request<OrdersResponse>(
      () => _networkService.get(
        '/delivery-agent/orders/my-deliveries',
        query: {
          'page': page,
          'limit': limit,
          if (tab != null) 'tab': tab,
          if (status != null && tab == null) 'status': status,
        },
      ),
      parser: (json) => OrdersResponse.fromJson(json["data"]),
    );
  }

  Future<ResponseStatusModel<Delivery?>> getActiveOrder() async {
    return _networkService.request<Delivery?>(
      () => _networkService.get('/delivery-agent/orders/active'),
      parser: (data) {
        final orderMap = (data['data'] as Map<String, dynamic>)['order'];
        if (orderMap == null) return null;
        return Delivery.fromJson(Map<String, dynamic>.from(orderMap as Map));
      },
    );
  }

  Future<ResponseStatusModel<Delivery>> getOrderById(String orderId) async {
    return _networkService.request<Delivery>(
      () => _networkService.get('/delivery-agent/orders/$orderId'),
      parser: (data) {
        final orderMap = (data['data'] as Map<String, dynamic>)['order'] as Map;
        return Delivery.fromJson(Map<String, dynamic>.from(orderMap));
      },
    );
  }

  Future<ResponseStatusModel<OrderCounts>> getOrderCounts() async {
    return _networkService.request<OrderCounts>(
      () => _networkService.get('/delivery-agent/orders/counts'),
      parser: (data) =>
          OrderCounts.fromJson(Map<String, dynamic>.from(data['data'] as Map)),
    );
  }

  Future<ResponseStatusModel<JsonMap>> selectOrder(String orderId) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post(
        '/delivery-agent/orders/select',
        data: {'orderId': orderId},
      ),
    );
  }

  Future<ResponseStatusModel<JsonMap>> updateOrderStatus({
    required String orderId,
    required String status,
    String? notes,
  }) async {
    return _networkService.request<JsonMap>(
      () => _networkService.put(
        '/delivery-agent/orders/status',
        data: {
          'orderId': orderId,
          'status': status,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      ),
    );
  }

  Future<ResponseStatusModel<ConfirmDeliveryResult>> confirmDelivery(
    String orderId,
  ) async {
    return _networkService.request<ConfirmDeliveryResult>(
      () => _networkService.post(
        '/delivery-agent/orders/confirm-delivery',
        data: {'orderId': orderId},
      ),
      parser: (data) => ConfirmDeliveryResult.fromJson(
        Map<String, dynamic>.from(data['data'] as Map),
      ),
    );
  }

  Future<ResponseStatusModel<EarningsHistoryResponse>> getEarningsHistory({
    int page = 1,
    int limit = 10,
    String status = 'delivered',
    String? search,
    int? month,
    int? year,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return _networkService.request<EarningsHistoryResponse>(
      () => _networkService.get(
        '/delivery-agent/earnings-history',
        query: {
          'page': page,
          'limit': limit,
          'status': status,
          if (search != null && search.trim().isNotEmpty)
            'search': search.trim(),
          if (month != null) 'month': month,
          if (year != null) 'year': year,
          if (startDate != null) 'startDate': _formatDate(startDate),
          if (endDate != null) 'endDate': _formatDate(endDate),
        },
      ),
      parser: (json) => EarningsHistoryResponse.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      ),
    );
  }

  Future<ResponseStatusModel<List<Delivery>>> getRecentOrders({
    int limit = 5,
  }) async {
    return _networkService.request<List<Delivery>>(
      () => _networkService.get(
        '/delivery-agent/orders/recent',
        query: {'limit': limit},
      ),
      parser: (data) {
        final payload = data['data'] as Map<String, dynamic>;
        return (payload['orders'] as List<dynamic>? ?? [])
            .map((o) => Delivery.fromJson(Map<String, dynamic>.from(o as Map)))
            .toList();
      },
    );
  }

  static String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  ///All profile endpoints
  Future<ResponseStatusModel<JsonMap>> createRiderProfile(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/delivery-agent/profile', data: payload),
    );
  }

  Future<ResponseStatusModel<JsonMap>> getRiderProfile() async {
    return _networkService.request<JsonMap>(
      () => _networkService.get('/delivery-agent/profile'),
    );
  }

  Future<ResponseStatusModel<JsonMap>> updateRiderProfile(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.put('/delivery-agent/profile', data: payload),
    );
  }

  Future<ResponseStatusModel<JsonMap>> updateRiderPersonalProfile(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.put('/delivery-agent/account', data: payload),
    );
  }

  ///All wallet/pin creation endpoints
  Future<ResponseStatusModel<JsonMap>> createWalletPin(String pin) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/wallet/pin', data: {"pin": pin}),
    );
  }

  Future<ResponseStatusModel<JsonMap>> forgotPin() async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/wallet/pin/forgot'),
    );
  }

  Future<ResponseStatusModel<JsonMap>> verifyOtp(String code) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post(
        '/wallet/pin/verify-reset',
        data: {"code": code},
      ),
    );
  }

  Future<ResponseStatusModel<JsonMap>> resetPin({
    required String newPin,
    required String resetSession,
  }) async {
    return _networkService.request<JsonMap>(
      () => _networkService.put(
        '/wallet/pin/reset',
        data: {"newPin": newPin, "resetSession": resetSession},
      ),
    );
  }

  Future<ResponseStatusModel<JsonMap>> createWallet(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/wallet/create', data: payload),
    );
  }

  Future<ResponseStatusModel<JsonMap>> getWallet() async {
    return _networkService.request<JsonMap>(
      () => _networkService.get('/wallet'),
      parser: (json) => Map<String, dynamic>.from(json['data'] as Map),
    );
  }

  Future<ResponseStatusModel<JsonMap>> addBankAccount(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/wallet/bank-account', data: payload),
    );
  }

  Future<ResponseStatusModel<JsonMap>> setDefaultBankAccount(
    String accountId,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.put('/wallet/bank-account/$accountId/default'),
    );
  }

  Future<ResponseStatusModel<JsonMap>> updateBankAccount(
    String accountId,
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () =>
          _networkService.put('/wallet/bank-account/$accountId', data: payload),
    );
  }

  Future<ResponseStatusModel<JsonMap>> deleteBankAccount(
    String accountId,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.delete('/wallet/bank-account/$accountId'),
    );
  }

  Future<ResponseStatusModel<JsonMap>> makeWithdrawal(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/wallet/withdraw', data: payload),
    );
  }

  Future<ResponseStatusModel<JsonMap>> resolveAccount({
    required String accountNumber,
    required String bankCode,
  }) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post(
        '/flutterwave/accounts/resolve',
        data: {"account_number": accountNumber, "account_bank": bankCode},
      ),
    );
  }

  ///Banking Endpoints
  Future<ResponseStatusModel<List<Bank>>> getBanks({
    String country = "NG",
  }) async {
    return _networkService.request<List<Bank>>(
      () => _networkService.get(
        '/flutterwave/banks',
        query: {"country": country},
      ),
      parser: (data) {
        final list = data['data'] as List;
        return list.map((e) => Bank.fromJson(e)).toList();
      },
    );
  }

  ///Notifications
  Future<ResponseStatusModel<JsonMap>> getNotificationPreferences() async {
    return _networkService.request<JsonMap>(
      () => _networkService.get('/notifications/preferences'),
    );
  }

  Future<ResponseStatusModel<JsonMap>> updateNotificationPreferences(
    Map<String, dynamic> data,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.put('/notifications/preferences', data: data),
    );
  }

  ///location/tracking
  Future<ResponseStatusModel<JsonMap>> getRoute({
    required String orderId,
    required double startLat,
    required double startLng,
  }) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post(
        '/location/route',
        data: {'orderId': orderId, 'startLat': startLat, 'startLng': startLng},
      ),
    );
  }

  Future<ResponseStatusModel<LocationUpdateResponse>> updateLocation({
    required String orderId,
    required double latitude,
    required double longitude,
    double accuracy = 0,
    double speed = 0,
    double heading = 0,
  }) async {
    return _networkService.request<LocationUpdateResponse>(
      () => _networkService.post(
        '/location/update',
        data: {
          'orderId': orderId,
          'latitude': latitude,
          'longitude': longitude,
          'accuracy': accuracy,
          'speed': speed,
          'heading': heading,
        },
      ),
      parser: (data) => LocationUpdateResponse.fromJson(data),
    );
  }

  Future<ResponseStatusModel<JsonMap>> updateLocationStatus({
    required String orderId,
    required String status,
    double? latitude,
    double? longitude,
  }) async {
    return _networkService.request<JsonMap>(
      () => _networkService.put(
        '/location/status',
        data: {
          'orderId': orderId,
          'status': status,
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
        },
      ),
    );
  }

  Future<ResponseStatusModel<JsonMap>> getCurrentLocation(
    String orderId,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.get('/location/current/$orderId'),
    );
  }

  Future<ResponseStatusModel<JsonMap>> getLocationHistory(
    String orderId, {
    int limit = 50,
  }) async {
    return _networkService.request<JsonMap>(
      () => _networkService.get(
        '/location/history/$orderId',
        query: {'limit': limit},
      ),
    );
  }

  ///Others
  Future<ResponseStatusModel<JsonMap>> updateAvailability(bool isOnline) async {
    return _networkService.request<JsonMap>(() {
      final String statusValue = isOnline ? "online" : "offline";

      return _networkService.put(
        '/delivery-agent/availability',
        data: {"status": statusValue},
      );
    });
  }

  Future<ResponseStatusModel<JsonMap>> getUploadSignature(String folder) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/upload/signature', data: {"folder": folder}),
    );
  }

  Future<ResponseStatusModel<JsonMap>> deleteRiderAccount() async {
    return _networkService.request<JsonMap>(
      () => _networkService.delete('/delivery-agent/account'),
    );
  }

  Future<ResponseStatusModel<EarningsOverview>> getEarningsOverview() async {
    return _networkService.request<EarningsOverview>(
      () => _networkService.get('/delivery-agent/earnings/overview'),
      parser: (json) => EarningsOverview.fromJson(json["data"]),
    );
  }
}

final riderApiServiceProvider = Provider<RiderApiService>((ref) {
  return RiderApiService(ref.read(networkServiceProvider));
});
