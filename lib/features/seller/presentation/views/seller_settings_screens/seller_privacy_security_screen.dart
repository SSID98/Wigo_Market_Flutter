import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/context_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../widgets/text_column.dart';

final isEmailEditProvider = StateProvider<bool>((ref) => false);

final isPasswordEditProvider = StateProvider<bool>((ref) => false);

class SellerPrivacyAndSecurityScreen extends ConsumerWidget {
  const SellerPrivacyAndSecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: context.isWeb
          ? null
          : AppBar(
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: AppAssets.icons.backCircleArrow.svg(),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: context.width * 0.24),
                      Text(
                        "Security",
                        style: GoogleFonts.hind(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlackGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              surfaceTintColor: Colors.transparent,
              backgroundColor: AppColors.backgroundWhite,
              automaticallyImplyLeading: false,
            ),
      backgroundColor: context.isWeb
          ? AppColors.backgroundLight
          : AppColors.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: context.isWeb
            ? Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    margin: EdgeInsets.only(bottom: 20, top: 20),
                    shadowColor: Colors.white70.withValues(alpha: 0.06),
                    color: AppColors.backgroundWhite,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            "Privacy & Security",
                            style: GoogleFonts.hind(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textBlackGrey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Manage how you log in, secure your account, and control access to your WiGo Market seller profile.",
                            style: GoogleFonts.hind(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textBlackGrey,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 20),
                          Card(
                            elevation: 0,
                            color: AppColors.backgroundWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: AppColors.borderColor),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  _buildLoginDetailsCard(context.isWeb, ref),
                                  const SizedBox(height: 15),
                                  _buildPrivacyPrefsCard(context.isWeb),
                                  const SizedBox(height: 15),
                                  _deleteAccountCard(context.isWeb),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        _buildLoginDetailsCard(context.isWeb, ref),
                        const SizedBox(height: 15),
                        _buildPrivacyPrefsCard(context.isWeb),
                        const SizedBox(height: 15),
                        _deleteAccountCard(context.isWeb),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLoginDetailsCard(bool isWeb, WidgetRef ref) {
    final isEmailEditMode = ref.watch(isEmailEditProvider);
    final isPasswordEditMode = ref.watch(isPasswordEditProvider);
    return Card(
      elevation: 0,
      color: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Login Details",
              style: GoogleFonts.hind(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textVidaGreen800,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomTextField(
                    enabled: isEmailEditMode,
                    hintText: 'johndoe112@gmail.com',
                    label: 'Email address',
                    labelFontSize: 16,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    spacing: 0,
                    border: InputBorder.none,
                  ),
                ),
                _buildCustomButton(
                  text: !isEmailEditMode ? "Change Email" : "Update Email",
                  onPressed: !isEmailEditMode
                      ? () => ref.read(isEmailEditProvider.notifier).state =
                            !isEmailEditMode
                      : () {
                          ref.read(isEmailEditProvider.notifier).state = false;
                        },
                  isWeb: isWeb,
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    enabled: isPasswordEditMode,
                    hintText: '●●●●●●●●●●●●●●',
                    label: 'Password',
                    isPassword: true,
                    suffixIcon: isPasswordEditMode
                        ? Icon(Icons.visibility)
                        : null,
                    labelFontSize: 16,
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    suffixIconPadding: 50,
                    border: InputBorder.none,
                  ),
                ),
                _buildCustomButton(
                  text: !isPasswordEditMode
                      ? "Reset Password"
                      : "Update Password",
                  onPressed: !isPasswordEditMode
                      ? () => ref.read(isPasswordEditProvider.notifier).state =
                            !isPasswordEditMode
                      : () {
                          ref.read(isPasswordEditProvider.notifier).state =
                              false;
                        },
                  isWeb: isWeb,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyPrefsCard(isWeb) {
    return Card(
      elevation: 0,
      color: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Preferences",
              style: GoogleFonts.hind(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: kIsWasm ? 0 : 8.0),
              child: Text(
                "Manage how you log in, secure your account, and control access to your WiGo Market seller profile.",
                style: GoogleFonts.hind(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textBlackGrey,
                ),
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {},
              child: Text(
                "Terms of Service",
                style: GoogleFonts.hind(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textVidaLocaGreen,
                ),
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {},
              child: Text(
                "Privacy Policy",
                style: GoogleFonts.hind(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textVidaLocaGreen,
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _deleteAccountCard(bool isWeb) {
    return Card(
      elevation: 0,
      color: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: buildTextColumn(
                    title: "Delete Account",
                    titleFontSize: 18,
                    subtitle1:
                        "Once you delete your account, there is no going back. Please be certain.",
                    subtitleFontWeight: FontWeight.w400,
                    subtitleFontSize: isWeb ? 16 : 15,
                  ),
                ),
                const SizedBox(width: 15),
                _buildCustomButton(
                  text: "Delete",
                  onPressed: () {},
                  isWeb: isWeb,
                  isDeleteAccount: true,
                ),
              ],
            ),
            Divider(),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Log out of this device",
                  style: GoogleFonts.hind(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                _buildCustomButton(
                  text: "Log out",
                  onPressed: () {},
                  isWeb: isWeb,
                  isDeleteAccount: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomButton({
    required String text,
    required void Function()? onPressed,
    required bool isWeb,
    bool isDeleteAccount = false,
  }) {
    return CustomButton(
      text: text,
      fontSize: isDeleteAccount ? 16 : 14,
      fontWeight: isDeleteAccount ? FontWeight.w600 : FontWeight.w500,
      onPressed: onPressed,
      height: isDeleteAccount ? 41 : 40,
      padding: EdgeInsets.zero,
      width: isDeleteAccount
          ? isWeb
                ? 120
                : 84
          : isWeb
          ? 130
          : 120,
      borderRadius: isDeleteAccount ? 6 : 4,
      buttonColor: isDeleteAccount
          ? AppColors.accentRed.withValues(alpha: 0.1)
          : AppColors.textVidaLocaGreen,
      textColor: isDeleteAccount ? AppColors.accentRed : AppColors.textWhite,
    );
  }
}
