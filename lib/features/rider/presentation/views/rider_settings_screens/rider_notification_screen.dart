import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/notification_body.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/context_extensions.dart';
import '../../../../../gen/assets.gen.dart';

class RiderNotificationScreen extends StatelessWidget {
  const RiderNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    final notificationBody = _NotificationBody(showSaveInside: isWeb);

    return Scaffold(
      backgroundColor: isWeb
          ? AppColors.backgroundLight
          : AppColors.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
        child: isWeb
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

class _NotificationBody extends StatelessWidget {
  final bool showSaveInside;

  const _NotificationBody({required this.showSaveInside});

  @override
  Widget build(BuildContext context) {
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
                    fontSize: context.isWeb ? 24 : 18,
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
          NotificationBody(),
        ],
      ),
    );
  }
}
