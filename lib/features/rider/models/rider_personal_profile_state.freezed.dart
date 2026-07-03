// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rider_personal_profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RiderPersonalProfileState {

 String get fullName; String get email; String get mobile; String get image; String get residentialAddress; String get residentialState; String get city; String get gender; String get nextOfKinName; String get nextOfKinMobile;@JsonKey(includeToJson: false, includeFromJson: false) List<String> get filteredCities;@JsonKey(includeToJson: false, includeFromJson: false) String get currentPassword;@JsonKey(includeToJson: false, includeFromJson: false) String get newPassword;@JsonKey(includeToJson: false, includeFromJson: false) bool get isEditMode;@JsonKey(includeToJson: false, includeFromJson: false) PersonalProfileLoadStatus get profileLoadStatus;@JsonKey(includeToJson: false, includeFromJson: false) bool get isLoading;@JsonKey(includeToJson: false, includeFromJson: false) String? get errorMessage;@JsonKey(includeToJson: false, includeFromJson: false) bool get success;@JsonKey(includeToJson: false, includeFromJson: false) bool get hasSubmitted;@JsonKey(includeToJson: false, includeFromJson: false) bool get isUploadingPhoto;@JsonKey(includeToJson: false, includeFromJson: false) bool get photoUploadFailed;@JsonKey(includeToJson: false, includeFromJson: false) String? get photoErrorMessage;@JsonKey(includeToJson: false, includeFromJson: false) PlatformFile? get pendingPhotoFile;@JsonKey(includeToJson: false, includeFromJson: false) CancelToken? get cancelToken;
/// Create a copy of RiderPersonalProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RiderPersonalProfileStateCopyWith<RiderPersonalProfileState> get copyWith => _$RiderPersonalProfileStateCopyWithImpl<RiderPersonalProfileState>(this as RiderPersonalProfileState, _$identity);

  /// Serializes this RiderPersonalProfileState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RiderPersonalProfileState&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.image, image) || other.image == image)&&(identical(other.residentialAddress, residentialAddress) || other.residentialAddress == residentialAddress)&&(identical(other.residentialState, residentialState) || other.residentialState == residentialState)&&(identical(other.city, city) || other.city == city)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.nextOfKinName, nextOfKinName) || other.nextOfKinName == nextOfKinName)&&(identical(other.nextOfKinMobile, nextOfKinMobile) || other.nextOfKinMobile == nextOfKinMobile)&&const DeepCollectionEquality().equals(other.filteredCities, filteredCities)&&(identical(other.currentPassword, currentPassword) || other.currentPassword == currentPassword)&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword)&&(identical(other.isEditMode, isEditMode) || other.isEditMode == isEditMode)&&(identical(other.profileLoadStatus, profileLoadStatus) || other.profileLoadStatus == profileLoadStatus)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.success, success) || other.success == success)&&(identical(other.hasSubmitted, hasSubmitted) || other.hasSubmitted == hasSubmitted)&&(identical(other.isUploadingPhoto, isUploadingPhoto) || other.isUploadingPhoto == isUploadingPhoto)&&(identical(other.photoUploadFailed, photoUploadFailed) || other.photoUploadFailed == photoUploadFailed)&&(identical(other.photoErrorMessage, photoErrorMessage) || other.photoErrorMessage == photoErrorMessage)&&(identical(other.pendingPhotoFile, pendingPhotoFile) || other.pendingPhotoFile == pendingPhotoFile)&&(identical(other.cancelToken, cancelToken) || other.cancelToken == cancelToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,fullName,email,mobile,image,residentialAddress,residentialState,city,gender,nextOfKinName,nextOfKinMobile,const DeepCollectionEquality().hash(filteredCities),currentPassword,newPassword,isEditMode,profileLoadStatus,isLoading,errorMessage,success,hasSubmitted,isUploadingPhoto,photoUploadFailed,photoErrorMessage,pendingPhotoFile,cancelToken]);

