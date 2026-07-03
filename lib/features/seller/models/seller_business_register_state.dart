import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'seller_business_register_state.freezed.dart';
part 'seller_business_register_state.g.dart';

@freezed
abstract class SellerBusinessRegisterState with _$SellerBusinessRegisterState {
  const factory SellerBusinessRegisterState({
    @Default('') String name,
    @Default('') String storeEmail,
    @Default('') String storeMobile,
    @Default('') String address,
    @Default('') String state,
    @Default('') String city,
    @Default('') String ownerNIN,
    @Default('') String businessType,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(0.0)
    double storeImageProgress,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(0.0)
    double ninProgress,
    String? description,
    String? storeImage,
    @JsonKey(includeToJson: false, includeFromJson: false)
    CancelToken? cancelToken,

    @JsonKey(includeToJson: false, includeFromJson: false)
    PlatformFile? storeImageFile,

    @JsonKey(includeToJson: false, includeFromJson: false)
    PlatformFile? ninFile,
    @Default([]) List<String> filteredCities,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool isLoading,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool isUploadingStoreImage,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool isUploadingNin,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool agreeToTerms,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool uploadFailed,
    @JsonKey(includeToJson: false, includeFromJson: false) String? errorMessage,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool success,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool hasSubmitted,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool ninUploadFailed,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool storeImageUploadFailed,
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool isFetchingLocation,
    @JsonKey(includeToJson: false, includeFromJson: false)
    String? locationError,
    @JsonKey(includeToJson: false, includeFromJson: false) String? emailError,
  }) = _SellerBusinessRegisterState;

  factory SellerBusinessRegisterState.fromJson(Map<String, dynamic> json) =>
      _$SellerBusinessRegisterStateFromJson(json);
}

extension SellerBusinessRegisterStateX on SellerBusinessRegisterState {
  SellerBusinessRegisterState clearCity() => copyWith(city: '');
}
