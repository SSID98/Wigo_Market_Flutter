import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';
import 'package:wigo_flutter/shared/widgets/custom_avatar.dart';
import 'package:wigo_flutter/shared/widgets/custom_search_field.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/url.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isWeb;
  final bool isBuyer;
  final bool showEmail, showCircleAvatar;
  final String userName = 'Emmanuel';
  final String userEmail = 'emmanuel@example.com';
  final void Function()? onMenuPress;

  const CustomAppBar({
    super.key,
    required this.isWeb,
    this.isBuyer = false,
    this.showCircleAvatar = true,
    this.showEmail = true,
    this.onMenuPress,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      surfaceTintColor: AppColors.backgroundWhite,
      backgroundColor: AppColors.backgroundWhite,
      title:
          isWeb
              ? Row(
                children: [
                  if (isBuyer) Image.network('$networkImageUrl/logo3.png'),
                  const SizedBox(width: 400),
                  Expanded(child: CustomSearchField(hintText: 'search')),
                ],
              )
              : isBuyer
              ? Image.network('$networkImageUrl/logo3.png')
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
                  if (!isBuyer) ...[
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
                    const SizedBox(width: 10),
                  ],
                  CustomAvatar(
                    showEmail: showEmail,
                    showCircleAvatar: showCircleAvatar,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  SizedBox(width: 8),
                  AppAssets.icons.arrowDown.svg(),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
          isBuyer
              ? AppAssets.icons.cart2.svg()
              : IconButton(
                icon: AppAssets.icons.webLogoutButton.svg(),
                onPressed: () {},
              ),
          const SizedBox(width: 50),
        ] else ...[
          if (isBuyer)
            Container(
              decoration: BoxDecoration(
                color: AppColors.tableHeader,
                borderRadius: BorderRadius.circular(46.13),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 10.0,
                ),
                child: Text(
                  'Hi, Emmanuel',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.textBlackGrey,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: AppAssets.icons.mobileSearch.svg(),
            onPressed: () {},
          ),
          isBuyer
              ? AppAssets.icons.cart2.svg()
              : Container(
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
            icon: AppAssets.icons.mobileMenu.svg(),
            onPressed: onMenuPress,
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
