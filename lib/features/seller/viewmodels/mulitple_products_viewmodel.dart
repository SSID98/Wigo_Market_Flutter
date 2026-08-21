import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wigo_flutter/features/seller/models/multiple_products_state.dart';
import 'package:wigo_flutter/features/seller/viewmodels/seller_product_text_field_providers.dart';
import 'package:wigo_flutter/features/seller/viewmodels/upload_file_viewmodel.dart';
import 'package:wigo_flutter/shared/widgets/custom_banner.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/custom_loading_overlay.dart';
import '../services/seller_api_service.dart';

class MultipleProductsViewModel extends StateNotifier<MultipleProductsState> {
  final SellerApiService api;

  MultipleProductsViewModel(this.api) : super(const MultipleProductsState());

  final ValueNotifier<String?> selectedRam = ValueNotifier(null);
  final ValueNotifier<String?> selectedRom = ValueNotifier(null);
  final ValueNotifier<String?> selectedModelYear = ValueNotifier(null);
  final ValueNotifier<String?> selectedUSBPort = ValueNotifier(null);
  final ValueNotifier<String?> selectedConnectivity = ValueNotifier(null);
  final ValueNotifier<String?> selectedWarranty = ValueNotifier(null);
  final ValueNotifier<String?> selectedWarrantyType = ValueNotifier(null);
  final ValueNotifier<String?> selectedCameraSpec = ValueNotifier(null);
  final ValueNotifier<String?> selectedBattery = ValueNotifier(null);
  final ValueNotifier<String?> selectedNetworkType = ValueNotifier(null);
  final ValueNotifier<String?> selectedSimConfig = ValueNotifier(null);

  void updateOS(String? v) => state = state.copyWith(oS: v);

  void updateProcessorType(String? v) =>
      state = state.copyWith(processorType: v);

  void updateRam(String? v) {
    state = state.copyWith(ramSize: v);
    selectedRam.value = v;
  }

  void updateRom(String? v) {
    state = state.copyWith(rom: v);
    selectedRom.value = v;
  }

  void updateDisplayResolution(String? v) =>
      state = state.copyWith(displayResolution: v);

  void updateCameraSpecs(String? v) {
    state = state.copyWith(cameraSpecs: v);
    selectedCameraSpec.value = v;
  }

  void updateScreenSize(String? v) => state = state.copyWith(screenSize: v);

  void updateBattery(String? v) {
    state = state.copyWith(battery: v);
    selectedBattery.value = v;
  }

  void updateNetworkType(String? v) {
    state = state.copyWith(networkType: v);
    selectedNetworkType.value = v;
  }

  void updateSimConfig(String? v) {
    state = state.copyWith(simConfig: v);
    selectedSimConfig.value = v;
  }

  void updateDimensions(String? v) => state = state.copyWith(dimensions: v);

  void updateWarranty(String? v) {
    state = state.copyWith(warranty: v);
    selectedWarranty.value = v;
  }

  void updateWarrantyType(String? warrantyType) {
    state = state.copyWith(warrantyType: warrantyType);
    selectedWarrantyType.value = warrantyType;
  }

  void updateModelYear(String? v) {
    state = state.copyWith(modelYear: v);
    selectedModelYear.value = v;
  }

  void updateGraphicsCard(String? v) => state = state.copyWith(graphicsCard: v);

  void updateUsbPorts(String? v) {
    state = state.copyWith(usbPorts: v);
    selectedUSBPort.value = v;
  }

  void updateConnectivity(String? v) {
    state = state.copyWith(connectivity: v);
    selectedConnectivity.value = v;
  }

  bool get needsMobileSpecsScreen => state.specSchema == 'phone';

  bool get needsComputerSpecsScreen {
    final s = state.specSchema;
    if (s == null) return false;
    return s.contains('laptop') ||
        s.contains('computer') ||
        s.contains('desktop');
  }

  void updateProductName(String name) =>
      state = state.copyWith(productName: name);

  void updateProductSKU(String id) => state = state.copyWith(productId: id);

  void updateSellingPrice(String sellingPrice) =>
      state = state.copyWith(sellingPrice: sellingPrice);

  void updateStockQuantity(String stock) =>
      state = state.copyWith(stockQuantity: stock);

  void updateProductDescription(String productDescription) =>
      state = state.copyWith(productDescription: productDescription);

