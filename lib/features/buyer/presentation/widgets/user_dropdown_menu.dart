import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import '../../../../core/auth/auth_state_notifier.dart';
import '../../../../core/utils/helper_methods.dart';
import '../../../../gen/assets.gen.dart';

class UserDropDownMenu extends ConsumerWidget {
  const UserDropDownMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    double iconHeight = isWeb ? 18 : 14;
    final menuItems = [
      {
        'icon': AppAssets.icons.userCircle.svg(height: iconHeight),
        'label': 'My account',
        'onPressed': () {},
      },
      {
        'icon': AppAssets.icons.cart.svg(height: iconHeight),
        'label': 'My Orders',
        'onPressed': () async {
          showLoadingDialog(context);
          await Future.delayed(const Duration(seconds: 1));
          if (!context.mounted) return;
          Navigator.of(context, rootNavigator: true).pop();
          context.push('/buyer/Orders');
        },
      },
      {
        'icon': AppAssets.icons.greenHeart.svg(height: iconHeight),
        'label': 'Saved',
        'onPressed': () {},
      },
      {
        'icon': AppAssets.icons.buyerLogout.svg(height: iconHeight),
        'label': 'Log out',
        'onPressed': () {
          ref.read(authStateProvider.notifier).logout();
        },
      },
    ];

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...menuItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              final isLastItem = index == menuItems.length - 1;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                child: GestureDetector(
                  onTap: item['onPressed'] as void Function()?,
                  child: Row(
                    children: [
                      item['icon'] as SvgPicture,
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item['label'] as String,
                          style: GoogleFonts.hind(
                            fontSize: isWeb ? 14 : 12,
                            color:
                                isLastItem
                                    ? AppColors.textLightRed
                                    : AppColors.primaryDarkGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
