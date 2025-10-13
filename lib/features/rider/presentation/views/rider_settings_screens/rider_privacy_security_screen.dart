import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';

class PrivacyAndSecurityScreen extends StatelessWidget {
  const PrivacyAndSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    final privacySection = _PrivacySection(showSaveInside: isWeb);
    final deleteAccountSection = const _DeleteAccountSection();

    return Scaffold(
      backgroundColor:
          isWeb ? AppColors.backgroundLight : AppColors.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
        child:
            isWeb
                ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 232,
                        child: Card(
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
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        height: 176,
                        child: Card(
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
                    CustomButton(
                      text: 'Save',
                      onPressed: () {},
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 45,
                      width: double.infinity,
                    ),
                  ],
                ),
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  final bool showSaveInside;

  const _PrivacySection({required this.showSaveInside});

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
                if (showSaveInside) ...[
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Save',
                    onPressed: () {},
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 41,
                    width: 153,
                  ),
                ],
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

class _DeleteAccountSection extends StatelessWidget {
  const _DeleteAccountSection();

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
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
                    trailing:
                        isWeb
                            ? CustomButton(
                              text: 'Delete',
                              onPressed: () {},
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
                      onPressed: () {},
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
}
