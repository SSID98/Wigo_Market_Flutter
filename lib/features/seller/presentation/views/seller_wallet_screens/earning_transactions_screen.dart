import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/core/utils/helper_methods_classes.dart';
import 'package:wigo_flutter/features/seller/models/seller_earnings_models.dart';
import 'package:wigo_flutter/features/seller/models/seller_earnings_state.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/earnings_date_range_picker.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/earnings_table.dart';
import 'package:wigo_flutter/features/seller/viewmodels/dropdown_providers.dart';
import 'package:wigo_flutter/features/seller/viewmodels/seller_earnings_viewmodel.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';
import 'package:wigo_flutter/shared/screens/wallet_screens/wallet_withdrawal_screen.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/custom_search_field.dart';
import 'package:wigo_flutter/shared/widgets/dashboard_widgets/earning_card.dart';
import 'package:wigo_flutter/shared/widgets/pagination_widget.dart';

import '../../../../rider/viewmodels/global_navigation_viewmodel.dart';
import '../../../models/earnings_formatters.dart';
import '../../widgets/earnings_shimmer.dart';

class EarningsAndTransactionsScreen extends HookConsumerWidget {
  const EarningsAndTransactionsScreen({super.key});

  static const int _tabIndex = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(globalNavigationViewModelProvider);
    final isCurrentTab = navState.currentIndex == _tabIndex;

    final hasLoaded = useRef(false);

