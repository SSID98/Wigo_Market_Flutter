import 'package:flutter_riverpod/legacy.dart';

class SettingsNavigationState {
  final int? selectedIndex;
  final bool executeMobilePush;

  const SettingsNavigationState({
    this.selectedIndex,
    this.executeMobilePush = false,
  });

  SettingsNavigationState copyWith({
    int? selectedIndex,
    bool? executeMobilePush,
  }) {
    return SettingsNavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      executeMobilePush: executeMobilePush ?? this.executeMobilePush,
    );
  }
}

class SettingsNavigationViewModel
    extends StateNotifier<SettingsNavigationState> {
  SettingsNavigationViewModel()
    : super(const SettingsNavigationState(selectedIndex: 0));

  // void updateIndex(int? index) {
  //   state = SettingsNavigationState(selectedIndex: index);
  // }
  void updateIndex(int? index, {bool mobilePush = false}) {
    state = state.copyWith(selectedIndex: index, executeMobilePush: mobilePush);
  }

  void clearMobilePush() {
    state = state.copyWith(executeMobilePush: false);
  }
}

final settingsNavigationProvider =
    StateNotifierProvider<SettingsNavigationViewModel, SettingsNavigationState>(
      (ref) => SettingsNavigationViewModel(),
    );