@override
String toString() {
  return 'RiderPersonalProfileState(fullName: $fullName, email: $email, mobile: $mobile, image: $image, residentialAddress: $residentialAddress, residentialState: $residentialState, city: $city, gender: $gender, nextOfKinName: $nextOfKinName, nextOfKinMobile: $nextOfKinMobile, filteredCities: $filteredCities, currentPassword: $currentPassword, newPassword: $newPassword, isEditMode: $isEditMode, profileLoadStatus: $profileLoadStatus, isLoading: $isLoading, errorMessage: $errorMessage, success: $success, hasSubmitted: $hasSubmitted, isUploadingPhoto: $isUploadingPhoto, photoUploadFailed: $photoUploadFailed, photoErrorMessage: $photoErrorMessage, pendingPhotoFile: $pendingPhotoFile, cancelToken: $cancelToken)';
}


}

/// @nodoc
abstract mixin class $RiderPersonalProfileStateCopyWith<$Res>  {
  factory $RiderPersonalProfileStateCopyWith(RiderPersonalProfileState value, $Res Function(RiderPersonalProfileState) _then) = _$RiderPersonalProfileStateCopyWithImpl;
@useResult
$Res call({
 String fullName, String email, String mobile, String image, String residentialAddress, String residentialState, String city, String gender, String nextOfKinName, String nextOfKinMobile,@JsonKey(includeToJson: false, includeFromJson: false) List<String> filteredCities,@JsonKey(includeToJson: false, includeFromJson: false) String currentPassword,@JsonKey(includeToJson: false, includeFromJson: false) String newPassword,@JsonKey(includeToJson: false, includeFromJson: false) bool isEditMode,@JsonKey(includeToJson: false, includeFromJson: false) PersonalProfileLoadStatus profileLoadStatus,@JsonKey(includeToJson: false, includeFromJson: false) bool isLoading,@JsonKey(includeToJson: false, includeFromJson: false) String? errorMessage,@JsonKey(includeToJson: false, includeFromJson: false) bool success,@JsonKey(includeToJson: false, includeFromJson: false) bool hasSubmitted,@JsonKey(includeToJson: false, includeFromJson: false) bool isUploadingPhoto,@JsonKey(includeToJson: false, includeFromJson: false) bool photoUploadFailed,@JsonKey(includeToJson: false, includeFromJson: false) String? photoErrorMessage,@JsonKey(includeToJson: false, includeFromJson: false) PlatformFile? pendingPhotoFile,@JsonKey(includeToJson: false, includeFromJson: false) CancelToken? cancelToken
});




}
/// @nodoc
class _$RiderPersonalProfileStateCopyWithImpl<$Res>
    implements $RiderPersonalProfileStateCopyWith<$Res> {
  _$RiderPersonalProfileStateCopyWithImpl(this._self, this._then);

  final RiderPersonalProfileState _self;
  final $Res Function(RiderPersonalProfileState) _then;

/// Create a copy of RiderPersonalProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,Object? email = null,Object? mobile = null,Object? image = null,Object? residentialAddress = null,Object? residentialState = null,Object? city = null,Object? gender = null,Object? nextOfKinName = null,Object? nextOfKinMobile = null,Object? filteredCities = null,Object? currentPassword = null,Object? newPassword = null,Object? isEditMode = null,Object? profileLoadStatus = null,Object? isLoading = null,Object? errorMessage = freezed,Object? success = null,Object? hasSubmitted = null,Object? isUploadingPhoto = null,Object? photoUploadFailed = null,Object? photoErrorMessage = freezed,Object? pendingPhotoFile = freezed,Object? cancelToken = freezed,}) {
  return _then(_self.copyWith(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,residentialAddress: null == residentialAddress ? _self.residentialAddress : residentialAddress // ignore: cast_nullable_to_non_nullable
as String,residentialState: null == residentialState ? _self.residentialState : residentialState // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,nextOfKinName: null == nextOfKinName ? _self.nextOfKinName : nextOfKinName // ignore: cast_nullable_to_non_nullable
as String,nextOfKinMobile: null == nextOfKinMobile ? _self.nextOfKinMobile : nextOfKinMobile // ignore: cast_nullable_to_non_nullable
as String,filteredCities: null == filteredCities ? _self.filteredCities : filteredCities // ignore: cast_nullable_to_non_nullable
as List<String>,currentPassword: null == currentPassword ? _self.currentPassword : currentPassword // ignore: cast_nullable_to_non_nullable
as String,newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String,isEditMode: null == isEditMode ? _self.isEditMode : isEditMode // ignore: cast_nullable_to_non_nullable
as bool,profileLoadStatus: null == profileLoadStatus ? _self.profileLoadStatus : profileLoadStatus // ignore: cast_nullable_to_non_nullable
as PersonalProfileLoadStatus,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,hasSubmitted: null == hasSubmitted ? _self.hasSubmitted : hasSubmitted // ignore: cast_nullable_to_non_nullable
as bool,isUploadingPhoto: null == isUploadingPhoto ? _self.isUploadingPhoto : isUploadingPhoto // ignore: cast_nullable_to_non_nullable
as bool,photoUploadFailed: null == photoUploadFailed ? _self.photoUploadFailed : photoUploadFailed // ignore: cast_nullable_to_non_nullable
as bool,photoErrorMessage: freezed == photoErrorMessage ? _self.photoErrorMessage : photoErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,pendingPhotoFile: freezed == pendingPhotoFile ? _self.pendingPhotoFile : pendingPhotoFile // ignore: cast_nullable_to_non_nullable
as PlatformFile?,cancelToken: freezed == cancelToken ? _self.cancelToken : cancelToken // ignore: cast_nullable_to_non_nullable
as CancelToken?,
  ));
}

}


