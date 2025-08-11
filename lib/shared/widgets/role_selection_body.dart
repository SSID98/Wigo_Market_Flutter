import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/widgets/role_card.dart';

import '../models/user_role.dart';
import '../viewmodel/role_selection/role_selection_provider.dart';
import '../viewmodel/role_selection/role_selection_view_model.dart';

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
    final viewModel = ref.watch(roleSelectionViewModelProvider);
    final selectedRole = ref.watch(selectedRoleProvider);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Text(
            'How do you want to use the platform? Choose a role to continue.',
            textAlign: TextAlign.center,
            style: GoogleFonts.hind(
              textStyle: TextStyle(
                color: AppColors.textBlackLight,
                fontSize: textFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: sizedBoxHeight1),
        RoleCard(
          title: 'Buyer',
          description:
              'Browse nearby stores, order what you need, and get it delivered or pick it up yourself.',
          icon: 'assets/icons/buyerIcon.svg',
          isSelected: selectedRole == UserRole.buyer,
          onTap: () {
            viewModel.selectRole(UserRole.buyer);
            viewModel.confirmSelection(context);
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
          icon: 'assets/icons/sellerIcon.svg',
          isSelected: selectedRole == UserRole.seller,
          onTap: () {
            viewModel.selectRole(UserRole.seller);
            viewModel.confirmSelection(context);
          },
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
          icon: 'assets/icons/riderIcon.svg',
          isSelected: selectedRole == UserRole.rider,
          onTap: () {
            viewModel.selectRole(UserRole.rider);
            viewModel.confirmSelection(context);
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
