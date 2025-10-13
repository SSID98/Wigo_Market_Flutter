import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/rider/viewmodels/rider_notification_viewmodel.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../widgets/switch.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    final notificationBody = _NotificationBody(showSaveInside: isWeb);

    return Scaffold(
      backgroundColor:
          isWeb ? AppColors.backgroundLight : AppColors.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
        child:
            isWeb
                ? SizedBox(
                  height: 393,
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
                      child: notificationBody,
                    ),
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
                    notificationBody,
                    CustomButton(
                      text: 'Save',
                      onPressed: () {},
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 45,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
      ),
    );
  }
}

class _NotificationBody extends ConsumerWidget {
  final bool showSaveInside;

  const _NotificationBody({required this.showSaveInside});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(riderNotificationViewModelProvider.notifier);
    final state = ref.watch(riderNotificationViewModelProvider);

    final isWeb = MediaQuery.of(context).size.width > 800;

    final List<String> settings = [
      "Push Notification",
      "Promotional Notifications",
      "Email Notifications",
    ];

    final Map<String, String> settingSubTitle = {
      "Push Notification":
          'Receive notifications about new deliveries and updates',
      "Promotional Notifications":
          'Get notified about special offers and bonuses',
      "Email Notifications":
          'Receive weekly summaries and important updates via email',
    };

    final Map<String, bool> switchValues = {
      "Push Notification": state.pushNotify,
      "Promotional Notifications": state.promoNotify,
      "Email Notifications": state.emailNotify,
    };

    final Map<String, void Function(bool)> switchToggles = {
      "Push Notification": viewModel.toggleSwitch1,
      "Promotional Notifications": viewModel.toggleSwitch2,
      "Email Notifications": viewModel.toggleSwitch3,
    };

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notification Preference",
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
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: settings.length,
              itemBuilder: (_, i) {
                final String settingTitle = settings[i];
                return Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          settings[i],
                          style: GoogleFonts.hind(
                            fontSize: isWeb ? 18 : 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBlackGrey,
                          ),
                        ),
                        subtitle: Text(
                          settingSubTitle[settingTitle]!,
                          style: GoogleFonts.hind(
                            fontSize: isWeb ? 16 : 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textBodyText,
                          ),
                        ),
                        trailing: CustomSwitch(
                          value: switchValues[settingTitle]!,
                          onChanged: switchToggles[settingTitle]!,
                          thumbColour: AppColors.accentWhite,
                          activeColor: AppColors.switchGreen,
                          inactiveColor: AppColors.accentGrey,
                          height: isWeb ? 26 : 16,
                          width: isWeb ? 49 : 29,
                          thumbDiameter: isWeb ? 20 : 12,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 10),
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
}
