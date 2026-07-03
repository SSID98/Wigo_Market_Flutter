import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/shared/widgets/role_card.dart';

import '../../core/providers/role_selection_provider.dart';
import '../../gen/assets.gen.dart';
import '../models/user_role.dart';
import '../viewmodels/role_selection_viewmodel.dart';

class RoleSelectionBody extends ConsumerWidget {
  final double sizedBoxHeight1, padding;
  final double textFontSize, titleTextSize, descriptionTextSize;
  final double iconHeight, iconWidth;
  final double? sizedBoxHeight2;

  const RoleSelectionBody({
    super.key,
    required this.titleTextSize,
    required this.descriptionTextSize,
    required this.textFontSize,
    required this.sizedBoxHeight1,
    required this.iconWidth,
    required this.iconHeight,
    required this.padding,
    this.sizedBoxHeight2,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(roleSelectionViewModelProvider.notifier);
    final selectedRole = ref.watch(userRoleProvider);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Text(
            'How do you want to use the platform? Choose a role to continue.',
            textAlign: TextAlign.center,
            style: GoogleFonts.hind(
              textStyle: TextStyle(
                color: AppColors.textBlackGrey,
                fontSize: textFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: sizedBoxHeight1),
        RadioGroup<UserRole>(
          groupValue: selectedRole,
          onChanged: (UserRole? newValue) {
            if (newValue != null) {
              vm.confirmSelection(context, ref, newValue);
            }
          },
          child: Column(
            children: [
              RoleCard<UserRole>(
                value: UserRole.buyer,
                title: 'Buyer',
                description:
                    'Browse nearby stores, order what you need, and get it delivered or pick it up yourself.',
                icon: AppAssets.icons.buyerIcon.path,
                onTap: () async {
                  vm.confirmSelection(context, ref, UserRole.buyer);
                },
                backgroundColor: AppColors.buyerCardColor,
                radioColor: AppColors.primaryDarkGreen,
                iconHeight: iconHeight,
                iconWidth: iconWidth,
                descriptionTextSize: descriptionTextSize,
                titleTextSize: titleTextSize,
              ),
              SizedBox(height: sizedBoxHeight2),
              RoleCard<UserRole>(
                value: UserRole.seller,
                title: 'Seller',
                description:
                    'Own a shop or run a business? List your products and start selling to nearby students.',
                icon: AppAssets.icons.sellerIcon.path,
                onTap: () async {
                  vm.confirmSelection(context, ref, UserRole.seller);
                },
                backgroundColor: AppColors.sellerCardColor,
                radioColor: AppColors.radioOrange,
                iconHeight: iconHeight,
                iconWidth: iconWidth,
                descriptionTextSize: descriptionTextSize,
                titleTextSize: titleTextSize,
              ),
              SizedBox(height: sizedBoxHeight2),
              RoleCard<UserRole>(
                value: UserRole.dispatch,
                title: 'Delivery Agent',
                description:
                    'Earn money delivering orders around campus. No experience needed!',
                icon: AppAssets.icons.riderIcon.path,
                onTap: () async {
                  vm.confirmSelection(context, ref, UserRole.dispatch);
                },
                backgroundColor: AppColors.riderCardColor,
                radioColor: AppColors.radioBlue,
                iconHeight: iconHeight,
                iconWidth: iconWidth,
                descriptionTextSize: descriptionTextSize,
                titleTextSize: titleTextSize,
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Already have an account? ",
                style: GoogleFonts.hind(
                  fontSize: context.isWeb ? 16.0 : 12.0,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textBlackGrey,
                ),
              ),
              TextSpan(
                text: "Sign in",
                style: GoogleFonts.hind(
                  fontSize: context.isWeb ? 16.0 : 12.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOrange,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    context.push('/login');
                  },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
