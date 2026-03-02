import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/widgets/role_card.dart';

import '../../core/local/local_user_controller.dart';
import '../../core/providers/role_selection_provider.dart';
import '../../core/utils/helper_methods.dart';
import '../../gen/assets.gen.dart';
import '../models/user_role.dart';
import '../viewmodels/role_selection_view_model.dart';

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
    final viewModel = ref.read(roleSelectionViewModelProvider.notifier);
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

        // RadioGroup<UserRole>(
        //   groupValue: selectedRole,
        //   onChanged: (value) async {
        //     if (value == null) return;
        //
        //     await ref
        //         .read(localUserControllerProvider.notifier)
        //         .saveRole(value.name);
        //
        //     await Future.delayed(Duration.zero);
        //     if (!context.mounted) return;
        //     showLoadingDialog(context);
        //
        //     await Future.delayed(const Duration(seconds: 1));
        //
        //     if (!context.mounted) return;
        //
        //     Navigator.of(context, rootNavigator: true).pop();
        //
        //     await ref
        //         .read(localUserControllerProvider.notifier)
        //         .saveStage(OnboardingStage.welcome);
        //   },
        //
        //   child: Column(
        //     children: [
        //       RoleCard(
        //         selectedValue: selectedRole,
        //         onTap:
        //             () =>
        //                 ref.read(userRoleProvider.notifier).state =
        //                     UserRole.buyer,
        //         title: 'Buyer',
        //         description:
        //             'Browse nearby stores, order what you need, and get it delivered or pick it up yourself.',
        //         icon: AppAssets.icons.buyerIcon.path,
        //         value: UserRole.buyer,
        //         backgroundColor: AppColors.buyerCardColor,
        //         radioColor: AppColors.primaryDarkGreen,
        //         iconHeight: iconHeight,
        //         iconWidth: iconWidth,
        //         descriptionTextSize: descriptionTextSize,
        //         titleTextSize: titleTextSize,
        //       ),
        //       SizedBox(height: sizedBoxHeight2),
        //       RoleCard(
        //         selectedValue: selectedRole,
        //         onTap:
        //             () =>
        //                 ref.read(userRoleProvider.notifier).state =
        //                     UserRole.seller,
        //         title: 'Seller',
        //         description:
        //             'Own a shop or run a business? List your products and start selling to nearby students.',
        //         icon: AppAssets.icons.sellerIcon.path,
        //         value: UserRole.seller,
        //         backgroundColor: AppColors.sellerCardColor,
        //         radioColor: AppColors.radioOrange,
        //         iconHeight: iconHeight,
        //         iconWidth: iconWidth,
        //         descriptionTextSize: descriptionTextSize,
        //         titleTextSize: titleTextSize,
        //       ),
        //       SizedBox(height: sizedBoxHeight2),
        //       RoleCard(
        //         selectedValue: selectedRole,
        //         onTap:
        //             () =>
        //                 ref.read(userRoleProvider.notifier).state =
        //                     UserRole.dispatch,
        //         title: 'Delivery Agent',
        //         description:
        //             'Earn money delivering orders around campus. No experience needed!',
        //         value: UserRole.dispatch,
        //         icon: AppAssets.icons.riderIcon.path,
        //         backgroundColor: AppColors.riderCardColor,
        //         radioColor: AppColors.radioBlue,
        //         iconHeight: iconHeight,
        //         iconWidth: iconWidth,
        //         descriptionTextSize: descriptionTextSize,
        //         titleTextSize: titleTextSize,
        //       ),
        //     ],
        //   ),
        // ),
        RoleCard(
          title: 'Buyer',
          description:
              'Browse nearby stores, order what you need, and get it delivered or pick it up yourself.',
          icon: AppAssets.icons.buyerIcon.path,
          isSelected: selectedRole == UserRole.buyer,
          onTap: () async {
            showLoadingDialog(context);

            await Future.delayed(const Duration(seconds: 1));

            if (!context.mounted) return;

            Navigator.of(context, rootNavigator: true).pop();

            await ref
                .read(localUserControllerProvider.notifier)
                .saveRole(UserRole.seller.name);

            await ref
                .read(localUserControllerProvider.notifier)
                .saveStage(OnboardingStage.welcome);
          },
          backgroundColor: AppColors.buyerCardColor,
          radioColor: AppColors.primaryDarkGreen,
          iconHeight: iconHeight,
          iconWidth: iconWidth,
          descriptionTextSize: descriptionTextSize,
          titleTextSize: titleTextSize,
        ),
        SizedBox(height: sizedBoxHeight2),
        RoleCard(
          title: 'Seller',
          description:
              'Own a shop or run a business? List your products and start selling to nearby students.',
          icon: AppAssets.icons.sellerIcon.path,
          isSelected: selectedRole == UserRole.seller,
          onTap: () async {
            showLoadingDialog(context);

            await Future.delayed(const Duration(seconds: 1));

            if (!context.mounted) return;

            Navigator.of(context, rootNavigator: true).pop();

            await ref
                .read(localUserControllerProvider.notifier)
                .saveRole(UserRole.seller.name);

            await ref
                .read(localUserControllerProvider.notifier)
                .saveStage(OnboardingStage.welcome);
          },
          // onTap: () {
          //   ref
          //       .read(localUserControllerProvider.notifier)
          //       .saveRole(UserRole.seller.name);
          //   ref
          //       .read(localUserControllerProvider.notifier)
          //       .saveStage(OnboardingStage.welcome);
          //   // viewModel.selectRole(UserRole.seller);
          //   viewModel.confirmSelection(context);
          // },
          backgroundColor: AppColors.sellerCardColor,
          radioColor: AppColors.radioOrange,
          iconHeight: iconHeight,
          iconWidth: iconWidth,
          descriptionTextSize: descriptionTextSize,
          titleTextSize: titleTextSize,
        ),
        SizedBox(height: sizedBoxHeight2),
        RoleCard(
          title: 'Delivery Agent',
          description:
              'Earn money delivering orders around campus. No experience needed!',
          icon: AppAssets.icons.riderIcon.path,
          isSelected: selectedRole == UserRole.dispatch,
          onTap: () async {
            showLoadingDialog(context);

            await Future.delayed(const Duration(seconds: 1));

            if (!context.mounted) return;

            Navigator.of(context, rootNavigator: true).pop();

            await ref
                .read(localUserControllerProvider.notifier)
                .saveRole(UserRole.dispatch.name);

            await ref
                .read(localUserControllerProvider.notifier)
                .saveStage(OnboardingStage.welcome);
          },
          backgroundColor: AppColors.riderCardColor,
          radioColor: AppColors.radioBlue,
          iconHeight: iconHeight,
          iconWidth: iconWidth,
          descriptionTextSize: descriptionTextSize,
          titleTextSize: titleTextSize,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
