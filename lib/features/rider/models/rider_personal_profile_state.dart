import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'rider_personal_profile_state.freezed.dart';
part 'rider_personal_profile_state.g.dart';

enum PersonalProfileLoadStatus { initial, loading, loaded, error }

@freezed
abstract class RiderPersonalProfileState with _$RiderPersonalProfileState {
  const factory RiderPersonalProfileState({
    @Default('') String fullName,
    @Default('') String email,
    @Default('') String mobile,
    @Default('') String image,
    @Default('') String residentialAddress,
    @Default('') String residentialState,
    @Default('') String city,
    @Default('') String gender,
    @Default('') String nextOfKinName,
    @Default('') String nextOfKinMobile,

    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default([])
    List<String> filteredCities,

    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default('')
    String currentPassword,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default('')
    String newPassword,

    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool isEditMode,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(PersonalProfileLoadStatus.initial)
    PersonalProfileLoadStatus profileLoadStatus,
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
    @Default(false)
    bool isUploadingPhoto,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(false)
    bool photoUploadFailed,
    @JsonKey(includeToJson: false, includeFromJson: false)
    String? photoErrorMessage,
    @JsonKey(includeToJson: false, includeFromJson: false)
    PlatformFile? pendingPhotoFile,
    @JsonKey(includeToJson: false, includeFromJson: false)
    CancelToken? cancelToken,
  }) = _RiderPersonalProfileState;

  factory RiderPersonalProfileState.fromJson(Map<String, dynamic> json) =>
      _$RiderPersonalProfileStateFromJson(json);
}
