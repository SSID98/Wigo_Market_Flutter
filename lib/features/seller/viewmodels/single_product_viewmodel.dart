import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wigo_flutter/features/seller/viewmodels/upload_file_viewmodel.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/custom_loading_overlay.dart';
import '../models/single_product_state.dart';
import '../services/seller_api_service.dart';

class SingleProductViewModel extends StateNotifier<SingleProductState> {
  final SellerApiService api;

  SingleProductViewModel(this.api) : super(const SingleProductState());

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

  void updateProductName(String name) =>
      state = state.copyWith(productName: name);

  void updateProductSKU(String id) => state = state.copyWith(productId: id);

  void updateSellingPrice(String sellingPrice) =>
      state = state.copyWith(sellingPrice: sellingPrice);

  void updateStockQuantity(String stock) =>
      state = state.copyWith(stockQuantity: stock);

  void updateProductDescription(String productDescription) =>
      state = state.copyWith(productDescription: productDescription);

  void updateOS(String? oS) => state = state.copyWith(oS: oS);

  void updateProcessorType(String? processorType) =>
      state = state.copyWith(processorType: processorType);

  void updateRam(String? ramSize) {
    state = state.copyWith(ramSize: ramSize);
    selectedRam.value = ramSize;
  }

  void updateRom(String? rom) {
    state = state.copyWith(rom: rom);
    selectedRom.value = rom;
  }

  void updateDisplayResolution(String? displayResolution) =>
      state = state.copyWith(displayResolution: displayResolution);

  void updateCameraSpecs(String? cameraSpecs) {
    state = state.copyWith(cameraSpecs: cameraSpecs);
    selectedCameraSpec.value = cameraSpecs;
  }

  void updateScreenSize(String? screenSize) =>
      state = state.copyWith(screenSize: screenSize);

  void updateBattery(String? battery) {
    state = state.copyWith(battery: battery);
    selectedBattery.value = battery;
  }

  void updateNetworkType(String? networkType) {
    state = state.copyWith(networkType: networkType);
    selectedNetworkType.value = networkType;
  }

  void updateSimConfig(String? simConfig) {
    state = state.copyWith(simConfig: simConfig);
    selectedSimConfig.value = simConfig;
  }

  void updateDimensions(String? dimensions) =>
      state = state.copyWith(dimensions: dimensions);

  void updateWarranty(String? warranty) {
    state = state.copyWith(warranty: warranty);
    selectedWarranty.value = warranty;
  }

  void updateWarrantyType(String? warrantyType) {
    state = state.copyWith(warrantyType: warrantyType);
    selectedWarrantyType.value = warrantyType;
  }

  void updateModelYear(String? modelYear) {
    state = state.copyWith(modelYear: modelYear);
    selectedModelYear.value = modelYear;
  }

  void updateGraphicsCard(String? graphicsCard) =>
      state = state.copyWith(graphicsCard: graphicsCard);

  void updateUsbPorts(String? usbPorts) {
    state = state.copyWith(usbPorts: usbPorts);
    selectedUSBPort.value = usbPorts;
  }

  void updateConnectivity(String? connectivity) {
    state = state.copyWith(connectivity: connectivity);
    selectedConnectivity.value = connectivity;
  }

  void selectCategory(
    String cat,
    String? sub, {
    String? categoryId,
    String? specSchema,
  }) {
    state = SingleProductState(
      productName: state.productName,
      productId: state.productId,
      stockQuantity: state.stockQuantity,
      sellingPrice: state.sellingPrice,
      productDescription: state.productDescription,
      category: cat,
      subCategory: sub,
      categoryId: categoryId,
      specSchema: specSchema,
      currentStep: state.currentStep,
      totalSteps: state.totalSteps,
      imagePaths: state.imagePaths,
      videoPath: state.videoPath,
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

  bool get needsMobileSpecsScreen => state.specSchema == 'phone';

  bool get needsComputerSpecsScreen {
    final s = state.specSchema;
    if (s == null) return false;
    return s.contains('laptop') ||
        s.contains('computer') ||
        s.contains('desktop');
  }

  void reset() {
    state = const SingleProductState();
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
      if (s.warrantyType?.isNotEmpty == true) 'warrantyType': s.warrantyType,
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

    Map<String, dynamic>? specifications;
    if (needsMobileSpecsScreen) specifications = _buildPhoneSpecifications();
    if (needsComputerSpecsScreen) specifications = _buildLaptopSpecifications();

    state = state.copyWith(isLoading: true, errorMessage: null, success: false);

    final result = await runWithOverlay<bool>(context, () async {
      try {
        final payload = {
          'title': state.productName,
          'productType': 'single',
          if (state.productId.isNotEmpty) 'sku': state.productId,
          'category': state.categoryId,
          'price': double.tryParse(state.sellingPrice) ?? 0,
          'quantity': int.tryParse(state.stockQuantity) ?? 0,
          if (state.productDescription.isNotEmpty)
            'description': state.productDescription,
          'images': imageUrls,
          if (videoUrl != null) 'video': videoUrl,
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

final singleProductProvider =
    StateNotifierProvider<SingleProductViewModel, SingleProductState>((ref) {
      return SingleProductViewModel(ref.read(sellerApiServiceProvider));
    });

// void resetSingleProductFlow(WidgetRef ref) {
//   ref.read(singleProductProvider.notifier).reset();
//   ref.read(expandedCategoryProvider.notifier).state = null;
//   ref.read(isCategoryOpenProvider.notifier).state = false;
//   ref.read(categorySearchQueryProvider.notifier).state = '';
// }
