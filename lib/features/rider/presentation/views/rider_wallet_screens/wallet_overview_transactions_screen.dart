import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/rider/presentation/widgets/dashboard_screen_widgets/earning_overview_widget.dart';
import 'package:wigo_flutter/features/rider/viewmodels/wallet_overview_transaction_viewmodel.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_search_field.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../../../shared/widgets/pagination_widget.dart';
import '../../../models/wallet_overview_transaction_state.dart';
import '../../widgets/earning_history_table.dart';

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
              _buildRecentEarning(ref, isWeb, state),
              const SizedBox(height: 15),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentEarning(
    WidgetRef ref,
    bool isWeb,
    WalletOverviewTransactionState state,
  ) {
    final orders = state.orders.value ?? [];
    final isLoading = state.orders.isLoading;
    final notifier = ref.read(walletOverviewTransactionProvider.notifier);
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
            if (!isLoading && orders.isEmpty && state.searchQuery.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isWeb ? 350 : 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppAssets.icons.recentDeliveries.svg(),
                    const SizedBox(height: 10.0),
                    Text(
                      "No Earnings yet",
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Completed deliveries that earned you money will show up here once you start accepting orders.',
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
            else ...[
              _EarningsFilterBar(isWeb: isWeb),
              const SizedBox(height: 10),
              SizedBox(
                height: 400,
                child: Stack(
                  children: [
                    Scrollbar(
                      thumbVisibility: isWeb,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          if (!isLoading && orders.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Text(
                                  'No results match your search/filter',
                                  style: GoogleFonts.hind(
                                    color: AppColors.textBodyText,
                                  ),
                                ),
                              ),
                            )
                          else
                            EarningsHistoryTable(orders: orders),
                        ],
                      ),
                    ),
                    if (isLoading)
                      const Positioned.fill(
                        child: Center(
                          child: SpinKitDualRing(
                            color: AppColors.primaryDarkGreen,
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
                  totalPages: state.totalPages,
                  currentPage: state.currentPage,
                  count: state.totalOrdersCount,
                  onPressedStart: state.currentPage > 1
                      ? () => notifier.goToPage(1)
                      : null,
                  onPressedBack: state.hasPrev
                      ? () => notifier.goToPage(state.currentPage - 1)
                      : null,
                  onPressedForward: state.hasNext
                      ? () => notifier.goToPage(state.currentPage + 1)
                      : null,
                  onPressedEnd: state.currentPage < state.totalPages
                      ? () => notifier.goToPage(state.totalPages)
                      : null,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EarningsFilterBar extends ConsumerStatefulWidget {
  const _EarningsFilterBar({required this.isWeb});

  final bool isWeb;

  @override
  ConsumerState<_EarningsFilterBar> createState() => _EarningsFilterBarState();
}

class _EarningsFilterBarState extends ConsumerState<_EarningsFilterBar> {
  late final TextEditingController _searchController;

  static const _months = [
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
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int? _monthNameToNumber(String name) {
    final index = _months.indexOf(name);
    return index <= 0 ? null : index;
  }

  String _monthNumberToName(int? month) =>
      (month == null || month < 1 || month > 12) ? 'Month' : _months[month];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(walletOverviewTransactionProvider);
    final notifier = ref.read(walletOverviewTransactionProvider.notifier);
    final isWeb = widget.isWeb;
    final currentYear = DateTime.now().year;
    final years = [
      'Year',
      ...List.generate(5, (i) => (currentYear - i).toString()),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: isWeb ? 294 : 225,
            child: CustomSearchField(
              searchController: _searchController,
              hintText: 'Search by order ID or Dates...',
              backgroundColor: Colors.transparent,
              padding: 10,
              height: 37,
              onChanged: notifier.updateSearch,
            ),
          ),
          const SizedBox(width: 50),
          SizedBox(
            width: isWeb ? 92 : 79,
            child: CustomDropdownField(
              radius: 4,
              menuItemPadding: const EdgeInsets.only(left: 11),
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
              hintText: _monthNumberToName(state.selectedMonth),
              items: _months,
              onChanged: (value) {
                if (value == null) return;
                notifier.updateMonth(_monthNameToNumber(value));
              },
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: isWeb ? 92 : 72,
            child: CustomDropdownField(
              menuItemPadding: const EdgeInsets.only(left: 11),
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
              hintText: state.selectedYear?.toString() ?? 'Year',
              items: years,
              onChanged: (value) {
                if (value == null) return;
                notifier.updateYear(
                  value == 'Year' ? null : int.tryParse(value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
