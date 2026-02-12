import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/seller/viewmodels/seller_dashboard_viewmodel.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../../../shared/widgets/dashboard_widgets/earning_card.dart';
import '../../../../../shared/widgets/custom_text_field.dart';

class BusinessAnalyticsWidget extends ConsumerWidget {
  const BusinessAnalyticsWidget({super.key, this.isWallet = false});

  final bool isWallet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(sellerDashboardViewModelProvider);
    final isWeb = MediaQuery.of(context).size.width > 600;

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
                if (isWeb) _buildDropDownRow(isWeb),
              ],
            ),
            if (!isWeb) ...[
              const SizedBox(height: 10),
              _buildDropDownRow(isWeb),
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
                      title: "Total Sale",
                      amountWidget: _buildEarningAmount(
                        dashboardState.totalSales,
                        AppColors.textWhite,
                        '54',
                        isWeb,
                      ),
                      leadingIcon: AppAssets.icons.totalSale.svg(),
                      watermarkIcon: AppAssets.icons.todayEarning.svg(
                        width: 65.51,
                        height: 64.65,
                        colorFilter: ColorFilter.mode(
                          AppColors.backgroundWhite,
                          BlendMode.srcIn,
                        ),
                      ),
                      borderColor: Colors.transparent,
                      titleColor: AppColors.textWhite,
                      stackLeft: isWeb ? 2 : 8.5,
                      stackBottom: 2.5,
                      iSeller: true,
                      backgroundColor: null,
                      gradient: LinearGradient(
                        colors: [Color(0xff6BAAFC), Color(0xff305FEC)],
                      ),
                    );
                  case 1:
                    return EarningCard(
                      title: "Pending Orders",
                      amountWidget: _buildEarningAmount(
                        dashboardState.pendingOrders,
                        AppColors.textWhite,
                        '54',
                        isWeb,
                      ),
                      leadingIcon: AppAssets.icons.cart2.svg(),
                      watermarkIcon: AppAssets.icons.thisWeek.svg(
                        width: 75.65,
                        height: 73.58,
                        colorFilter: ColorFilter.mode(
                          AppColors.backgroundWhite,
                          BlendMode.srcIn,
                        ),
                      ),
                      borderColor: Colors.transparent,
                      titleColor: AppColors.textWhite,
                      stackLeft: -2,
                      stackBottom: 2.5,
                      iSeller: true,
                      backgroundColor: null,
                      gradient: LinearGradient(
                        colors: [Color(0xffEF5E7A), Color(0xffD35385)],
                      ),
                    );
                  case 2:
                    return EarningCard(
                      title: "Completed Orders",
                      amountWidget: _buildEarningAmount(
                        dashboardState.completedOrders,
                        AppColors.textWhite,
                        '54',
                        isWeb,
                      ),
                      leadingIcon: AppAssets.icons.note.svg(),
                      watermarkIcon: AppAssets.icons.totalEarning.svg(
                        width: 60.37,
                        height: 73.64,
                        colorFilter: ColorFilter.mode(
                          AppColors.backgroundWhite,
                          BlendMode.srcIn,
                        ),
                      ),
                      borderColor: Colors.transparent,
                      titleColor: AppColors.textWhite,
                      stackLeft: 11,
                      stackBottom: -3,
                      iSeller: true,
                      backgroundColor: null,
                      gradient: LinearGradient(
                        colors: [Color(0xff3ABB5D), Color(0xff40862A)],
                      ),
                    );
                  case 3:
                    return EarningCard(
                      title: "Active Product",
                      amountWidget: _buildEarningAmount(
                        dashboardState.activeProduct,
                        AppColors.backgroundWhite,
                        '54',
                        isWeb,
                      ),
                      leadingIcon: AppAssets.icons.activeProduct.svg(),
                      watermarkIcon: AppAssets.icons.pendingPayout.svg(
                        height: 65,
                        width: 71.56,
                        colorFilter: ColorFilter.mode(
                          AppColors.backgroundWhite,
                          BlendMode.srcIn,
                        ),
                      ),
                      borderColor: Colors.transparent,
                      titleColor: AppColors.textWhite,
                      stackLeft: isWeb ? 3 : 7,
                      stackBottom: 2,
                      iSeller: true,
                      backgroundColor: null,
                      gradient: LinearGradient(
                        colors: [Color(0xffD623FE), Color(0xffA530F2)],
                        stops: const [0.0, 1.0],
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

  Widget _buildRow(String amount, String percentage, Color color, bool isWeb) {
    return Row(
      children: [
        Text(
          amount,
          style: GoogleFonts.notoSans(
            fontSize: isWeb ? 32 : 24.0,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(width: 5),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            height: 14,
            width: 28,
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                '+$percentage%',
                style: GoogleFonts.hind(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOrange,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEarningAmount(
    AsyncValue<String> asyncValue,
    Color color,
    String percentage,
    bool isWeb,
  ) {
    return asyncValue.when(
      data: (amount) => _buildRow(amount, percentage, color, isWeb),
      loading:
          () => SizedBox(
            width: 50,
            height: 20,
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

  Widget _buildDropDownRow(bool isWeb) {
    return Row(
      children: [
        Container(
          height: isWeb ? 26 : 37,
          width: 72,
          decoration: BoxDecoration(
            color: AppColors.primaryDarkGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              'Today',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.textWhite,
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
            menuItemPadding: EdgeInsets.only(left: 22),
            itemTextColor: AppColors.textBlackGrey,
            fillColor: AppColors.clampBgColor,
            hintFontSize: 12,
            hintTextColor: AppColors.textBlackGrey,
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
          ),
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: 92,
          height: isWeb ? 26 : 37,
          child: CustomDropdownField(
            radius: 20,
            menuItemPadding: EdgeInsets.only(left: 18),
            itemTextColor: AppColors.textBlackGrey,
            fillColor: AppColors.clampBgColor,
            hintFontSize: 12,
            hintTextColor: AppColors.textBlackGrey,
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
          ),
        ),
      ],
    );
  }
}
