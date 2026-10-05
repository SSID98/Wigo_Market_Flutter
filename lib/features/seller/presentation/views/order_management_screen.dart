import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/features/seller/viewmodels/order_task_viewmodel.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_search_field.dart';
import '../../../../../shared/widgets/pagination_widget.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_checkbox_2.dart';
import '../../models/order_task_state.dart';
import '../../navigation/seller_tab_navigation.dart';
import '../../viewmodels/dropdown_providers.dart';
import '../widgets/custom_multi_date_picker.dart';
import '../widgets/filter_button.dart';
import '../widgets/order_shimmer.dart';
import '../widgets/order_table.dart';
import 'add_product_screen.dart';

Widget _withActiveDot({required Widget child, required bool active}) {
  if (!active) return child;
  return Stack(
    clipBehavior: Clip.none,
    children: [
      child,
      Positioned(
        right: -3,
        top: -3,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.primaryDarkGreen,
            shape: BoxShape.circle,
          ),
        ),
      ),
    ],
  );
}

String _shortDate(DateTime d) => '${d.day}/${d.month}';

String? _dateSelectedValue(OrderTaskState state) {
  if (state.dateFilterType == DateFilterType.today) return 'Today';
  if (state.dateFilterType == DateFilterType.custom &&
      state.activeSelectedDates.isNotEmpty) {
    final sorted = state.activeSelectedDates.toList()..sort();
    final start = sorted.first;
    final end = sorted.length > 1 ? sorted.last : DateTime.now();
    return '${_shortDate(start)} - ${_shortDate(end)}';
  }
  return null;
}

String? _statusSelectedValue(OrderTaskState state) {
  if (state.activeStatuses.isEmpty) return null;
  if (state.activeStatuses.length <= 2) {
    return state.activeStatuses.map((s) => s.displayName).join(', ');
  }
  return '${state.activeStatuses.length} selected';
}

String? _orderTypeSelectedValue(OrderTaskState state) {
  if (state.deliveryType == DeliveryType.all) return null;
  return state.deliveryType.displayName;
}

bool _isDefaultSort(OrderTaskState state) =>
    state.sortBy == 'date' && state.sortOrder == 'desc';

String? _sortSelectedValue(OrderTaskState state) {
  if (_isDefaultSort(state)) return null;
  if (state.sortBy == 'date' && state.sortOrder == 'asc') return 'Oldest first';
  if (state.sortBy == 'amount' && state.sortOrder == 'desc') {
    return 'Amount: high to low';
  }
  if (state.sortBy == 'amount' && state.sortOrder == 'asc') {
    return 'Amount: low to high';
  }
  return null;
}

