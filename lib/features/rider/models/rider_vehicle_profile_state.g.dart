// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rider_vehicle_profile_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RiderVehicleProfileState _$RiderVehicleProfileStateFromJson(
  Map<String, dynamic> json,
) => _RiderVehicleProfileState(
  type: json['type'] as String? ?? '',
  plateNumber: json['plateNumber'] as String? ?? '',
  make: json['make'] as String? ?? '',
  year: json['year'] as String? ?? '',
  model: json['model'] as String? ?? '',
  color: json['color'] as String? ?? '',
  ownerNIN: json['ownerNIN'] as String? ?? '',
  license: json['license'] as String? ?? '',
  vehicleReg: json['vehicleReg'] as String? ?? '',
  driverLicenseNumber: json['driverLicenseNumber'] as String? ?? '',
  driverLicenseExpiry: json['driverLicenseExpiry'] as String? ?? '',
  vehicleRegNumber: json['vehicleRegNumber'] as String? ?? '',
  vehicleRegExpiry: json['vehicleRegExpiry'] as String? ?? '',
  ninNumber: json['ninNumber'] as String? ?? '',
  workingDays:
      (json['workingDays'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$RiderVehicleProfileStateToJson(
  _RiderVehicleProfileState instance,
) => <String, dynamic>{
  'type': instance.type,
  'plateNumber': instance.plateNumber,
  'make': instance.make,
  'year': instance.year,
  'model': instance.model,
  'color': instance.color,
  'ownerNIN': instance.ownerNIN,
  'license': instance.license,
  'vehicleReg': instance.vehicleReg,
  'driverLicenseNumber': instance.driverLicenseNumber,
  'driverLicenseExpiry': instance.driverLicenseExpiry,
  'vehicleRegNumber': instance.vehicleRegNumber,
  'vehicleRegExpiry': instance.vehicleRegExpiry,
  'ninNumber': instance.ninNumber,
  'workingDays': instance.workingDays,
};
