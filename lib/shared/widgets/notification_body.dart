import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/context_extensions.dart';
import '../../features/rider/presentation/widgets/switch.dart';
import '../screens/notification_viewmodel.dart';

class NotificationBody extends ConsumerWidget {
  const NotificationBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(notificationViewModelProvider.notifier);
    final state = ref.watch(notificationViewModelProvider);

    final List<String> notifications = [
      "Push Notification",
      "Promotional Notifications",
      "Email Notifications",
    ];

    final Map<String, String> notificationSubTitle = {
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
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10),
        itemCount: notifications.length,
        itemBuilder: (_, i) {
          final String settingTitle = notifications[i];
          return Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    notifications[i],
                    style: GoogleFonts.hind(
                      fontSize: context.isWeb ? 18 : 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(right: context.isWeb ? 0 : 20.0),
                    child: Text(
                      notificationSubTitle[settingTitle]!,
                      style: GoogleFonts.hind(
                        fontSize: context.isWeb ? 16 : 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textBodyText,
                      ),
                    ),
                  ),
                  trailing: CustomSwitch(
                    value: switchValues[settingTitle]!,
                    onChanged: switchToggles[settingTitle]!,
                    thumbColour: AppColors.accentWhite,
                    activeColor: AppColors.switchGreen,
                    inactiveColor: AppColors.accentGrey,
                    height: 26,
                    width: 49,
                    thumbDiameter: 20,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
