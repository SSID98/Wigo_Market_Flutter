import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/presentation/views/seller_settings_screens/profile_account_screens/seller_profile_account_main_screen.dart';
import 'package:wigo_flutter/features/seller/presentation/views/seller_settings_screens/seller_help_support_screens/seller_help_support_main_screen.dart';
import 'package:wigo_flutter/features/seller/presentation/views/seller_settings_screens/seller_notification_screen.dart';
import 'package:wigo_flutter/features/seller/presentation/views/seller_settings_screens/seller_privacy_security_screen.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/context_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/viewmodels/settings_navg_viewmodel.dart';

class SellerSettingsMainScreen extends ConsumerWidget {
  const SellerSettingsMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(settingsNavigationProvider);
    final navNotifier = ref.read(settingsNavigationProvider.notifier);

    final List<String> settings = [
      "Profile & Account",
      "Notifications",
      "Privacy & Security",
      "Help & Support",
    ];

    final Map<String, String> settingsIcons = {
      "Profile & Account": AppAssets.icons.user2.path,
      "Notifications": AppAssets.icons.settingsNotify.path,
      "Privacy & Security": AppAssets.icons.privacy.path,
      "Help & Support": AppAssets.icons.customerService.path,
    };

    final Map<String, String> settingSubTitle = {
      "Profile & Account":
          'Manage your personal information and Shop account details',
      "Notifications": 'Control how you receive updates and alerts',
      "Privacy & Security": 'Manage your Privacy and Security settings',
      "Help & Support": 'Get Help and Contact Support. We’re here to help.',
    };

    return Scaffold(
      backgroundColor: context.isWeb
          ? AppColors.backgroundLight
          : AppColors.backgroundWhite,
      body: context.isWeb
          ? Row(
              children: [
                SizedBox(
                  width: 371,
                  child: Card(
                    margin: EdgeInsets.only(
                      bottom: context.isWeb ? 150 : 250,
                      left: 20,
                      top: 20,
                    ),
                    shadowColor: Colors.white70.withValues(alpha: 0.06),
                    color: AppColors.backgroundWhite,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            30.0,
                            15.0,
                            30,
                            5.0,
                          ),
                          child: Text(
                            "Settings",
                            style: GoogleFonts.hind(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBlackGrey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Text(
                            "Manage your account and preferences",
                            style: GoogleFonts.hind(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textBlackGrey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: settings.length,
                            itemBuilder: (_, i) {
                              final String settingTitle = settings[i];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Row(
                                      children: [
                                        SvgPicture.asset(
                                          settingsIcons[settingTitle]!,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          settings[i],
                                          style: GoogleFonts.hind(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textBlackGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 35.0,
                                      ),
                                      child: Text(
                                        settingSubTitle[settingTitle]!,
                                        style: GoogleFonts.hind(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.textBlackGrey,
                                        ),
                                      ),
                                    ),
                                    tileColor: navState.selectedIndex == i
                                        ? AppColors.tableHeader
                                        : null,
                                    onTap: () => navNotifier.updateIndex(i),
                                  ),
                                  const SizedBox(height: 35),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Right detail panel
                Expanded(child: _buildDetailScreen(navState.selectedIndex!)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 80, 30, 5),
                  child: Text(
                    "Settings",
                    style: GoogleFonts.hind(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    "Manage your account and preferences",
                    style: GoogleFonts.hind(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: settings.length,
                    itemBuilder: (_, i) {
                      final String settingTitle = settings[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  SvgPicture.asset(
                                    settingsIcons[settingTitle]!,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    settings[i],
                                    style: GoogleFonts.hind(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textBlackGrey,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(left: 35.0),
                                child: Text(
                                  settingSubTitle[settingTitle]!,
                                  style: GoogleFonts.hind(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textBlackGrey,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => _buildDetailScreen(i),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDetailScreen(int index) {
    switch (index) {
      case 0:
        return const SellerProfileAccountMainScreen();
      case 1:
        return const SellerNotificationScreen();
      case 2:
        return const SellerPrivacyAndSecurityScreen();
      case 3:
        return const SellerHelpAndSupportMainScreen();
      default:
        return const SellerProfileAccountMainScreen();
    }
  }
}
