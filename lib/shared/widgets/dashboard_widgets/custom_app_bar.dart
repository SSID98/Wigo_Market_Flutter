import 'package:flutter/material.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';
import 'package:wigo_flutter/shared/widgets/custom_avatar.dart';
import 'package:wigo_flutter/shared/widgets/custom_search_field.dart';

import '../../../core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isWeb;
  final String userName = 'Emmanuel';
  final String userEmail = 'emmanuel@example.com';

  const CustomAppBar({super.key, required this.isWeb});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      surfaceTintColor: AppColors.backgroundWhite,
      backgroundColor:
          isWeb ? AppColors.backgroundWhite : AppColors.backgroundWhite,
      title:
          isWeb
              ? Row(
                children: [
                  const SizedBox(width: 400),
                  Expanded(child: CustomSearchField(hintText: 'search')),
                ],
              )
              : CustomAvatar(),
      actions: [
        if (isWeb) ...[
          // Web-specific actions
          Padding(
            padding: EdgeInsets.only(left: 200.0, right: 10),
            child: Container(
              height: 52,
              width: 180,
              decoration: BoxDecoration(
                color: AppColors.tableHeader,
                borderRadius: BorderRadius.circular(46.13),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  CustomAvatar(
                    showEmail: true,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  SizedBox(width: 8),
                  AppAssets.icons.arrowDown.svg(),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
          IconButton(
            icon: AppAssets.icons.webLogoutButton.svg(),
            onPressed: () {
              // Handle logout
            },
          ),
          const SizedBox(width: 50),
        ] else ...[
          // Mobile-specific actions
          IconButton(
            icon: AppAssets.icons.mobileSearch.svg(),
            onPressed: () {
              // Handle search
            },
          ),
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppColors.tableHeader,
              borderRadius: BorderRadius.circular(56.08),
            ),
            child: IconButton(
              icon: AppAssets.icons.notification.svg(),
              onPressed: () {
                // Handle notifications
              },
            ),
          ),
          IconButton(
            icon: AppAssets.icons.mobileMenu.svg(), // Hamburger menu
            onPressed: () {
              Scaffold.of(context).openEndDrawer(); // Or openDrawer()
            },
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
