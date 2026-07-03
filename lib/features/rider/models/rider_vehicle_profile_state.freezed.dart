// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rider_vehicle_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RiderVehicleProfileState {

 String get type; String get plateNumber; String get make; String get year; String get model; String get color; String get ownerNIN; String get license; String get vehicleReg; String get driverLicenseNumber; String get driverLicenseExpiry; String get vehicleRegNumber; String get vehicleRegExpiry; String get ninNumber; List<String> get workingDays;@JsonKey(includeToJson: false, includeFromJson: false) bool get isEditMode;@JsonKey(includeToJson: false, includeFromJson: false) bool get hasProfile;@JsonKey(includeToJson: false, includeFromJson: false) ProfileLoadStatus get profileLoadStatus;@JsonKey(includeToJson: false, includeFromJson: false) bool get isLoading;@JsonKey(includeToJson: false, includeFromJson: false) String? get errorMessage;@JsonKey(includeToJson: false, includeFromJson: false) bool get success;@JsonKey(includeToJson: false, includeFromJson: false) bool get hasSubmitted;@JsonKey(includeToJson: false, includeFromJson: false) CancelToken? get cancelToken;@JsonKey(includeToJson: false, includeFromJson: false) PlatformFile? get ninFile;@JsonKey(includeToJson: false, includeFromJson: false) bool get isUploadingNin;@JsonKey(includeToJson: false, includeFromJson: false) bool get ninUploadFailed;@JsonKey(includeToJson: false, includeFromJson: false) PlatformFile? get driverLicenseFile;@JsonKey(includeToJson: false, includeFromJson: false) bool get isUploadingDriverLicense;@JsonKey(includeToJson: false, includeFromJson: false) bool get driverLicenseUploadFailed;@JsonKey(includeToJson: false, includeFromJson: false) PlatformFile? get driverRegistrationFile;@JsonKey(includeToJson: false, includeFromJson: false) bool get isUploadingDriverRegistration;@JsonKey(includeToJson: false, includeFromJson: false) bool get driverRegUploadFailed;@JsonKey(includeToJson: false, includeFromJson: false) double get ninProgress;@JsonKey(includeToJson: false, includeFromJson: false) double get licenseProgress;@JsonKey(includeToJson: false, includeFromJson: false) double get driverRegProgress;
/// Create a copy of RiderVehicleProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RiderVehicleProfileStateCopyWith<RiderVehicleProfileState> get copyWith => _$RiderVehicleProfileStateCopyWithImpl<RiderVehicleProfileState>(this as RiderVehicleProfileState, _$identity);

  /// Serializes this RiderVehicleProfileState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RiderVehicleProfileState&&(identical(other.type, type) || other.type == type)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber)&&(identical(other.make, make) || other.make == make)&&(identical(other.year, year) || other.year == year)&&(identical(other.model, model) || other.model == model)&&(identical(other.color, color) || other.color == color)&&(identical(other.ownerNIN, ownerNIN) || other.ownerNIN == ownerNIN)&&(identical(other.license, license) || other.license == license)&&(identical(other.vehicleReg, vehicleReg) || other.vehicleReg == vehicleReg)&&(identical(other.driverLicenseNumber, driverLicenseNumber) || other.driverLicenseNumber == driverLicenseNumber)&&(identical(other.driverLicenseExpiry, driverLicenseExpiry) || other.driverLicenseExpiry == driverLicenseExpiry)&&(identical(other.vehicleRegNumber, vehicleRegNumber) || other.vehicleRegNumber == vehicleRegNumber)&&(identical(other.vehicleRegExpiry, vehicleRegExpiry) || other.vehicleRegExpiry == vehicleRegExpiry)&&(identical(other.ninNumber, ninNumber) || other.ninNumber == ninNumber)&&const DeepCollectionEquality().equals(other.workingDays, workingDays)&&(identical(other.isEditMode, isEditMode) || other.isEditMode == isEditMode)&&(identical(other.hasProfile, hasProfile) || other.hasProfile == hasProfile)&&(identical(other.profileLoadStatus, profileLoadStatus) || other.profileLoadStatus == profileLoadStatus)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.success, success) || other.success == success)&&(identical(other.hasSubmitted, hasSubmitted) || other.hasSubmitted == hasSubmitted)&&(identical(other.cancelToken, cancelToken) || other.cancelToken == cancelToken)&&(identical(other.ninFile, ninFile) || other.ninFile == ninFile)&&(identical(other.isUploadingNin, isUploadingNin) || other.isUploadingNin == isUploadingNin)&&(identical(other.ninUploadFailed, ninUploadFailed) || other.ninUploadFailed == ninUploadFailed)&&(identical(other.driverLicenseFile, driverLicenseFile) || other.driverLicenseFile == driverLicenseFile)&&(identical(other.isUploadingDriverLicense, isUploadingDriverLicense) || other.isUploadingDriverLicense == isUploadingDriverLicense)&&(identical(other.driverLicenseUploadFailed, driverLicenseUploadFailed) || other.driverLicenseUploadFailed == driverLicenseUploadFailed)&&(identical(other.driverRegistrationFile, driverRegistrationFile) || other.driverRegistrationFile == driverRegistrationFile)&&(identical(other.isUploadingDriverRegistration, isUploadingDriverRegistration) || other.isUploadingDriverRegistration == isUploadingDriverRegistration)&&(identical(other.driverRegUploadFailed, driverRegUploadFailed) || other.driverRegUploadFailed == driverRegUploadFailed)&&(identical(other.ninProgress, ninProgress) || other.ninProgress == ninProgress)&&(identical(other.licenseProgress, licenseProgress) || other.licenseProgress == licenseProgress)&&(identical(other.driverRegProgress, driverRegProgress) || other.driverRegProgress == driverRegProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,type,plateNumber,make,year,model,color,ownerNIN,license,vehicleReg,driverLicenseNumber,driverLicenseExpiry,vehicleRegNumber,vehicleRegExpiry,ninNumber,const DeepCollectionEquality().hash(workingDays),isEditMode,hasProfile,profileLoadStatus,isLoading,errorMessage,success,hasSubmitted,cancelToken,ninFile,isUploadingNin,ninUploadFailed,driverLicenseFile,isUploadingDriverLicense,driverLicenseUploadFailed,driverRegistrationFile,isUploadingDriverRegistration,driverRegUploadFailed,ninProgress,licenseProgress,driverRegProgress]);

