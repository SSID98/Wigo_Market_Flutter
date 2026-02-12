import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/providers/role_selection_provider.dart';
import '../../../features/rider/viewmodels/global_navigation_viewmodel.dart';
import '../../../gen/assets.gen.dart';
import '../../models/user_role.dart';

class WebSideBar extends ConsumerWidget {
  const WebSideBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(globalNavigationViewModelProvider);
    final navNotifier = ref.read(globalNavigationViewModelProvider.notifier);
    final role = ref.watch(userRoleProvider);
    final isSeller = role == UserRole.seller;

    final List<Map<String, dynamic>> navItems = [
      {
        'label': 'Dashboard',
        'icon': AppAssets.icons.home2.path,
        'activeIcon': AppAssets.icons.home2.path,
      },
      {
        'label': isSeller ? 'Orders' : 'Deliveries',
        'icon':
            isSeller
                ? AppAssets.icons.dashboardCart.path
                : AppAssets.icons.menu.path,
        'activeIcon':
            isSeller
                ? AppAssets.icons.dashboardCart.path
                : AppAssets.icons.menu.path,
      },
      // Placeholder
      {
        'label': isSeller ? 'Products' : 'Map',
        'icon':
            isSeller ? AppAssets.icons.products.path : AppAssets.icons.map.path,
        'activeIcon':
            isSeller ? AppAssets.icons.products.path : AppAssets.icons.map.path,
      },
      // Placeholder
      {
        'label': isSeller ? 'Earning' : 'Wallet',
        'icon':
            isSeller
                ? AppAssets.icons.sellerEarning.path
                : AppAssets.icons.wallet.path,
        'activeIcon':
            isSeller
                ? AppAssets.icons.sellerEarning.path
                : AppAssets.icons.wallet.path,
      },
      // Placeholder
      {
        'label': 'Settings',
        'icon': AppAssets.icons.setting.path,
        'activeIcon': AppAssets.icons.setting.path,
      },
      // Placeholder
      if (isSeller) ...[
        {
          'label': 'Help and Support',
          'icon': AppAssets.icons.helpCircle.path,
          'activeIcon': AppAssets.icons.helpCircle.path,
        },
      ],
    ];

    return Container(
      width: 280,
      color: AppColors.darkerGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 20, left: 20),
            child: AppAssets.icons.logoWeb.svg(),
          ),
          // Navigation items
          ...navItems.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> item = entry.value;
            bool isSelected = navState.currentIndex == index;

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 8.0,
              ),
              child: Card(
                color: isSelected ? AppColors.clampBgColor : Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: SvgPicture.asset(
                    isSelected ? item['activeIcon'] : item['icon'],
                    colorFilter: ColorFilter.mode(
                      isSelected
                          ? AppColors.textDarkerGreen
                          : AppColors.accentWhite,
                      BlendMode.srcIn,
                    ),
                  ),
                  title: Text(
                    item['label'],
                    style: GoogleFonts.hind(
                      fontSize: 18,
                      color:
                          isSelected
                              ? AppColors.textDarkerGreen
                              : AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () => navNotifier.setIndex(index),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
