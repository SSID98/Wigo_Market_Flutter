import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationState {
  final bool pushNotify;
  final bool promoNotify;
  final bool emailNotify;

  const NotificationState({
    this.pushNotify = false,
    this.emailNotify = false,
    this.promoNotify = false,
  });

  NotificationState copyWith({
    bool? pushNotify,
    bool? promoNotify,
    bool? emailNotify,
  }) {
    return NotificationState(
      pushNotify: pushNotify ?? this.pushNotify,
      promoNotify: promoNotify ?? this.promoNotify,
      emailNotify: emailNotify ?? this.emailNotify,
    );
  }
}

class NotificationViewModel extends StateNotifier<NotificationState> {
  NotificationViewModel() : super(const NotificationState());

  void toggleSwitch1(bool newValue) {
    state = state.copyWith(pushNotify: newValue);
  }

  void toggleSwitch2(bool newValue) {
    state = state.copyWith(promoNotify: newValue);
  }

  void toggleSwitch3(bool newValue) {
    state = state.copyWith(emailNotify: newValue);
  }
}

final notificationViewModelProvider =
    StateNotifierProvider<NotificationViewModel, NotificationState>(
      (ref) => NotificationViewModel(),
    );
