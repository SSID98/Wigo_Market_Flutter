import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNavigationState {
  final int? selectedIndex;

  const SettingsNavigationState({this.selectedIndex});
}

class SettingsNavigationViewModel
    extends StateNotifier<SettingsNavigationState> {
  SettingsNavigationViewModel() : super(const SettingsNavigationState());

  void updateIndex(int? index) {
    state = SettingsNavigationState(selectedIndex: index);
  }
}

final settingsNavigationProvider =
    StateNotifierProvider<SettingsNavigationViewModel, SettingsNavigationState>(
      (ref) => SettingsNavigationViewModel(),
    );
