import 'package:freezed_annotation/freezed_annotation.dart';

part 'single_product_state.freezed.dart';
part 'single_product_state.g.dart';

@freezed
abstract class SingleProductState with _$SingleProductState {
  const factory SingleProductState({
    @Default('') String productName,
    @Default('') String productId,
    @Default('') String stockQuantity,
    @Default('') String sellingPrice,
    @Default('') String productDescription,
    String? category,
    String? subCategory,
    @Default(1) int currentStep,
    @Default(3) int totalSteps,
    String? ramSize,
    String? rom,
    String? cameraSpecs,
    String? modelYear,
    String? usbPorts,
    String? networkType,
    String? warranty,
    String? warrantyType,
    String? battery,
    String? connectivity,
    String? dimensions,
    String? simConfig,
    String? oS,
    String? processorType,
    String? displayResolution,
    String? screenSize,
    String? graphicsCard,
    @Default([]) List<String> imagePaths,
    String? videoPath,
    String? categoryId,
    String? specSchema,
    @Default(false) bool isLoading,
    @Default(false) bool success,
    String? errorMessage,
  }) = _SingleProductState;

  factory SingleProductState.fromJson(Map<String, dynamic> json) =>
      _$SingleProductStateFromJson(json);
}
