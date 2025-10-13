import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_settings_screens/profile_account_screen.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_settings_screens/rider_notification_screen.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_settings_screens/rider_privacy_security_screen.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_settings_screens/vehicle_documents_screen.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../viewmodels/rider_settings_navg_viewmodel.dart';

class RiderSettingsMainScreen extends ConsumerWidget {
  const RiderSettingsMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(settingsNavigationProvider);
    final navNotifier = ref.read(settingsNavigationProvider.notifier);

    final isWeb = MediaQuery.of(context).size.width > 800;

    final List<String> settings = [
      "Profile & Account",
      "Vehicle & Documents",
      "Notifications",
      "Privacy & Security",
      "Help & Others",
    ];

    final Map<String, String> settingsIcons = {
      "Profile & Account": AppAssets.icons.user2.path,
      "Vehicle & Documents": AppAssets.icons.fileValidation.path,
      "Notifications": AppAssets.icons.settingsNotify.path,
      "Privacy & Security": AppAssets.icons.privacy.path,
      "Help & Others": AppAssets.icons.customerService.path,
    };

    final Map<String, String> settingSubTitle = {
      "Profile & Account":
          'Manage your personal information and account details',
      "Vehicle & Documents":
          'Update vehicle information and other related documents',
      "Notifications": 'Control how you receive updates and alerts',
      "Privacy & Security": 'Manage your Privacy and security settings',
      "Help & Others": 'Get Help and Contact Support. We’re here to help.',
    };

    return Scaffold(
      backgroundColor:
          isWeb ? AppColors.backgroundLight : AppColors.backgroundWhite,
      body:
          isWeb
              ? Row(
                children: [
                  SizedBox(
                    width: 371,
                    child: Card(
                      margin: EdgeInsets.only(
                        bottom: isWeb ? 150 : 250,
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
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
                                      tileColor:
                                          navState.selectedIndex == i
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
                  Expanded(
                    child:
                        navState.selectedIndex == null
                            ? const Center(child: Text("Select a setting"))
                            : _buildDetailScreen(navState.selectedIndex!),
                  ),
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
        return const ProfileAndAccountScreen();
      case 1:
        return const VehicleAndDocumentsScreen();
      case 2:
        return const NotificationScreen();
      case 3:
        return const PrivacyAndSecurityScreen();
      default:
        return const Center(child: Text("Coming soon..."));
    }
  }
}
