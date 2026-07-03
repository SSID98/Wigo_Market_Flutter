import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/core/local/session_manager.dart';

import '../auth/auth_state_notifier.dart';

class AppLifecycleHandler with WidgetsBindingObserver {
  final Ref ref;

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
    final session = ref.read(sessionManagerProvider);

    final isValid = await session.validateOrRefreshToken();

    if (!isValid) {
      await session.clearSession();

      ref.read(authStateProvider.notifier).logout();
    } else {
      await ref.read(authStateProvider.notifier).init();
    }
  }
}

final appLifecycleProvider = Provider<AppLifecycleHandler>((ref) {
  final handler = AppLifecycleHandler(ref);
  handler.init();
  return handler;
});
