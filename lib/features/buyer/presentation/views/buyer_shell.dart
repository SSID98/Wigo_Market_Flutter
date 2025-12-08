import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/dashboard_widgets/custom_app_bar.dart';
import '../../viewmodels/buyer_home_viewmodel.dart';
import '../widgets/custom_dropdown_menu.dart';
import '../widgets/user_dropdown_menu.dart';

class BuyerShell extends ConsumerStatefulWidget {
  final Widget child;

  const BuyerShell({super.key, required this.child});

  @override
  ConsumerState<BuyerShell> createState() => _BuyerShellState();
}

class _BuyerShellState extends ConsumerState<BuyerShell> {
  OverlayEntry? _overlayEntry1;
  bool _showingCategories = false;

  void _showDropdownMenu(bool isMenu) {
    final overlay = Overlay.of(context);

    _overlayEntry1 = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              isMenu
                  ? Positioned.fill(
                    child: GestureDetector(
                      onTap: _closeDropdownMenu,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.02),
                        ),
                      ),
                    ),
                  )
                  : Positioned.fill(
                    child: GestureDetector(
                      onTap: _closeDropdownMenu,
                      child: Container(color: Colors.transparent),
                    ),
                  ),

              Positioned(
                top: isMenu ? 60 : 90,
                right: isMenu ? 16 : 120,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return isMenu
                        ? CustomDropdownMenu(
                          onClose: _closeDropdownMenu,
                          onCategoriesPress: () {
                            setState(() {
                              _showingCategories = !_showingCategories;
                            });
                          },
                          showCategories: _showingCategories,
                        )
                        : UserDropDownMenu();
                  },
                ),
              ),
            ],
          ),
    );

    overlay.insert(_overlayEntry1!);
  }

  void _closeDropdownMenu() {
    _overlayEntry1?.remove();
    _overlayEntry1 = null;
  }

  @override
  Widget build(BuildContext context) {
    final vmNotifier = ref.read(buyerHomeViewModelProvider.notifier);
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundWhit,
          appBar: CustomAppBar(
            isWeb: isWeb,
            isBuyer: true,
            onUserPress: () {
              _showDropdownMenu(false);
            },
            onMobileMenuPress: () {
              _showDropdownMenu(true);
            },
            onMobileSearchPress: vmNotifier.toggleSearchFieldVisibility,
            onLoginPress: () {
              context.push('/login');
            },
          ),
          body: widget.child,
        ),
      ],
    );
  }
}
