import 'package:freezed_annotation/freezed_annotation.dart';

part 'multiple_products_state.freezed.dart';
part 'multiple_products_state.g.dart';

@freezed
abstract class ProductVariant with _$ProductVariant {
  const factory ProductVariant({
    required String colorName,
    required String colorHex,
    required String size,
    required String price,
    required String stock,
    required String sku,
    @Default(false) bool isSelected,
  }) = _ProductVariant;

  factory ProductVariant.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantFromJson(json);
}

@freezed
abstract class MultipleProductsState with _$MultipleProductsState {
  const factory MultipleProductsState({
    @Default('') String productName,
    @Default('') String productId,
    @Default('') String stockQuantity,
    @Default('') String sellingPrice,
    @Default('') String productDescription,
    String? category,
    String? subCategory,
    @Default(1) int currentStep,
    @Default(3) int totalSteps,
    @Default([]) List<String> imagePaths,
    String? videoPath,
    @Default([]) List<ProductVariant> variants,
    @Default(false) bool selectAll,
    @Default(false) bool isCustomSizeMode,
    @Default(false) bool showVariant,
    String? selectedColorName,
    String? selectedColorHex,
    String? selectedSize,
  }) = _MultipleProductsState;

  factory MultipleProductsState.fromJson(Map<String, dynamic> json) =>
      _$MultipleProductsStateFromJson(json);
}
