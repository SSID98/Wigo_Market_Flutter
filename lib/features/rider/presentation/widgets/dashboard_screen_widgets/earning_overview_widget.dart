import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/dashboard_widgets/earning_card.dart';
import '../../../viewmodels/rider_dashboard_viewmodel.dart';

class EarningOverviewWidget extends ConsumerWidget {
  const EarningOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(riderDashboardViewModelProvider);
    final isWeb = MediaQuery.of(context).size.width > 600;

    Widget buildEarningAmount(AsyncValue<String> asyncValue, Color color) {
      return asyncValue.when(
        data:
            (amount) => Text(
              amount,
              style: GoogleFonts.notoSans(
                fontSize: isWeb ? 32 : 24.0,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
        loading:
            () => SizedBox(
              width: 50, // Match expected text width
              height: 20, // Match expected text height
              child: LinearProgressIndicator(
                backgroundColor: color.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
        error:
            (e, _) => Text(
              "Error",
              style: GoogleFonts.hind(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: AppColors.accentRed,
              ),
            ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: isWeb ? 18 : 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white70.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isWeb ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Earning Overview",
              style: GoogleFonts.hind(
                fontSize: isWeb ? 20 : 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackGrey,
              ),
            ),
            SizedBox(height: isWeb ? 24 : 5),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWeb ? 4 : 2,
                childAspectRatio: isWeb ? 1.8 : 1.9,
                crossAxisSpacing: 24,
                mainAxisSpacing: isWeb ? 24 : 20,
              ),
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return EarningCard(
                      title: "Today's Earning",
                      amountWidget: buildEarningAmount(
                        dashboardState.todaysEarnings,
                        AppColors.textBlue,
                      ),
                      leadingIcon: AppAssets.icons.cash.svg(
                        width: 24,
                        height: 24,
                      ),
                      watermarkIcon: AppAssets.icons.todayEarning.svg(
                        width: isWeb ? 90 : 62.75,
                        height: isWeb ? 100 : 66,
                      ),
                      borderColor: AppColors.textBlue,
                      titleColor: AppColors.textBlue,
                      stackLeft: isWeb ? 2 : 8.5,
                      stackBottom: 2.5,
                    );
                  case 1:
                    return EarningCard(
                      title: "This Week",
                      amountWidget: buildEarningAmount(
                        dashboardState.thisWeekEarnings,
                        AppColors.textPink,
                      ),
                      leadingIcon: AppAssets.icons.moneyBag.svg(
                        width: 26,
                        height: 26,
                      ),
                      watermarkIcon: AppAssets.icons.thisWeek.svg(
                        width: isWeb ? 70 : 72.94,
                        height: isWeb ? 95 : 68.85,
                      ),
                      borderColor: AppColors.textPink,
                      titleColor: AppColors.textPink,
                      stackLeft: -2,
                      stackBottom: 2.5,
                    );
                  case 2:
                    return EarningCard(
                      title: "Pending Payout",
                      amountWidget: buildEarningAmount(
                        dashboardState.pendingPayout,
                        AppColors.textPurple,
                      ),
                      leadingIcon: Icon(
                        Icons.pending_actions,
                        color: AppColors.textPurple,
                        size: 24.0,
                      ),
                      watermarkIcon: AppAssets.icons.pendingPayout.svg(
                        width: isWeb ? 71.56 : 65.71,
                        height: isWeb ? 90 : 62,
                      ),
                      borderColor: AppColors.textPurple,
                      titleColor: AppColors.textPurple,
                      stackLeft: 11,
                      stackBottom: -3,
                    );
                  case 3:
                    return EarningCard(
                      title: "Total Earning",
                      amountWidget: buildEarningAmount(
                        dashboardState.totalEarnings,
                        isWeb
                            ? AppColors.webTotalEarningGreen
                            : AppColors.textGreen,
                      ),
                      leadingIcon: AppAssets.icons.note.svg(
                        width: 16.17,
                        height: 19.96,
                      ),
                      watermarkIcon:
                          isWeb
                              ? AppAssets.icons.totalEarningWeb.svg(
                                width: 90,
                                height: 90,
                              )
                              : AppAssets.icons.totalEarning.svg(height: 67),
                      borderColor:
                          isWeb
                              ? AppColors.webTotalEarningGreen
                              : AppColors.textGreen,
                      titleColor:
                          isWeb
                              ? AppColors.webTotalEarningGreen
                              : AppColors.textGreen,
                      stackLeft: isWeb ? 3 : 7,
                      stackBottom: 2,
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
