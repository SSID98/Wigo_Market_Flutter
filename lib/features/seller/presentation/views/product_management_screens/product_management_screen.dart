import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/features/seller/models/seller_product_model.dart';
import 'package:wigo_flutter/features/seller/models/seller_product_task_state.dart';
import 'package:wigo_flutter/features/seller/presentation/views/add_product_screen.dart';
import 'package:wigo_flutter/features/seller/viewmodels/order_task_viewmodel.dart';
import 'package:wigo_flutter/features/seller/viewmodels/seller_product_task_viewmodel.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../shared/widgets/pagination_widget.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_search_field.dart';
import '../../../../../shared/widgets/shimmer_widget.dart';
import '../../../../rider/viewmodels/global_navigation_viewmodel.dart';
import '../../../models/category_node.dart';
import '../../../viewmodels/categories_provider.dart';
import '../../../viewmodels/dropdown_providers.dart';
import '../../widgets/filter_button.dart';
import '../../widgets/hide_delete_product_dialog.dart';
import '../../widgets/menu_anchor_buttons.dart';
import '../../widgets/seller_product_card.dart';

class ProductManagementScreen extends HookConsumerWidget {
  const ProductManagementScreen({super.key});

  static const int _tabIndex = 2;

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
            ref.read(sellerProductTaskProvider.notifier).loadProducts();
          }
        });
      }
      return null;
    }, [isCurrentTab]);

    final state = ref.watch(sellerProductTaskProvider);
    final notifier = ref.read(sellerProductTaskProvider.notifier);
    final totalPages = (state.totalProductsCount / state.rowsPerPage).ceil();
    final currentPage = state.currentPage + 1;
    final isWeb = context.isWeb;
    final focusNode = ref.watch(searchFocusProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        focusNode.unfocus();

        FocusScope.of(context).unfocus();
      },
      child: RefreshIndicator(
        color: AppColors.primaryDarkGreen,
        onRefresh: () => notifier.loadProducts(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
              if (isWeb)
                state.sellerProducts.isLoading
                    ? const SizedBox.shrink()
                    : OrderHeaderWeb()
              else
                state.sellerProducts.isLoading
                    ? const _ProductManagementHeaderShimmer(isWeb: false)
                    : _OrderHeaderMobile(),

              const SizedBox(height: 20),
              _buildProductList(
                isWeb,
                state.sellerProducts,
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
                categoriesAsync,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(
    bool isWeb,
    AsyncValue<List<SellerProduct>> productsAsync,
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
    AsyncValue<List<CategoryNode>> categoriesAsync,
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
                if (productsAsync.isLoading)
                  AppShimmer(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Block(width: 60, height: 6, radius: 8),
                    ),
                  )
                else if (!productsAsync.hasError)
                  Text(
                    'Product List: ${state.totalProductsCount}',
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.textOrange,
                    ),
                  ),
                if (productsAsync.isLoading)
                  AppShimmer(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Block(width: 65, height: 6, radius: 8),
                    ),
                  )
                else if (productsAsync.value?.isNotEmpty == true)
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
                            action: ProductDialogAction.hideMultiple,
                          );
                        },
                        child: Text(
                          "Hide Products",
                          style: GoogleFonts.hind(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textBlackGrey,
                          ),
                        ),
                      ),
                      MenuItemButton(
                        leadingIcon: const Icon(
                          Icons.visibility_outlined,
                          size: 18,
                        ),
                        onPressed: () {
                          DialogUtils.showHideDeleteProductDialog(
                            context,
                            isWeb,
                            vm,
                            state,
                            action: ProductDialogAction.unhideMultiple,
                          );
                        },
                        child: Text(
                          "Unhide Products",
                          style: GoogleFonts.hind(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textBlackGrey,
                          ),
                        ),
                      ),
                      MenuItemButton(
                        leadingIcon: AppAssets.icons.delete.svg(),
                        onPressed: () =>
                            DialogUtils.showHideDeleteProductDialog(
                              context,
                              isWeb,
                              vm,
                              state,
                              action: ProductDialogAction.deleteMultiple,
                            ),
                        child: Text(
                          "Delete Products",
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
            productsAsync.when(
              loading: () => const _ProductListShimmer(count: 6),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.cloud_off_outlined,
                        size: 48,
                        color: AppColors.textIconGrey,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Failed to load products',
                        style: GoogleFonts.hind(
                          color: AppColors.textBodyText,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        e.toString(),
                        style: GoogleFonts.hind(
                          color: AppColors.textRed,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () => ref
                            .read(sellerProductTaskProvider.notifier)
                            .loadProducts(),
                        icon: const Icon(
                          Icons.refresh,
                          color: AppColors.primaryDarkGreen,
                        ),
                        label: Text(
                          'Retry',
                          style: GoogleFonts.hind(
                            color: AppColors.primaryDarkGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              data: (sellerProducts) => sellerProducts.isEmpty
                  ? _buildEmptyState(isWeb, context, vm)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: sellerProducts.length,
                      itemBuilder: (context, index) {
                        return SellerProductCard(
                          product: sellerProducts[index],
                        );
                      },
                    ),
            ),

            const SizedBox(height: 20),
            if (!productsAsync.hasError)
              Container(
                color: AppColors.backgroundWhite,
                child: PaginationWidget(
                  labelPerPage: "Products per page",
                  isEarning: true,
                  showPage: true,
                  totalPages: totalPages,
                  currentPage: currentPage,
                  count: count,
                  rowsPerPage: state.rowsPerPage,
                  onSelected: (rows) => vm.setRowsPerPage(rows),
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

  Widget _buildEmptyState(
    bool isWeb,
    BuildContext context,
    SellerProductTaskViewmodel vm,
  ) {
    return RefreshIndicator(
      onRefresh: () => vm.loadProducts(),
      color: AppColors.primaryDarkGreen,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isWeb ? 350 : 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              AppAssets.images.noProductAdded.path,
              height: isWeb ? 344 : 197,
              width: isWeb ? 453 : 300,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(
                  Icons.broken_image,
                  color: AppColors.textIconGrey,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "No Product Added to your store yet",
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: isWeb ? 32 : 18,
                color: isWeb
                    ? AppColors.textVidaGreen800
                    : AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Start listing your items to reach more buyers and grow your business on Wigo Market.',
              textAlign: TextAlign.center,
              style: GoogleFonts.hind(
                fontWeight: isWeb ? FontWeight.w500 : FontWeight.w400,
                fontSize: isWeb ? 16 : 14,
                color: isWeb ? AppColors.textBlackGrey : AppColors.textBodyText,
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Add product',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddProductScreen()),
              ),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              prefixIcon: const Icon(
                Icons.add_circle_outline,
                size: 20,
                color: AppColors.accentWhite,
              ),
              height: 48,
              padding: EdgeInsets.zero,
              width: isWeb ? 326 : 251,
            ),
            const SizedBox(height: 20),
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
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'today', child: Text("Today")),
        const PopupMenuItem(value: 'custom', child: Text("Custom date")),
      ],
    );
  }

  //
  // Widget _buildStatusDropdown({
  //   required void Function(OrderFilter) onSelected,
  //   required bool isWeb,
  // }) {
  //   return PopupMenuButton<OrderFilter>(
  //     onSelected: onSelected,
  //     itemBuilder: (_) => OrderFilter.values
  //         .map((f) => PopupMenuItem(value: f, child: Text(f.name)))
  //         .toList(),
  //     child: FilterButton(label: "Order Status"),
  //   );
  // }
}

class _OrderHeaderMobile extends ConsumerWidget {
  const _OrderHeaderMobile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(sellerProductTaskProvider.notifier);
    final state = ref.watch(sellerProductTaskProvider);
    final expandedSection = ref.watch(expandedIdProvider);
    final searchController = ref.watch(searchControllerProvider);
    final focusNode = ref.watch(searchFocusProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final hasActiveFilter =
        state.productStatus != SellerProductStatus.all ||
        state.filterCategoryId != null;
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
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          FilterButton(
                            label: 'Filters',
                            icon: AppAssets.icons.mobileFilter.svg(),
                          ),
                          if (hasActiveFilter)
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
                        final selectedCategoryName =
                            state.filterCategoryId == null
                            ? null
                            : categoriesAsync.value
                                  ?.where((c) => c.id == state.filterCategoryId)
                                  .map((c) => c.name)
                                  .firstOrNull;
                        return Column(
                          children: [
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
                                      top: expandedSection == 'category'
                                          ? 10
                                          : 0,
                                    ),
                                    child: buildMenuButton(
                                      ref: ref,
                                      sectionKey: 'category',
                                      isExpanded: expandedSection == 'category',
                                      menuText: "Category",
                                      selectedValue: selectedCategoryName,
                                    ),
                                  ),
                                  if (expandedSection == 'category')
                                    categoriesAsync.when(
                                      loading: () => const Padding(
                                        padding: EdgeInsets.all(8),
                                        child: CategoryDropdownShimmer(),
                                      ),
                                      error: (_, __) =>
                                          const CategoryDropdownShimmer(),
                                      data: (cats) => Column(
                                        children: [
                                          buildMenuItem(
                                            trailingIcon: const Icon(
                                              Icons.check_rounded,
                                              color: AppColors.primaryDarkGreen,
                                              size: 16,
                                            ),
                                            onPressed: () {
                                              vm.filterByCategory(null);
                                              controller?.close();
                                            },
                                            itemText: 'All Categories',
                                            isSelected:
                                                state.filterCategoryId == null,
                                          ),
                                          ...cats.map(
                                            (cat) => buildMenuItem(
                                              onPressed: () {
                                                vm.filterByCategory(cat.id);
                                                controller?.close();
                                              },
                                              itemText: cat.name,
                                              isSelected:
                                                  state.filterCategoryId ==
                                                  cat.id,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                        child: buildMenuButton(
                                          ref: ref,
                                          sectionKey: 'productStatus',
                                          isExpanded:
                                              expandedSection ==
                                              'productStatus',
                                          menuText: "Status",
                                          selectedValue:
                                              state.productStatus ==
                                                  SellerProductStatus.all
                                              ? null
                                              : state.productStatus.displayName,
                                        ),
                                      ),
                                      if (expandedSection ==
                                          'productStatus') ...[
                                        buildMenuItem(
                                          onPressed: () {
                                            vm.filterByProductStatus(
                                              SellerProductStatus.all,
                                            );
                                            controller?.close();
                                          },
                                          itemText: 'All',
                                          trailingIcon: const Icon(
                                            Icons.check_rounded,
                                            color: AppColors.primaryDarkGreen,
                                            size: 16,
                                          ),
                                          isSelected:
                                              state.productStatus ==
                                              SellerProductStatus.all,
                                        ),
                                        buildMenuItem(
                                          onPressed: () {
                                            vm.filterByProductStatus(
                                              SellerProductStatus.active,
                                            );
                                            controller?.close();
                                          },
                                          itemText: 'Active',
                                          isSelected:
                                              state.productStatus ==
                                              SellerProductStatus.active,
                                        ),
                                        buildMenuItem(
                                          onPressed: () {
                                            vm.filterByProductStatus(
                                              SellerProductStatus.outOfStock,
                                            );
                                            controller?.close();
                                          },
                                          itemText: 'Out of Stock',
                                          isSelected:
                                              state.productStatus ==
                                              SellerProductStatus.outOfStock,
                                        ),
                                        buildMenuItem(
                                          onPressed: () {
                                            vm.filterByProductStatus(
                                              SellerProductStatus.hidden,
                                            );
                                            controller?.close();
                                          },
                                          itemText: 'Hidden',
                                          isSelected:
                                              state.productStatus ==
                                              SellerProductStatus.hidden,
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddProductScreen()),
                    );
                  },
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
                    if (val.isNotEmpty && !controller.isOpen) {
                      controller.open();
                    } else if (val.isEmpty && controller.isOpen) {
                      controller.close();
                    }
                  },
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      vm.applySearch(val.trim());
                    }
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
                          searchController.clear();
                          vm.clearSearch();
                          if (controller.isOpen) controller.close();
                        },
                      ),
                  ],
                );
              },
              menuChildren: state.searchSuggestions.isEmpty
                  ? [
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("No such products found"),
                      ),
                    ]
                  : state.searchSuggestions.map((product) {
                      return MenuItemButton(
                        onPressed: () {
                          searchController.text = product.title;
                          vm.applySearch(product.title);
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
                              product.title,
                              style: GoogleFonts.hind(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBlackGrey,
                              ),
                            ),
                            if (product.sku != null)
                              Text(
                                product.sku!,
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
}

class _ProductCardShimmer extends StatelessWidget {
  const _ProductCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: AppShimmer(
                  child: const Block(
                    width: double.infinity,
                    height: 62,
                    radius: 3,
                  ),
                ),
              ),

              const SizedBox(width: 5),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmer(child: const Block(width: 180, height: 14)),

                      const SizedBox(height: 5),

                      AppShimmer(child: const Block(width: 130, height: 14)),

                      const SizedBox(height: 10),
                      AppShimmer(
                        child: Row(
                          children: const [
                            Block(width: 90, height: 12),
                            SizedBox(width: 12),
                            Block(width: 75, height: 12),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                      AppShimmer(
                        child: Row(
                          children: const [
                            Block(width: 85, height: 14),
                            SizedBox(width: 12),
                            Block(width: 65, height: 12),
                            SizedBox(width: 12),
                            Block(width: 65, height: 12),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                      AppShimmer(
                        child: Row(
                          children: const [
                            Block(width: 45, height: 12),
                            SizedBox(width: 4),
                            Block(width: 70, height: 24, radius: 12),
                            SizedBox(width: 14),
                            Block(width: 105, height: 18, radius: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 2,
            left: 2,
            child: AppShimmer(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  border: Border.all(color: AppColors.borderColor1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          Positioned(
            top: 4,
            right: 5,
            child: AppShimmer(
              child: Container(
                width: 14,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(2.22),
                ),
                child: const Center(
                  child: Block(width: 4, height: 12, radius: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductListShimmer extends StatelessWidget {
  final int count;

  const _ProductListShimmer({this.count = 6});

  @override
  Widget build(BuildContext context) => Column(
    children: List.generate(count, (_) => const _ProductCardShimmer()),
  );
}

class CategoryDropdownShimmer extends StatelessWidget {
  const CategoryDropdownShimmer({super.key});

  static const _widths = [160.0, 140.0, 200.0, 120.0, 180.0, 150.0];

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            6,
            (i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Block(width: _widths[i % _widths.length], height: 14),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductManagementHeaderShimmer extends StatelessWidget {
  final bool isWeb;

  const _ProductManagementHeaderShimmer({required this.isWeb});

  @override
  Widget build(BuildContext context) {
    if (isWeb) return const SizedBox.shrink();

    return AppShimmer(
      child: Container(
        height: 147,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Block(width: 90, height: 36, radius: 8),
                Block(width: 140, height: 40, radius: 4),
              ],
            ),
            const SizedBox(height: 19),
            const Block(height: 48, radius: 6),
          ],
        ),
      ),
    );
  }
}
