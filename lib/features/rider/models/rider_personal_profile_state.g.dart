// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rider_personal_profile_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RiderPersonalProfileState _$RiderPersonalProfileStateFromJson(
  Map<String, dynamic> json,
) => _RiderPersonalProfileState(
  fullName: json['fullName'] as String? ?? '',
  email: json['email'] as String? ?? '',
  mobile: json['mobile'] as String? ?? '',
  image: json['image'] as String? ?? '',
  residentialAddress: json['residentialAddress'] as String? ?? '',
  residentialState: json['residentialState'] as String? ?? '',
  city: json['city'] as String? ?? '',
  gender: json['gender'] as String? ?? '',
  nextOfKinName: json['nextOfKinName'] as String? ?? '',
  nextOfKinMobile: json['nextOfKinMobile'] as String? ?? '',
);

Map<String, dynamic> _$RiderPersonalProfileStateToJson(
  _RiderPersonalProfileState instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'email': instance.email,
  'mobile': instance.mobile,
  'image': instance.image,
  'residentialAddress': instance.residentialAddress,
  'residentialState': instance.residentialState,
  'city': instance.city,
  'gender': instance.gender,
  'nextOfKinName': instance.nextOfKinName,
  'nextOfKinMobile': instance.nextOfKinMobile,
};
