import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/order_table.dart';
import 'package:wigo_flutter/features/seller/viewmodels/order_task_viewmodel.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_search_field.dart';
import '../../../../../shared/widgets/pagination_widget.dart';
import '../../../../core/constants/url.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_checkbox_2.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../models/order.dart';
import '../../models/order_task_state.dart';
import '../../viewmodels/dropdown_providers.dart';
import '../widgets/custom_multi_date_picker.dart';
import '../widgets/filter_button.dart';

class OrderManagementScreen extends ConsumerWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderTaskProvider);
    final notifier = ref.read(orderTaskProvider.notifier);
    final totalPages = (state.totalOrdersCount / state.rowsPerPage).ceil();
    final currentPage = state.currentPage + 1;
    final isWeb = MediaQuery.of(context).size.width > 800;

    return SingleChildScrollView(
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
                ),
              ),
              if (isWeb)
                SizedBox(
                  width: 91,
                  height: isWeb ? 26 : 37,
                  child: CustomDropdownField(
                    radius: 4,
                    menuItemPadding: EdgeInsets.only(left: 22),
                    itemTextColor: AppColors.primaryDarkGreen,
                    fillColor: Colors.transparent,
                    hintFontSize: 12,
                    hintTextColor: AppColors.primaryDarkGreen,
                    sizeBoxHeight: 37,
                    iconHeight: 14,
                    hintFontWeight: FontWeight.w500,
                    iconWidth: 14,
                    itemsFontSize: 12,
                    hintText: 'Bulk action',
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
                )
              else
                AppAssets.icons.mobileMore.svg(),
            ],
          ),
          const SizedBox(height: 20),
          _buildOrderList(
            isWeb,
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
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOrderList(
    bool isWeb,
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
              'Recent Order List: 20',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppColors.textOrange,
              ),
            ),
            const SizedBox(height: 10),
            if (orders.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isWeb ? 350 : 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.network(
                      '$networkImageUrl/noOrders.png',
                      height: isWeb ? 347 : 155,
                      width: isWeb ? 384 : 172,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        BuildContext context,
                        Object exception,
                        StackTrace? stackTrace,
                      ) {
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
                      "No orders yet",
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: isWeb ? 32 : 18,
                        color:
                            isWeb
                                ? AppColors.textVidaGreen800
                                : AppColors.textBlackGrey,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Once customers place an order, you’ll see them here. Keep your products up to date to attract more orders.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.hind(
                        fontWeight: isWeb ? FontWeight.w500 : FontWeight.w400,
                        fontSize: isWeb ? 16 : 14,
                        color:
                            isWeb
                                ? AppColors.textBlackGrey
                                : AppColors.textBodyText,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    CustomButton(
                      text: 'Add product',
                      onPressed: () {},
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      prefixIcon: Icon(
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
              )
            else
              SizedBox(
                height: 400,
                child: Scrollbar(
                  thumbVisibility: isWeb ? true : false,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [OrderTable(orders: orders, isExpanded: true)],
                  ),
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
}

class OrderHeaderWeb extends ConsumerWidget {
  const OrderHeaderWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(orderTaskProvider.notifier);
    final isWeb = MediaQuery.of(context).size.width > 800;
    return Row(
      children: [
        _buildDateDropdown(
          onToday: vm.setTodayFilter,
          isWeb: isWeb,
          onCustom: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
            );
            if (picked != null) vm.setCustomDate(picked);
          },
        ),

        const SizedBox(width: 12),

        // _buildStatusDropdown(onSelected: vm.setFilter, isWeb: isWeb),
      ],
    );
  }

  Widget _buildDateDropdown({
    required VoidCallback onToday,
    required VoidCallback onCustom,
    required bool isWeb,
  }) {
    return PopupMenuButton<String>(
      child: FilterButton(label: "Date"),
      onSelected: (value) {
        if (value == 'today') onToday();
        if (value == 'custom') onCustom();
      },
      itemBuilder:
          (_) => [
            const PopupMenuItem(value: 'today', child: Text("Today")),
            const PopupMenuItem(value: 'custom', child: Text("Custom date")),
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
            //Filters
            MenuAnchor(
              crossAxisUnconstrained: true,
              alignmentOffset: const Offset(-14, 15),
              builder: (context, controller, child) {
                return GestureDetector(
                  onTap: () {
                    if (!controller.isOpen) {
                      ref.read(orderTaskProvider.notifier).syncTempWithActive();

                      ref.read(expandedIdProvider.notifier).state = null;

                      controller.open();
                    } else {
                      controller.close();
                    }
                    // ref.read(expandedIdProvider.notifier).state =
                    //     null;
                    // controller.isOpen ? controller.close() : controller.open();
                  },
                  child: FilterButton(
                    label: 'Filters',
                    icon: AppAssets.icons.mobileFilter.svg(),
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
                          padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //date filter
                              Padding(
                                padding: EdgeInsets.only(
                                  top: expandedSection == 'date' ? 10 : 0,
                                ),
                                child: _buildMenuButton(
                                  ref: ref,
                                  sectionKey: 'date',
                                  menuText: "Date",
                                  isExpanded: expandedSection == 'date',
                                ),
                              ),
                              if (expandedSection == 'date') ...[
                                _buildMenuItem(
                                  onPressed: () {
                                    vm.setTodayFilter();
                                    controller?.close();
                                  },
                                  itemText: 'Today',
                                ),
                                _buildMenuItem(
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
                                              backgroundColor:
                                                  Colors.transparent,
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

                              //status filter
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
                                ),
                              ),
                              if (expandedSection == 'status')
                                ...OrderFilter.values
                                    .where((e) => e != OrderFilter.all)
                                    .map(
                                      (status) => GestureDetector(
                                        onTap:
                                            () => vm.toggleStatusSelection(
                                              status,
                                            ),
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
                                                  onChanged:
                                                      (_) => vm
                                                          .toggleStatusSelection(
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
                                                          : AppColors
                                                              .borderColor,
                                                  checkColor:
                                                      AppColors
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
                                ),
                              ),
                              if (expandedSection == 'orderType') ...[
                                _buildMenuItem(
                                  onPressed: () {
                                    vm.setDeliveryType(DeliveryType.all);
                                    controller?.close();
                                  },
                                  itemText: 'All',
                                ),
                                _buildMenuItem(
                                  onPressed: () {
                                    vm.setDeliveryType(DeliveryType.pickUp);
                                    controller?.close();
                                  },
                                  itemText: 'Pick up',
                                ),
                                _buildMenuItem(
                                  onPressed: () {
                                    vm.setDeliveryType(DeliveryType.delivery);
                                    controller?.close();
                                  },
                                  itemText: 'Delivery',
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (expandedSection == 'status') ...[
                          Divider(),
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

            //Sort By
            MenuAnchor(
              crossAxisUnconstrained: true,
              alignmentOffset: const Offset(-40, 15),
              builder: (context, controller, child) {
                return GestureDetector(
                  onTap: () {
                    if (!controller.isOpen) {
                      ref.read(orderTaskProvider.notifier).syncTempWithActive();

                      ref.read(expandedIdProvider.notifier).state = null;

                      controller.open();
                    } else {
                      controller.close();
                    }
                  },
                  child: FilterButton(
                    label: 'Sort By',
                    icon: AppAssets.icons.sortBy.svg(),
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
                    return Padding(
                      padding: EdgeInsets.only(left: 50, right: 50, top: 8),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            onPressed: () {},
                            isNotAccordion: true,
                            itemText: 'Recent Orders',
                          ),
                          _buildMenuItem(
                            onPressed: () {},
                            isNotAccordion: true,
                            itemText: 'Ongoing Orders',
                          ),
                          _buildMenuItem(
                            onPressed: () {},
                            isNotAccordion: true,
                            itemText: 'Order History',
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
            color:
                isNotAccordion
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
    required WidgetRef ref,
    required String sectionKey,
    bool isSelected = true,
    Color? newColor,
  }) {
    return InkWell(
      onTap: () {
        final notifier = ref.read(expandedIdProvider.notifier);
        notifier.state = isExpanded ? null : sectionKey;
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color:
              isSelected
                  ? isExpanded
                      ? AppColors.tableHeader
                      : Colors.transparent
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
                child: Text(
                  menuText,
                  style: GoogleFonts.hind(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textBlackGrey,
                  ),
                ),
              ),
              const SizedBox(width: 100),
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