  void selectCategory(
    String cat,
    String? sub, {
    String? categoryId,
    String? specSchema,
  }) {
    // Use copyWith to preserve variants and all other fields
    state = state.copyWith(
      category: cat,
      subCategory: sub,
      categoryId: categoryId,
      specSchema: specSchema,
      // Clear spec fields since they're category-specific
      oS: null,
      processorType: null,
      ramSize: null,
      rom: null,
      cameraSpecs: null,
      modelYear: null,
      usbPorts: null,
      networkType: null,
      warranty: null,
      battery: null,
      connectivity: null,
      dimensions: null,
      simConfig: null,
      displayResolution: null,
      screenSize: null,
      graphicsCard: null,
    );
    for (final n in [
      selectedRam,
      selectedRom,
      selectedModelYear,
      selectedUSBPort,
      selectedConnectivity,
      selectedWarranty,
      selectedCameraSpec,
      selectedBattery,
      selectedNetworkType,
      selectedSimConfig,
    ]) {
      n.value = null;
    }
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
    for (final n in [
      selectedRam,
      selectedRom,
      selectedModelYear,
      selectedUSBPort,
      selectedConnectivity,
      selectedWarranty,
      selectedCameraSpec,
      selectedBattery,
      selectedNetworkType,
      selectedSimConfig,
    ]) {
      n.value = null;
    }
  }

  void generateVariant(BuildContext context, WidgetRef ref) {
    final controllers = ref.read(multipleProductTextControllersProvider);
    if (state.selectedColorName == null ||
        state.selectedSize == null ||
        state.sellingPrice.isEmpty ||
        state.productId.isEmpty ||
        state.stockQuantity.isEmpty) {
      showErrorBanner("Please fill all variant fields", context);
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

      showSuccessBanner("Variant added successfully!", context);
    } catch (e) {
      showErrorBanner(e.toString().replaceAll("Exception: ", ""), context);
    }
  }

  Map<String, dynamic> _buildPhoneSpecifications() {
    final s = state;
    return {
      if (s.oS?.isNotEmpty == true) 'operatingSystem': s.oS,
      if (s.processorType?.isNotEmpty == true) 'processorType': s.processorType,
      if (s.ramSize?.isNotEmpty == true) 'ramSize': s.ramSize,
      if (s.rom?.isNotEmpty == true) 'romSize': s.rom,
      if (s.cameraSpecs?.isNotEmpty == true) 'cameraSpecs': s.cameraSpecs,
      if (s.screenSize?.isNotEmpty == true) 'screenSize': s.screenSize,
      if (s.battery?.isNotEmpty == true) 'batteryCapacity': s.battery,
      if (s.networkType?.isNotEmpty == true) 'networkType': s.networkType,
      if (s.simConfig?.isNotEmpty == true) 'simConfiguration': s.simConfig,
      if (s.displayResolution?.isNotEmpty == true)
        'displayResolution': s.displayResolution,
      if (s.dimensions?.isNotEmpty == true) 'dimensions': s.dimensions,
      'warrantyType': 'Seller Warranty',
      if (s.warranty?.isNotEmpty == true) 'warrantyDuration': s.warranty,
    };
  }

  Map<String, dynamic> _buildLaptopSpecifications() {
    final s = state;
    return {
      if (s.oS?.isNotEmpty == true) 'operatingSystem': s.oS,
      if (s.processorType?.isNotEmpty == true) 'processorCpu': s.processorType,
      if (s.ramSize?.isNotEmpty == true) 'ramSize': s.ramSize,
      if (s.rom?.isNotEmpty == true) 'romStorage': s.rom,
      if (s.modelYear?.isNotEmpty == true) 'modelYear': s.modelYear,
      if (s.graphicsCard?.isNotEmpty == true) 'graphicsCard': s.graphicsCard,
      if (s.displayResolution?.isNotEmpty == true)
        'displayResolution': s.displayResolution,
      if (s.screenSize?.isNotEmpty == true) 'screenSize': s.screenSize,
      if (s.battery?.isNotEmpty == true) 'batteryLife': s.battery,
      if (s.usbPorts?.isNotEmpty == true) 'usbPorts': s.usbPorts,
      if (s.connectivity?.isNotEmpty == true)
        'connectivityFeatures': s.connectivity,
      if (s.dimensions?.isNotEmpty == true) 'dimensions': s.dimensions,
      if (s.warrantyType?.isNotEmpty == true) 'warrantyType': s.warrantyType,
      if (s.warranty?.isNotEmpty == true) 'warrantyDuration': s.warranty,
    };
  }

