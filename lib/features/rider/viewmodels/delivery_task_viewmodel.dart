import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/network/network.dart';
import '../models/delivery_model.dart';
import '../models/delivery_task_state.dart';
import '../service/rider_api_service.dart';

// Private sentinel — distinguishes "not provided" from explicit null in copyWith.
const _keep = Object();

class DeliveryTaskViewModel extends StateNotifier<DeliveryTaskState> {
  final Reader read;
  final RiderApiService api;

  static const int _pageSize = 10;

  DeliveryTaskViewModel(this.read, {RiderApiService? apiService})
    : api = apiService ?? read(riderApiServiceProvider),
      super(const DeliveryTaskState()) {
    _init();
  }

  Future<void> _init() async {
    // Fire both in parallel so the UI is ready as fast as possible.
    await Future.wait([fetchOrders(), refreshCounts()]);
  }

  Future<void> fetchOrders({bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(deliveries: const AsyncValue.loading());
    }

    try {
      final result = await api.getOrders(
        page: state.currentPage + 1, // API is 1-indexed
        limit: _pageSize,
        tab: state.selectedFilter.tabParam,
      );

      if (!mounted) return;

      if (result.isSuccess && result.data != null) {
        final freshOrders = result.data!.orders;
        final pagination = result.data!.pagination;

        // If the web side-panel delivery was claimed by another rider during
        // a silent poll, auto-clear it so the rider isn't looking at stale info.
        final selectedId = state.selectedDelivery?.id;
        final selectedStillExists =
            selectedId == null || freshOrders.any((o) => o.id == selectedId);

        state = state.copyWith(
          deliveries: AsyncValue.data(freshOrders),
          pagination: pagination,
          selectedDelivery: selectedStillExists ? _keep : null,
        );
      } else if (!silent) {
        state = state.copyWith(
          deliveries: AsyncValue.error(
            result.errorDescription ?? 'Failed to load orders.',
            StackTrace.current,
          ),
        );
      }
    } catch (e, st) {
      if (!mounted) return;
      if (!silent) {
        state = state.copyWith(deliveries: AsyncValue.error(e, st));
      }
    }
  }

  Future<void> refreshCounts() async {
    try {
      final result = await api.getOrderCounts();
      if (!mounted || !result.isSuccess || result.data == null) return;

      final counts = result.data!;
      state = state.copyWith(
        deliveryCounts: {
          DeliveryFilter.all: counts.all,
          DeliveryFilter.newRequest: counts.available,
          DeliveryFilter.ongoing: counts.ongoing,
          DeliveryFilter.completed: counts.completed,
          DeliveryFilter.cancelled: counts.cancelled,
        },
      );
    } catch (_) {}
  }

  void setFilter(DeliveryFilter filter) {
    state = state.copyWith(
      selectedFilter: filter,
      currentPage: 0,
      selectedDelivery: null,
    );
    fetchOrders();
  }

  void goToPage(int page) {
    if (page < 0 || page >= state.totalPages) return;
    state = state.copyWith(currentPage: page);
    fetchOrders();
  }

  void setSelectedDelivery(Delivery? delivery) {
    state = state.copyWith(selectedDelivery: delivery);
  }

  // ─── Actions ───────────────────────────────────────────────────────────────
  //
  // Status progression (maps to API endpoints):
  //
  //   pending_assignment ──[selectOrder]──► assigned
  //   assigned           ──[updateOrderStatus('picked_up')]──► picked_up
  //   picked_up          ──[updateOrderStatus('in_transit')]──► in_transit
  //   in_transit         ──[confirmDelivery]──► delivered + wallet credited

  /// Step 1 — Atomically claims a pending_assignment order for this rider.
  /// If two riders request the same order simultaneously, only one succeeds
  Future<bool> selectOrder(String orderId) async {
    return _runAction(() async {
      final result = await api.selectOrder(orderId);
      if (!result.isSuccess) {
        return _fail(
          result.errorDescription ??
              'Could not accept this order — it may have already been taken.',
        );
      }
      return true;
    });
  }

  /// Steps 2 & 3 — Intermediate status transitions.
  /// [status]: 'picked_up' (step 2) or 'in_transit' (step 3).
  Future<bool> updateOrderStatus(String orderId, String status) async {
    return _runAction(() async {
      final result = await api.updateOrderStatus(
        orderId: orderId,
        status: status,
      );
      if (!result.isSuccess) {
        return _fail(
          result.errorDescription ?? 'Failed to update delivery status.',
        );
      }
      return true;
    });
  }

  /// Step 4 — Confirms parcel handoff to the customer.
  /// Atomically marks the order as delivered and credits the delivery fee
  /// to the rider's wallet. Idempotent — safe to call more than once.
  ///
  /// Returns (success, creditedAmount). creditedAmount is null if the
  /// backend reported credited: false.
  Future<(bool, double?)> confirmDelivery(String orderId) async {
    state = state.copyWith(isActionLoading: true, actionError: _keep);

    try {
      final result = await api.confirmDelivery(orderId);
      if (!mounted) return (false, null);

      if (result.isSuccess && result.data != null) {
        final amount = result.data!.credited ? result.data!.amount : null;
        state = state.copyWith(
          isActionLoading: false,
          selectedDelivery: null,
          lastCreditedAmount: amount,
        );
        await Future.wait([fetchOrders(silent: true), refreshCounts()]);
        return (true, amount);
      } else {
        state = state.copyWith(
          isActionLoading: false,
          actionError: result.errorDescription ?? 'Failed to confirm delivery.',
        );
        return (false, null);
      }
    } catch (_) {
      if (!mounted) return (false, null);
      state = state.copyWith(
        isActionLoading: false,
        actionError: 'Something went wrong. Please try again.',
      );
      return (false, null);
    }
  }

  void clearActionError() => state = state.copyWith(actionError: null);

  void clearLastCreditedAmount() =>
      state = state.copyWith(lastCreditedAmount: null);

  Future<bool> _runAction(Future<bool> Function() action) async {
    state = state.copyWith(isActionLoading: true, actionError: _keep);
    try {
      final success = await action();
      if (!mounted) return false;
      state = state.copyWith(
        isActionLoading: false,
        selectedDelivery: success ? null : _keep,
      );
      if (success) {
        await Future.wait([fetchOrders(silent: true), refreshCounts()]);
      }
      return success;
    } catch (_) {
      if (!mounted) return false;
      state = state.copyWith(
        isActionLoading: false,
        actionError: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  bool _fail(String message) {
    state = state.copyWith(isActionLoading: false, actionError: message);
    return false;
  }
}

final deliveryTaskProvider =
    StateNotifierProvider<DeliveryTaskViewModel, DeliveryTaskState>(
      (ref) => DeliveryTaskViewModel(ref.read),
    );
