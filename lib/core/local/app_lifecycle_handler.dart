import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/core/local/session_manager.dart';

import '../auth/auth_state_notifier.dart';
import '../providers/reset_userscope_providers.dart';

class AppLifecycleHandler with WidgetsBindingObserver {
  final Ref ref;
  bool _isResuming = false;

  AppLifecycleHandler(this.ref);

  void init() {
    WidgetsBinding.instance.addObserver(this);
    _handleResume();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleResume();
    }
  }

  Future<void> _handleResume() async {
    if (_isResuming) return;
    _isResuming = true;
    try {
      final session = ref.read(sessionManagerProvider);
      final isValid = await session.validateOrRefreshToken();

      if (!isValid) {
        await session.clearSession();
        resetUserScopedProviders(ref.invalidate);
        ref.read(authStateProvider.notifier).logout();
      } else {
        await ref.read(authStateProvider.notifier).init();
      }
    } finally {
      _isResuming = false;
    }
  }
}

final appLifecycleProvider = Provider<AppLifecycleHandler>((ref) {
  final handler = AppLifecycleHandler(ref);
  handler.init();
  return handler;
});