class OrderManagementScreen extends ConsumerWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderTaskProvider);
    final notifier = ref.read(orderTaskProvider.notifier);
    final totalPages = state.totalOrdersCount == 0
        ? 1
        : (state.totalOrdersCount / state.rowsPerPage).ceil();
    final currentPage = state.currentPage + 1;
    final isWeb = context.isWeb;

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Management',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppColors.textBlackGrey,
              ),
            ),

            if (isWeb) ...[
              const SizedBox(height: 10),
              Text(
                'Track your store performance at a glance',
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: AppColors.textBlackGrey,
                ),
              ),
            ],
            const SizedBox(height: 20),
            if (isWeb) OrderHeaderWeb() else OrderHeaderMobile(),
            const SizedBox(height: 20),
            _buildCategoryTabs(state, notifier),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: isWeb ? 380 : 300,
                  child: CustomSearchField(
                    hintText: 'Search by order ID or customer name...',
                    backgroundColor: Colors.transparent,
                    padding: 10,
                    height: 48,
                    borderColor: AppColors.textIconGrey,
                    onChanged: notifier.onSearchChanged,
                  ),
                ),
                // if (isWeb)
                //   SizedBox(
                //     width: 91,
                //     height: isWeb ? 26 : 37,
                //     child: CustomDropdownField(
                //       radius: 4,
                //       menuItemPadding: EdgeInsets.only(left: 22),
                //       itemTextColor: AppColors.primaryDarkGreen,
                //       fillColor: Colors.transparent,
                //       hintFontSize: 12,
                //       hintTextColor: AppColors.primaryDarkGreen,
                //       sizeBoxHeight: 37,
                //       iconHeight: 14,
                //       hintFontWeight: FontWeight.w500,
                //       iconWidth: 14,
                //       itemsFontSize: 12,
                //       hintText: 'Bulk action',
                //       items: const [
                //         'Weekly',
                //         'Monday',
                //         'Tuesday',
                //         'Wednesday',
                //         'Thursday',
                //         'Friday',
                //         'Saturday',
                //         'Sunday',
                //       ],
                //     ),
                //   )
                // else
                AppAssets.icons.mobileMore.svg(),
              ],
            ),
            const SizedBox(height: 20),
            _buildOrderList(
              context,
              ref,
              isWeb,
              state,
              notifier,
              totalPages,
              currentPage,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(OrderTaskState state, OrderTaskViewmodel notifier) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: OrderCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = OrderCategory.values[index];
          final isSelected = category == state.category;
          final count = state.categoryCounts.forCategory(category);
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => notifier.setCategory(category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryDarkGreen
                    : AppColors.tableHeader,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '${category.label} ($count)',
                style: GoogleFonts.hind(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppColors.accentWhite
                      : AppColors.textBlackGrey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderList(
    BuildContext context,
    WidgetRef ref,
    bool isWeb,
    OrderTaskState state,
    OrderTaskViewmodel notifier,
    int totalPages,
    int currentPage,
  ) {
    return Card(
      margin: EdgeInsets.only(top: isWeb ? 40 : 10),
      elevation: 0,
      color: AppColors.backgroundWhite,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order List: ${state.totalOrdersCount}',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppColors.textOrange,
              ),
            ),
            const SizedBox(height: 10),
            _buildListBody(context, ref, isWeb, state, notifier),
            const SizedBox(height: 20),
            Container(
              color: AppColors.backgroundWhite,
              child: PaginationWidget(
                onSelected: (s) =>
                    notifier.setRowsPerPage(_parseRows(s, state.rowsPerPage)),
                labelPerPage: "Orders per page",
                rowsPerPage: state.rowsPerPage,
                isEarning: true,
                showPage: true,
                totalPages: totalPages,
                currentPage: currentPage,
                count: state.totalOrdersCount,
                onPressedBack: state.currentPage > 0
                    ? () => notifier.goToPage(state.currentPage - 1)
                    : null,
                onPressedEnd: state.currentPage < totalPages - 1
                    ? () => notifier.goToPage(totalPages - 1)
                    : null,
                onPressedForward: state.currentPage < totalPages - 1
                    ? () => notifier.goToPage(state.currentPage + 1)
                    : null,
                onPressedStart: state.currentPage > 0
                    ? () => notifier.goToPage(0)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _parseRows(dynamic s, int fallback) {
    if (s is int) return s;
    if (s is double) return s.toInt();
    return int.tryParse(s.toString()) ?? fallback;
  }

  Widget _buildListBody(
    BuildContext context,
    WidgetRef ref,
    bool isWeb,
    OrderTaskState state,
    OrderTaskViewmodel notifier,
  ) {
    return state.orders.when(
      loading: () => OrderTableShimmer(isWeb: isWeb),
      error: (err, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Couldn't load orders.",
                style: GoogleFonts.hind(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlackGrey,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: notifier.refresh,
                child: Text(
                  'Retry',
                  style: GoogleFonts.hind(
                    color: AppColors.primaryDarkGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (orders) {
        if (orders.isEmpty) {
          return _buildEmptyState(isWeb, state, ref);
        }
        return SizedBox(
          height: 400,
          child: Scrollbar(
            thumbVisibility: isWeb,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [OrderTable(orders: orders, isExpanded: true)],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isWeb, OrderTaskState state, WidgetRef ref) {
    final hasActiveFilters =
        state.searchQuery.isNotEmpty ||
        state.activeStatuses.isNotEmpty ||
        state.deliveryType != DeliveryType.all ||
        state.dateFilterType != DateFilterType.all;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 350 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Image.asset(
            AppAssets.images.noOrders.path,
            height: isWeb ? 347 : 155,
            width: isWeb ? 384 : 172,
            fit: BoxFit.cover,
            errorBuilder: (context, exception, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.broken_image,
                  color: AppColors.textIconGrey,
                  size: 50.0,
                ),
              );
            },
          ),
          const SizedBox(height: 25.0),
          Text(
            hasActiveFilters ? "No orders match your filters" : "No orders yet",
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: isWeb ? 32 : 18,
              color: isWeb
                  ? AppColors.textVidaGreen800
                  : AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            hasActiveFilters
                ? 'Try a different search term or clear your filters.'
                : 'Once customers place an order, you’ll see them here. '
                      'Keep your products up to date to attract more orders.',
            textAlign: TextAlign.center,
            style: GoogleFonts.hind(
              fontWeight: isWeb ? FontWeight.w500 : FontWeight.w400,
              fontSize: isWeb ? 16 : 14,
              color: isWeb ? AppColors.textBlackGrey : AppColors.textBodyText,
            ),
          ),
          const SizedBox(height: 30.0),
          if (!hasActiveFilters)
            CustomButton(
              text: 'Add product',
              onPressed: () => pushOnSellerTab(
                ref,
                SellerTab.products,
                (_) => const AddProductScreen(),
              ),
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              prefixIcon: const Icon(
                Icons.add_circle_outline,
                size: 20,
                color: AppColors.accentWhite,
              ),
              height: 48.0,
              padding: EdgeInsets.zero,
              width: isWeb ? 326 : 251,
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class OrderHeaderWeb extends ConsumerWidget {
  const OrderHeaderWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(orderTaskProvider.notifier);
    final state = ref.watch(orderTaskProvider);

    return Row(
      children: [
        _buildDateDropdown(context: context, ref: ref, vm: vm, state: state),
        const SizedBox(width: 12),
        _buildStatusDropdown(vm: vm, state: state),
        const SizedBox(width: 12),
        _buildOrderTypeDropdown(vm: vm, state: state),
        const SizedBox(width: 12),
        _buildSortDropdown(vm: vm, state: state),
      ],
    );
  }

  Widget _buildDateDropdown({
    required BuildContext context,
    required WidgetRef ref,
    required OrderTaskViewmodel vm,
    required OrderTaskState state,
  }) {
    final selected = _dateSelectedValue(state);
    return PopupMenuButton<String>(
      child: _withActiveDot(
        active: selected != null,
        child: FilterButton(
          label: selected == null ? "Date" : "Date: $selected",
        ),
      ),
      onSelected: (value) async {
        if (value == 'all') vm.clearDateFilter();
        if (value == 'today') vm.setTodayFilter();
        if (value == 'custom') {
          vm.syncDateTempWithActive();
          await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (dialogContext) {
              return Consumer(
                builder: (context, dialogRef, child) {
                  final s = dialogRef.watch(orderTaskProvider);
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomMultiDatePicker(
                      initialSelectedDates: s.tempSelectedDates,
                      onDateToggled: (date) => dialogRef
                          .read(orderTaskProvider.notifier)
                          .toggleDateSelection(date),
                      onApply: () {
                        dialogRef
                            .read(orderTaskProvider.notifier)
                            .applyDateFilters();
                        Navigator.pop(dialogContext);
                      },
                    ),
                  );
                },
              );
            },
          );
        }
      },

      itemBuilder: (_) => [
        CheckedPopupMenuItem<String>(
          value: 'all',
          checked: state.dateFilterType == DateFilterType.all,
          child: const Text("All dates"),
        ),
        CheckedPopupMenuItem<String>(
          value: 'today',
          checked: state.dateFilterType == DateFilterType.today,
          child: const Text("Today"),
        ),
        CheckedPopupMenuItem<String>(
          value: 'custom',
          checked: state.dateFilterType == DateFilterType.custom,
          child: const Text("Pick a date range"),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown({
    required OrderTaskViewmodel vm,
    required OrderTaskState state,
  }) {
    final selected = _statusSelectedValue(state);
    return PopupMenuButton<OrderFilter?>(
      onSelected: vm.setSingleStatusFilter,
      itemBuilder: (_) => [
        CheckedPopupMenuItem<OrderFilter?>(
          value: null,
          checked: state.activeStatuses.isEmpty,
          child: const Text('All statuses'),
        ),
        ...OrderFilter.values
            .where((f) => f != OrderFilter.all)
            .map(
              (f) => CheckedPopupMenuItem<OrderFilter?>(
                value: f,
                checked:
                    state.activeStatuses.length == 1 &&
                    state.activeStatuses.single == f,
                child: Text(f.displayName),
              ),
            ),
      ],
      child: _withActiveDot(
        active: selected != null,
        child: FilterButton(
          label: selected == null ? "Status" : "Status: $selected",
        ),
      ),
    );
  }

  Widget _buildOrderTypeDropdown({
    required OrderTaskViewmodel vm,
    required OrderTaskState state,
  }) {
    final selected = _orderTypeSelectedValue(state);
    return PopupMenuButton<DeliveryType>(
      onSelected: vm.setDeliveryType,
      itemBuilder: (_) => DeliveryType.values
          .map(
            (t) => CheckedPopupMenuItem<DeliveryType>(
              value: t,
              checked: state.deliveryType == t,
              child: Text(t.displayName),
            ),
          )
          .toList(),
      child: _withActiveDot(
        active: selected != null,
        child: FilterButton(
          label: selected == null ? "Order Type" : "Order Type: $selected",
        ),
      ),
    );
  }

  Widget _buildSortDropdown({
    required OrderTaskViewmodel vm,
    required OrderTaskState state,
  }) {
    final selected = _sortSelectedValue(state);
    return PopupMenuButton<List<String>>(
      child: _withActiveDot(
        active: selected != null,
        child: FilterButton(
          label: selected == null ? "Sort" : "Sort: $selected",
        ),
      ),
      onSelected: (value) => vm.setSort(value[0], value[1]),
      itemBuilder: (_) => [
        CheckedPopupMenuItem<List<String>>(
          value: const ['date', 'desc'],
          checked: state.sortBy == 'date' && state.sortOrder == 'desc',
          child: const Text('Newest first'),
        ),
        CheckedPopupMenuItem<List<String>>(
          value: const ['date', 'asc'],
          checked: state.sortBy == 'date' && state.sortOrder == 'asc',
          child: const Text('Oldest first'),
        ),
        CheckedPopupMenuItem<List<String>>(
          value: const ['amount', 'desc'],
          checked: state.sortBy == 'amount' && state.sortOrder == 'desc',
          child: const Text('Amount: high to low'),
        ),
        CheckedPopupMenuItem<List<String>>(
          value: const ['amount', 'asc'],
          checked: state.sortBy == 'amount' && state.sortOrder == 'asc',
          child: const Text('Amount: low to high'),
        ),
      ],
    );
  }
}

class OrderHeaderMobile extends ConsumerWidget {
  const OrderHeaderMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(orderTaskProvider.notifier);
    final state = ref.watch(orderTaskProvider);
    final expandedSection = ref.watch(expandedIdProvider);
    final hasFilterActive =
        state.dateFilterType != DateFilterType.all ||
        state.activeStatuses.isNotEmpty ||
        state.deliveryType != DeliveryType.all;
    final hasSortActive = !_isDefaultSort(state);
    return Container(
      height: 64,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuAnchor(
              crossAxisUnconstrained: true,
              alignmentOffset: const Offset(-14, 15),
              builder: (context, controller, child) {
                return GestureDetector(
                  onTap: () {
                    if (!controller.isOpen) {
                      vm.syncTempWithActive();
                      ref.read(expandedIdProvider.notifier).state = null;
                      controller.open();
                    } else {
                      controller.close();
                    }
                  },
                  child: _withActiveDot(
                    active: hasFilterActive,
                    child: FilterButton(
                      label: 'Filters',
                      icon: AppAssets.icons.mobileFilter.svg(),
                    ),
                  ),
                );
              },
              style: MenuStyle(
                backgroundColor: WidgetStateProperty.all(
                  AppColors.backgroundWhite,
                ),
                elevation: WidgetStateProperty.all(6),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                padding: WidgetStateProperty.all(EdgeInsets.zero),
              ),
              menuChildren: [
                Builder(
                  builder: (menuContext) {
                    final controller = MenuController.maybeOf(menuContext);
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // date filter
                              Padding(
                                padding: EdgeInsets.only(
                                  top: expandedSection == 'date' ? 10 : 0,
                                ),
                                child: _buildMenuButton(
                                  ref: ref,
                                  sectionKey: 'date',
                                  menuText: "Date",
                                  isExpanded: expandedSection == 'date',
                                  selectedValue: _dateSelectedValue(state),
                                ),
                              ),
                              if (expandedSection == 'date') ...[
                                _buildMenuItem(
                                  onPressed: () {
                                    vm.clearDateFilter();
                                    controller?.close();
                                  },
                                  itemText: 'All',
                                  isSelected:
                                      state.dateFilterType ==
                                      DateFilterType.all,
                                ),
                                _buildMenuItem(
                                  onPressed: () {
                                    vm.setTodayFilter();
                                    controller?.close();
                                  },
                                  itemText: 'Today',
                                  isSelected:
                                      state.dateFilterType ==
                                      DateFilterType.today,
                                ),
                                _buildMenuItem(
                                  trailingIcon: const Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                  ),
                                  isSelected:
                                      state.dateFilterType ==
                                      DateFilterType.custom,
                                  onPressed: () async {
                                    controller?.close();
                                    vm.syncDateTempWithActive();
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        return Consumer(
                                          builder: (context, ref, child) {
                                            final s = ref.watch(
                                              orderTaskProvider,
                                            );
                                            return Dialog(
                                              backgroundColor:
                                                  Colors.transparent,
                                              insetPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                  ),
                                              child: CustomMultiDatePicker(
                                                initialSelectedDates:
                                                    s.tempSelectedDates,
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

                              Padding(
                                padding: EdgeInsets.only(
                                  top: expandedSection == 'status' ? 10 : 0,
                                ),
                                child: _buildMenuButton(
                                  ref: ref,
                                  sectionKey: 'status',
                                  menuText: "Status",
                                  isExpanded: expandedSection == 'status',
                                  isSelected: false,
                                  newColor:
                                      state.tempSelectedStatuses.isNotEmpty
                                      ? Colors.transparent
                                      : expandedSection == 'status'
                                      ? AppColors.tableHeader
                                      : Colors.transparent,
                                  selectedValue: _statusSelectedValue(state),
                                ),
                              ),
                              if (expandedSection == 'status')
                                ...OrderFilter.values
                                    .where((e) => e != OrderFilter.all)
                                    .map(
                                      (status) => GestureDetector(
                                        onTap: () =>
                                            vm.toggleStatusSelection(status),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            color:
                                                state.tempSelectedStatuses
                                                    .contains(status)
                                                ? AppColors.tableHeader
                                                : Colors.transparent,
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 3,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 35,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  status.displayName,
                                                  style: GoogleFonts.hind(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColors.textBodyText,
                                                  ),
                                                ),
                                                CustomCheckbox2(
                                                  value: state
                                                      .tempSelectedStatuses
                                                      .contains(status),
                                                  onChanged: (_) =>
                                                      vm.toggleStatusSelection(
                                                        status,
                                                      ),
                                                  borderRadius: 2,
                                                  size: 16,
                                                  checkSize: 12,
                                                  borderColor:
                                                      state.tempSelectedStatuses
                                                          .contains(status)
                                                      ? AppColors
                                                            .primaryDarkGreen
                                                      : AppColors.borderColor,
                                                  checkColor: AppColors
                                                      .primaryDarkGreen,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: expandedSection == 'orderType' ? 10 : 0,
                                ),
                                child: _buildMenuButton(
                                  ref: ref,
                                  sectionKey: 'orderType',
                                  isExpanded: expandedSection == 'orderType',
                                  menuText: "Order Type",
                                  selectedValue: _orderTypeSelectedValue(state),
                                ),
                              ),
                              if (expandedSection == 'orderType') ...[
                                _buildMenuItem(
                                  onPressed: () {
                                    vm.setDeliveryType(DeliveryType.all);
                                    controller?.close();
                                  },
                                  itemText: 'All',
                                  isSelected:
                                      state.deliveryType == DeliveryType.all,
                                ),
                                _buildMenuItem(
                                  onPressed: () {
                                    vm.setDeliveryType(DeliveryType.pickUp);
                                    controller?.close();
                                  },
                                  itemText: 'Pick up',
                                  isSelected:
                                      state.deliveryType == DeliveryType.pickUp,
                                ),
                                _buildMenuItem(
                                  onPressed: () {
                                    vm.setDeliveryType(DeliveryType.delivery);
                                    controller?.close();
                                  },
                                  itemText: 'Delivery',
                                  isSelected:
                                      state.deliveryType ==
                                      DeliveryType.delivery,
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (expandedSection == 'status') ...[
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 32,
                            ),
                            child: CustomButton(
                              text: 'Apply Now',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 42,
                              width: 179,
                              onPressed: () {
                                vm.applyFilters();
                                controller?.close();
                              },
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),

            const SizedBox(width: 12),

            MenuAnchor(
              crossAxisUnconstrained: true,
              alignmentOffset: const Offset(-10, 15),
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
                  child: _withActiveDot(
                    active: hasSortActive,
                    child: FilterButton(
                      label: 'Sort By',
                      icon: AppAssets.icons.sortBy.svg(),
                    ),
                  ),
                );
              },
              style: MenuStyle(
                backgroundColor: WidgetStateProperty.all(
                  AppColors.backgroundWhite,
                ),
                elevation: WidgetStateProperty.all(6),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                padding: WidgetStateProperty.all(EdgeInsets.zero),
              ),
              menuChildren: [
                Builder(
                  builder: (menuContext) {
                    final controller = MenuController.maybeOf(menuContext);
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 50,
                        right: 50,
                        top: 8,
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            onPressed: () {
                              vm.setSort('date', 'desc');
                              controller?.close();
                            },
                            isNotAccordion: true,
                            itemText: 'Newest first',
                            isSelected:
                                state.sortBy == 'date' &&
                                state.sortOrder == 'desc',
                          ),
                          _buildMenuItem(
                            onPressed: () {
                              vm.setSort('date', 'asc');
                              controller?.close();
                            },
                            isNotAccordion: true,
                            itemText: 'Oldest first',
                            isSelected:
                                state.sortBy == 'date' &&
                                state.sortOrder == 'asc',
                          ),
                          _buildMenuItem(
                            onPressed: () {
                              vm.setSort('amount', 'desc');
                              controller?.close();
                            },
                            isNotAccordion: true,
                            itemText: 'Amount: high to low',
                            isSelected:
                                state.sortBy == 'amount' &&
                                state.sortOrder == 'desc',
                          ),
                          _buildMenuItem(
                            onPressed: () {
                              vm.setSort('amount', 'asc');
                              controller?.close();
                            },
                            isNotAccordion: true,
                            itemText: 'Amount: low to high',
                            isSelected:
                                state.sortBy == 'amount' &&
                                state.sortOrder == 'asc',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
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
    bool isSelected = false,
  }) {
    final color = isSelected
        ? AppColors.primaryDarkGreen
        : (isNotAccordion ? AppColors.textBlackGrey : AppColors.textBodyText);
    return MenuItemButton(
      onPressed: onPressed,
      trailingIcon: trailingIcon,
      child: Padding(
        padding: EdgeInsets.only(left: isNotAccordion ? 0 : 35),
        child: Text(
          itemText,
          style: GoogleFonts.hind(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required bool isExpanded,
    required String menuText,
    required WidgetRef ref,
    required String sectionKey,
    bool isSelected = true,
    Color? newColor,
    String? selectedValue,
  }) {
    final hasValue = selectedValue != null && selectedValue.isNotEmpty;
    return InkWell(
      onTap: () {
        final notifier = ref.read(expandedIdProvider.notifier);
        notifier.state = isExpanded ? null : sectionKey;
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isSelected
              ? (isExpanded ? AppColors.tableHeader : Colors.transparent)
              : newColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            bottom: 15,
            left: 12,
            right: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menuText,
                      style: GoogleFonts.hind(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                    if (hasValue)
                      Text(
                        selectedValue,
                        style: GoogleFonts.hind(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryDarkGreen,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 50),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
