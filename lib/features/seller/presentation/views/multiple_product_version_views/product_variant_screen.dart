import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/helper_methods.dart';
import 'package:wigo_flutter/features/seller/presentation/views/product_upload_screen.dart';
import 'package:wigo_flutter/features/seller/viewmodels/mulitple_products_viewmodel.dart';
import 'package:wigo_flutter/features/seller/viewmodels/seller_product_text_field_providers.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../models/multiple_products_state.dart';
import '../../widgets/step_progress_indicator.dart';
import '../../widgets/variant_table.dart';
import 'multiple_product_dialog_methods.dart';

class ProductVariantScreen extends ConsumerWidget {
  const ProductVariantScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    final state = ref.watch(multipleProductsProvider);
    final vm = ref.read(multipleProductsProvider.notifier);
    return Padding(
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
    );
  }

  Widget _buildBody(
    bool isWeb,
    MultipleProductsState state,
    MultipleProductsViewModel vm,
    WidgetRef ref,
    BuildContext context,
  ) {
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
                    "Add Product Variants",
                    style: GoogleFonts.hind(
                      color: AppColors.textVidaLocaGreen,
                      fontWeight: isWeb ? FontWeight.w700 : FontWeight.w600,
                      fontSize: isWeb ? 20 : 16,
                    ),
                  ),
                  StepProgressIndicator(
                    currentStep: 2,
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
                      "Add different versions of the product based on size, color.",
                      style: GoogleFonts.hind(
                        color: isWeb
                            ? AppColors.textBodyText
                            : AppColors.textBlackGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: isWeb ? 18 : 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (state.variants.isEmpty) ...[
                      _buildVariantCard(isWeb, ref, context),
                      const SizedBox(height: 20),
                    ],
                    if (state.variants.isNotEmpty)
                      _buildVariantTable(context, ref, isWeb),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (state.variants.isNotEmpty && !state.showVariant)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 50),
                child: CustomButton(
                  text: "Next",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 48,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductUploadScreen(isMultiProduct: true),
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

  Widget _buildVariantCard(bool isWeb, WidgetRef ref, BuildContext context) {
    final vm = ref.read(multipleProductsProvider.notifier);
    final state = ref.watch(multipleProductsProvider);
    return Card(
      elevation: 0,
      color: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: AppColors.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Choose your product’s variations (e.g., color, size).",
              style: GoogleFonts.hind(
                color: AppColors.textBlackGrey,
                fontWeight: FontWeight.w500,
                fontSize: isWeb ? 18 : 16,
              ),
            ),
            const SizedBox(height: 15),
            _buildVariations(isWeb, state, vm, ref),
            const SizedBox(height: 20),
            CustomButton(
              text: "Generate Variant",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 48,
              width: isWeb ? 315 : double.infinity,
              onPressed: () {
                vm.generateVariant(context, ref);
                vm.setCustomSizeMode(false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariations(
    bool isWeb,
    MultipleProductsState state,
    MultipleProductsViewModel vm,
    WidgetRef ref,
  ) {
    final controllers = ref.watch(multipleProductTextControllersProvider);
    return GridView.builder(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWeb ? 5 : 1,
        crossAxisSpacing: isWeb ? 13 : 0,
        mainAxisSpacing: 5,
        mainAxisExtent: isWeb ? 95 : 85,
      ),
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return MenuAnchor(
              builder: (context, controller, child) {
                return GestureDetector(
                  onTap: () => controller.isOpen
                      ? controller.close()
                      : controller.open(),
                  child: AbsorbPointer(
                    child: CustomTextField(
                      enabled: false,
                      label: 'Color',
                      prefixIconPadding: 0,
                      prefixIcon2: state.selectedColorHex != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color(
                                    int.parse(
                                      state.selectedColorHex!.replaceFirst(
                                        '#',
                                        '0xFF',
                                      ),
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            )
                          : null,
                      hintText: state.selectedColorName ?? 'Select Color',
                      hintTextColor: state.selectedColorName != null
                          ? AppColors.textBlack
                          : AppColors.textBodyText,
                      contentPadding: EdgeInsets.only(left: 10, top: 15),
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
                colorVariant(
                  ref: ref,
                  context: context,
                  isWeb: isWeb,
                  onSelect: (name, hex) => vm.updateSelectedColor(name, hex),
                ),
              ],
            );
          case 1:
            if (!state.isCustomSizeMode) {
              return _buildSizeDropdown(ref, state);
            } else {
              return CustomTextField(
                label: 'Custom Size',
                hintText: 'e.g., 42, XXL, 15-inch',
                onChanged: (val) => vm.updateSelectedSize(val),
                autoFocus: true,
                contentPadding: EdgeInsets.only(left: 10),
                suffixIcon: GestureDetector(
                  child: const Icon(
                    Icons.cancel_rounded,
                    size: 20,
                    color: AppColors.textIconGrey,
                  ),
                  onTap: () {
                    vm.setCustomSizeMode(false);
                  },
                ),
              );
            }
          case 2:
            return CustomTextField(
              label: 'Selling Price',
              hintText: 'e.g., 4500',
              contentPadding: EdgeInsets.only(left: 10),
              onChanged: (val) => vm.updateSellingPrice(val),
              controller: controllers["sellingPrice"],
              keyboardType: TextInputType.number,
            );
          case 3:
            return CustomTextField(
              label: 'Stock Quantity',
              hintText: 'e.g., 20',
              contentPadding: EdgeInsets.only(left: 10),
              onChanged: (val) => vm.updateStockQuantity(val),
              keyboardType: TextInputType.number,
              controller: controllers["stockQuantity"],
            );
          case 4:
            return CustomTextField(
              label: 'Stock Keeping Unit (SKU)',
              hintText: 'Unique code to identify this product (e.g., SPK-001)',
              contentPadding: EdgeInsets.only(left: 10),
              onChanged: (val) => vm.updateProductSKU(val),
              controller: controllers["productId"],
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildSizeDropdown(WidgetRef ref, MultipleProductsState state) {
    final vm = ref.read(multipleProductsProvider.notifier);
    return MenuAnchor(
      style: anchorMenuStyle(),
      builder: (context, controller, child) => GestureDetector(
        onTap: () => controller.isOpen ? controller.close() : controller.open(),
        child: AbsorbPointer(
          child: CustomTextField(
            enabled: false,
            label: 'Size',
            hintText: state.selectedSize ?? 'Select Size',
            hintTextColor: state.selectedSize != null
                ? AppColors.textBlack
                : AppColors.textBodyText,
            contentPadding: EdgeInsets.only(left: 10, top: 15),
            border: InputBorder.none,
            clipRectBorderRadius: 8,
            suffixIcon: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: AppColors.textIconGrey,
            ),
          ),
        ),
      ),
      menuChildren: [
        sizeVariant(
          ref: ref,
          onSelect: (size) => vm.updateSelectedSize(size),
          onCustomSize: () => vm.setCustomSizeMode(true),
        ),
      ],
    );
  }

  Widget _buildVariantTable(BuildContext context, WidgetRef ref, bool isWeb) {
    final vm = ref.read(multipleProductsProvider.notifier);
    final state = ref.watch(multipleProductsProvider);
    final variants = state.variants;
    final anySelected = variants.any((v) => v.isSelected);
    final allSelected = state.selectAll;
    final int selectedIndex = variants.indexWhere((v) => v.isSelected);
    return Card(
      elevation: 0,
      color: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: AppColors.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.tableHeader,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 10,
                ),
                child: Text(
                  "Color & Size Variant",
                  style: GoogleFonts.hind(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textVidaLocaGreen,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Each row below represents the variant you created. You can choose to edit or delete a variant and you can choose to delete all created variants at once",
              style: GoogleFonts.hind(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlackGrey,
              ),
            ),
            if (allSelected)
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: CustomButton(
                  text: 'Delete All Variants',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 40,
                  borderRadius: 8,
                  textColor: AppColors.textWhite,
                  buttonColor: AppColors.accentRed,
                  width: 150,
                  onPressed: () => vm.deleteSelected(),
                ),
              ),
            const SizedBox(height: 20),
            VariantTable(),
            if (state.variants.isNotEmpty) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  if (anySelected && !allSelected) ...[
                    CustomButton(
                      text: 'Edit Variant',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 35,
                      borderRadius: 8,
                      padding: EdgeInsets.zero,
                      width: 100,
                      onPressed: () => showEditVariantDialog(
                        context,
                        ref,
                        selectedIndex,
                        isWeb,
                      ),
                    ),
                    const SizedBox(width: 5),
                    CustomButton(
                      text: 'Delete Variant',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 35,
                      borderRadius: 8,
                      textColor: AppColors.textWhite,
                      buttonColor: AppColors.accentRed,
                      padding: EdgeInsets.zero,
                      width: 100,
                      onPressed: () => vm.deleteSelected(),
                    ),
                  ],
                ],
              ),
              if (!state.showVariant && !anySelected)
                CustomButton(
                  text: "Add new Variant",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.textVidaLocaGreen,
                  height: 48,
                  borderWidth: 1.2,
                  borderColor: AppColors.primaryDarkGreen,
                  onPressed: () => vm.setShowVariant(true),
                  buttonColor: Colors.transparent,
                  prefixIcon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: AppColors.primaryDarkGreen,
                    size: 20,
                  ),
                ),
              if (state.showVariant && !anySelected) ...[
                _buildVariations(isWeb, state, vm, ref),
                const SizedBox(height: 15),
                CustomButton(
                  text: "Generate Variant",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 48,
                  width: isWeb ? 315 : double.infinity,
                  onPressed: () {
                    vm.setShowVariant(false);
                    vm.setCustomSizeMode(false);
                    vm.generateVariant(context, ref);
                  },
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
