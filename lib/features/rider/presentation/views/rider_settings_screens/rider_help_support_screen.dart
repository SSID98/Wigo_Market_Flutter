import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    final notificationBody = _HelpAndSupportSection();
    final appInfo = _AppInfoSection();

    return Scaffold(
      backgroundColor:
          isWeb ? AppColors.backgroundLight : AppColors.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
        child:
            isWeb
                ? Column(
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
                        child: notificationBody,
                      ),
                    ),
                    const SizedBox(width: 16),
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
                        child: appInfo,
                      ),
                    ),
                  ],
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
                    notificationBody,
                    appInfo,
                    const SizedBox(height: 15),
                  ],
                ),
      ),
    );
  }
}

class _HelpAndSupportSection extends StatelessWidget {
  const _HelpAndSupportSection();

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    final List<String> supports = ["Phone Support", "Email Support"];

    final Map<String, String> subTitle = {
      "Phone Support": '+1 (555) 123-HELP',
      "Email Support": 'support@rideflow.com',
    };

    final Map<String, String> icon = {
      "Phone Support": AppAssets.icons.deliveryContact.path,
      "Email Support": AppAssets.icons.blueMailContainer.path,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Help & Support",
          style: GoogleFonts.hind(
            fontSize: isWeb ? 24 : 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 200,
          child: ListView.builder(
            padding: EdgeInsets.only(top: 10),
            itemCount: supports.length,
            itemBuilder: (_, i) {
              final String title = supports[i];
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: isWeb ? 900 : 0),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          supports[i],
                          style: GoogleFonts.hind(
                            fontSize: isWeb ? 18 : 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBlackGrey,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        subTitle[title]!,
                        style: GoogleFonts.hind(
                          fontSize: isWeb ? 16 : 12,
                          fontWeight: FontWeight.w400,
                          color:
                              isWeb
                                  ? AppColors.textBlackGrey
                                  : AppColors.textBodyText,
                        ),
                      ),
                      trailing: SvgPicture.asset(icon[title]!),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AppInfoSection extends StatelessWidget {
  const _AppInfoSection();

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "App Information",
          style: GoogleFonts.hind(
            fontSize: isWeb ? 24 : 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 10),
        _buildAppInfoRow(isWeb, 'App Version', '1.0', 150),
        const SizedBox(height: 15),
        _buildAppInfoRow(isWeb, 'Last Updated', 'March 15, 2024', 60),
      ],
    );
  }

  Widget _buildAppInfoRow(
    bool isWeb,
    String title,
    String description,
    double width,
  ) {
    return Row(
      mainAxisAlignment:
          isWeb ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.hind(
            fontSize: isWeb ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlackGrey,
          ),
        ),
        if (isWeb) SizedBox(width: width),
        Text(
          description,
          style: GoogleFonts.hind(
            fontSize: isWeb ? 16 : 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textBodyText,
          ),
        ),
      ],
    );
  }
}
