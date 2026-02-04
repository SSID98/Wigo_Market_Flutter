import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_state.dart';
import '../auth/auth_state_notifier.dart';
import '../local/local_user_controller.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  // 1. Create local variables to hold the "Current" state
  AuthStatus _authStatus = AuthStatus.loading;
  LocalUserState? _localUserState;

  RouterNotifier(this._ref) {
    // 2. Listen to changes and update our local variables immediately
    _ref.listen(authStateProvider, (previous, next) {
      if (previous?.status != next.status) {
        _authStatus = next.status;
        notifyListeners();
      }
    }, fireImmediately: true);

    _ref.listen(localUserControllerProvider, (previous, next) {
      _localUserState = next;
      notifyListeners();
    }, fireImmediately: true);
  }

  // 3. Expose getters so GoRouter doesn't have to use 'ref.read'
  AuthStatus get authStatus => _authStatus;

  LocalUserState? get localUserState => _localUserState;
}

final routerNotifierProvider = ChangeNotifierProvider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});
