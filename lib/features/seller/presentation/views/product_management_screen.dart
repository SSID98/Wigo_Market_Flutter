import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/models/seller_product_model.dart';
import 'package:wigo_flutter/features/seller/models/seller_product_task_state.dart';
import 'package:wigo_flutter/features/seller/viewmodels/order_task_viewmodel.dart';
import 'package:wigo_flutter/features/seller/viewmodels/seller_product_task_viewmodel.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/pagination_widget.dart';
import '../../../../core/constants/url.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_search_field.dart';
import '../../models/order_task_state.dart';
import '../../viewmodels/dropdown_providers.dart';
import '../widgets/filter_button.dart';
import '../widgets/hide_delete_product_dialog.dart';
import '../widgets/seller_product_card.dart';

class ProductManagementScreen extends ConsumerWidget {
  const ProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sellerProductTaskProvider);
    final notifier = ref.read(sellerProductTaskProvider.notifier);
    final totalPages = (state.totalProductsCount / state.rowsPerPage).ceil();
    final currentPage = state.currentPage + 1;
    final isWeb = MediaQuery.of(context).size.width > 800;
    final focusNode = ref.watch(searchFocusProvider);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // Drop focus from the search field
        focusNode.unfocus();

        // Drop focus from any other text field to hide keyboard
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Management',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 20,
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
            _buildProductList(
              isWeb,
              state.sellerProducts.value ?? [],
              totalPages,
              currentPage,
              state.totalProductsCount,
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
      ),
    );
  }

  Widget _buildProductList(
    bool isWeb,
    List<SellerProduct> sellerProducts,
    int totalPages,
    int currentPage,
    int count,
    void Function()? onPressedBack,
    void Function()? onPressedEnd,
    void Function()? onPressedForward,
    void Function()? onPressedStart,
    SellerProductTaskState state,
    SellerProductTaskViewmodel vm,
    WidgetRef ref,
    BuildContext context,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Product List: 20',
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: AppColors.textOrange,
                  ),
                ),
                if (sellerProducts.isNotEmpty)
                  MenuAnchor(
                    crossAxisUnconstrained: true,
                    alignmentOffset: const Offset(-43, -15),
                    builder: (context, controller, child) {
                      return TextButton(
                        onPressed: () {
                          ref.read(expandedIdProvider.notifier).state = null;
                          controller.isOpen
                              ? controller.close()
                              : controller.open();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Bulk action',
                              style: GoogleFonts.hind(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppColors.textVidaLocaGreen,
                              ),
                            ),
                            SizedBox(width: 8),
                            AppAssets.icons.arrowDown.svg(
                              colorFilter: ColorFilter.mode(
                                AppColors.primaryDarkGreen,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
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
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      ),
                    ),
                    menuChildren: [
                      MenuItemButton(
                        leadingIcon: AppAssets.icons.hideProduct.svg(),
                        onPressed: () {
                          DialogUtils.showHideDeleteProductDialog(
                            context,
                            isWeb,
                            vm,
                            state,
                            isBulkHideProducts: true,
                          );
                        },
                        child: Text(
                          "Hide Product",
                          style: GoogleFonts.hind(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textBlackGrey,
                          ),
                        ),
                      ),
                      MenuItemButton(
                        leadingIcon: AppAssets.icons.delete.svg(),
                        onPressed: () {},
                        child: Text(
                          "Delete Product",
                          style: GoogleFonts.hind(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.radioOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (sellerProducts.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isWeb ? 350 : 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.network(
                      '$networkImageUrl/noProductAdded.png',
                      height: isWeb ? 344 : 197,
                      width: isWeb ? 453 : 300,
                      fit: BoxFit.fill,
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
                      "No Product Added to your store yet",
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
                      'Start listing your items to reach more buyers and grow your business on Wigo Market.',
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: sellerProducts.length,
                itemBuilder: (context, index) {
                  return SellerProductCard(product: sellerProducts[index]);
                },
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

  Widget _buildStatusDropdown({
    required void Function(OrderFilter) onSelected,
    required bool isWeb,
  }) {
    return PopupMenuButton<OrderFilter>(
      onSelected: onSelected,
      itemBuilder:
          (_) =>
              OrderFilter.values
                  .map((f) => PopupMenuItem(value: f, child: Text(f.name)))
                  .toList(),
      child: FilterButton(label: "Order Status"),
    );
  }
}

class OrderHeaderMobile extends ConsumerWidget {
  const OrderHeaderMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(sellerProductTaskProvider.notifier);
    final state = ref.watch(sellerProductTaskProvider);
    final expandedSection = ref.watch(expandedIdProvider);
    final searchController = ref.watch(searchControllerProvider);
    final focusNode = ref.watch(searchFocusProvider);
    return Container(
      height: 147,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Filters
                MenuAnchor(
                  crossAxisUnconstrained: true,
                  alignmentOffset: const Offset(-14, 15),
                  builder: (context, controller, child) {
                    return GestureDetector(
                      onTap: () {
                        if (!controller.isOpen) {
                          ref
                              .read(sellerProductTaskProvider.notifier)
                              .syncTempWithActive();

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
                            //category filter
                            Padding(
                              padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top:
                                          expandedSection == 'category'
                                              ? 10
                                              : 0,
                                    ),
                                    child: _buildMenuButton(
                                      ref: ref,
                                      sectionKey: 'category',
                                      isExpanded: expandedSection == 'category',
                                      menuText: "Category",
                                    ),
                                  ),
                                  if (expandedSection == 'category') ...[],

                                  //Product Status
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top:
                                              expandedSection == 'productStatus'
                                                  ? 10
                                                  : 0,
                                        ),
                                        child: _buildMenuButton(
                                          ref: ref,
                                          sectionKey: 'productStatus',
                                          isExpanded:
                                              expandedSection ==
                                              'productStatus',
                                          menuText: "Status",
                                        ),
                                      ),
                                      if (expandedSection ==
                                          'productStatus') ...[
                                        _buildMenuItem(
                                          onPressed: () {
                                            vm.filterByProductStatus(
                                              SellerProductStatus.all,
                                            );
                                            controller?.close();
                                          },
                                          itemText: 'All',
                                        ),
                                        _buildMenuItem(
                                          onPressed: () {
                                            vm.filterByProductStatus(
                                              SellerProductStatus.active,
                                            );
                                            controller?.close();
                                          },
                                          itemText: 'Active',
                                        ),
                                        _buildMenuItem(
                                          onPressed: () {
                                            vm.filterByProductStatus(
                                              SellerProductStatus.outOfStock,
                                            );
                                            controller?.close();
                                          },
                                          itemText: 'Out of Stock',
                                        ),
                                        _buildMenuItem(
                                          onPressed: () {
                                            vm.filterByProductStatus(
                                              SellerProductStatus.hidden,
                                            );
                                            controller?.close();
                                          },
                                          itemText: 'Hidden',
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                CustomButton(
                  text: 'Add New product',
                  onPressed: () {},
                  fontSize: 14.0,
                  borderRadius: 2.7,
                  fontWeight: FontWeight.w500,
                  prefixIcon: Icon(
                    Icons.add_circle_outline,
                    size: 17,
                    color: AppColors.accentWhite,
                  ),
                  height: 40,
                  padding: EdgeInsets.zero,
                  width: 160,
                ),
              ],
            ),
            const SizedBox(height: 19),
            MenuAnchor(
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
              crossAxisUnconstrained: false,
              builder: (context, controller, child) {
                return CustomSearchField(
                  hintText: 'Search by product name or SKU',
                  backgroundColor: Colors.transparent,
                  padding: 10,
                  height: 48,
                  borderRadius: 6.5,
                  borderColor: AppColors.borderColor,
                  searchController: searchController,
                  focusNode: focusNode,
                  onChanged: (val) {
                    vm.updateTypingQuery(val);
                    // Logic: Open the menu if we have suggestions, close if empty
                    if (val.isNotEmpty && !controller.isOpen) {
                      controller.open();
                    } else if (val.isEmpty && controller.isOpen) {
                      vm.clearSearch();
                      controller.close();
                    }
                  },
                  onSubmitted: (val) {
                    vm.applySearch(val);
                    controller.close();
                  },
                  trailing: [
                    if (state.searchQuery.isNotEmpty ||
                        state.typingQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          size: 20,
                          color: AppColors.textIconGrey,
                        ),
                        onPressed: () {
                          searchController.clear(); // Clear the text in the UI
                          vm.clearSearch(); // Reset the filter in the logic
                          // if (controller.isOpen) controller.close();
                        },
                      ),
                  ],
                );
              },
              menuChildren:
                  state.searchSuggestions.isEmpty
                      ? [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("No such products found"),
                        ),
                      ]
                      : state.searchSuggestions.map((product) {
                        return MenuItemButton(
                          onPressed: () {
                            searchController.text = product.productName;
                            vm.applySearch(product.productName);
                            // The menu closes automatically on MenuItemButton press
                          },
                          leadingIcon: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              product.imageUrl,
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName,
                                style: GoogleFonts.hind(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlackGrey,
                                ),
                              ),
                              Text(
                                product.productId,
                                style: GoogleFonts.hind(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textBlackGrey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
