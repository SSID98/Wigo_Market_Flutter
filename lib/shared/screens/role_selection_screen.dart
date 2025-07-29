import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../features/role_selection/viewmodel/role_selection_provider.dart';
import '../models/user_role.dart';
import '../widgets/role_card.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRole = ref.watch(selectedRoleProvider);
    final Size screenSize = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileLayout(context, ref, selectedRole, screenSize);
        } else {
          return _buildWebLayout(context, ref, selectedRole, screenSize);
        }
      },
    );
  }

  //Mobile Layout
  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    UserRole? selectedRole,
    Size screenSize,
  ) {
    void onRoleSelected(UserRole role) {
      ref.read(selectedRoleProvider.notifier).state = role;
    }

    return Scaffold(
      // appBar: AppBar(toolbarHeight: 5),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/login.png', fit: BoxFit.cover),
          Center(
            child: Container(
              width: screenSize.width * 0.95,
              constraints: BoxConstraints(
                maxWidth: 400,
                maxHeight: screenSize.height * 0.8,
              ),
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/logo.svg',
                      height: 49,
                      width: 143.86,
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 35.0,
                          ),
                          child: Text(
                            'How do you want to use the platform? Choose a role to continue.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.hind(
                              textStyle: TextStyle(
                                color: AppColors.textBlackLight,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        RoleCard(
                          title: 'Buyer',
                          description:
                              'Browse nearby stores, order what you need, and get it delivered or pick it up yourself.',
                          icon: 'assets/icons/buyerIcon.svg',
                          isSelected: selectedRole == UserRole.buyer,
                          onTap: () => onRoleSelected(UserRole.buyer),
                          backgroundColor: AppColors.buyerCardColor,
                          radioColor: AppColors.primaryDarkGreen,
                          iconHeight: 44.0,
                          iconWidth: 44.0,
                          descriptionTextSize: 10,
                          titleTextSize: 14,
                        ),
                        RoleCard(
                          title: 'Seller',
                          description:
                              'Own a shop or run a business? List your products and start selling to nearby students.',
                          icon: 'assets/icons/sellerIcon.svg',
                          isSelected: selectedRole == UserRole.seller,
                          onTap: () => onRoleSelected(UserRole.seller),
                          backgroundColor: AppColors.sellerCardColor,
                          radioColor: AppColors.radioOrange,
                          iconHeight: 44.0,
                          iconWidth: 44.0,
                          descriptionTextSize: 10,
                          titleTextSize: 14,
                        ),
                        RoleCard(
                          title: 'Delivery Agent',
                          description:
                              'Earn money delivering orders around campus. No experience needed!',
                          icon: 'assets/icons/riderIcon.svg',
                          isSelected: selectedRole == UserRole.rider,
                          onTap: () => onRoleSelected(UserRole.rider),
                          backgroundColor: AppColors.riderCardColor,
                          radioColor: AppColors.radioBlue,
                          iconHeight: 44.0,
                          iconWidth: 44.0,
                          descriptionTextSize: 10,
                          titleTextSize: 14,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomText(17),
        ],
      ),
    );
  }

  Widget _buildWebLayout(
    BuildContext context,
    WidgetRef ref,
    UserRole? selectedRole,
    Size screenSize,
  ) {
    final double webContentWidth = screenSize.width * 0.34;
    final double webContentHeight = screenSize.height * 0.95;
    final double imageBorderRadius = 15.0;

    void onRoleSelected(UserRole role) {
      ref.read(selectedRoleProvider.notifier).state = role;
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 100.0),
        child: Row(
          children: [
            // Left section: Image and Bottom Text
            Expanded(
              child: Container(
                color: AppColors.backgroundWhite,
                child: Center(
                  child: Container(
                    width: webContentWidth,
                    height: webContentHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(imageBorderRadius),
                      image: DecorationImage(
                        image: AssetImage('assets/images/login.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              imageBorderRadius,
                            ),
                            child: _buildBottomText(25),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Right form section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/logo.svg',
                      height: 59,
                      width: 153.86,
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 480,
                            maxHeight: screenSize.height * 0.80,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundWhite,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    'How do you want to use the platform? Choose a role to continue.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.hind(
                                      textStyle: TextStyle(
                                        color: AppColors.textBlackLight,
                                        fontSize: 21.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 35),
                                  RoleCard(
                                    title: 'Buyer',
                                    description:
                                        'Browse nearby stores, order what you need, and get it delivered or pick it up yourself.',
                                    icon: 'assets/icons/buyerIcon.svg',
                                    isSelected: selectedRole == UserRole.buyer,
                                    onTap: () => onRoleSelected(UserRole.buyer),
                                    backgroundColor: AppColors.buyerCardColor,
                                    radioColor: AppColors.primaryDarkGreen,
                                    iconHeight: 70.0,
                                    iconWidth: 70.0,
                                    descriptionTextSize: 14,
                                    titleTextSize: 19,
                                  ),
                                  SizedBox(height: 10),
                                  RoleCard(
                                    title: 'Seller',
                                    description:
                                        'Own a shop or run a business? List your products and start selling to nearby students.',
                                    icon: 'assets/icons/sellerIcon.svg',
                                    isSelected: selectedRole == UserRole.seller,
                                    onTap:
                                        () => onRoleSelected(UserRole.seller),
                                    backgroundColor: AppColors.sellerCardColor,
                                    radioColor: AppColors.radioOrange,
                                    iconHeight: 70.0,
                                    iconWidth: 70.0,
                                    descriptionTextSize: 14,
                                    titleTextSize: 19,
                                  ),
                                  SizedBox(height: 10),
                                  RoleCard(
                                    title: 'Delivery Agent',
                                    description:
                                        'Earn money delivering orders around campus. No experience needed!',
                                    icon: 'assets/icons/riderIcon.svg',
                                    isSelected: selectedRole == UserRole.rider,
                                    onTap: () => onRoleSelected(UserRole.rider),
                                    backgroundColor: AppColors.riderCardColor,
                                    radioColor: AppColors.radioBlue,
                                    iconHeight: 70.0,
                                    iconWidth: 70.0,
                                    descriptionTextSize: 14,
                                    titleTextSize: 19,
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom text gradient overlay
  Widget _buildBottomText(double textSize) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        // ClipRect to ensure blur doesn't go beyond boundaries
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 15.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Colors.black.withValues(alpha: 0.1),
                // Start with more transparent black
                Colors.black.withValues(alpha: 0.8),
                // End with more opaque black
              ],
              stops: const [0.0, 1.0],
            ),
          ),
          child: Text(
            'WIGOMARKET connects students, sellers, and local businesses—shop, earn, and grow on one seamless platform.',
            textAlign: TextAlign.left,
            style: GoogleFonts.hind(
              textStyle: TextStyle(
                color: AppColors.textWhite,
                fontSize: textSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
