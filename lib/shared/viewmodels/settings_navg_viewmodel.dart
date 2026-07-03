import 'package:flutter_riverpod/legacy.dart';

class SettingsNavigationState {
  final int? selectedIndex;

  const SettingsNavigationState({this.selectedIndex});
}

class SettingsNavigationViewModel
    extends StateNotifier<SettingsNavigationState> {
  SettingsNavigationViewModel()
    : super(const SettingsNavigationState(selectedIndex: 0));

  void updateIndex(int? index) {
    state = SettingsNavigationState(selectedIndex: index);
  }
}

final settingsNavigationProvider =
    StateNotifierProvider<SettingsNavigationViewModel, SettingsNavigationState>(
      (ref) => SettingsNavigationViewModel(),
    );