/// Adds pattern-matching-related methods to [RiderPersonalProfileState].
extension RiderPersonalProfileStatePatterns on RiderPersonalProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RiderPersonalProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RiderPersonalProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RiderPersonalProfileState value)  $default,){
final _that = this;
switch (_that) {
case _RiderPersonalProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RiderPersonalProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _RiderPersonalProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fullName,  String email,  String mobile,  String image,  String residentialAddress,  String residentialState,  String city,  String gender,  String nextOfKinName,  String nextOfKinMobile, @JsonKey(includeToJson: false, includeFromJson: false)  List<String> filteredCities, @JsonKey(includeToJson: false, includeFromJson: false)  String currentPassword, @JsonKey(includeToJson: false, includeFromJson: false)  String newPassword, @JsonKey(includeToJson: false, includeFromJson: false)  bool isEditMode, @JsonKey(includeToJson: false, includeFromJson: false)  PersonalProfileLoadStatus profileLoadStatus, @JsonKey(includeToJson: false, includeFromJson: false)  bool isLoading, @JsonKey(includeToJson: false, includeFromJson: false)  String? errorMessage, @JsonKey(includeToJson: false, includeFromJson: false)  bool success, @JsonKey(includeToJson: false, includeFromJson: false)  bool hasSubmitted, @JsonKey(includeToJson: false, includeFromJson: false)  bool isUploadingPhoto, @JsonKey(includeToJson: false, includeFromJson: false)  bool photoUploadFailed, @JsonKey(includeToJson: false, includeFromJson: false)  String? photoErrorMessage, @JsonKey(includeToJson: false, includeFromJson: false)  PlatformFile? pendingPhotoFile, @JsonKey(includeToJson: false, includeFromJson: false)  CancelToken? cancelToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RiderPersonalProfileState() when $default != null:
return $default(_that.fullName,_that.email,_that.mobile,_that.image,_that.residentialAddress,_that.residentialState,_that.city,_that.gender,_that.nextOfKinName,_that.nextOfKinMobile,_that.filteredCities,_that.currentPassword,_that.newPassword,_that.isEditMode,_that.profileLoadStatus,_that.isLoading,_that.errorMessage,_that.success,_that.hasSubmitted,_that.isUploadingPhoto,_that.photoUploadFailed,_that.photoErrorMessage,_that.pendingPhotoFile,_that.cancelToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fullName,  String email,  String mobile,  String image,  String residentialAddress,  String residentialState,  String city,  String gender,  String nextOfKinName,  String nextOfKinMobile, @JsonKey(includeToJson: false, includeFromJson: false)  List<String> filteredCities, @JsonKey(includeToJson: false, includeFromJson: false)  String currentPassword, @JsonKey(includeToJson: false, includeFromJson: false)  String newPassword, @JsonKey(includeToJson: false, includeFromJson: false)  bool isEditMode, @JsonKey(includeToJson: false, includeFromJson: false)  PersonalProfileLoadStatus profileLoadStatus, @JsonKey(includeToJson: false, includeFromJson: false)  bool isLoading, @JsonKey(includeToJson: false, includeFromJson: false)  String? errorMessage, @JsonKey(includeToJson: false, includeFromJson: false)  bool success, @JsonKey(includeToJson: false, includeFromJson: false)  bool hasSubmitted, @JsonKey(includeToJson: false, includeFromJson: false)  bool isUploadingPhoto, @JsonKey(includeToJson: false, includeFromJson: false)  bool photoUploadFailed, @JsonKey(includeToJson: false, includeFromJson: false)  String? photoErrorMessage, @JsonKey(includeToJson: false, includeFromJson: false)  PlatformFile? pendingPhotoFile, @JsonKey(includeToJson: false, includeFromJson: false)  CancelToken? cancelToken)  $default,) {final _that = this;
switch (_that) {
case _RiderPersonalProfileState():
return $default(_that.fullName,_that.email,_that.mobile,_that.image,_that.residentialAddress,_that.residentialState,_that.city,_that.gender,_that.nextOfKinName,_that.nextOfKinMobile,_that.filteredCities,_that.currentPassword,_that.newPassword,_that.isEditMode,_that.profileLoadStatus,_that.isLoading,_that.errorMessage,_that.success,_that.hasSubmitted,_that.isUploadingPhoto,_that.photoUploadFailed,_that.photoErrorMessage,_that.pendingPhotoFile,_that.cancelToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fullName,  String email,  String mobile,  String image,  String residentialAddress,  String residentialState,  String city,  String gender,  String nextOfKinName,  String nextOfKinMobile, @JsonKey(includeToJson: false, includeFromJson: false)  List<String> filteredCities, @JsonKey(includeToJson: false, includeFromJson: false)  String currentPassword, @JsonKey(includeToJson: false, includeFromJson: false)  String newPassword, @JsonKey(includeToJson: false, includeFromJson: false)  bool isEditMode, @JsonKey(includeToJson: false, includeFromJson: false)  PersonalProfileLoadStatus profileLoadStatus, @JsonKey(includeToJson: false, includeFromJson: false)  bool isLoading, @JsonKey(includeToJson: false, includeFromJson: false)  String? errorMessage, @JsonKey(includeToJson: false, includeFromJson: false)  bool success, @JsonKey(includeToJson: false, includeFromJson: false)  bool hasSubmitted, @JsonKey(includeToJson: false, includeFromJson: false)  bool isUploadingPhoto, @JsonKey(includeToJson: false, includeFromJson: false)  bool photoUploadFailed, @JsonKey(includeToJson: false, includeFromJson: false)  String? photoErrorMessage, @JsonKey(includeToJson: false, includeFromJson: false)  PlatformFile? pendingPhotoFile, @JsonKey(includeToJson: false, includeFromJson: false)  CancelToken? cancelToken)?  $default,) {final _that = this;
switch (_that) {
case _RiderPersonalProfileState() when $default != null:
return $default(_that.fullName,_that.email,_that.mobile,_that.image,_that.residentialAddress,_that.residentialState,_that.city,_that.gender,_that.nextOfKinName,_that.nextOfKinMobile,_that.filteredCities,_that.currentPassword,_that.newPassword,_that.isEditMode,_that.profileLoadStatus,_that.isLoading,_that.errorMessage,_that.success,_that.hasSubmitted,_that.isUploadingPhoto,_that.photoUploadFailed,_that.photoErrorMessage,_that.pendingPhotoFile,_that.cancelToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RiderPersonalProfileState implements RiderPersonalProfileState {
  const _RiderPersonalProfileState({this.fullName = '', this.email = '', this.mobile = '', this.image = '', this.residentialAddress = '', this.residentialState = '', this.city = '', this.gender = '', this.nextOfKinName = '', this.nextOfKinMobile = '', @JsonKey(includeToJson: false, includeFromJson: false) final  List<String> filteredCities = const [], @JsonKey(includeToJson: false, includeFromJson: false) this.currentPassword = '', @JsonKey(includeToJson: false, includeFromJson: false) this.newPassword = '', @JsonKey(includeToJson: false, includeFromJson: false) this.isEditMode = false, @JsonKey(includeToJson: false, includeFromJson: false) this.profileLoadStatus = PersonalProfileLoadStatus.initial, @JsonKey(includeToJson: false, includeFromJson: false) this.isLoading = false, @JsonKey(includeToJson: false, includeFromJson: false) this.errorMessage, @JsonKey(includeToJson: false, includeFromJson: false) this.success = false, @JsonKey(includeToJson: false, includeFromJson: false) this.hasSubmitted = false, @JsonKey(includeToJson: false, includeFromJson: false) this.isUploadingPhoto = false, @JsonKey(includeToJson: false, includeFromJson: false) this.photoUploadFailed = false, @JsonKey(includeToJson: false, includeFromJson: false) this.photoErrorMessage, @JsonKey(includeToJson: false, includeFromJson: false) this.pendingPhotoFile, @JsonKey(includeToJson: false, includeFromJson: false) this.cancelToken}): _filteredCities = filteredCities;
  factory _RiderPersonalProfileState.fromJson(Map<String, dynamic> json) => _$RiderPersonalProfileStateFromJson(json);

@override@JsonKey() final  String fullName;
@override@JsonKey() final  String email;
@override@JsonKey() final  String mobile;
@override@JsonKey() final  String image;
@override@JsonKey() final  String residentialAddress;
@override@JsonKey() final  String residentialState;
@override@JsonKey() final  String city;
@override@JsonKey() final  String gender;
@override@JsonKey() final  String nextOfKinName;
@override@JsonKey() final  String nextOfKinMobile;
 final  List<String> _filteredCities;
@override@JsonKey(includeToJson: false, includeFromJson: false) List<String> get filteredCities {
  if (_filteredCities is EqualUnmodifiableListView) return _filteredCities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredCities);
}

@override@JsonKey(includeToJson: false, includeFromJson: false) final  String currentPassword;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  String newPassword;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool isEditMode;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  PersonalProfileLoadStatus profileLoadStatus;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool isLoading;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  String? errorMessage;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool success;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool hasSubmitted;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool isUploadingPhoto;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool photoUploadFailed;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  String? photoErrorMessage;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  PlatformFile? pendingPhotoFile;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  CancelToken? cancelToken;

/// Create a copy of RiderPersonalProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RiderPersonalProfileStateCopyWith<_RiderPersonalProfileState> get copyWith => __$RiderPersonalProfileStateCopyWithImpl<_RiderPersonalProfileState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RiderPersonalProfileStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RiderPersonalProfileState&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.image, image) || other.image == image)&&(identical(other.residentialAddress, residentialAddress) || other.residentialAddress == residentialAddress)&&(identical(other.residentialState, residentialState) || other.residentialState == residentialState)&&(identical(other.city, city) || other.city == city)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.nextOfKinName, nextOfKinName) || other.nextOfKinName == nextOfKinName)&&(identical(other.nextOfKinMobile, nextOfKinMobile) || other.nextOfKinMobile == nextOfKinMobile)&&const DeepCollectionEquality().equals(other._filteredCities, _filteredCities)&&(identical(other.currentPassword, currentPassword) || other.currentPassword == currentPassword)&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword)&&(identical(other.isEditMode, isEditMode) || other.isEditMode == isEditMode)&&(identical(other.profileLoadStatus, profileLoadStatus) || other.profileLoadStatus == profileLoadStatus)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.success, success) || other.success == success)&&(identical(other.hasSubmitted, hasSubmitted) || other.hasSubmitted == hasSubmitted)&&(identical(other.isUploadingPhoto, isUploadingPhoto) || other.isUploadingPhoto == isUploadingPhoto)&&(identical(other.photoUploadFailed, photoUploadFailed) || other.photoUploadFailed == photoUploadFailed)&&(identical(other.photoErrorMessage, photoErrorMessage) || other.photoErrorMessage == photoErrorMessage)&&(identical(other.pendingPhotoFile, pendingPhotoFile) || other.pendingPhotoFile == pendingPhotoFile)&&(identical(other.cancelToken, cancelToken) || other.cancelToken == cancelToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,fullName,email,mobile,image,residentialAddress,residentialState,city,gender,nextOfKinName,nextOfKinMobile,const DeepCollectionEquality().hash(_filteredCities),currentPassword,newPassword,isEditMode,profileLoadStatus,isLoading,errorMessage,success,hasSubmitted,isUploadingPhoto,photoUploadFailed,photoErrorMessage,pendingPhotoFile,cancelToken]);

@override
String toString() {
  return 'RiderPersonalProfileState(fullName: $fullName, email: $email, mobile: $mobile, image: $image, residentialAddress: $residentialAddress, residentialState: $residentialState, city: $city, gender: $gender, nextOfKinName: $nextOfKinName, nextOfKinMobile: $nextOfKinMobile, filteredCities: $filteredCities, currentPassword: $currentPassword, newPassword: $newPassword, isEditMode: $isEditMode, profileLoadStatus: $profileLoadStatus, isLoading: $isLoading, errorMessage: $errorMessage, success: $success, hasSubmitted: $hasSubmitted, isUploadingPhoto: $isUploadingPhoto, photoUploadFailed: $photoUploadFailed, photoErrorMessage: $photoErrorMessage, pendingPhotoFile: $pendingPhotoFile, cancelToken: $cancelToken)';
}


}

/// @nodoc
abstract mixin class _$RiderPersonalProfileStateCopyWith<$Res> implements $RiderPersonalProfileStateCopyWith<$Res> {
  factory _$RiderPersonalProfileStateCopyWith(_RiderPersonalProfileState value, $Res Function(_RiderPersonalProfileState) _then) = __$RiderPersonalProfileStateCopyWithImpl;
@override @useResult
$Res call({
 String fullName, String email, String mobile, String image, String residentialAddress, String residentialState, String city, String gender, String nextOfKinName, String nextOfKinMobile,@JsonKey(includeToJson: false, includeFromJson: false) List<String> filteredCities,@JsonKey(includeToJson: false, includeFromJson: false) String currentPassword,@JsonKey(includeToJson: false, includeFromJson: false) String newPassword,@JsonKey(includeToJson: false, includeFromJson: false) bool isEditMode,@JsonKey(includeToJson: false, includeFromJson: false) PersonalProfileLoadStatus profileLoadStatus,@JsonKey(includeToJson: false, includeFromJson: false) bool isLoading,@JsonKey(includeToJson: false, includeFromJson: false) String? errorMessage,@JsonKey(includeToJson: false, includeFromJson: false) bool success,@JsonKey(includeToJson: false, includeFromJson: false) bool hasSubmitted,@JsonKey(includeToJson: false, includeFromJson: false) bool isUploadingPhoto,@JsonKey(includeToJson: false, includeFromJson: false) bool photoUploadFailed,@JsonKey(includeToJson: false, includeFromJson: false) String? photoErrorMessage,@JsonKey(includeToJson: false, includeFromJson: false) PlatformFile? pendingPhotoFile,@JsonKey(includeToJson: false, includeFromJson: false) CancelToken? cancelToken
});




}
/// @nodoc
class __$RiderPersonalProfileStateCopyWithImpl<$Res>
    implements _$RiderPersonalProfileStateCopyWith<$Res> {
  __$RiderPersonalProfileStateCopyWithImpl(this._self, this._then);

  final _RiderPersonalProfileState _self;
  final $Res Function(_RiderPersonalProfileState) _then;

/// Create a copy of RiderPersonalProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? email = null,Object? mobile = null,Object? image = null,Object? residentialAddress = null,Object? residentialState = null,Object? city = null,Object? gender = null,Object? nextOfKinName = null,Object? nextOfKinMobile = null,Object? filteredCities = null,Object? currentPassword = null,Object? newPassword = null,Object? isEditMode = null,Object? profileLoadStatus = null,Object? isLoading = null,Object? errorMessage = freezed,Object? success = null,Object? hasSubmitted = null,Object? isUploadingPhoto = null,Object? photoUploadFailed = null,Object? photoErrorMessage = freezed,Object? pendingPhotoFile = freezed,Object? cancelToken = freezed,}) {
  return _then(_RiderPersonalProfileState(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,residentialAddress: null == residentialAddress ? _self.residentialAddress : residentialAddress // ignore: cast_nullable_to_non_nullable
as String,residentialState: null == residentialState ? _self.residentialState : residentialState // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,nextOfKinName: null == nextOfKinName ? _self.nextOfKinName : nextOfKinName // ignore: cast_nullable_to_non_nullable
as String,nextOfKinMobile: null == nextOfKinMobile ? _self.nextOfKinMobile : nextOfKinMobile // ignore: cast_nullable_to_non_nullable
as String,filteredCities: null == filteredCities ? _self._filteredCities : filteredCities // ignore: cast_nullable_to_non_nullable
as List<String>,currentPassword: null == currentPassword ? _self.currentPassword : currentPassword // ignore: cast_nullable_to_non_nullable
as String,newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String,isEditMode: null == isEditMode ? _self.isEditMode : isEditMode // ignore: cast_nullable_to_non_nullable
as bool,profileLoadStatus: null == profileLoadStatus ? _self.profileLoadStatus : profileLoadStatus // ignore: cast_nullable_to_non_nullable
as PersonalProfileLoadStatus,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,hasSubmitted: null == hasSubmitted ? _self.hasSubmitted : hasSubmitted // ignore: cast_nullable_to_non_nullable
as bool,isUploadingPhoto: null == isUploadingPhoto ? _self.isUploadingPhoto : isUploadingPhoto // ignore: cast_nullable_to_non_nullable
as bool,photoUploadFailed: null == photoUploadFailed ? _self.photoUploadFailed : photoUploadFailed // ignore: cast_nullable_to_non_nullable
as bool,photoErrorMessage: freezed == photoErrorMessage ? _self.photoErrorMessage : photoErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,pendingPhotoFile: freezed == pendingPhotoFile ? _self.pendingPhotoFile : pendingPhotoFile // ignore: cast_nullable_to_non_nullable
as PlatformFile?,cancelToken: freezed == cancelToken ? _self.cancelToken : cancelToken // ignore: cast_nullable_to_non_nullable
as CancelToken?,
  ));
}


}

// dart format on
