import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/features/seller/viewmodels/seller_dashboard_viewmodel.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../../shared/widgets/dashboard_widgets/earning_card.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../models/seller_analytics_model.dart';

class BusinessAnalyticsWidget extends ConsumerWidget {
  const BusinessAnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(sellerDashboardViewModelProvider);
    final viewModel = ref.read(sellerDashboardViewModelProvider.notifier);
    final isWeb = context.isWeb;
    final selectedPeriod = dashboardState.selectedPeriod;
    final analyticsAsync = dashboardState.analytics;

    Widget buildMetricAmount(
      AnalyticsMetric Function(PeriodAnalytics) selector, {
      bool isAmount = false,
    }) {
      return analyticsAsync.when(
        loading: () => SizedBox(
          width: 50,
          height: 20,
          child: LinearProgressIndicator(
            backgroundColor: AppColors.backgroundWhite.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation(AppColors.backgroundWhite),
          ),
        ),
        error: (e, _) => Text(
          'Error',
          style: GoogleFonts.hind(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: AppColors.accentRed,
          ),
        ),
        data: (analytics) {
          final periodData = analytics.forPeriod(selectedPeriod);
          if (periodData == null) {
            return Text(
              'N/A',
              style: GoogleFonts.notoSans(
                fontSize: isWeb ? 32 : 24.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textWhite,
              ),
            );
          }
          final metric = selector(periodData);
          final displayValue = isAmount
              ? _formatAmount(metric.value.toDouble())
              : metric.value.toStringAsFixed(0);
          return _buildRow(displayValue, metric.changePercent, isWeb);
        },
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Business Analytics",
                  style: GoogleFonts.hind(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                if (isWeb)
                  _buildPeriodSelector(isWeb, selectedPeriod, viewModel),
              ],
            ),
            if (!isWeb) ...[
              const SizedBox(height: 10),
              _buildPeriodSelector(isWeb, selectedPeriod, viewModel),
            ],
            SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWeb ? 4 : 2,
                childAspectRatio: isWeb ? 1.8 : 1.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: isWeb ? 24 : 19,
              ),
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return EarningCard(
                      title: 'Total Sale',
                      amountWidget: buildMetricAmount(
                        (p) => p.totalSales,
                        isAmount: true,
                      ),
                      leadingIcon: AppAssets.icons.totalSale.svg(),
                      watermarkIcon: AppAssets.icons.todayEarning.svg(
                        width: 65.51,
                        height: 64.65,
                      ),
                      borderColor: Colors.transparent,
                      titleColor: AppColors.textWhite,
                      stackLeft: isWeb ? 2 : 8.5,
                      stackBottom: 2.5,
                      iSeller: true,
                      backgroundColor: null,
                      gradient: const LinearGradient(
                        colors: [Color(0xff6BAAFC), Color(0xff305FEC)],
                      ),
                    );
                  case 1:
                    return EarningCard(
                      title: 'Pending Orders',
                      amountWidget: buildMetricAmount((p) => p.pendingOrders),
                      leadingIcon: AppAssets.icons.cart2.svg(),
                      watermarkIcon: AppAssets.icons.thisWeek.svg(
                        width: 75.65,
                        height: 73.58,
                      ),
                      borderColor: Colors.transparent,
                      titleColor: AppColors.textWhite,
                      stackLeft: -2,
                      stackBottom: 2.5,
                      iSeller: true,
                      backgroundColor: null,
                      gradient: const LinearGradient(
                        colors: [Color(0xffEF5E7A), Color(0xffD35385)],
                      ),
                    );
                  case 2:
                    return EarningCard(
                      title: 'Completed Orders',
                      amountWidget: buildMetricAmount((p) => p.completedOrders),
                      leadingIcon: AppAssets.icons.note.svg(),
                      watermarkIcon: AppAssets.icons.totalEarning.svg(
                        width: 60.37,
                        height: 73.64,
                      ),
                      borderColor: Colors.transparent,
                      titleColor: AppColors.textWhite,
                      stackLeft: 11,
                      stackBottom: -3,
                      iSeller: true,
                      backgroundColor: null,
                      gradient: const LinearGradient(
                        colors: [Color(0xff3ABB5D), Color(0xff40862A)],
                      ),
                    );
                  case 3:
                    return EarningCard(
                      title: 'Active Product',
                      amountWidget: buildMetricAmount((p) => p.activeProducts),
                      leadingIcon: AppAssets.icons.activeProduct.svg(),
                      watermarkIcon: AppAssets.icons.pendingPayout.svg(
                        height: 65,
                        width: 71.56,
                      ),
                      borderColor: Colors.transparent,
                      titleColor: AppColors.textWhite,
                      stackLeft: isWeb ? 3 : 7,
                      stackBottom: 2,
                      iSeller: true,
                      backgroundColor: null,
                      gradient: const LinearGradient(
                        colors: [Color(0xffD623FE), Color(0xffA530F2)],
                        stops: [0.0, 1.0],
                      ),
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

  Widget _buildPeriodSelector(
    bool isWeb,
    String selectedPeriod,
    SellerDashboardViewModel viewModel,
  ) {
    final isToday = selectedPeriod == 'today';
    final isWeekly = selectedPeriod == 'weekly';
    final isMonthly = selectedPeriod == 'monthly';

    return Row(
      children: [
        GestureDetector(
          onTap: () => viewModel.setPeriod('today'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: isWeb ? 26 : 37,
            width: 72,
            decoration: BoxDecoration(
              color: isToday
                  ? AppColors.primaryDarkGreen
                  : AppColors.clampBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'Today',
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isToday
                      ? AppColors.textWhite
                      : AppColors.textBlackGrey,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),

        SizedBox(
          width: 91,
          height: isWeb ? 26 : 37,
          child: CustomDropdownField(
            radius: 20,
            menuItemPadding: const EdgeInsets.only(left: 15),
            itemTextColor: AppColors.textBlackGrey,
            fillColor: isWeekly
                ? AppColors.primaryDarkGreen.withValues(alpha: 0.1)
                : AppColors.clampBgColor,
            hintFontSize: 12,
            hintTextColor: isWeekly
                ? AppColors.primaryDarkGreen
                : AppColors.textBlackGrey,
            sizeBoxHeight: 37,
            iconHeight: 14,
            hintFontWeight: FontWeight.w600,
            iconWidth: 14,
            itemsFontSize: 12,
            hintText: 'Weekly',
            items: const [
              'Weekly',
              'Monday',
              'Tuesday',
              'Wednesday',
              'Thursday',
              'Friday',
              'Saturday',
              'Sunday',
            ],
            onChanged: (_) => viewModel.setPeriod('weekly'),
          ),
        ),
        const SizedBox(width: 5),

        SizedBox(
          width: 92,
          height: isWeb ? 26 : 37,
          child: CustomDropdownField(
            radius: 20,
            menuItemPadding: const EdgeInsets.only(left: 15),
            itemTextColor: AppColors.textBlackGrey,
            fillColor: isMonthly
                ? AppColors.primaryDarkGreen.withValues(alpha: 0.1)
                : AppColors.clampBgColor,
            hintFontSize: 12,
            hintTextColor: isMonthly
                ? AppColors.primaryDarkGreen
                : AppColors.textBlackGrey,
            sizeBoxHeight: 37,
            iconHeight: 14,
            iconWidth: 14,
            hintFontWeight: FontWeight.w600,
            itemsFontSize: 12,
            hintText: 'Monthly',
            items: const [
              'Monthly',
              'January',
              'February',
              'March',
              'April',
              'May',
              'June',
              'July',
              'August',
              'September',
              'October',
              'November',
              'December',
            ],
            onChanged: (_) => viewModel.setPeriod('monthly'),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String amount, double changePercent, bool isWeb) {
    final isPositive = changePercent >= 0;
    final sign = isPositive ? '+' : '-';
    final pctDisplay = '$sign${_formatPercent(changePercent)}%';

    return Row(
      children: [
        Text(
          amount,
          style: GoogleFonts.notoSans(
            fontSize: isWeb ? 32 : 24.0,
            fontWeight: FontWeight.w600,
            color: AppColors.textWhite,
          ),
        ),
        const SizedBox(width: 5),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            height: 14,
            constraints: const BoxConstraints(minWidth: 28),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                pctDisplay,
                style: GoogleFonts.hind(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: isPositive
                      ? AppColors.textOrange
                      : AppColors.accentRed,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    return '₦${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}';
  }

  String _formatPercent(double pct) {
    final abs = pct.abs();
    return abs == abs.roundToDouble()
        ? '${abs.round()}'
        : abs.toStringAsFixed(1);
  }
}
