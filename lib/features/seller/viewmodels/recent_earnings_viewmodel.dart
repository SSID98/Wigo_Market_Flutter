import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/seller_earnings_models.dart';
import '../services/seller_api_service.dart';

class RecentEarningsViewModel
    extends StateNotifier<AsyncValue<List<RecentEarning>>> {
  RecentEarningsViewModel(this._api, {this.limit = 5})
    : super(const AsyncValue<List<RecentEarning>>.loading()) {
    load();
  }

  final SellerApiService _api;
  final int limit;
  int _requestId = 0;

  Future<void> load() async {
    final requestId = ++_requestId;
    try {
      final response = await _api.getRecentEarnings(limit: limit);
      if (!mounted || requestId != _requestId) return;

      final data = response.data;
      if (response.isSuccess && data != null) {
        state = AsyncValue.data(data);
      } else {
        _setError(
          response.errorDescription ?? 'Failed to load recent earnings',
        );
      }
    } catch (_) {
      if (!mounted || requestId != _requestId) return;
      _setError('Something went wrong loading your recent earnings.');
    }
  }

  Future<void> refresh() {
    if (!state.hasValue) state = const AsyncValue.loading();
    return load();
  }

  void _setError(String message) {
    if (state.hasValue) return;
    state = AsyncValue.error(message, StackTrace.current);
  }
}

final recentEarningsViewModelProvider =
    StateNotifierProvider.autoDispose<
      RecentEarningsViewModel,
      AsyncValue<List<RecentEarning>>
    >((ref) => RecentEarningsViewModel(ref.read(sellerApiServiceProvider)));
