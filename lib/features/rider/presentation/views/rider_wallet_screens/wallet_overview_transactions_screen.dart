import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/rider/presentation/widgets/dashboard_screen_widgets/earning_overview_widget.dart';
import 'package:wigo_flutter/features/rider/viewmodels/wallet_overview_transaction_viewmodel.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_search_field.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../../../shared/widgets/dashboard_widgets/delivery_table.dart';
import '../../../../../shared/widgets/pagination_widget.dart';
import '../../../models/delivery.dart';

class WalletOverviewAndTransactionsScreen extends ConsumerWidget {
  const WalletOverviewAndTransactionsScreen({
    super.key,
    required this.isWeb,
    this.isOverView = true,
  });

  final bool isWeb;
  final bool isOverView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletOverviewTransactionProvider);
    final notifier = ref.read(walletOverviewTransactionProvider.notifier);
    final totalPages = (state.totalDeliveriesCount / state.rowsPerPage).ceil();
    final currentPage = state.currentPage + 1;

    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 15),
        children: [
          Column(
            children: [
              if (isOverView)
                Padding(
                  padding: EdgeInsets.only(
                    top: isWeb ? 20 : 0,
                    right: isWeb ? 600 : 0,
                  ),
                  child: EarningOverviewWidget(isWallet: true),
                ),
              _buildRecentEarning(
                isWeb,
                state.deliveries.value ?? [],
                totalPages,
                currentPage,
                state.totalDeliveriesCount,
                state.currentPage > 0
                    ? () => notifier.goToPage(state.currentPage - 1)
                    : null,
                state.currentPage < totalPages - 1
                    ? () => notifier.goToPage(totalPages - 1)
                    : null,
                state.currentPage < totalPages - 1
                    ? () => notifier.goToPage(state.currentPage + 1)
                    : null,
                state.currentPage > 0 ? () => notifier.goToPage(0) : null,
              ),
              const SizedBox(height: 15),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentEarning(
    bool isWeb,
    List<Delivery> deliveries,
    int totalPages,
    int currentPage,
    int count,
    void Function()? onPressedBack,
    void Function()? onPressedEnd,
    void Function()? onPressedForward,
    void Function()? onPressedStart,
  ) {
    return Card(
      margin: EdgeInsets.only(top: isWeb ? 40 : 10),
      elevation: 0,
      color: AppColors.backgroundWhite,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Earning History',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 10),
            if (deliveries.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isWeb ? 350 : 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppAssets.icons.recentDeliveries.svg(),
                    const SizedBox(height: 10.0),
                    Text(
                      "No Active Deliveries yet",
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Your recent deliveries will show up here once you start accepting orders. Stay ready, opportunities are always around the corner!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.textBodyText,
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    CustomButton(
                      text: 'View Active Deliveries',
                      onPressed: () {},
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      height: 36.0,
                      padding: EdgeInsets.zero,
                      width: 251,
                    ),
                  ],
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: isWeb ? 294 : 225,
                      child: CustomSearchField(
                        hintText: 'Search by order ID or Dates...',
                        backgroundColor: Colors.transparent,
                        padding: 10,
                        height: 37,
                      ),
                    ),
                    const SizedBox(width: 50),
                    SizedBox(
                      width: isWeb ? 92 : 79,
                      child: CustomDropdownField(
                        radius: 4,
                        menuItemPadding: EdgeInsets.only(left: 11),
                        iconColorFilter: ColorFilter.mode(
                          AppColors.primaryDarkGreen,
                          BlendMode.srcIn,
                        ),
                        itemTextColor: AppColors.primaryDarkGreen,
                        fillColor: Colors.transparent,
                        enabledBorderColor: AppColors.primaryDarkGreen,
                        focusedBorderColor: AppColors.primaryDarkGreen,
                        hintFontSize: isWeb ? 14 : 12,
                        hintTextColor: AppColors.primaryDarkGreen,
                        sizeBoxHeight: 37,
                        iconHeight: 14,
                        iconWidth: 14,
                        itemsFontSize: isWeb ? 14 : 12,
                        hintText: 'Month',
                        items: const [
                          'Month',
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
                    const SizedBox(width: 10),
                    SizedBox(
                      width: isWeb ? 92 : 72,
                      child: CustomDropdownField(
                        menuItemPadding: EdgeInsets.only(left: 11),
                        radius: 4,
                        iconColorFilter: ColorFilter.mode(
                          AppColors.primaryDarkGreen,
                          BlendMode.srcIn,
                        ),
                        itemTextColor: AppColors.primaryDarkGreen,
                        itemsFontSize: isWeb ? 14 : 12,
                        fillColor: Colors.transparent,
                        enabledBorderColor: AppColors.primaryDarkGreen,
                        focusedBorderColor: AppColors.primaryDarkGreen,
                        hintFontSize: isWeb ? 14 : 12,
                        hintTextColor: AppColors.primaryDarkGreen,
                        sizeBoxHeight: 37,
                        iconHeight: 14,
                        iconWidth: 14,
                        hintText: 'Year',
                        items: const ['Year', '2024', '2023', '2022'],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            SizedBox(
              height: 400,
              child: Scrollbar(
                thumbVisibility: isWeb ? true : false,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [DeliveryTable(deliveries: deliveries)],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: AppColors.backgroundWhite,
              child: PaginationWidget(
                isEarning: true,
                totalPages: totalPages,
                currentPage: currentPage,
                count: count,
                onPressedBack: onPressedBack,
                onPressedEnd: onPressedEnd,
                onPressedForward: onPressedForward,
                onPressedStart: onPressedStart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
