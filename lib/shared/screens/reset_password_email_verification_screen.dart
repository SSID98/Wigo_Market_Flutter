import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wigo_flutter/shared/viewmodels/reset_password_viewmodel.dart';
import 'package:wigo_flutter/shared/widgets/bottom_text.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/url.dart';
import '../../core/utils/context_extensions.dart';
import '../../core/utils/helper_methods_classes.dart';
import '../../gen/assets.gen.dart';
import '../models/reset_password_state.dart';
import '../widgets/verification_widget.dart';

class ResetPasswordEmailVerificationScreen extends ConsumerWidget {
  const ResetPasswordEmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resetPasswordVerificationProvider);
    final vm = ref.read(resetPasswordVerificationProvider.notifier);
    final String displayEmail = state.email.isEmpty
        ? 'chu******osy@gmail.com'
        : state.email;
    final String maskedEmail = MaskedEmail.maskEmail(displayEmail);
    final screenSize = MediaQuery.of(context).size;

    return context.isWeb
        ? _buildWebLayout(screenSize, maskedEmail)
        : _buildMobileLayout(screenSize, maskedEmail, context, vm, ref, state);
  }

  Widget _buildMobileLayout(
    Size screenSize,
    String maskedEmail,
    BuildContext context,
    ResetPasswordViewmodel vm,
    WidgetRef ref,
    ResetPasswordState state,
  ) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            '$networkImageUrl/login.png',
            fit: BoxFit.cover,
            errorBuilder:
                (
                  BuildContext context,
                  Object exception,
                  StackTrace? stackTrace,
                ) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: AppColors.textIconGrey,
                      size: 50.0,
                    ),
                  );
                },
          ),
          BottomTextBuilder.buildMobileBottomText(),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: screenSize.width * 0.95,
                constraints: BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: SvgPicture.asset(
                          AppAssets.icons.logo.path,
                          height: 49,
                          width: 143.86,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      VerificationWidgetBuilder.buildMobileBody(
                        hasError: state.codeError != null,
                        errorMessage: state.codeError,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(6),
                        ],
                        email: maskedEmail,
                        onChanged: vm.updateCode,
                        bodyText:
                            'Please enter the 6- digit OTP sent to your email at ${state.email} to reset your password',
                        onPressed: () {
                          vm.verifyToken(context: context);
                        },
                      ),
                      const SizedBox(height: 33),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebLayout(Size screenSize, String maskedEmail) {
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
                          image: NetworkImage('$networkImageUrl/login.png'),
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
                              child: BottomTextBuilder.buildWebBottomText(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
                      SizedBox(height: 30),
                      Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 500,
                            maxHeight: screenSize.height * 0.70,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundWhite,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                VerificationWidgetBuilder.buildWebBody(
                                  email: maskedEmail,
                                ),
                              ],
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
}
