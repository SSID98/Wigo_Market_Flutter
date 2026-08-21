// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_products_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductVariant _$ProductVariantFromJson(Map<String, dynamic> json) =>
    _ProductVariant(
      colorName: json['colorName'] as String,
      colorHex: json['colorHex'] as String,
      size: json['size'] as String,
      price: json['price'] as String,
      stock: json['stock'] as String,
      sku: json['sku'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
    );

Map<String, dynamic> _$ProductVariantToJson(_ProductVariant instance) =>
    <String, dynamic>{
      'colorName': instance.colorName,
      'colorHex': instance.colorHex,
      'size': instance.size,
      'price': instance.price,
      'stock': instance.stock,
      'sku': instance.sku,
      'isSelected': instance.isSelected,
    };

_MultipleProductsState _$MultipleProductsStateFromJson(
  Map<String, dynamic> json,
) => _MultipleProductsState(
  productName: json['productName'] as String? ?? '',
  productId: json['productId'] as String? ?? '',
  stockQuantity: json['stockQuantity'] as String? ?? '',
  sellingPrice: json['sellingPrice'] as String? ?? '',
  productDescription: json['productDescription'] as String? ?? '',
  category: json['category'] as String?,
  subCategory: json['subCategory'] as String?,
  currentStep: (json['currentStep'] as num?)?.toInt() ?? 1,
  totalSteps: (json['totalSteps'] as num?)?.toInt() ?? 3,
  imagePaths:
      (json['imagePaths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  videoPath: json['videoPath'] as String?,
  variants:
      (json['variants'] as List<dynamic>?)
          ?.map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  selectAll: json['selectAll'] as bool? ?? false,
  isCustomSizeMode: json['isCustomSizeMode'] as bool? ?? false,
  showVariant: json['showVariant'] as bool? ?? false,
  selectedColorName: json['selectedColorName'] as String?,
  selectedColorHex: json['selectedColorHex'] as String?,
  selectedSize: json['selectedSize'] as String?,
  categoryId: json['categoryId'] as String?,
  oS: json['oS'] as String?,
  processorType: json['processorType'] as String?,
  ramSize: json['ramSize'] as String?,
  rom: json['rom'] as String?,
  cameraSpecs: json['cameraSpecs'] as String?,
  modelYear: json['modelYear'] as String?,
  usbPorts: json['usbPorts'] as String?,
  networkType: json['networkType'] as String?,
  warranty: json['warranty'] as String?,
  warrantyType: json['warrantyType'] as String?,
  battery: json['battery'] as String?,
  connectivity: json['connectivity'] as String?,
  dimensions: json['dimensions'] as String?,
  simConfig: json['simConfig'] as String?,
  displayResolution: json['displayResolution'] as String?,
  screenSize: json['screenSize'] as String?,
  graphicsCard: json['graphicsCard'] as String?,
  specSchema: json['specSchema'] as String?,
  isLoading: json['isLoading'] as bool? ?? false,
  success: json['success'] as bool? ?? false,
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$MultipleProductsStateToJson(
  _MultipleProductsState instance,
) => <String, dynamic>{
  'productName': instance.productName,
  'productId': instance.productId,
  'stockQuantity': instance.stockQuantity,
  'sellingPrice': instance.sellingPrice,
  'productDescription': instance.productDescription,
  'category': instance.category,
  'subCategory': instance.subCategory,
  'currentStep': instance.currentStep,
  'totalSteps': instance.totalSteps,
  'imagePaths': instance.imagePaths,
  'videoPath': instance.videoPath,
  'variants': instance.variants,
  'selectAll': instance.selectAll,
  'isCustomSizeMode': instance.isCustomSizeMode,
  'showVariant': instance.showVariant,
  'selectedColorName': instance.selectedColorName,
  'selectedColorHex': instance.selectedColorHex,
  'selectedSize': instance.selectedSize,
  'categoryId': instance.categoryId,
  'oS': instance.oS,
  'processorType': instance.processorType,
  'ramSize': instance.ramSize,
  'rom': instance.rom,
  'cameraSpecs': instance.cameraSpecs,
  'modelYear': instance.modelYear,
  'usbPorts': instance.usbPorts,
  'networkType': instance.networkType,
  'warranty': instance.warranty,
  'warrantyType': instance.warrantyType,
  'battery': instance.battery,
  'connectivity': instance.connectivity,
  'dimensions': instance.dimensions,
  'simConfig': instance.simConfig,
  'displayResolution': instance.displayResolution,
  'screenSize': instance.screenSize,
  'graphicsCard': instance.graphicsCard,
  'specSchema': instance.specSchema,
  'isLoading': instance.isLoading,
  'success': instance.success,
  'errorMessage': instance.errorMessage,
};
