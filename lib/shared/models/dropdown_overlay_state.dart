enum DropdownType {
  menu,
  user,
  mobileFilter,
  date,
  orderStatus,
  updateStatus,
  actions,
}

class DropdownOverlayState {
  final DropdownType? active;
  final DropdownType? openedSubMenu;
  final bool showCategories;

  // final bool showDateItems;
  // final bool showStatusItems;

  const DropdownOverlayState({
    this.active,
    this.showCategories = false,
    // this.showDateItems = false,
    // this.showStatusItems = false,
    this.openedSubMenu,
  });

  DropdownOverlayState copyWith({
    DropdownType? active,
    bool? showCategories,
    // bool? showDateItems,
    // bool? showStatusItems,
    DropdownType? openedSubMenu,
  }) {
    return DropdownOverlayState(
      active: active,
      openedSubMenu: openedSubMenu,
      showCategories: showCategories ?? this.showCategories,
      // showDateItems: showDateItems ?? this.showDateItems,
      // showStatusItems: showStatusItems ?? this.showStatusItems,
    );
  }
}