@override
String toString() {
  return 'RiderVehicleProfileState(type: $type, plateNumber: $plateNumber, make: $make, year: $year, model: $model, color: $color, ownerNIN: $ownerNIN, license: $license, vehicleReg: $vehicleReg, driverLicenseNumber: $driverLicenseNumber, driverLicenseExpiry: $driverLicenseExpiry, vehicleRegNumber: $vehicleRegNumber, vehicleRegExpiry: $vehicleRegExpiry, ninNumber: $ninNumber, workingDays: $workingDays, isEditMode: $isEditMode, hasProfile: $hasProfile, profileLoadStatus: $profileLoadStatus, isLoading: $isLoading, errorMessage: $errorMessage, success: $success, hasSubmitted: $hasSubmitted, cancelToken: $cancelToken, ninFile: $ninFile, isUploadingNin: $isUploadingNin, ninUploadFailed: $ninUploadFailed, driverLicenseFile: $driverLicenseFile, isUploadingDriverLicense: $isUploadingDriverLicense, driverLicenseUploadFailed: $driverLicenseUploadFailed, driverRegistrationFile: $driverRegistrationFile, isUploadingDriverRegistration: $isUploadingDriverRegistration, driverRegUploadFailed: $driverRegUploadFailed, ninProgress: $ninProgress, licenseProgress: $licenseProgress, driverRegProgress: $driverRegProgress)';
}


}

