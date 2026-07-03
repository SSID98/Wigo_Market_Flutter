import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/auth/auth_state.dart';
import '../../../core/auth/auth_state_notifier.dart';
import '../../../core/local/secure_storage.dart';
import '../../../core/network/network.dart';
import '../../../shared/models/location_data.dart';
import '../models/rider_personal_profile_state.dart';
import '../service/rider_api_service.dart';

class RiderPersonalProfileViewModel
    extends StateNotifier<RiderPersonalProfileState> {
  final Reader read;
  final RiderApiService api;

  RiderPersonalProfileViewModel(this.read, {RiderApiService? apiService})
    : api = apiService ?? read(riderApiServiceProvider),
      super(const RiderPersonalProfileState());

  static const String _profileCacheKey = 'rider_personal_profile_cache';
  static const String _profileSeededKey = 'rider_personal_profile_seeded';

  final SecureStorage _storage = SecureStorage();

  RiderPersonalProfileState? _preEditSnapshot;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController nextOfKinNameController = TextEditingController();
  final TextEditingController nextOfKinMobileController =
      TextEditingController();
  final TextEditingController residentialAddressController =
      TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final ValueNotifier<String?> selectedGender = ValueNotifier(null);
  final ValueNotifier<String?> selectedState = ValueNotifier(null);
  final ValueNotifier<String?> selectedCity = ValueNotifier(null);

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    nextOfKinNameController.dispose();
    nextOfKinMobileController.dispose();
    residentialAddressController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    selectedGender.dispose();
    selectedState.dispose();
    selectedCity.dispose();
    super.dispose();
  }

  void updateFullName(String v) => state = state.copyWith(fullName: v);

  void updateMobile(String v) => state = state.copyWith(mobile: v);

  void updateNextOfKinName(String v) =>
      state = state.copyWith(nextOfKinName: v);

  void updateNextOfKinMobile(String v) =>
      state = state.copyWith(nextOfKinMobile: v);

  void updateResidentialAddress(String v) =>
      state = state.copyWith(residentialAddress: v);

  void updateCurrentPassword(String v) =>
      state = state.copyWith(currentPassword: v);

  void updateNewPassword(String v) => state = state.copyWith(newPassword: v);

  void updateGender(String? v) {
    selectedGender.value = v;
    state = state.copyWith(gender: v ?? '');
  }

  void updateResidentialState(String? value) {
    if (value != null) {
      final newFilteredCities = nigeriaStatesAndCities[value] ?? [];
      state = state.copyWith(
        residentialState: value,
        filteredCities: newFilteredCities,
        city: '',
      );
      selectedState.value = value;
      selectedCity.value = null;
    } else {
      state = state.copyWith(
        residentialState: '',
        filteredCities: [],
        city: '',
      );
      selectedState.value = null;
      selectedCity.value = null;
    }
  }

  void updateCity(String? v) {
    selectedCity.value = v;
    state = state.copyWith(city: v ?? '');
  }

  void enterEditMode() {
    _preEditSnapshot = state;
    state = state.copyWith(
      isEditMode: true,
      hasSubmitted: false,
      errorMessage: null,
    );
  }

  void exitEditMode() {
    final snapshot = _preEditSnapshot;
    if (snapshot != null) {
      _populateControllers(snapshot);
      selectedGender.value = snapshot.gender.isNotEmpty
          ? snapshot.gender
          : null;
      selectedState.value = snapshot.residentialState.isNotEmpty
          ? snapshot.residentialState
          : null;
      selectedCity.value = snapshot.city.isNotEmpty ? snapshot.city : null;
      state = snapshot.copyWith(
        isEditMode: false,
        hasSubmitted: false,
        currentPassword: '',
        newPassword: '',
        errorMessage: null,
        isUploadingPhoto: false,
        photoUploadFailed: false,
        photoErrorMessage: null,
      );
    } else {
      state = state.copyWith(
        isEditMode: false,
        hasSubmitted: false,
        currentPassword: '',
        newPassword: '',
        errorMessage: null,
      );
    }
    _preEditSnapshot = null;
    currentPasswordController.clear();
    newPasswordController.clear();
  }

  Future<void> loadProfileOnce(WidgetRef ref) async {
    if (state.profileLoadStatus == PersonalProfileLoadStatus.loaded) return;

    state = state.copyWith(
      profileLoadStatus: PersonalProfileLoadStatus.loading,
    );

    final seededResult = await _storage.getData(key: _profileSeededKey);

    if (seededResult.isSuccess && seededResult.data == 'true') {
      await _loadFromCache();
    } else {
      await _seedFromAuthState(ref);
    }
  }

  Future<void> _seedFromAuthState(WidgetRef ref) async {
    final authState = ref.read(authStateProvider);

    if (authState.status == AuthStatus.loggedIn && authState.user != null) {
      final user = authState.user!;

      state = state.copyWith(
        fullName: user.fullName,
        email: user.email,
        mobile: user.mobile,
        residentialAddress: user.address,
        residentialState: user.state,
        city: user.city,
        image: user.image,
        filteredCities: nigeriaStatesAndCities[user.state] ?? [],
        profileLoadStatus: PersonalProfileLoadStatus.loaded,
      );

      _populateControllers(state);
      selectedState.value = user.state.isNotEmpty ? user.state : null;
      selectedCity.value = user.city.isNotEmpty ? user.city : null;

      await _cacheProfile();
      await _storage.storeData(key: _profileSeededKey, data: 'true');
    } else {
      state = state.copyWith(
        profileLoadStatus: PersonalProfileLoadStatus.error,
      );
    }
  }

  Future<void> _loadFromCache() async {
    final result = await _storage.getData(key: _profileCacheKey);

    if (!result.isSuccess || result.data == null) {
      state = state.copyWith(
        profileLoadStatus: PersonalProfileLoadStatus.error,
      );
      return;
    }

    try {
      final data = jsonDecode(result.data) as Map<String, dynamic>;
      final cached = RiderPersonalProfileState.fromJson(data);

      state = state.copyWith(
        fullName: cached.fullName,
        email: cached.email,
        mobile: cached.mobile,
        image: cached.image,
        residentialAddress: cached.residentialAddress,
        residentialState: cached.residentialState,
        city: cached.city,
        gender: cached.gender,
        nextOfKinName: cached.nextOfKinName,
        nextOfKinMobile: cached.nextOfKinMobile,
        filteredCities: nigeriaStatesAndCities[cached.residentialState] ?? [],
        profileLoadStatus: PersonalProfileLoadStatus.loaded,
      );

      _populateControllers(state);
      selectedGender.value = cached.gender.isNotEmpty ? cached.gender : null;
      selectedState.value = cached.residentialState.isNotEmpty
          ? cached.residentialState
          : null;
      selectedCity.value = cached.city.isNotEmpty ? cached.city : null;
    } catch (_) {
      state = state.copyWith(
        profileLoadStatus: PersonalProfileLoadStatus.error,
      );
    }
  }

  void _populateControllers(RiderPersonalProfileState s) {
    fullNameController.text = s.fullName;
    emailController.text = s.email;
    mobileController.text = s.mobile;
    nextOfKinNameController.text = s.nextOfKinName;
    nextOfKinMobileController.text = s.nextOfKinMobile;
    residentialAddressController.text = s.residentialAddress;
  }

  Future<void> _cacheProfile() async {
    await _storage.storeData(
      key: _profileCacheKey,
      data: jsonEncode(state.toJson()),
    );
  }

  void validateOnSubmit() {
    final isChangingPassword =
        state.currentPassword.isNotEmpty || state.newPassword.isNotEmpty;

    String? error;
    if (state.fullName.trim().isEmpty) {
      error = 'Full name is required';
    } else if (state.mobile.trim().isEmpty) {
      error = 'Phone number is required';
    } else if (isChangingPassword) {
      if (state.currentPassword.isEmpty) {
        error = 'Enter your current password to change it';
      } else if (state.newPassword.isEmpty) {
        error = 'Enter a new password';
      } else if (state.newPassword.length < 8) {
        error = 'New password must be at least 8 characters';
      }
    }

    state = state.copyWith(hasSubmitted: true, errorMessage: error);
  }

  Future<bool> updateProfile() async {
    validateOnSubmit();
    if (state.errorMessage != null) return false;

    state = state.copyWith(isLoading: true, errorMessage: null, success: false);

    try {
      final result = await api.updateRiderPersonalProfile(_buildPayload());

      if (result.isSuccess == true) {
        if (result.data != null) {
          _applyApiResponse(result.data!);
        }
        await _cacheProfile();

        currentPasswordController.clear();
        newPasswordController.clear();

        state = state.copyWith(
          isLoading: false,
          success: true,
          isEditMode: false,
          hasSubmitted: false,
          currentPassword: '',
          newPassword: '',
          errorMessage: null,
        );
        _preEditSnapshot = null;
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: result.errorDescription?.toString(),
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  void _applyApiResponse(Map<String, dynamic> rawData) {
    final data =
        rawData.containsKey('data') && rawData['data'] is Map<String, dynamic>
        ? rawData['data'] as Map<String, dynamic>
        : rawData;

    final nextOfKin = (data['nextOfKin'] as Map<String, dynamic>?) ?? {};

    final newFullName = data['fullName']?.toString() ?? state.fullName;
    final newMobile = data['mobile']?.toString() ?? state.mobile;
    final newImage = (data['image'] as String?)?.isNotEmpty == true
        ? data['image'] as String
        : state.image;
    final newAddress =
        data['residentialAddress']?.toString() ?? state.residentialAddress;
    final newKinName = nextOfKin['name']?.toString() ?? state.nextOfKinName;
    final newKinMobile =
        nextOfKin['mobile']?.toString() ?? state.nextOfKinMobile;
    // final newGender = data['gender']?.toString() ?? state.gender;
    final newResidentialState =
        data['state']?.toString() ?? state.residentialState;
    final newCity = data['city']?.toString() ?? state.city;

    state = state.copyWith(
      fullName: newFullName,
      mobile: newMobile,
      image: newImage,
      residentialAddress: newAddress,
      nextOfKinName: newKinName,
      nextOfKinMobile: newKinMobile,
      // gender: newGender,
      residentialState: newResidentialState,
      city: newCity,
      filteredCities: nigeriaStatesAndCities[newResidentialState] ?? [],
    );

    fullNameController.text = newFullName;
    mobileController.text = newMobile;
    residentialAddressController.text = newAddress;
    nextOfKinNameController.text = newKinName;
    nextOfKinMobileController.text = newKinMobile;
    // selectedGender.value = newGender;
    selectedState.value = newResidentialState.isNotEmpty
        ? newResidentialState
        : null;
    selectedCity.value = newCity.isNotEmpty ? newCity : null;
  }

  Map<String, dynamic> _buildPayload() {
    final payload = <String, dynamic>{
      'fullName': state.fullName,
      'mobile': state.mobile,
      'residentialAddress': state.residentialAddress,
      'nextOfKin': {
        'name': state.nextOfKinName,
        'mobile': state.nextOfKinMobile,
      },
      // 'gender': state.gender,
      'state': state.residentialState,
      'city': state.city,
    };

    if (state.image.isNotEmpty) {
      payload['image'] = state.image;
    }

    if (state.currentPassword.isNotEmpty && state.newPassword.isNotEmpty) {
      payload['currentPassword'] = state.currentPassword;
      payload['password'] = state.newPassword;
    }

    return payload;
  }

  Future<void> uploadProfilePhoto(PlatformFile file) async {
    final cancelToken = CancelToken();

    state = state.copyWith(
      isUploadingPhoto: true,
      photoUploadFailed: false,
      photoErrorMessage: null,
      pendingPhotoFile: file,
      cancelToken: cancelToken,
    );

    final url = await _uploadToCloudinary(
      file: file,
      folder: 'profiles',
      cancelToken: cancelToken,
      onProgress: (_) {},
    );

    if (url != null) {
      state = state.copyWith(
        image: url,
        isUploadingPhoto: false,
        photoUploadFailed: false,
        photoErrorMessage: null,
        pendingPhotoFile: null,
      );
      await _cacheProfile();
    } else {
      state = state.copyWith(
        isUploadingPhoto: false,
        photoUploadFailed: true,
        photoErrorMessage: 'Photo upload failed. Tap to retry.',
      );
    }
  }

  void retryPhotoUpload() {
    if (state.pendingPhotoFile != null) {
      uploadProfilePhoto(state.pendingPhotoFile!);
    }
  }

  void clearPhotoError() =>
      state = state.copyWith(photoErrorMessage: null, photoUploadFailed: false);

  Future<String?> _uploadToCloudinary({
    required PlatformFile file,
    required String folder,
    required Function(double progress) onProgress,
    required CancelToken cancelToken,
  }) async {
    try {
      final signatureRes = await api.getUploadSignature(folder);
      if (!signatureRes.isSuccess) throw Exception('Failed to get signature');

      final data = signatureRes.data!;
      final cloudName = data['cloudName'];
      final apiKey = data['apiKey'];
      final timestamp = data['timestamp'];
      final signature = data['signature'];

      final url = 'https://api.cloudinary.com/v1_1/$cloudName/auto/upload';

      final MultipartFile fileMultipart;
      if (kIsWeb) {
        fileMultipart = MultipartFile.fromBytes(
          file.bytes!,
          filename: file.name,
        );
      } else {
        fileMultipart = await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        );
      }

      final formData = FormData.fromMap({
        'file': fileMultipart,
        'api_key': apiKey,
        'timestamp': timestamp,
        'signature': signature,
        'folder': folder,
      });

      final response = await Dio().post(
        url,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: (sent, total) {
          if (total != -1) onProgress(sent / total);
        },
      );

      return response.data['secure_url'] as String?;
    } catch (e) {
      debugPrint('PHOTO UPLOAD ERROR => $e');
      return null;
    }
  }
}

final riderPersonalProfileViewModelProvider =
    StateNotifierProvider<
      RiderPersonalProfileViewModel,
      RiderPersonalProfileState
    >((ref) => RiderPersonalProfileViewModel(ref.read));
