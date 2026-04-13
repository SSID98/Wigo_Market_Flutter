// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_product_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SingleProductState _$SingleProductStateFromJson(Map<String, dynamic> json) =>
    _SingleProductState(
      productName: json['productName'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      stockQuantity: json['stockQuantity'] as String? ?? '',
      sellingPrice: json['sellingPrice'] as String? ?? '',
      productDescription: json['productDescription'] as String? ?? '',
      category: json['category'] as String?,
      subCategory: json['subCategory'] as String?,
      currentStep: (json['currentStep'] as num?)?.toInt() ?? 1,
      totalSteps: (json['totalSteps'] as num?)?.toInt() ?? 3,
      ramSize: json['ramSize'] as String?,
      rom: json['rom'] as String?,
      cameraSpecs: json['cameraSpecs'] as String?,
      modelYear: json['modelYear'] as String?,
      usbPorts: json['usbPorts'] as String?,
      networkType: json['networkType'] as String?,
      warranty: json['warranty'] as String?,
      battery: json['battery'] as String?,
      connectivity: json['connectivity'] as String?,
      dimensions: json['dimensions'] as String?,
      simConfig: json['simConfig'] as String?,
      oS: json['oS'] as String?,
      processorType: json['processorType'] as String?,
      displayResolution: json['displayResolution'] as String?,
      screenSize: json['screenSize'] as String?,
      graphicsCard: json['graphicsCard'] as String?,
      imagePaths:
          (json['imagePaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      videoPath: json['videoPath'] as String?,
    );

Map<String, dynamic> _$SingleProductStateToJson(_SingleProductState instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'productId': instance.productId,
      'stockQuantity': instance.stockQuantity,
      'sellingPrice': instance.sellingPrice,
      'productDescription': instance.productDescription,
      'category': instance.category,
      'subCategory': instance.subCategory,
      'currentStep': instance.currentStep,
      'totalSteps': instance.totalSteps,
      'ramSize': instance.ramSize,
      'rom': instance.rom,
      'cameraSpecs': instance.cameraSpecs,
      'modelYear': instance.modelYear,
      'usbPorts': instance.usbPorts,
      'networkType': instance.networkType,
      'warranty': instance.warranty,
      'battery': instance.battery,
      'connectivity': instance.connectivity,
      'dimensions': instance.dimensions,
      'simConfig': instance.simConfig,
      'oS': instance.oS,
      'processorType': instance.processorType,
      'displayResolution': instance.displayResolution,
      'screenSize': instance.screenSize,
      'graphicsCard': instance.graphicsCard,
      'imagePaths': instance.imagePaths,
      'videoPath': instance.videoPath,
    };
