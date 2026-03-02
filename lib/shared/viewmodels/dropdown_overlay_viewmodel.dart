import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dropdown_overlay_state.dart';
import '../widgets/dropdown_ovelay_widget.dart';

final dropdownOverlayProvider =
    StateNotifierProvider<DropdownOverlayNotifier, DropdownOverlayState>(
      (ref) => DropdownOverlayNotifier(),
    );

class DropdownOverlayNotifier extends StateNotifier<DropdownOverlayState> {
  DropdownOverlayNotifier() : super(const DropdownOverlayState());

  OverlayEntry? _overlay;

  void show({
    required BuildContext context,
    required DropdownType type,
    required bool isBuyer,
  }) {
    close();

    final overlay = Overlay.of(context);

    _overlay =
        isBuyer
            ? OverlayEntry(
              builder:
                  (_) => DropdownOverlay(
                    type: type,
                    onClose: close,
                    onToggleCategories: toggleCategories,
                    // onDatePress: () {},
                  ),
            )
            : OverlayEntry(
              builder:
                  (_) => DropdownOverlay(
                    type: type,
                    onClose: close,
                    onToggleCategories: () {},
                    // onDatePress: showDateItems,
                    isBuyer: false,
                  ),
            );

    overlay.insert(_overlay!);
    state = state.copyWith(active: type);
  }

  void toggleCategories() {
    state = state.copyWith(showCategories: !state.showCategories);
  }

  void toggleSubMenu(DropdownType type) {
    state = state.copyWith(
      openedSubMenu: state.openedSubMenu == type ? null : type,
    );
  }

  void close() {
    _overlay?.remove();
    _overlay = null;
    state = const DropdownOverlayState();
  }
}
