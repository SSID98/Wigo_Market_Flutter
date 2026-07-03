import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rider_vehicle_profile_state.freezed.dart';
part 'rider_vehicle_profile_state.g.dart';

enum ProfileLoadStatus { initial, loading, loaded, notFound, error }

@freezed
abstract class RiderVehicleProfileState with _$RiderVehicleProfileState {
  const factory RiderVehicleProfileState({
    @Default('') String type,
    @Default('') String plateNumber,
    @Default('') String make,
    @Default('') String year,
    @Default('') String model,
    @Default('') String color,
    @Default('') String ownerNIN,
    @Default('') String license,
    @Default('') String vehicleReg,
    @Default('') String driverLicenseNumber,
    @Default('') String driverLicenseExpiry,
    @Default('') String vehicleRegNumber,
    @Default('') String vehicleRegExpiry,
    @Default('') String ninNumber,
    @Default([]) List<String> workingDays,

    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool isEditMode,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool hasProfile,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(ProfileLoadStatus.initial)
    ProfileLoadStatus profileLoadStatus,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool isLoading,
    @JsonKey(includeToJson: false, includeFromJson: false) String? errorMessage,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool success,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool hasSubmitted,
    @JsonKey(includeToJson: false, includeFromJson: false)
    CancelToken? cancelToken,
    @JsonKey(includeToJson: false, includeFromJson: false)
    PlatformFile? ninFile,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool isUploadingNin,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool ninUploadFailed,
    @JsonKey(includeToJson: false, includeFromJson: false)
    PlatformFile? driverLicenseFile,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool isUploadingDriverLicense,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool driverLicenseUploadFailed,
    @JsonKey(includeToJson: false, includeFromJson: false)
    PlatformFile? driverRegistrationFile,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool isUploadingDriverRegistration,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool driverRegUploadFailed,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(0.0)
    double ninProgress,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(0.0)
    double licenseProgress,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(0.0)
    double driverRegProgress,
  }) = _RiderVehicleProfileState;

  factory RiderVehicleProfileState.fromJson(Map<String, dynamic> json) =>
      _$RiderVehicleProfileStateFromJson(json);
}
