import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/order_details_model.dart';
import '../models/order_enums.dart';
import '../services/seller_api_service.dart';
import 'order_task_viewmodel.dart';

final orderDetailProvider = FutureProvider.family<OrderDetail, String>((
  ref,
  orderId,
) async {
  final api = ref.read(sellerApiServiceProvider);
  final response = await api.getOrderDetail(orderId);
  if (response.isSuccess && response.data != null) {
    return response.data!;
  }
  throw Exception(response.errorDescription ?? 'Failed to load this order.');
});

final orderActionsProvider = Provider<OrderActions>((ref) => OrderActions(ref));

class OrderActions {
  OrderActions(this._ref);

  final Ref _ref;

  Future<String?> updateStatus(
    String orderId,
    OrderFilter status, {
    String? reason,
  }) async {
    final error = await _ref
        .read(orderTaskProvider.notifier)
        .updateOrderStatus(orderId, status, reason: reason);
    _ref.invalidate(orderDetailProvider(orderId));
    _ref.invalidate(recentOrdersProvider);
    return error;
  }

  Future<String?> contactCustomer(String orderId, String message) async {
    try {
      final response = await _ref
          .read(sellerApiServiceProvider)
          .contactCustomer(orderId, message);
      if (!response.isSuccess) {
        return response.errorDescription ?? 'Could not send the message.';
      }
      return null;
    } catch (_) {
      return 'Something went wrong sending the message. Please try again.';
    }
  }
}
