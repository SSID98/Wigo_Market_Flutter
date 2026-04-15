import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/viewmodels/order_task_viewmodel.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_search_field.dart';
import '../../../../../shared/widgets/pagination_widget.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../core/utils/helper_methods.dart';
import '../../../../shared/widgets/dashboard_widgets/earning_card.dart';
import '../../models/order.dart';
import '../../models/order_task_state.dart';
import '../../viewmodels/dropdown_providers.dart';
import '../widgets/custom_multi_date_picker.dart';
import '../widgets/recent_earning_table.dart';

class EarningsAndTransactionsScreen extends ConsumerWidget {
  const EarningsAndTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderTaskProvider);
    final notifier = ref.read(orderTaskProvider.notifier);
    final totalPages = (state.totalOrdersCount / state.rowsPerPage).ceil();
    final currentPage = state.currentPage + 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.isWeb ? "Earnings & Transactions" : "Earnings",
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: AppColors.textBlackGrey,
            ),
          ),

          if (context.isWeb) ...[
            const SizedBox(height: 10),
            Text(
              'See what you’ve earned and track every payment—all in one place.',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: AppColors.textBlackGrey,
              ),
            ),
          ],
          const SizedBox(height: 20),
          _buildEarningsSummaryCard(context.isWeb),
          const SizedBox(height: 20),
          _buildOrderList(
            state.orders.value ?? [],
            totalPages,
            currentPage,
            state.totalOrdersCount,
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
            state,
            notifier,
            ref,
            context,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOrderList(
    List<Order> orders,
    int totalPages,
    int currentPage,
    int count,
    void Function()? onPressedBack,
    void Function()? onPressedEnd,
    void Function()? onPressedForward,
    void Function()? onPressedStart,
    OrderTaskState state,
    OrderTaskViewmodel vm,
    WidgetRef ref,
    BuildContext context,
  ) {
    return Card(
      margin: EdgeInsets.only(top: context.isWeb ? 40 : 10),
      elevation: 0,
      color: AppColors.backgroundWhite,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: context.isWeb ? 48 : 40,
                  width: context.isWeb ? 320 : 240,
                  child: CustomSearchField(
                    hintText: context.isWeb
                        ? 'Search by product name, Customer Name or Amount'
                        : "Search",
                    backgroundColor: Colors.transparent,
                    padding: 10,
                    height: 48,
                    borderColor: AppColors.borderColor,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: MenuAnchor(
                    crossAxisUnconstrained: true,
                    alignmentOffset: const Offset(-14, 15),
                    builder: (context, controller, child) {
                      return GestureDetector(
                        onTap: () {
                          if (!controller.isOpen) {
                            ref
                                .read(orderTaskProvider.notifier)
                                .syncTempWithActive();

                            ref.read(expandedIdProvider.notifier).state = null;
                            controller.open();
                          } else {
                            controller.close();
                          }
                        },
                        child: _buildMenuButton(
                          menuText: "Date",
                          isExpanded: controller.isOpen,
                        ),
                      );
                    },
                    style: anchorMenuStyle(),
                    menuChildren: [
                      Builder(
                        builder: (menuContext) {
                          final controller = MenuController.maybeOf(
                            menuContext,
                          );
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildMenuItem(
                                onPressed: () {
                                  vm.setTodayFilter();
                                  controller?.close();
                                },
                                isNotAccordion: true,
                                itemText: 'Today',
                              ),
                              _buildMenuItem(
                                isNotAccordion: true,
                                trailingIcon: Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                ),
                                onPressed: () async {
                                  controller?.close();
                                  vm.syncDateTempWithActive();
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return Consumer(
                                        builder: (context, ref, child) {
                                          final state = ref.watch(
                                            orderTaskProvider,
                                          );
                                          return Dialog(
                                            backgroundColor: Colors.transparent,
                                            insetPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                ),
                                            child: CustomMultiDatePicker(
                                              initialSelectedDates:
                                                  state.tempSelectedDates,
                                              onDateToggled: (date) {
                                                vm.toggleDateSelection(date);
                                              },
                                              onApply: () {
                                                vm.applyDateFilters();
                                                Navigator.pop(context);
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                itemText: 'Custom Date',
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (orders.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.isWeb ? 350 : 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    AppAssets.icons.walletEmpty.svg(),
                    const SizedBox(height: 25.0),
                    Text(
                      "No earnings yet.",
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: context.isWeb ? 28 : 15,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Once you start making sales, you’ll see your earnings here',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w400,
                        fontSize: context.isWeb ? 20 : 14,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            else
              SizedBox(
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recent Earning",
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: AppColors.textOrange,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: context.isWeb ? true : false,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            RecentEarningTable(
                              orders: orders,
                              isExpanded: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Container(
              color: AppColors.backgroundWhite,
              child: PaginationWidget(
                isEarning: true,
                showPage: true,
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

  Widget _buildMenuItem({
    required void Function()? onPressed,
    required itemText,
    Widget? trailingIcon,
    bool isNotAccordion = false,
  }) {
    return MenuItemButton(
      onPressed: onPressed,
      trailingIcon: trailingIcon,
      child: Padding(
        padding: EdgeInsets.only(left: isNotAccordion ? 0 : 35),
        child: Text(
          itemText,
          style: GoogleFonts.hind(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isNotAccordion
                ? AppColors.textBlackGrey
                : AppColors.textBodyText,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required bool isExpanded,
    required String menuText,
    bool isSelected = true,
    Color? newColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isSelected
            ? isExpanded
                  ? AppColors.tableHeader
                  : AppColors.backgroundLight
            : newColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                menuText,
                style: GoogleFonts.hind(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBlackGrey,
                ),
              ),
            ),
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsSummaryCard(bool isWeb) {
    return Container(
      margin: EdgeInsets.only(top: isWeb ? 18 : 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(6.0),
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
              "Earnings Summary",
              style: GoogleFonts.hind(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackGrey,
              ),
            ),
            SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWeb ? 3 : 2,
                childAspectRatio: isWeb ? 1.8 : 1.6,
                crossAxisSpacing: 16,
                mainAxisSpacing: isWeb ? 24 : 19,
              ),
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return EarningCard(
                      title: "Total Earnings",
                      amountWidget: _buildRow(
                        amount: "100,000",
                        percentage: '0',
                        isWeb: isWeb,
                      ),
                      leadingIcon: AppAssets.icons.totalEarn.svg(height: 17),
                      watermarkIcon: AppAssets.icons.totalEarnings.svg(
                        width: 94.06,
                        height: 93.08,
                      ),
                      borderColor: Colors.transparent,
                      titleColor: AppColors.textWhite,
                      stackLeft: isWeb ? 2 : 8.5,
                      stackBottom: 2.5,
                      iSeller: true,
                      backgroundColor: null,
                      borderRadius: 8,
                      gradient: LinearGradient(
                        colors: [Color(0xffEF5E7A), Color(0xffD35385)],
                      ),
                    );
                  case 1:
                    return EarningCard(
                      title: "Weekly Earning",
                      amountWidget: _buildRow(
                        amount: "5,000",
                        percentage: '54',
                        isWeb: isWeb,
                      ),
                      leadingIcon: AppAssets.icons.weekEarn.svg(height: 17),
                      watermarkIcon: AppAssets.icons.weeklyEarnings.svg(
                        width: 91.52,
                        height: 90.99,
                      ),
                      borderColor: Colors.transparent,
                      titleColor: AppColors.textWhite,
                      stackLeft: -2,
                      stackBottom: 2.5,
                      iSeller: true,
                      backgroundColor: null,
                      borderRadius: 8,
                      gradient: LinearGradient(
                        colors: [Color(0xffD623FE), Color(0xffA530F2)],
                      ),
                    );
                  case 2:
                    return EarningCard(
                      title: "Today’s Earning",
                      amountWidget: _buildRow(
                        amount: "10,000",
                        percentage: '0',
                        isWeb: isWeb,
                      ),
                      leadingIcon: AppAssets.icons.todayEarn.svg(height: 17),
                      watermarkIcon: AppAssets.icons.todaysEarning.svg(
                        width: 62.97,
                        height: 66.01,
                      ),
                      borderColor: Colors.transparent,
                      titleColor: AppColors.textWhite,
                      stackLeft: 21,
                      stackBottom: -3,
                      iSeller: true,
                      backgroundColor: null,
                      borderRadius: 8,
                      gradient: LinearGradient(
                        colors: [Color(0xff6BAAFC), Color(0xff305FEC)],
                      ),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required String amount,
    required String percentage,
    required bool isWeb,
  }) {
    return Row(
      children: [
        Text(
          "₦$amount",
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
}
