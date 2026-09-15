import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/presentation/views/multiple_product_version_views/product_variant_screen.dart';
import 'package:wigo_flutter/features/seller/viewmodels/mulitple_products_viewmodel.dart';
import 'package:wigo_flutter/features/seller/viewmodels/seller_product_text_field_providers.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/custom_search_field.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/helper_methods_classes.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../models/multiple_products_state.dart';
import '../../../viewmodels/categories_provider.dart';
import '../../../viewmodels/seller_product_task_viewmodel.dart';
import '../../widgets/step_progress_indicator.dart';
import '../product_management_screens/product_management_screen.dart';

class MultipleProductInfoScreen extends ConsumerWidget {
  const MultipleProductInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    final state = ref.watch(multipleProductsProvider);
    final vm = ref.read(multipleProductsProvider.notifier);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          vm.reset();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: isWeb
                      ? AppAssets.icons.squareArrowBack.svg()
                      : AppAssets.icons.addproductBackArrow.svg(),
                ),
                SizedBox(width: isWeb ? 10 : 20),
                Text(
                  "Add Multiple Version Product",
                  style: GoogleFonts.hind(
                    color: AppColors.textBlackGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            _buildBody(isWeb, state, vm, ref, context),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    bool isWeb,
    MultipleProductsState state,
    MultipleProductsViewModel vm,
    WidgetRef ref,
    BuildContext context,
  ) {
    String getCategoryDisplay(MultipleProductsState state) {
      if (state.category == null) {
        return 'Select a category that fits your product';
      }
      if (state.subCategory == null) return state.category!;
      return '${state.category} > ${state.subCategory}';
    }

    final categoriesAsync = ref.watch(categoriesProvider);
    final query = ref.watch(categorySearchQueryProvider);
    final searchController = ref.watch(searchControllerProvider);
    final isSearching = query.isNotEmpty;
    final controllers = ref.watch(multipleProductTextControllersProvider);
    return Expanded(
      child: Card(
        elevation: 0,
        color: AppColors.backgroundWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 26, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Basic Product Information",
                    style: GoogleFonts.hind(
                      color: AppColors.textVidaLocaGreen,
                      fontWeight: isWeb ? FontWeight.w700 : FontWeight.w600,
                      fontSize: isWeb ? 20 : 16,
                    ),
                  ),
                  StepProgressIndicator(
                    currentStep: 1,
                    totalSteps: 3,
                    isWeb: isWeb,
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10,
                  top: 8,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tell us the essentials about your product.",
                      style: GoogleFonts.hind(
                        color: isWeb
                            ? AppColors.textBodyText
                            : AppColors.textBlackGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: isWeb ? 18 : 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWeb ? 2 : 1,
                        crossAxisSpacing: isWeb ? 13 : 0,
                        mainAxisSpacing: 15,
                        mainAxisExtent: isWeb ? 95 : 85,
                      ),
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return CustomTextField(
                              label: 'Product Name',
                              hintText: 'e.g., Wireless Bluetooth Speaker',
                              contentPadding: EdgeInsets.only(left: 10),
                              onChanged: (val) => vm.updateProductName(val),
                              controller: controllers["productName"],
                            );
                          case 1:
                            return MenuAnchor(
                              builder: (context, controller, child) {
                                return GestureDetector(
                                  onTap: () => controller.isOpen
                                      ? controller.close()
                                      : controller.open(),
                                  child: AbsorbPointer(
                                    child: CustomTextField(
                                      enabled: false,
                                      label: 'Category',
                                      hintText: getCategoryDisplay(state),
                                      hintTextColor: state.category == null
                                          ? AppColors.textBodyText
                                          : AppColors.textBlack,
                                      contentPadding: EdgeInsets.only(
                                        left: 10,
                                        top: 15,
                                      ),
                                      border: InputBorder.none,
                                      clipRectBorderRadius: 8,
                                      suffixIcon: Icon(
                                        Icons.keyboard_arrow_right_rounded,
                                        color: AppColors.textIconGrey,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              style: anchorMenuStyle(),
                              menuChildren: [
                                Builder(
                                  builder: (menuContext) {
                                    final menuController =
                                        MenuController.maybeOf(menuContext);
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Header
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Categories",
                                                style: GoogleFonts.hind(
                                                  color:
                                                      AppColors.textBlackGrey,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () =>
                                                    menuController?.close(),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: SizedBox(
                                            width: 300,
                                            child: CustomSearchField(
                                              backgroundColor:
                                                  Colors.transparent,
                                              searchController:
                                                  searchController,
                                              hintText: 'Search for a category',
                                              onChanged: (val) =>
                                                  ref
                                                          .read(
                                                            categorySearchQueryProvider
                                                                .notifier,
                                                          )
                                                          .state =
                                                      val,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "All Categories",
                                          style: GoogleFonts.hind(
                                            color: AppColors.textBlackGrey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        categoriesAsync.when(
                                          loading: () =>
                                              const CategoryDropdownShimmer(),
                                          error: (e, _) => Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Failed to load categories",
                                                  style: GoogleFonts.hind(
                                                    color: AppColors.textRed,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  e.toString(),
                                                  style: GoogleFonts.hind(
                                                    color: AppColors.textRed,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                TextButton.icon(
                                                  onPressed: () =>
                                                      ref.invalidate(
                                                        categoriesProvider,
                                                      ),
                                                  icon: const Icon(
                                                    Icons.refresh,
                                                    size: 16,
                                                  ),
                                                  label: Text(
                                                    "Retry",
                                                    style: GoogleFonts.hind(
                                                      color: AppColors
                                                          .primaryDarkGreen,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          data: (categories) {
                                            final filtered =
                                                filterCategoryNodes(
                                                  categories,
                                                  query,
                                                );

                                            if (filtered.isEmpty) {
                                              return Padding(
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      query.isEmpty
                                                          ? "No categories available"
                                                          : "No categories match \"$query\"",
                                                      style: GoogleFonts.hind(
                                                        color: AppColors
                                                            .textBodyText,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    if (query.isEmpty) ...[
                                                      const SizedBox(height: 8),
                                                      TextButton.icon(
                                                        onPressed: () =>
                                                            ref.invalidate(
                                                              categoriesProvider,
                                                            ),
                                                        icon: const Icon(
                                                          Icons.refresh,
                                                          size: 16,
                                                          color: AppColors
                                                              .primaryDarkGreen,
                                                        ),
                                                        label: Text(
                                                          "Refresh",
                                                          style: GoogleFonts.hind(
                                                            color: AppColors
                                                                .primaryDarkGreen,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              );
                                            }

                                            return Column(
                                              children: filtered.map((cat) {
                                                final isExpanded =
                                                    isSearching ||
                                                    ref.watch(
                                                          expandedCategoryProvider,
                                                        ) ==
                                                        cat.name;

                                                if (!cat.hasChildren) {
                                                  return MenuItemButton(
                                                    child: Text(
                                                      cat.name,
                                                      style: GoogleFonts.hind(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors
                                                            .textBlackGrey,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      vm.selectCategory(
                                                        cat.name,
                                                        null,
                                                        categoryId: cat.id,
                                                        specSchema:
                                                            cat.specSchema,
                                                      );
                                                      searchController.clear();
                                                      ref
                                                              .read(
                                                                categorySearchQueryProvider
                                                                    .notifier,
                                                              )
                                                              .state =
                                                          '';
                                                      menuController?.close();
                                                    },
                                                  );
                                                }

                                                return Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        ref
                                                            .read(
                                                              expandedCategoryProvider
                                                                  .notifier,
                                                            )
                                                            .state = isExpanded
                                                            ? null
                                                            : cat.name;
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                4,
                                                              ),
                                                          color: isExpanded
                                                              ? AppColors
                                                                    .tableHeader
                                                              : Colors
                                                                    .transparent,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 15,
                                                                horizontal: 12,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  cat.name,
                                                                  style: GoogleFonts.hind(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: AppColors
                                                                        .textBlackGrey,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 50,
                                                              ),
                                                              Icon(
                                                                isExpanded
                                                                    ? Icons
                                                                          .keyboard_arrow_up
                                                                    : Icons
                                                                          .keyboard_arrow_down,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    if (isExpanded)
                                                      ...cat.children.map(
                                                        (sub) => Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                left: 16,
                                                              ),
                                                          child: MenuItemButton(
                                                            child: Text(
                                                              sub.name,
                                                              style: GoogleFonts.hind(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColors
                                                                    .textBodyText,
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              // Sub inherits parent specSchema from API
                                                              vm.selectCategory(
                                                                cat.name,
                                                                sub.name,
                                                                categoryId:
                                                                    sub.id,
                                                                specSchema: sub
                                                                    .specSchema,
                                                              );
                                                              searchController
                                                                  .clear();
                                                              ref
                                                                      .read(
                                                                        categorySearchQueryProvider
                                                                            .notifier,
                                                                      )
                                                                      .state =
                                                                  '';
                                                              menuController
                                                                  ?.close();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          default:
                            return const SizedBox.shrink();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: 'Product Description',
                      hintText:
                          'Describe your product in detail to help buyers understand what you’re offering. Include materials, dimensions, benefits, or use cases',
                      contentPadding: EdgeInsets.all(10),
                      minLines: 12,
                      maxLines: 16,
                      onChanged: (val) => vm.updateProductDescription(val),
                      controller: controllers["productDescription"],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 50),
              child: CustomButton(
                text: "Next",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 48,
                width: double.infinity,
                onPressed:
                    (state.productName.isEmpty ||
                        state.category == null ||
                        state.productDescription.isEmpty)
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductVariantScreen(),
                          ),
                        );
                      },
                suffixIcon: AppAssets.icons.arrowRight.svg(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
