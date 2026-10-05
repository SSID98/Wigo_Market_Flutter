import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../rider/viewmodels/global_navigation_viewmodel.dart';
import 'seller_main_screen.dart';

class SellerTab {
  SellerTab._();

  static const int dashboard = 0;
  static const int orders = 1;
  static const int products = 2;
  static const int wallet = 3;
  static const int settings = 4;
}

void goToSellerTab(WidgetRef ref, int tabIndex) {
  ref.read(globalNavigationViewModelProvider.notifier).setIndex(tabIndex);
}

void pushOnSellerTab(WidgetRef ref, int tabIndex, WidgetBuilder builder) {
  goToSellerTab(ref, tabIndex);
  final keys = ref.read(sellerNavigatorKeysProvider);
  keys[tabIndex].currentState?.push(MaterialPageRoute(builder: builder));
}
