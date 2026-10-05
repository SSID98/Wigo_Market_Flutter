import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/local/session_manager.dart';
import '../../rider/viewmodels/global_navigation_viewmodel.dart';
import '../models/order.dart';
import '../navigation/seller_tab_navigation.dart';
import '../services/seller_api_service.dart';

const _maxReconnectDelay = Duration(seconds: 30);

const _recentOrdersLimit = 5;

class RecentOrdersLiveViewmodel extends StateNotifier<AsyncValue<List<Order>>> {
  RecentOrdersLiveViewmodel(this._api, this._session, this._ref)
    : super(const AsyncValue.loading()) {
    _loadInitial();
    _navSub = _ref.listen<GlobalNavigationState>(
      globalNavigationViewModelProvider,
      (previous, next) => _onTabChanged(next.currentIndex),
      fireImmediately: true,
    );
  }

  final SellerApiService _api;
  final SessionManager _session;
  final Ref _ref;

  ProviderSubscription<GlobalNavigationState>? _navSub;
  WebSocketChannel? _wsChannel;
  StreamSubscription? _wsSub;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  bool _everConnected = false;

  void _onTabChanged(int tabIndex) {
    if (tabIndex == SellerTab.dashboard) {
      _connect();
    } else {
      _disconnect();
    }
  }

  Future<void> _loadInitial() async {
    state = const AsyncValue.loading();
    try {
      final response = await _api.getRecentOrders();
      if (!mounted) return;
      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data!);
      } else {
        state = AsyncValue.error(
          response.errorDescription ?? 'Failed to load recent orders',
          StackTrace.current,
        );
      }
    } catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => _loadInitial();

  void _connect() {
    if (_wsChannel != null) return;
    final token = _session.accessToken;
    if (token == null) return;

    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final httpUri = Uri.tryParse(baseUrl);
    if (httpUri == null) return;

    final wsScheme = httpUri.scheme == 'https' ? 'wss' : 'ws';
    final wsUri = Uri(
      scheme: wsScheme,
      host: httpUri.host,
      port: (httpUri.port == 80 || httpUri.port == 443 || httpUri.port == 0)
          ? null
          : httpUri.port,
      path: '/ws/orders',
      queryParameters: {'token': token},
    );

    try {
      _wsChannel = WebSocketChannel.connect(wsUri);
      _wsSub = _wsChannel!.stream.listen(
        _onMessage,
        onDone: _scheduleReconnect,
        onError: (_) => _scheduleReconnect(),
        cancelOnError: false,
      );
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void _disconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _reconnectAttempts = 0;
    _wsSub?.cancel();
    _wsSub = null;
    _wsChannel?.sink.close();
    _wsChannel = null;
  }

  void _scheduleReconnect() {
    _wsSub?.cancel();
    _wsSub = null;
    _wsChannel = null;

    if (!mounted ||
        _ref.read(globalNavigationViewModelProvider).currentIndex !=
            SellerTab.dashboard) {
      return;
    }

    _reconnectTimer?.cancel();
    final delay = Duration(
      seconds: min(
        _maxReconnectDelay.inSeconds,
        pow(2, _reconnectAttempts).toInt(),
      ),
    );
    _reconnectAttempts++;
    _reconnectTimer = Timer(delay, () {
      _connect();
      if (_everConnected) _loadInitial();
    });
  }

  void _onMessage(dynamic raw) {
    _reconnectAttempts = 0;
    try {
      final msg = jsonDecode(raw as String) as Map<String, dynamic>;
      final type = msg['type'] as String? ?? '';

      if (type == 'connection') {
        _everConnected = true;
        return;
      }

      final orderJson = msg['order'] as Map<String, dynamic>?;
      if (orderJson == null) return;
      final order = Order.fromJson(orderJson);

      final current = List<Order>.from(state.value ?? const []);

      if (type == 'order.created') {
        current.insert(0, order);
        if (current.length > _recentOrdersLimit) {
          current.removeRange(_recentOrdersLimit, current.length);
        }
        state = AsyncValue.data(current);
      } else if (type == 'order.updated') {
        final idx = current.indexWhere((o) => o.id == order.id);
        if (idx == -1) return;
        current[idx] = order;
        state = AsyncValue.data(current);
      }
    } catch (_) {
      // Malformed message - ignore; the next reconnect/resync (or a
      // manual refresh()) will reconcile state.
    }
  }

  @override
  void dispose() {
    _navSub?.close();
    _disconnect();
    super.dispose();
  }
}

final recentOrdersLiveProvider =
    StateNotifierProvider.autoDispose<
      RecentOrdersLiveViewmodel,
      AsyncValue<List<Order>>
    >(
      (ref) => RecentOrdersLiveViewmodel(
        ref.read(sellerApiServiceProvider),
        ref.read(sessionManagerProvider),
        ref,
      ),
    );
