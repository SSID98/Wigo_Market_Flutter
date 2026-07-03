import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/utils/helper_methods_classes.dart';
import '../models/single_product_state.dart';

class SingleProductViewModel extends StateNotifier<SingleProductState> {
  SingleProductViewModel() : super(const SingleProductState());

  final ValueNotifier<String?> selectedRam = ValueNotifier(null);
  final ValueNotifier<String?> selectedRom = ValueNotifier(null);
  final ValueNotifier<String?> selectedModelYear = ValueNotifier(null);
  final ValueNotifier<String?> selectedUSBPort = ValueNotifier(null);
  final ValueNotifier<String?> selectedConnectivity = ValueNotifier(null);
  final ValueNotifier<String?> selectedWarranty = ValueNotifier(null);
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

  void selectCategory(String cat, String? sub) {
    state = SingleProductState(
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

  bool get needsMobileSpecsScreen {
    final cat = state.category?.toLowerCase() ?? '';
    return cat.contains('phone');
  }

  bool get needsComputerSpecsScreen {
    final cat = state.category?.toLowerCase() ?? '';
    return cat.contains('computer') || cat.contains('laptop');
  }

  void reset() {
    state = const SingleProductState();
  }
}

final singleProductProvider =
    StateNotifierProvider<SingleProductViewModel, SingleProductState>((ref) {
      return SingleProductViewModel();
    });
final specsPageProvider = StateProvider<int>((ref) => 1);

void resetSingleProductFlow(WidgetRef ref) {
  ref.read(singleProductProvider.notifier).reset();
  ref.read(expandedCategoryProvider.notifier).state = null;
  ref.read(isCategoryOpenProvider.notifier).state = false;
  ref.read(categorySearchQueryProvider.notifier).state = '';
  ref.read(specsPageProvider.notifier).state = 1;
}