  Future<bool> submit(BuildContext context, WidgetRef ref) async {
    if (state.variants.isEmpty) {
      state = state.copyWith(errorMessage: "Please add at least one variant");
      return false;
    }

    final mainFiles = ref.read(uploadProvider('cover_image'));
    final extraFiles = ref.read(uploadProvider('extra_images'));
    final videoFiles = ref.read(uploadProvider('product_video'));

    if (mainFiles.isEmpty || mainFiles[0]?.isUploadComplete != true) {
      state = state.copyWith(
        errorMessage: "Please upload a main product image",
      );
      return false;
    }

    final anyUploading = [
      mainFiles,
      extraFiles,
      videoFiles,
    ].expand((l) => l).any((f) => f?.isUploading == true);
    if (anyUploading) {
      state = state.copyWith(
        errorMessage: "Please wait for all uploads to complete",
      );
      return false;
    }

    final imageUrls = [
      mainFiles[0]!.cloudinaryUrl!,
      ...extraFiles
          .where((f) => f?.isUploadComplete == true)
          .map((f) => f!.cloudinaryUrl!),
    ];

    final videoUrl =
        videoFiles.isNotEmpty && videoFiles[0]?.isUploadComplete == true
        ? videoFiles[0]!.cloudinaryUrl
        : null;

    if (state.categoryId == null || state.categoryId!.isEmpty) {
      state = state.copyWith(errorMessage: "Please select a category");
      return false;
    }

    final allColors = state.variants.map((v) => v.colorName).toSet().toList();
    final allSizes = state.variants.map((v) => v.size).toSet().toList();
    final optionTypes = [
      if (allColors.isNotEmpty) {'name': 'Color', 'values': allColors},
      if (allSizes.isNotEmpty) {'name': 'Size', 'values': allSizes},
    ];

    final variantPayload = state.variants
        .map(
          (v) => {
            if (v.sku.isNotEmpty) 'sku': v.sku,
            'price': double.tryParse(v.price) ?? 0,
            'quantity': int.tryParse(v.stock) ?? 0,
            'options': [
              {'name': 'Color', 'value': v.colorName},
              {'name': 'Size', 'value': v.size},
            ],
          },
        )
        .toList();

    Map<String, dynamic>? specifications;
    if (needsMobileSpecsScreen) specifications = _buildPhoneSpecifications();
    if (needsComputerSpecsScreen) specifications = _buildLaptopSpecifications();

    state = state.copyWith(isLoading: true, errorMessage: null, success: false);

    final result = await runWithOverlay<bool>(context, () async {
      try {
        final payload = {
          'title': state.productName,
          'productType': 'variable',
          'category': state.categoryId,
          if (state.productDescription.isNotEmpty)
            'description': state.productDescription,
          'images': imageUrls,
          if (videoUrl != null) 'video': videoUrl,
          'optionTypes': optionTypes,
          'variants': variantPayload,
          if (specifications != null && specifications.isNotEmpty)
            'specifications': specifications,
        };

        final res = await api.createProduct(payload);
        if (res.isSuccess) {
          state = state.copyWith(isLoading: false, success: true);
          return true;
        }
        state = state.copyWith(
          isLoading: false,
          errorMessage: (res.errors != null && res.errors!.isNotEmpty)
              ? res.errors!.join(', ')
              : res.errorDescription,
        );
        return false;
      } catch (e) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
        return false;
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));

    return result;
  }
}

final multipleProductsProvider =
    StateNotifierProvider<MultipleProductsViewModel, MultipleProductsState>((
      ref,
    ) {
      return MultipleProductsViewModel(ref.read(sellerApiServiceProvider));
    });

// void resetMultipleProductFlow(WidgetRef ref) {
//   ref.read(multipleProductsProvider.notifier).reset();
//   ref.read(expandedCategoryProvider.notifier).state = null;
//   ref.read(isCategoryOpenProvider.notifier).state = false;
//   ref.read(categorySearchQueryProvider.notifier).state = '';
// }