/// @nodoc
abstract mixin class $RiderVehicleProfileStateCopyWith<$Res>  {
  factory $RiderVehicleProfileStateCopyWith(RiderVehicleProfileState value, $Res Function(RiderVehicleProfileState) _then) = _$RiderVehicleProfileStateCopyWithImpl;
@useResult
$Res call({
 String type, String plateNumber, String make, String year, String model, String color, String ownerNIN, String license, String vehicleReg, String driverLicenseNumber, String driverLicenseExpiry, String vehicleRegNumber, String vehicleRegExpiry, String ninNumber, List<String> workingDays,@JsonKey(includeToJson: false, includeFromJson: false) bool isEditMode,@JsonKey(includeToJson: false, includeFromJson: false) bool hasProfile,@JsonKey(includeToJson: false, includeFromJson: false) ProfileLoadStatus profileLoadStatus,@JsonKey(includeToJson: false, includeFromJson: false) bool isLoading,@JsonKey(includeToJson: false, includeFromJson: false) String? errorMessage,@JsonKey(includeToJson: false, includeFromJson: false) bool success,@JsonKey(includeToJson: false, includeFromJson: false) bool hasSubmitted,@JsonKey(includeToJson: false, includeFromJson: false) CancelToken? cancelToken,@JsonKey(includeToJson: false, includeFromJson: false) PlatformFile? ninFile,@JsonKey(includeToJson: false, includeFromJson: false) bool isUploadingNin,@JsonKey(includeToJson: false, includeFromJson: false) bool ninUploadFailed,@JsonKey(includeToJson: false, includeFromJson: false) PlatformFile? driverLicenseFile,@JsonKey(includeToJson: false, includeFromJson: false) bool isUploadingDriverLicense,@JsonKey(includeToJson: false, includeFromJson: false) bool driverLicenseUploadFailed,@JsonKey(includeToJson: false, includeFromJson: false) PlatformFile? driverRegistrationFile,@JsonKey(includeToJson: false, includeFromJson: false) bool isUploadingDriverRegistration,@JsonKey(includeToJson: false, includeFromJson: false) bool driverRegUploadFailed,@JsonKey(includeToJson: false, includeFromJson: false) double ninProgress,@JsonKey(includeToJson: false, includeFromJson: false) double licenseProgress,@JsonKey(includeToJson: false, includeFromJson: false) double driverRegProgress
});




}
/// @nodoc
class _$RiderVehicleProfileStateCopyWithImpl<$Res>
    implements $RiderVehicleProfileStateCopyWith<$Res> {
  _$RiderVehicleProfileStateCopyWithImpl(this._self, this._then);

  final RiderVehicleProfileState _self;
  final $Res Function(RiderVehicleProfileState) _then;

/// Create a copy of RiderVehicleProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? plateNumber = null,Object? make = null,Object? year = null,Object? model = null,Object? color = null,Object? ownerNIN = null,Object? license = null,Object? vehicleReg = null,Object? driverLicenseNumber = null,Object? driverLicenseExpiry = null,Object? vehicleRegNumber = null,Object? vehicleRegExpiry = null,Object? ninNumber = null,Object? workingDays = null,Object? isEditMode = null,Object? hasProfile = null,Object? profileLoadStatus = null,Object? isLoading = null,Object? errorMessage = freezed,Object? success = null,Object? hasSubmitted = null,Object? cancelToken = freezed,Object? ninFile = freezed,Object? isUploadingNin = null,Object? ninUploadFailed = null,Object? driverLicenseFile = freezed,Object? isUploadingDriverLicense = null,Object? driverLicenseUploadFailed = null,Object? driverRegistrationFile = freezed,Object? isUploadingDriverRegistration = null,Object? driverRegUploadFailed = null,Object? ninProgress = null,Object? licenseProgress = null,Object? driverRegProgress = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,plateNumber: null == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,ownerNIN: null == ownerNIN ? _self.ownerNIN : ownerNIN // ignore: cast_nullable_to_non_nullable
as String,license: null == license ? _self.license : license // ignore: cast_nullable_to_non_nullable
as String,vehicleReg: null == vehicleReg ? _self.vehicleReg : vehicleReg // ignore: cast_nullable_to_non_nullable
as String,driverLicenseNumber: null == driverLicenseNumber ? _self.driverLicenseNumber : driverLicenseNumber // ignore: cast_nullable_to_non_nullable
as String,driverLicenseExpiry: null == driverLicenseExpiry ? _self.driverLicenseExpiry : driverLicenseExpiry // ignore: cast_nullable_to_non_nullable
as String,vehicleRegNumber: null == vehicleRegNumber ? _self.vehicleRegNumber : vehicleRegNumber // ignore: cast_nullable_to_non_nullable
as String,vehicleRegExpiry: null == vehicleRegExpiry ? _self.vehicleRegExpiry : vehicleRegExpiry // ignore: cast_nullable_to_non_nullable
as String,ninNumber: null == ninNumber ? _self.ninNumber : ninNumber // ignore: cast_nullable_to_non_nullable
as String,workingDays: null == workingDays ? _self.workingDays : workingDays // ignore: cast_nullable_to_non_nullable
as List<String>,isEditMode: null == isEditMode ? _self.isEditMode : isEditMode // ignore: cast_nullable_to_non_nullable
as bool,hasProfile: null == hasProfile ? _self.hasProfile : hasProfile // ignore: cast_nullable_to_non_nullable
as bool,profileLoadStatus: null == profileLoadStatus ? _self.profileLoadStatus : profileLoadStatus // ignore: cast_nullable_to_non_nullable
as ProfileLoadStatus,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,hasSubmitted: null == hasSubmitted ? _self.hasSubmitted : hasSubmitted // ignore: cast_nullable_to_non_nullable
as bool,cancelToken: freezed == cancelToken ? _self.cancelToken : cancelToken // ignore: cast_nullable_to_non_nullable
as CancelToken?,ninFile: freezed == ninFile ? _self.ninFile : ninFile // ignore: cast_nullable_to_non_nullable
as PlatformFile?,isUploadingNin: null == isUploadingNin ? _self.isUploadingNin : isUploadingNin // ignore: cast_nullable_to_non_nullable
as bool,ninUploadFailed: null == ninUploadFailed ? _self.ninUploadFailed : ninUploadFailed // ignore: cast_nullable_to_non_nullable
as bool,driverLicenseFile: freezed == driverLicenseFile ? _self.driverLicenseFile : driverLicenseFile // ignore: cast_nullable_to_non_nullable
as PlatformFile?,isUploadingDriverLicense: null == isUploadingDriverLicense ? _self.isUploadingDriverLicense : isUploadingDriverLicense // ignore: cast_nullable_to_non_nullable
as bool,driverLicenseUploadFailed: null == driverLicenseUploadFailed ? _self.driverLicenseUploadFailed : driverLicenseUploadFailed // ignore: cast_nullable_to_non_nullable
as bool,driverRegistrationFile: freezed == driverRegistrationFile ? _self.driverRegistrationFile : driverRegistrationFile // ignore: cast_nullable_to_non_nullable
as PlatformFile?,isUploadingDriverRegistration: null == isUploadingDriverRegistration ? _self.isUploadingDriverRegistration : isUploadingDriverRegistration // ignore: cast_nullable_to_non_nullable
as bool,driverRegUploadFailed: null == driverRegUploadFailed ? _self.driverRegUploadFailed : driverRegUploadFailed // ignore: cast_nullable_to_non_nullable
as bool,ninProgress: null == ninProgress ? _self.ninProgress : ninProgress // ignore: cast_nullable_to_non_nullable
as double,licenseProgress: null == licenseProgress ? _self.licenseProgress : licenseProgress // ignore: cast_nullable_to_non_nullable
as double,driverRegProgress: null == driverRegProgress ? _self.driverRegProgress : driverRegProgress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RiderVehicleProfileState].
extension RiderVehicleProfileStatePatterns on RiderVehicleProfileState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RiderVehicleProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RiderVehicleProfileState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RiderVehicleProfileState value)  $default,){
final _that = this;
switch (_that) {
case _RiderVehicleProfileState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RiderVehicleProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _RiderVehicleProfileState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String plateNumber,  String make,  String year,  String model,  String color,  String ownerNIN,  String license,  String vehicleReg,  String driverLicenseNumber,  String driverLicenseExpiry,  String vehicleRegNumber,  String vehicleRegExpiry,  String ninNumber,  List<String> workingDays, @JsonKey(includeToJson: false, includeFromJson: false)  bool isEditMode, @JsonKey(includeToJson: false, includeFromJson: false)  bool hasProfile, @JsonKey(includeToJson: false, includeFromJson: false)  ProfileLoadStatus profileLoadStatus, @JsonKey(includeToJson: false, includeFromJson: false)  bool isLoading, @JsonKey(includeToJson: false, includeFromJson: false)  String? errorMessage, @JsonKey(includeToJson: false, includeFromJson: false)  bool success, @JsonKey(includeToJson: false, includeFromJson: false)  bool hasSubmitted, @JsonKey(includeToJson: false, includeFromJson: false)  CancelToken? cancelToken, @JsonKey(includeToJson: false, includeFromJson: false)  PlatformFile? ninFile, @JsonKey(includeToJson: false, includeFromJson: false)  bool isUploadingNin, @JsonKey(includeToJson: false, includeFromJson: false)  bool ninUploadFailed, @JsonKey(includeToJson: false, includeFromJson: false)  PlatformFile? driverLicenseFile, @JsonKey(includeToJson: false, includeFromJson: false)  bool isUploadingDriverLicense, @JsonKey(includeToJson: false, includeFromJson: false)  bool driverLicenseUploadFailed, @JsonKey(includeToJson: false, includeFromJson: false)  PlatformFile? driverRegistrationFile, @JsonKey(includeToJson: false, includeFromJson: false)  bool isUploadingDriverRegistration, @JsonKey(includeToJson: false, includeFromJson: false)  bool driverRegUploadFailed, @JsonKey(includeToJson: false, includeFromJson: false)  double ninProgress, @JsonKey(includeToJson: false, includeFromJson: false)  double licenseProgress, @JsonKey(includeToJson: false, includeFromJson: false)  double driverRegProgress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RiderVehicleProfileState() when $default != null:
return $default(_that.type,_that.plateNumber,_that.make,_that.year,_that.model,_that.color,_that.ownerNIN,_that.license,_that.vehicleReg,_that.driverLicenseNumber,_that.driverLicenseExpiry,_that.vehicleRegNumber,_that.vehicleRegExpiry,_that.ninNumber,_that.workingDays,_that.isEditMode,_that.hasProfile,_that.profileLoadStatus,_that.isLoading,_that.errorMessage,_that.success,_that.hasSubmitted,_that.cancelToken,_that.ninFile,_that.isUploadingNin,_that.ninUploadFailed,_that.driverLicenseFile,_that.isUploadingDriverLicense,_that.driverLicenseUploadFailed,_that.driverRegistrationFile,_that.isUploadingDriverRegistration,_that.driverRegUploadFailed,_that.ninProgress,_that.licenseProgress,_that.driverRegProgress);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String plateNumber,  String make,  String year,  String model,  String color,  String ownerNIN,  String license,  String vehicleReg,  String driverLicenseNumber,  String driverLicenseExpiry,  String vehicleRegNumber,  String vehicleRegExpiry,  String ninNumber,  List<String> workingDays, @JsonKey(includeToJson: false, includeFromJson: false)  bool isEditMode, @JsonKey(includeToJson: false, includeFromJson: false)  bool hasProfile, @JsonKey(includeToJson: false, includeFromJson: false)  ProfileLoadStatus profileLoadStatus, @JsonKey(includeToJson: false, includeFromJson: false)  bool isLoading, @JsonKey(includeToJson: false, includeFromJson: false)  String? errorMessage, @JsonKey(includeToJson: false, includeFromJson: false)  bool success, @JsonKey(includeToJson: false, includeFromJson: false)  bool hasSubmitted, @JsonKey(includeToJson: false, includeFromJson: false)  CancelToken? cancelToken, @JsonKey(includeToJson: false, includeFromJson: false)  PlatformFile? ninFile, @JsonKey(includeToJson: false, includeFromJson: false)  bool isUploadingNin, @JsonKey(includeToJson: false, includeFromJson: false)  bool ninUploadFailed, @JsonKey(includeToJson: false, includeFromJson: false)  PlatformFile? driverLicenseFile, @JsonKey(includeToJson: false, includeFromJson: false)  bool isUploadingDriverLicense, @JsonKey(includeToJson: false, includeFromJson: false)  bool driverLicenseUploadFailed, @JsonKey(includeToJson: false, includeFromJson: false)  PlatformFile? driverRegistrationFile, @JsonKey(includeToJson: false, includeFromJson: false)  bool isUploadingDriverRegistration, @JsonKey(includeToJson: false, includeFromJson: false)  bool driverRegUploadFailed, @JsonKey(includeToJson: false, includeFromJson: false)  double ninProgress, @JsonKey(includeToJson: false, includeFromJson: false)  double licenseProgress, @JsonKey(includeToJson: false, includeFromJson: false)  double driverRegProgress)  $default,) {final _that = this;
switch (_that) {
case _RiderVehicleProfileState():
return $default(_that.type,_that.plateNumber,_that.make,_that.year,_that.model,_that.color,_that.ownerNIN,_that.license,_that.vehicleReg,_that.driverLicenseNumber,_that.driverLicenseExpiry,_that.vehicleRegNumber,_that.vehicleRegExpiry,_that.ninNumber,_that.workingDays,_that.isEditMode,_that.hasProfile,_that.profileLoadStatus,_that.isLoading,_that.errorMessage,_that.success,_that.hasSubmitted,_that.cancelToken,_that.ninFile,_that.isUploadingNin,_that.ninUploadFailed,_that.driverLicenseFile,_that.isUploadingDriverLicense,_that.driverLicenseUploadFailed,_that.driverRegistrationFile,_that.isUploadingDriverRegistration,_that.driverRegUploadFailed,_that.ninProgress,_that.licenseProgress,_that.driverRegProgress);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String plateNumber,  String make,  String year,  String model,  String color,  String ownerNIN,  String license,  String vehicleReg,  String driverLicenseNumber,  String driverLicenseExpiry,  String vehicleRegNumber,  String vehicleRegExpiry,  String ninNumber,  List<String> workingDays, @JsonKey(includeToJson: false, includeFromJson: false)  bool isEditMode, @JsonKey(includeToJson: false, includeFromJson: false)  bool hasProfile, @JsonKey(includeToJson: false, includeFromJson: false)  ProfileLoadStatus profileLoadStatus, @JsonKey(includeToJson: false, includeFromJson: false)  bool isLoading, @JsonKey(includeToJson: false, includeFromJson: false)  String? errorMessage, @JsonKey(includeToJson: false, includeFromJson: false)  bool success, @JsonKey(includeToJson: false, includeFromJson: false)  bool hasSubmitted, @JsonKey(includeToJson: false, includeFromJson: false)  CancelToken? cancelToken, @JsonKey(includeToJson: false, includeFromJson: false)  PlatformFile? ninFile, @JsonKey(includeToJson: false, includeFromJson: false)  bool isUploadingNin, @JsonKey(includeToJson: false, includeFromJson: false)  bool ninUploadFailed, @JsonKey(includeToJson: false, includeFromJson: false)  PlatformFile? driverLicenseFile, @JsonKey(includeToJson: false, includeFromJson: false)  bool isUploadingDriverLicense, @JsonKey(includeToJson: false, includeFromJson: false)  bool driverLicenseUploadFailed, @JsonKey(includeToJson: false, includeFromJson: false)  PlatformFile? driverRegistrationFile, @JsonKey(includeToJson: false, includeFromJson: false)  bool isUploadingDriverRegistration, @JsonKey(includeToJson: false, includeFromJson: false)  bool driverRegUploadFailed, @JsonKey(includeToJson: false, includeFromJson: false)  double ninProgress, @JsonKey(includeToJson: false, includeFromJson: false)  double licenseProgress, @JsonKey(includeToJson: false, includeFromJson: false)  double driverRegProgress)?  $default,) {final _that = this;
switch (_that) {
case _RiderVehicleProfileState() when $default != null:
return $default(_that.type,_that.plateNumber,_that.make,_that.year,_that.model,_that.color,_that.ownerNIN,_that.license,_that.vehicleReg,_that.driverLicenseNumber,_that.driverLicenseExpiry,_that.vehicleRegNumber,_that.vehicleRegExpiry,_that.ninNumber,_that.workingDays,_that.isEditMode,_that.hasProfile,_that.profileLoadStatus,_that.isLoading,_that.errorMessage,_that.success,_that.hasSubmitted,_that.cancelToken,_that.ninFile,_that.isUploadingNin,_that.ninUploadFailed,_that.driverLicenseFile,_that.isUploadingDriverLicense,_that.driverLicenseUploadFailed,_that.driverRegistrationFile,_that.isUploadingDriverRegistration,_that.driverRegUploadFailed,_that.ninProgress,_that.licenseProgress,_that.driverRegProgress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RiderVehicleProfileState implements RiderVehicleProfileState {
  const _RiderVehicleProfileState({this.type = '', this.plateNumber = '', this.make = '', this.year = '', this.model = '', this.color = '', this.ownerNIN = '', this.license = '', this.vehicleReg = '', this.driverLicenseNumber = '', this.driverLicenseExpiry = '', this.vehicleRegNumber = '', this.vehicleRegExpiry = '', this.ninNumber = '', final  List<String> workingDays = const [], @JsonKey(includeToJson: false, includeFromJson: false) this.isEditMode = false, @JsonKey(includeToJson: false, includeFromJson: false) this.hasProfile = false, @JsonKey(includeToJson: false, includeFromJson: false) this.profileLoadStatus = ProfileLoadStatus.initial, @JsonKey(includeToJson: false, includeFromJson: false) this.isLoading = false, @JsonKey(includeToJson: false, includeFromJson: false) this.errorMessage, @JsonKey(includeToJson: false, includeFromJson: false) this.success = false, @JsonKey(includeToJson: false, includeFromJson: false) this.hasSubmitted = false, @JsonKey(includeToJson: false, includeFromJson: false) this.cancelToken, @JsonKey(includeToJson: false, includeFromJson: false) this.ninFile, @JsonKey(includeToJson: false, includeFromJson: false) this.isUploadingNin = false, @JsonKey(includeToJson: false, includeFromJson: false) this.ninUploadFailed = false, @JsonKey(includeToJson: false, includeFromJson: false) this.driverLicenseFile, @JsonKey(includeToJson: false, includeFromJson: false) this.isUploadingDriverLicense = false, @JsonKey(includeToJson: false, includeFromJson: false) this.driverLicenseUploadFailed = false, @JsonKey(includeToJson: false, includeFromJson: false) this.driverRegistrationFile, @JsonKey(includeToJson: false, includeFromJson: false) this.isUploadingDriverRegistration = false, @JsonKey(includeToJson: false, includeFromJson: false) this.driverRegUploadFailed = false, @JsonKey(includeToJson: false, includeFromJson: false) this.ninProgress = 0.0, @JsonKey(includeToJson: false, includeFromJson: false) this.licenseProgress = 0.0, @JsonKey(includeToJson: false, includeFromJson: false) this.driverRegProgress = 0.0}): _workingDays = workingDays;
  factory _RiderVehicleProfileState.fromJson(Map<String, dynamic> json) => _$RiderVehicleProfileStateFromJson(json);

@override@JsonKey() final  String type;
@override@JsonKey() final  String plateNumber;
@override@JsonKey() final  String make;
@override@JsonKey() final  String year;
@override@JsonKey() final  String model;
@override@JsonKey() final  String color;
@override@JsonKey() final  String ownerNIN;
@override@JsonKey() final  String license;
@override@JsonKey() final  String vehicleReg;
@override@JsonKey() final  String driverLicenseNumber;
@override@JsonKey() final  String driverLicenseExpiry;
@override@JsonKey() final  String vehicleRegNumber;
@override@JsonKey() final  String vehicleRegExpiry;
@override@JsonKey() final  String ninNumber;
 final  List<String> _workingDays;
@override@JsonKey() List<String> get workingDays {
  if (_workingDays is EqualUnmodifiableListView) return _workingDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workingDays);
}

@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool isEditMode;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool hasProfile;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  ProfileLoadStatus profileLoadStatus;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool isLoading;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  String? errorMessage;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool success;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool hasSubmitted;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  CancelToken? cancelToken;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  PlatformFile? ninFile;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool isUploadingNin;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool ninUploadFailed;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  PlatformFile? driverLicenseFile;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool isUploadingDriverLicense;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool driverLicenseUploadFailed;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  PlatformFile? driverRegistrationFile;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool isUploadingDriverRegistration;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool driverRegUploadFailed;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  double ninProgress;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  double licenseProgress;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  double driverRegProgress;

/// Create a copy of RiderVehicleProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RiderVehicleProfileStateCopyWith<_RiderVehicleProfileState> get copyWith => __$RiderVehicleProfileStateCopyWithImpl<_RiderVehicleProfileState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RiderVehicleProfileStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RiderVehicleProfileState&&(identical(other.type, type) || other.type == type)&&(identical(other.plateNumber, plateNumber) || other.plateNumber == plateNumber)&&(identical(other.make, make) || other.make == make)&&(identical(other.year, year) || other.year == year)&&(identical(other.model, model) || other.model == model)&&(identical(other.color, color) || other.color == color)&&(identical(other.ownerNIN, ownerNIN) || other.ownerNIN == ownerNIN)&&(identical(other.license, license) || other.license == license)&&(identical(other.vehicleReg, vehicleReg) || other.vehicleReg == vehicleReg)&&(identical(other.driverLicenseNumber, driverLicenseNumber) || other.driverLicenseNumber == driverLicenseNumber)&&(identical(other.driverLicenseExpiry, driverLicenseExpiry) || other.driverLicenseExpiry == driverLicenseExpiry)&&(identical(other.vehicleRegNumber, vehicleRegNumber) || other.vehicleRegNumber == vehicleRegNumber)&&(identical(other.vehicleRegExpiry, vehicleRegExpiry) || other.vehicleRegExpiry == vehicleRegExpiry)&&(identical(other.ninNumber, ninNumber) || other.ninNumber == ninNumber)&&const DeepCollectionEquality().equals(other._workingDays, _workingDays)&&(identical(other.isEditMode, isEditMode) || other.isEditMode == isEditMode)&&(identical(other.hasProfile, hasProfile) || other.hasProfile == hasProfile)&&(identical(other.profileLoadStatus, profileLoadStatus) || other.profileLoadStatus == profileLoadStatus)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.success, success) || other.success == success)&&(identical(other.hasSubmitted, hasSubmitted) || other.hasSubmitted == hasSubmitted)&&(identical(other.cancelToken, cancelToken) || other.cancelToken == cancelToken)&&(identical(other.ninFile, ninFile) || other.ninFile == ninFile)&&(identical(other.isUploadingNin, isUploadingNin) || other.isUploadingNin == isUploadingNin)&&(identical(other.ninUploadFailed, ninUploadFailed) || other.ninUploadFailed == ninUploadFailed)&&(identical(other.driverLicenseFile, driverLicenseFile) || other.driverLicenseFile == driverLicenseFile)&&(identical(other.isUploadingDriverLicense, isUploadingDriverLicense) || other.isUploadingDriverLicense == isUploadingDriverLicense)&&(identical(other.driverLicenseUploadFailed, driverLicenseUploadFailed) || other.driverLicenseUploadFailed == driverLicenseUploadFailed)&&(identical(other.driverRegistrationFile, driverRegistrationFile) || other.driverRegistrationFile == driverRegistrationFile)&&(identical(other.isUploadingDriverRegistration, isUploadingDriverRegistration) || other.isUploadingDriverRegistration == isUploadingDriverRegistration)&&(identical(other.driverRegUploadFailed, driverRegUploadFailed) || other.driverRegUploadFailed == driverRegUploadFailed)&&(identical(other.ninProgress, ninProgress) || other.ninProgress == ninProgress)&&(identical(other.licenseProgress, licenseProgress) || other.licenseProgress == licenseProgress)&&(identical(other.driverRegProgress, driverRegProgress) || other.driverRegProgress == driverRegProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,type,plateNumber,make,year,model,color,ownerNIN,license,vehicleReg,driverLicenseNumber,driverLicenseExpiry,vehicleRegNumber,vehicleRegExpiry,ninNumber,const DeepCollectionEquality().hash(_workingDays),isEditMode,hasProfile,profileLoadStatus,isLoading,errorMessage,success,hasSubmitted,cancelToken,ninFile,isUploadingNin,ninUploadFailed,driverLicenseFile,isUploadingDriverLicense,driverLicenseUploadFailed,driverRegistrationFile,isUploadingDriverRegistration,driverRegUploadFailed,ninProgress,licenseProgress,driverRegProgress]);

@override
String toString() {
  return 'RiderVehicleProfileState(type: $type, plateNumber: $plateNumber, make: $make, year: $year, model: $model, color: $color, ownerNIN: $ownerNIN, license: $license, vehicleReg: $vehicleReg, driverLicenseNumber: $driverLicenseNumber, driverLicenseExpiry: $driverLicenseExpiry, vehicleRegNumber: $vehicleRegNumber, vehicleRegExpiry: $vehicleRegExpiry, ninNumber: $ninNumber, workingDays: $workingDays, isEditMode: $isEditMode, hasProfile: $hasProfile, profileLoadStatus: $profileLoadStatus, isLoading: $isLoading, errorMessage: $errorMessage, success: $success, hasSubmitted: $hasSubmitted, cancelToken: $cancelToken, ninFile: $ninFile, isUploadingNin: $isUploadingNin, ninUploadFailed: $ninUploadFailed, driverLicenseFile: $driverLicenseFile, isUploadingDriverLicense: $isUploadingDriverLicense, driverLicenseUploadFailed: $driverLicenseUploadFailed, driverRegistrationFile: $driverRegistrationFile, isUploadingDriverRegistration: $isUploadingDriverRegistration, driverRegUploadFailed: $driverRegUploadFailed, ninProgress: $ninProgress, licenseProgress: $licenseProgress, driverRegProgress: $driverRegProgress)';
}


}

/// @nodoc
abstract mixin class _$RiderVehicleProfileStateCopyWith<$Res> implements $RiderVehicleProfileStateCopyWith<$Res> {
  factory _$RiderVehicleProfileStateCopyWith(_RiderVehicleProfileState value, $Res Function(_RiderVehicleProfileState) _then) = __$RiderVehicleProfileStateCopyWithImpl;
@override @useResult
$Res call({
 String type, String plateNumber, String make, String year, String model, String color, String ownerNIN, String license, String vehicleReg, String driverLicenseNumber, String driverLicenseExpiry, String vehicleRegNumber, String vehicleRegExpiry, String ninNumber, List<String> workingDays,@JsonKey(includeToJson: false, includeFromJson: false) bool isEditMode,@JsonKey(includeToJson: false, includeFromJson: false) bool hasProfile,@JsonKey(includeToJson: false, includeFromJson: false) ProfileLoadStatus profileLoadStatus,@JsonKey(includeToJson: false, includeFromJson: false) bool isLoading,@JsonKey(includeToJson: false, includeFromJson: false) String? errorMessage,@JsonKey(includeToJson: false, includeFromJson: false) bool success,@JsonKey(includeToJson: false, includeFromJson: false) bool hasSubmitted,@JsonKey(includeToJson: false, includeFromJson: false) CancelToken? cancelToken,@JsonKey(includeToJson: false, includeFromJson: false) PlatformFile? ninFile,@JsonKey(includeToJson: false, includeFromJson: false) bool isUploadingNin,@JsonKey(includeToJson: false, includeFromJson: false) bool ninUploadFailed,@JsonKey(includeToJson: false, includeFromJson: false) PlatformFile? driverLicenseFile,@JsonKey(includeToJson: false, includeFromJson: false) bool isUploadingDriverLicense,@JsonKey(includeToJson: false, includeFromJson: false) bool driverLicenseUploadFailed,@JsonKey(includeToJson: false, includeFromJson: false) PlatformFile? driverRegistrationFile,@JsonKey(includeToJson: false, includeFromJson: false) bool isUploadingDriverRegistration,@JsonKey(includeToJson: false, includeFromJson: false) bool driverRegUploadFailed,@JsonKey(includeToJson: false, includeFromJson: false) double ninProgress,@JsonKey(includeToJson: false, includeFromJson: false) double licenseProgress,@JsonKey(includeToJson: false, includeFromJson: false) double driverRegProgress
});




}
/// @nodoc
class __$RiderVehicleProfileStateCopyWithImpl<$Res>
    implements _$RiderVehicleProfileStateCopyWith<$Res> {
  __$RiderVehicleProfileStateCopyWithImpl(this._self, this._then);

  final _RiderVehicleProfileState _self;
  final $Res Function(_RiderVehicleProfileState) _then;

/// Create a copy of RiderVehicleProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? plateNumber = null,Object? make = null,Object? year = null,Object? model = null,Object? color = null,Object? ownerNIN = null,Object? license = null,Object? vehicleReg = null,Object? driverLicenseNumber = null,Object? driverLicenseExpiry = null,Object? vehicleRegNumber = null,Object? vehicleRegExpiry = null,Object? ninNumber = null,Object? workingDays = null,Object? isEditMode = null,Object? hasProfile = null,Object? profileLoadStatus = null,Object? isLoading = null,Object? errorMessage = freezed,Object? success = null,Object? hasSubmitted = null,Object? cancelToken = freezed,Object? ninFile = freezed,Object? isUploadingNin = null,Object? ninUploadFailed = null,Object? driverLicenseFile = freezed,Object? isUploadingDriverLicense = null,Object? driverLicenseUploadFailed = null,Object? driverRegistrationFile = freezed,Object? isUploadingDriverRegistration = null,Object? driverRegUploadFailed = null,Object? ninProgress = null,Object? licenseProgress = null,Object? driverRegProgress = null,}) {
  return _then(_RiderVehicleProfileState(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,plateNumber: null == plateNumber ? _self.plateNumber : plateNumber // ignore: cast_nullable_to_non_nullable
as String,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,ownerNIN: null == ownerNIN ? _self.ownerNIN : ownerNIN // ignore: cast_nullable_to_non_nullable
as String,license: null == license ? _self.license : license // ignore: cast_nullable_to_non_nullable
as String,vehicleReg: null == vehicleReg ? _self.vehicleReg : vehicleReg // ignore: cast_nullable_to_non_nullable
as String,driverLicenseNumber: null == driverLicenseNumber ? _self.driverLicenseNumber : driverLicenseNumber // ignore: cast_nullable_to_non_nullable
as String,driverLicenseExpiry: null == driverLicenseExpiry ? _self.driverLicenseExpiry : driverLicenseExpiry // ignore: cast_nullable_to_non_nullable
as String,vehicleRegNumber: null == vehicleRegNumber ? _self.vehicleRegNumber : vehicleRegNumber // ignore: cast_nullable_to_non_nullable
as String,vehicleRegExpiry: null == vehicleRegExpiry ? _self.vehicleRegExpiry : vehicleRegExpiry // ignore: cast_nullable_to_non_nullable
as String,ninNumber: null == ninNumber ? _self.ninNumber : ninNumber // ignore: cast_nullable_to_non_nullable
as String,workingDays: null == workingDays ? _self._workingDays : workingDays // ignore: cast_nullable_to_non_nullable
as List<String>,isEditMode: null == isEditMode ? _self.isEditMode : isEditMode // ignore: cast_nullable_to_non_nullable
as bool,hasProfile: null == hasProfile ? _self.hasProfile : hasProfile // ignore: cast_nullable_to_non_nullable
as bool,profileLoadStatus: null == profileLoadStatus ? _self.profileLoadStatus : profileLoadStatus // ignore: cast_nullable_to_non_nullable
as ProfileLoadStatus,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,hasSubmitted: null == hasSubmitted ? _self.hasSubmitted : hasSubmitted // ignore: cast_nullable_to_non_nullable
as bool,cancelToken: freezed == cancelToken ? _self.cancelToken : cancelToken // ignore: cast_nullable_to_non_nullable
as CancelToken?,ninFile: freezed == ninFile ? _self.ninFile : ninFile // ignore: cast_nullable_to_non_nullable
as PlatformFile?,isUploadingNin: null == isUploadingNin ? _self.isUploadingNin : isUploadingNin // ignore: cast_nullable_to_non_nullable
as bool,ninUploadFailed: null == ninUploadFailed ? _self.ninUploadFailed : ninUploadFailed // ignore: cast_nullable_to_non_nullable
as bool,driverLicenseFile: freezed == driverLicenseFile ? _self.driverLicenseFile : driverLicenseFile // ignore: cast_nullable_to_non_nullable
as PlatformFile?,isUploadingDriverLicense: null == isUploadingDriverLicense ? _self.isUploadingDriverLicense : isUploadingDriverLicense // ignore: cast_nullable_to_non_nullable
as bool,driverLicenseUploadFailed: null == driverLicenseUploadFailed ? _self.driverLicenseUploadFailed : driverLicenseUploadFailed // ignore: cast_nullable_to_non_nullable
as bool,driverRegistrationFile: freezed == driverRegistrationFile ? _self.driverRegistrationFile : driverRegistrationFile // ignore: cast_nullable_to_non_nullable
as PlatformFile?,isUploadingDriverRegistration: null == isUploadingDriverRegistration ? _self.isUploadingDriverRegistration : isUploadingDriverRegistration // ignore: cast_nullable_to_non_nullable
as bool,driverRegUploadFailed: null == driverRegUploadFailed ? _self.driverRegUploadFailed : driverRegUploadFailed // ignore: cast_nullable_to_non_nullable
as bool,ninProgress: null == ninProgress ? _self.ninProgress : ninProgress // ignore: cast_nullable_to_non_nullable
as double,licenseProgress: null == licenseProgress ? _self.licenseProgress : licenseProgress // ignore: cast_nullable_to_non_nullable
as double,driverRegProgress: null == driverRegProgress ? _self.driverRegProgress : driverRegProgress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
