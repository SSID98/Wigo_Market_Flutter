import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/models/multiple_products_state.dart';
import 'package:wigo_flutter/features/seller/viewmodels/seller_product_text_field_providers.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/helper_methods.dart';

class MultipleProductsViewModel extends StateNotifier<MultipleProductsState> {
  MultipleProductsViewModel() : super(const MultipleProductsState());

  void updateProductName(String name) =>
      state = state.copyWith(productName: name);

  void updateProductSKU(String id) => state = state.copyWith(productId: id);

  void updateSellingPrice(String sellingPrice) =>
      state = state.copyWith(sellingPrice: sellingPrice);

  void updateStockQuantity(String stock) =>
      state = state.copyWith(stockQuantity: stock);

  void updateProductDescription(String productDescription) =>
      state = state.copyWith(productDescription: productDescription);

  void selectCategory(String cat, String? sub) {
    state = MultipleProductsState(
      productName: state.productName,
      productId: state.productId,
      category: cat,
      subCategory: sub,
      currentStep: state.currentStep,
      totalSteps: state.totalSteps,
      imagePaths: state.imagePaths,
      videoPath: state.videoPath,
    );
  }

  void updateSelectedColor(String name, String hex) {
    state = state.copyWith(selectedColorName: name, selectedColorHex: hex);
  }

  void updateSelectedSize(String size) {
    state = state.copyWith(selectedSize: size);
  }

  void setCustomSizeMode(bool val) =>
      state = state.copyWith(isCustomSizeMode: val);

  void setShowVariant(bool val) => state = state.copyWith(showVariant: val);

  void addVariant(ProductVariant variant) {
    // 1. Validation Check
    bool exists = state.variants.any(
      (v) =>
          (v.colorHex == variant.colorHex && v.size == variant.size) ||
          (v.sku == variant.sku),
    );

    if (exists) {
      throw Exception("Variant with this Color/Size or SKU already exists!");
    }

    state = state.copyWith(variants: [...state.variants, variant]);
  }

  void toggleSelection(int index) {
    final newList = List<ProductVariant>.from(state.variants);
    newList[index] = newList[index].copyWith(
      isSelected: !newList[index].isSelected,
    );
    state = state.copyWith(variants: newList);
  }

  void toggleSelectAll(bool? val) {
    final select = val ?? false;
    state = state.copyWith(
      selectAll: select,
      variants: state.variants
          .map((v) => v.copyWith(isSelected: select))
          .toList(),
    );
  }

  void deleteSelected() {
    state = state.copyWith(
      variants: state.variants.where((v) => !v.isSelected).toList(),
      selectAll: false,
    );
  }

  void updateVariant(int index, ProductVariant updated) {
    final newList = List<ProductVariant>.from(state.variants);
    newList[index] = updated;
    state = state.copyWith(variants: newList);
  }

  void clearVariantInputs() {
    state = state.copyWith(
      sellingPrice: '',
      stockQuantity: '',
      productId: '',
      selectedColorName: null,
      selectedColorHex: null,
      selectedSize: null,
    );
  }

  void nextStep() {
    if (state.currentStep < state.totalSteps) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void reset() {
    state = const MultipleProductsState();
  }

  void generateVariant(BuildContext context, WidgetRef ref) {
    final controllers = ref.watch(multipleProductTextControllersProvider);
    if (state.selectedColorName == null ||
        state.selectedSize == null ||
        state.sellingPrice.isEmpty ||
        state.productId.isEmpty ||
        state.stockQuantity.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryDarkGreen,
          content: Text(
            "Please fill all variant fields",
            style: GoogleFonts.hind(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
        ),
      );
      return;
    }

    final newVariant = ProductVariant(
      colorName: state.selectedColorName!,
      colorHex: state.selectedColorHex ?? "#000000",
      size: state.selectedSize!,
      price: state.sellingPrice,
      stock: state.stockQuantity,
      sku: state.productId,
    );

    try {
      addVariant(newVariant);
      clearVariantInputs();
      controllers["productId"]?.clear();
      controllers["sellingPrice"]?.clear();
      controllers["stockQuantity"]?.clear();
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryDarkGreen,
          content: Text(
            "Variant added successfully!",
            style: GoogleFonts.hind(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryDarkGreen,
          content: Text(
            e.toString().replaceAll("Exception: ", ""),
            style: GoogleFonts.hind(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textWhite,
            ),
          ),
        ),
      );
    }
  }
}

final multipleProductsProvider =
    StateNotifierProvider<MultipleProductsViewModel, MultipleProductsState>((
      ref,
    ) {
      return MultipleProductsViewModel();
    });
final specsPageProvider = StateProvider<int>((ref) => 1);

void resetMultipleProductFlow(WidgetRef ref) {
  ref.read(multipleProductsProvider.notifier).reset();
  ref.read(expandedCategoryProvider.notifier).state = null;
  ref.read(isCategoryOpenProvider.notifier).state = false;
  ref.read(categorySearchQueryProvider.notifier).state = '';
  ref.read(specsPageProvider.notifier).state = 1;
}
