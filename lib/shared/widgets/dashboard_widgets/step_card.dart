import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/dashboard_widgets/status_chip.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/dashboard_helpers.dart';
import '../../../features/rider/presentation/widgets/dashboard_screen_widgets/account_setup_status_widget.dart';

class StepCard extends StatelessWidget {
  final AccountSetupStep step;
  final double? width;
  final double height;

  const StepCard({
    super.key,
    required this.step,
    this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = statusColors(step.status);
    final icons = statusIcon(step.status);

    return InkWell(
      onTap: step.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(7.04),
          border: Border.all(color: AppColors.accentGrey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: kIsWeb ? 7 : 6,
                    left: 7.0,
                  ),
                  child: Text(
                    step.title,
                    maxLines: 2,
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w600,
                      fontSize: kIsWeb ? 18 : 12.68,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 17.0, top: 10.0),
                  child: step.iconAsset,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: const Divider(thickness: 0.9),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7.0, bottom: 5.2),
              child: StatusChip(
                statusColor: AppColors.textWhite,
                containerColor: colors.bg,
                status: statusText(step.status),
                prefixIcon: icons,
                alignment: Alignment.center,
                width: kIsWeb ? 123 : 86.63,
                height: kIsWeb ? 28 : 19.72,
                fontSize: kIsWeb ? 12.0 : 8.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
