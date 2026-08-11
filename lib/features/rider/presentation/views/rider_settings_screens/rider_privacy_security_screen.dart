import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../viewmodels/rider_privacy_security_viewmodel.dart';

class PrivacyAndSecurityScreen extends StatelessWidget {
  const PrivacyAndSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    final privacySection = _PrivacySection();
    final deleteAccountSection = const _DeleteAccountSection();

    return Scaffold(
      backgroundColor: isWeb
          ? AppColors.backgroundLight
          : AppColors.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
        child: isWeb
            ? Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      margin: EdgeInsets.only(bottom: 20, top: 20),
                      shadowColor: Colors.white70.withValues(alpha: 0.06),
                      color: AppColors.backgroundWhite,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: privacySection,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Card(
                      margin: EdgeInsets.only(bottom: 150, top: 20),
                      shadowColor: Colors.white70.withValues(alpha: 0.06),
                      color: AppColors.backgroundWhite,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: deleteAccountSection,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 50),
                    child: Row(
                      children: [
                        GestureDetector(
                          child: AppAssets.icons.arrowLeft.svg(),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Back",
                          style: GoogleFonts.hind(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textBlackGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 30),
                  privacySection,
                  const SizedBox(height: 60),
                  deleteAccountSection,
                ],
              ),
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  const _PrivacySection();

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Privacy & Security",
                  style: GoogleFonts.hind(
                    fontSize: isWeb ? 24 : 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlackGrey,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: isWeb ? 16.0 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Data & Privacy",
                  style: GoogleFonts.hind(
                    fontSize: isWeb ? 18 : 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Manage your data and privacy preferences",
                  style: GoogleFonts.hind(
                    fontSize: isWeb ? 16 : 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textBodyText,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Privacy Policy",
                  style: GoogleFonts.hind(
                    fontSize: isWeb ? 16 : 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDeliveryFee,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Terms of Service",
                  style: GoogleFonts.hind(
                    fontSize: isWeb ? 16 : 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDeliveryFee,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteAccountSection extends ConsumerWidget {
  const _DeleteAccountSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = context.isWeb;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Delete Account",
              style: GoogleFonts.hind(
                fontSize: isWeb ? 24 : 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackGrey,
              ),
            ),
            SizedBox(height: isWeb ? 20 : 0),
            Padding(
              padding: EdgeInsets.only(left: isWeb ? 16 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      "Delete Account",
                      style: GoogleFonts.hind(
                        fontSize: isWeb ? 18 : 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(
                        right: isWeb ? 0 : 60.0,
                        top: isWeb ? 0 : 4,
                      ),
                      child: Text(
                        "Once you delete your account, there is no going back. Please be certain.",
                        style: GoogleFonts.hind(
                          fontSize: isWeb ? 16 : 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textBlackGrey,
                        ),
                      ),
                    ),
                    trailing: isWeb
                        ? CustomButton(
                            text: 'Delete',
                            onPressed: () =>
                                _showDeleteConfirmationDialog(context, ref),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 41,
                            width: 102,
                            textColor: AppColors.accentRed,
                            buttonColor: AppColors.accentRed.withValues(
                              alpha: 0.15,
                            ),
                          )
                        : null,
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (!isWeb)
                    CustomButton(
                      text: 'Delete',
                      onPressed: () =>
                          _showDeleteConfirmationDialog(context, ref),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 33,
                      width: 102,
                      textColor: AppColors.accentRed,
                      buttonColor: AppColors.accentRed.withValues(alpha: 0.15),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final vm = ref.read(riderPrivacySecurityProvider.notifier);
    final isWeb = context.isWeb;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.backgroundWhite,
          titlePadding: EdgeInsets.zero,
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Final Confirmation",
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: isWeb ? 25 : 19,
                    color: AppColors.textBlack,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.only(right: isWeb ? 0 : 25),
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Are you sure you want to delete your account? This action cannot be undone.",
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w600,
                  fontSize: isWeb ? 20 : 14,
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    fontSize: isWeb ? 18 : 12,
                    height: isWeb ? 48 : 40,
                    fontWeight: FontWeight.w500,
                    buttonColor: AppColors.buttonLighterGreen,
                    textColor: AppColors.textBlackGrey,
                    padding: EdgeInsets.zero,
                  ),
                  CustomButton(
                    text: 'Confirm',
                    onPressed: () => vm.deleteRiderAccount(dialogContext, ref),
                    fontSize: isWeb ? 18 : 12,
                    height: isWeb ? 48 : 40,
                    fontWeight: FontWeight.w500,
                    buttonColor: AppColors.accentRed,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
