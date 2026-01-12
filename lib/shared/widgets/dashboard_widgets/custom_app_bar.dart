import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/helper_methods.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';
import 'package:wigo_flutter/shared/widgets/custom_avatar.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/custom_search_field.dart';

import '../../../core/auth/auth_state.dart';
import '../../../core/auth/auth_state_notifier.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/url.dart';
import '../../../features/buyer/viewmodels/buyer_cart_viewmodel.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool isWeb;
  final bool isBuyer;
  final bool showEmail, showCircleAvatar;
  final String userName = 'Emmanuel';
  final String userEmail = 'emmanuel@example.com';
  final void Function()? onMobileMenuPress;
  final void Function()? onMobileSearchPress, onUserPress;
  final void Function()? onLoginPress;

  const CustomAppBar({
    super.key,
    required this.isWeb,
    this.isBuyer = false,
    this.showCircleAvatar = true,
    this.showEmail = true,
    this.onMobileMenuPress,
    this.onMobileSearchPress,
    this.onUserPress,
    this.onLoginPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final cartItemCount = ref.watch(cartCountProvider);
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      surfaceTintColor: AppColors.backgroundWhite,
      backgroundColor: AppColors.backgroundWhite,
      titleSpacing: 10,
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
          if (authState.status == AuthStatus.loggedIn)
            if (isBuyer) ...[
              GestureDetector(
                onTap: onUserPress,
                child: Container(
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
              ),
            ],
          IconButton(
            icon: AppAssets.icons.mobileSearch.svg(
              height: authState.status == AuthStatus.loggedIn ? null : 35,
            ),
            onPressed: onMobileSearchPress,
          ),
          isBuyer
              ? authState.status == AuthStatus.loggedOut
                  ? Row(
                    children: [
                      CustomButton(
                        text: 'Login',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        buttonColor: Colors.transparent,
                        textColor: AppColors.textVidaLocaGreen,
                        onPressed: onLoginPress,
                        width: 55,
                        padding: EdgeInsets.zero,
                      ),
                      CustomButton(
                        text: 'Sign Up',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 35,
                        width: 76,
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  )
                  : Stack(
                    children: [
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(66.76),
                          color: AppColors.tableHeader,
                        ),
                        child: IconButton(
                          key: const Key('cart_button'),
                          icon: AppAssets.icons.cart.svg(height: 24),
                          onPressed: () async {
                            showLoadingDialog(context);
                            await Future.delayed(const Duration(seconds: 1));
                            if (!context.mounted) return;
                            Navigator.of(context, rootNavigator: true).pop();
                            context.push('/buyer/cart');
                          },
                        ),
                      ),
                      if (cartItemCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.only(top: 1),
                            decoration: BoxDecoration(
                              color: AppColors.accentRed,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              cartItemCount.toString(),
                              style: GoogleFonts.hind(
                                color: AppColors.textWhite,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  )
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
            onPressed: onMobileMenuPress,
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
