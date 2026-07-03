// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller_business_register_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SellerBusinessRegisterState _$SellerBusinessRegisterStateFromJson(
  Map<String, dynamic> json,
) => _SellerBusinessRegisterState(
  name: json['name'] as String? ?? '',
  storeEmail: json['storeEmail'] as String? ?? '',
  storeMobile: json['storeMobile'] as String? ?? '',
  address: json['address'] as String? ?? '',
  state: json['state'] as String? ?? '',
  city: json['city'] as String? ?? '',
  ownerNIN: json['ownerNIN'] as String? ?? '',
  businessType: json['businessType'] as String? ?? '',
  description: json['description'] as String?,
  storeImage: json['storeImage'] as String?,
  filteredCities:
      (json['filteredCities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
  longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$SellerBusinessRegisterStateToJson(
  _SellerBusinessRegisterState instance,
) => <String, dynamic>{
  'name': instance.name,
  'storeEmail': instance.storeEmail,
  'storeMobile': instance.storeMobile,
  'address': instance.address,
  'state': instance.state,
  'city': instance.city,
  'ownerNIN': instance.ownerNIN,
  'businessType': instance.businessType,
  'description': instance.description,
  'storeImage': instance.storeImage,
  'filteredCities': instance.filteredCities,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
