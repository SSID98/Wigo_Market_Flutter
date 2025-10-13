import 'package:flutter_riverpod/flutter_riverpod.dart';

class RNotificationState {
  final bool pushNotify;
  final bool promoNotify;
  final bool emailNotify;

  const RNotificationState({
    this.pushNotify = false,
    this.emailNotify = false,
    this.promoNotify = false,
  });

  RNotificationState copyWith({
    bool? pushNotify,
    bool? promoNotify,
    bool? emailNotify,
  }) {
    return RNotificationState(
      pushNotify: pushNotify ?? this.pushNotify,
      promoNotify: promoNotify ?? this.promoNotify,
      emailNotify: emailNotify ?? this.emailNotify,
    );
  }
}

class RiderNotificationViewModel extends StateNotifier<RNotificationState> {
  RiderNotificationViewModel() : super(const RNotificationState());

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

final riderNotificationViewModelProvider =
    StateNotifierProvider<RiderNotificationViewModel, RNotificationState>(
      (ref) => RiderNotificationViewModel(),
    );
