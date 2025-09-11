import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/role_selection_body.dart';

import '../../core/constants/app_colors.dart';
import '../../gen/assets.gen.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb
        ? _buildWebLayout(context, screenSize)
        : _buildMobileLayout(context, screenSize);
  }

  //Mobile Layout
  Widget _buildMobileLayout(BuildContext context, Size screenSize) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            AppAssets.images.login.image(fit: BoxFit.cover),
            Center(
              child: Container(
                width: screenSize.width * 0.95,
                constraints: BoxConstraints(
                  maxWidth: 400,
                  maxHeight: screenSize.height * 0.8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.icons.logo.path,
                        height: 49,
                        width: 143.86,
                      ),
                      const SizedBox(height: 30),
                      RoleSelectionBody(
                        titleTextSize: 14,
                        descriptionTextSize: 10,
                        textFontSize: 16,
                        sizedBoxHeight1: 10,
                        iconWidth: 44,
                        iconHeight: 44,
                        padding: 35.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomText(17),
          ],
        ),
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context, Size screenSize) {
    final double webContentWidth = screenSize.width * 0.34;
    final double webContentHeight = screenSize.height * 0.95;
    final double imageBorderRadius = 15.0;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 100.0,
          ),
          child: Row(
            children: [
              // Left section: Image and Bottom Text
              Expanded(
                child: Container(
                  color: AppColors.backgroundLight,
                  child: Center(
                    child: Container(
                      width: webContentWidth,
                      height: webContentHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(imageBorderRadius),
                        image: DecorationImage(
                          image: AssetImage(AppAssets.images.login.path),
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
                              child: _buildBottomText(24),
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
                        AppAssets.icons.logo.path,
                        height: 78,
                        width: 229.86,
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
                              maxWidth: 525,
                              maxHeight: screenSize.height * 0.70,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: SingleChildScrollView(
                                child: RoleSelectionBody(
                                  titleTextSize: 22,
                                  descriptionTextSize: 14,
                                  textFontSize: 20,
                                  sizedBoxHeight1: 35,
                                  iconWidth: 72,
                                  iconHeight: 72,
                                  padding: 0.0,
                                  sizedBoxHeight2: 10.0,
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