    useEffect(() {
      if (isCurrentTab && !hasLoaded.value) {
        hasLoaded.value = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ref.read(sellerEarningsViewModelProvider.notifier).loadEarnings();
          }
        });
      }
      return null;
    }, [isCurrentTab]);

    final state = ref.watch(sellerEarningsViewModelProvider);
    final notifier = ref.read(sellerEarningsViewModelProvider.notifier);
    final isWeb = context.isWeb;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: notifier.refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 15),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEarningsSummaryCard(context, state),
                const SizedBox(height: 20),
                _buildOrderList(context, ref, state, notifier),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(
    BuildContext context,
    WidgetRef ref,
    SellerEarningsState state,
    SellerEarningsViewModel notifier,
  ) {
    final isWeb = context.isWeb;
    final isLoading = state.earnings.isLoading;
    final canGoBack = !isLoading && state.currentPage > 0;
    final canGoForward = !isLoading && state.currentPage < state.totalPages - 1;

    return Card(
      margin: EdgeInsets.only(top: isWeb ? 40 : 10),
      elevation: 0,
      color: AppColors.backgroundWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: isWeb ? 48 : 40,
                  width: isWeb ? 320 : 240,
                  child: CustomSearchField(
                    hintText: isWeb
                        ? 'Search by order ID, product, customer or amount'
                        : 'Search',
                    backgroundColor: Colors.transparent,
                    padding: 10,
                    height: 48,
                    borderColor: AppColors.borderColor,
                    // Assumes CustomSearchField exposes `onChanged` (see notes).
                    onChanged: notifier.onSearchChanged,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: _buildDateMenu(context, ref, state, notifier),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTableArea(context, state, notifier),
            const SizedBox(height: 20),
            Container(
              color: AppColors.backgroundWhite,
              child: PaginationWidget(
                labelPerPage: 'Earnings per page',
                onSelected: notifier.setRowsPerPage,
                rowsPerPage: state.rowsPerPage,
                rowsPerPageOptions: const [5, 10, 20, 50],
                isEarning: true,
                showPage: true,
                totalPages: state.totalPages,
                currentPage: state.currentPage + 1,
                count: state.totalCount,
                onPressedStart: canGoBack ? () => notifier.goToPage(0) : null,
                onPressedBack: canGoBack
                    ? () => notifier.goToPage(state.currentPage - 1)
                    : null,
                onPressedForward: canGoForward
                    ? () => notifier.goToPage(state.currentPage + 1)
                    : null,
                onPressedEnd: canGoForward
                    ? () => notifier.goToPage(state.totalPages - 1)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableArea(
    BuildContext context,
    SellerEarningsState state,
    SellerEarningsViewModel notifier,
  ) {
    final isWeb = context.isWeb;

    return state.earnings.when(
      loading: () => _tableFrame(
        context,
        child: EarningTableShimmer(isWeb: isWeb, rowCount: 5),
      ),
      error: (error, _) => _buildErrorState(
        context,
        error is String ? error : 'Something went wrong. Please try again.',
        notifier.refresh,
      ),
      data: (earnings) {
        if (earnings.isEmpty) {
          return _buildEmptyState(context, state, notifier);
        }
        return _tableFrame(
          context,
          child: SellerEarningsTable(earnings: earnings),
        );
      },
    );
  }

  Widget _tableFrame(BuildContext context, {required Widget child}) {
    return SizedBox(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Earning',
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColors.textOrange,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _TableViewport(showThumb: context.isWeb, child: child),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    SellerEarningsState state,
    SellerEarningsViewModel notifier,
  ) {
    final isWeb = context.isWeb;
    final filtered = state.hasActiveFilters;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 350 : 40),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            AppAssets.icons.walletEmpty.svg(),
            const SizedBox(height: 25.0),
            Text(
              filtered ? 'No matching earnings.' : 'No earnings yet.',
              textAlign: TextAlign.center,
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: isWeb ? 28 : 15,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              filtered
                  ? 'Try a different search or date range.'
                  : 'Once you start making sales, you’ll see your earnings here',
              textAlign: TextAlign.center,
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w400,
                fontSize: isWeb ? 20 : 14,
                color: AppColors.textBlackGrey,
              ),
            ),
            if (state.hasDateFilter) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: notifier.clearDateFilter,
                child: Text(
                  'Clear date filter',
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textOrange,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String message,
    Future<void> Function() onRetry,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: AppColors.textRed,
            ),
            const SizedBox(height: 12),
            Text(
              'Couldn’t load your earnings',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.hind(
                fontSize: 14,
                color: AppColors.textBodyText,
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                'Try again',
                style: GoogleFonts.hind(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dateLabel(SellerEarningsState state) => switch (state.dateFilter) {
    EarningsDateFilter.all => 'Date',
    EarningsDateFilter.today => 'Today',
    EarningsDateFilter.custom => 'Custom',
  };

  Widget _buildDateMenu(
    BuildContext context,
    WidgetRef ref,
    SellerEarningsState state,
    SellerEarningsViewModel notifier,
  ) {
    return MenuAnchor(
      crossAxisUnconstrained: true,
      alignmentOffset: const Offset(-14, 15),
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () {
            if (!controller.isOpen) {
              ref.read(expandedIdProvider.notifier).state = null;
              controller.open();
            } else {
              controller.close();
            }
          },
          child: _buildMenuButton(
            menuText: _dateLabel(state),
            isExpanded: controller.isOpen,
            isActive: state.hasDateFilter,
          ),
        );
      },
      style: anchorMenuStyle(),
      menuChildren: [
        Builder(
          builder: (menuContext) {
            final controller = MenuController.maybeOf(menuContext);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMenuItem(
                  onPressed: () {
                    notifier.setTodayFilter();
                    controller?.close();
                  },
                  isNotAccordion: true,
                  itemText: 'Today',
                ),
                _buildMenuItem(
                  isNotAccordion: true,
                  trailingIcon: const Icon(Icons.keyboard_arrow_right_rounded),
                  onPressed: () {
                    controller?.close();
                    _showRangeDialog(context, state, notifier);
                  },
                  itemText: 'Custom Date',
                ),
                if (state.hasDateFilter)
                  _buildMenuItem(
                    isNotAccordion: true,
                    onPressed: () {
                      notifier.clearDateFilter();
                      controller?.close();
                    },
                    itemText: 'Clear',
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showRangeDialog(
    BuildContext context,
    SellerEarningsState state,
    SellerEarningsViewModel notifier,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: EarningsDateRangePicker(
            initialStart: state.dateFilter == EarningsDateFilter.custom
                ? state.dateFrom
                : null,
            initialEnd: state.dateFilter == EarningsDateFilter.custom
                ? state.dateTo
                : null,
            onClear: state.hasDateFilter
                ? () {
                    Navigator.of(dialogContext).pop();
                    notifier.clearDateFilter();
                  }
                : null,
            onApply: (start, end) {
              Navigator.of(dialogContext).pop();
              notifier.applyDateRange(start, end);
            },
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required void Function()? onPressed,
    required String itemText,
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
    bool isActive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isExpanded ? AppColors.tableHeader : AppColors.backgroundLight,
        border: isActive ? Border.all(color: AppColors.textOrange) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                menuText,
                overflow: TextOverflow.ellipsis,
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

  Widget _buildEarningsSummaryCard(
    BuildContext context,
    SellerEarningsState state,
  ) {
    final isWeb = context.isWeb;

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
              'Earnings Summary',
              style: GoogleFonts.hind(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 24),
            state.summary.when(
              loading: () => EarningCardsShimmer(isWeb: isWeb),
              error: (_, __) => _buildCardsGrid(isWeb, null),
              data: (summary) => _buildCardsGrid(isWeb, summary),
            ),
            if (!isWeb) const SizedBox(height: 15),
            if (!isWeb)
              CustomButton(
                text: 'Withdraw',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WalletWithdrawalScreen(isSeller: true),
                    ),
                  );
                },
                fontSize: 12,
                fontWeight: FontWeight.w500,
                prefixIcon: AppAssets.icons.download.svg(width: 17, height: 17),
                width: double.infinity,
                height: 41,
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsGrid(bool isWeb, EarningsSummary? summary) {
    return GridView.builder(
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
              title: 'Total Earnings',
              amountWidget: _buildRow(
                metric: summary?.totalEarnings,
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
              gradient: const LinearGradient(
                colors: [Color(0xffEF5E7A), Color(0xffD35385)],
              ),
            );
          case 1:
            return EarningCard(
              title: 'Weekly Earning',
              amountWidget: _buildRow(
                metric: summary?.weeklyEarnings,
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
              gradient: const LinearGradient(
                colors: [Color(0xffD623FE), Color(0xffA530F2)],
              ),
            );
          case 2:
            return EarningCard(
              title: 'Today’s Earning',
              amountWidget: _buildRow(
                metric: summary?.todayEarnings,
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
              gradient: const LinearGradient(
                colors: [Color(0xff6BAAFC), Color(0xff305FEC)],
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildRow({required EarningMetric? metric, required bool isWeb}) {
    final amountText = metric == null
        ? '₦--'
        : formatNaira(metric.value, trimWhole: true);
    final change = metric?.changePercent ?? 0;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            amountText,
            style: GoogleFonts.notoSans(
              fontSize: isWeb ? 32 : 24.0,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
          if (metric != null) ...[
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 14,
                constraints: const BoxConstraints(minWidth: 28),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  formatChangePercent(change),
                  style: GoogleFonts.hind(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: change < 0
                        ? AppColors.textRed
                        : AppColors.textOrange,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TableViewport extends StatefulWidget {
  const _TableViewport({required this.child, required this.showThumb});

  final Widget child;
  final bool showThumb;

  @override
  State<_TableViewport> createState() => _TableViewportState();
}

class _TableViewportState extends State<_TableViewport> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _controller,
      thumbVisibility: widget.showThumb,
      child: SingleChildScrollView(
        controller: _controller,
        child: widget.child,
      ),
    );
  }
}
