import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/context_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/notification_body.dart';

class SellerNotificationScreen extends ConsumerWidget {
  const SellerNotificationScreen({super.key});

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
                        "Notification",
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
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            "Notification",
                            style: GoogleFonts.hind(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textBlackGrey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Control how you receive updates and alerts",
                            style: GoogleFonts.hind(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textBlackGrey,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 20),
                          Card(
                            color: AppColors.backgroundWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: AppColors.borderColor),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: NotificationBody(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Column(
                children: [const SizedBox(height: 20), NotificationBody()],
              ),
      ),
    );
  }
}
