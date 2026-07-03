import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/local/secure_storage.dart';
import 'package:wigo_flutter/features/rider/models/rider_vehicle_profile_state.dart';
import 'package:wigo_flutter/features/rider/service/rider_api_service.dart';
import 'package:wigo_flutter/shared/widgets/custom_loading_overlay.dart';

import '../../../core/auth/auth_state.dart';
import '../../../core/auth/auth_state_notifier.dart';
import '../../../core/network/network.dart';
import '../../../core/utils/helper_methods_classes.dart';
import '../../../core/utils/validation_utils.dart';

class RiderVehicleProfileViewmodel
    extends StateNotifier<RiderVehicleProfileState> {
  final Reader read;
  final RiderApiService api;

  RiderVehicleProfileViewmodel(this.read, {RiderApiService? apiService})
    : api = apiService ?? read(riderApiServiceProvider),
      super(const RiderVehicleProfileState());

  static const String _profileFetchedKey = 'rider_profile_fetched_once';
  static const String _profileCacheKey = 'rider_profile_cache';

  final SecureStorage _storage = SecureStorage();

  final ValueNotifier<String?> selectedTransportMode = ValueNotifier(null);
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController makeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController driverLicenseNumberController =
      TextEditingController();
  final TextEditingController driverLicenseExpiryController =
      TextEditingController();
  final TextEditingController vehicleRegNumberController =
      TextEditingController();
  final TextEditingController vehicleRegExpiryController =
      TextEditingController();
  final TextEditingController ninNumberController = TextEditingController();

  @override
  void dispose() {
    plateNumberController.dispose();
    makeController.dispose();
    modelController.dispose();
    colorController.dispose();
    yearController.dispose();
    driverLicenseNumberController.dispose();
    driverLicenseExpiryController.dispose();
    vehicleRegNumberController.dispose();
    vehicleRegExpiryController.dispose();
    ninNumberController.dispose();
    selectedTransportMode.dispose();
    super.dispose();
  }

  void updateTransportMode(String? value) {
    state = state.copyWith(type: value!);
    selectedTransportMode.value = value;
  }

  void updatePlateNumber(String value) =>
      state = state.copyWith(plateNumber: value);

  void updateMake(String value) => state = state.copyWith(make: value);

  void updateModel(String value) => state = state.copyWith(model: value);

  void updateColor(String value) => state = state.copyWith(color: value);

  void updateYear(String value) => state = state.copyWith(year: value);

  void updateNin(String value) => state = state.copyWith(ownerNIN: value);

  void updateVehicleReg(String value) =>
      state = state.copyWith(vehicleReg: value);

  void updateLicense(String value) => state = state.copyWith(license: value);

  void updateDriverLicenseNumber(String value) =>
      state = state.copyWith(driverLicenseNumber: value);

  void updateDriverLicenseExpiry(String value) =>
      state = state.copyWith(driverLicenseExpiry: value);

  void updateVehicleRegNumber(String value) =>
      state = state.copyWith(vehicleRegNumber: value);

  void updateVehicleRegExpiry(String value) =>
      state = state.copyWith(vehicleRegExpiry: value);

  void updateNinNumber(String value) =>
      state = state.copyWith(ninNumber: value);

  void toggleWorkingDay(String day) {
    final updated = List<String>.from(state.workingDays);
    if (updated.contains(day)) {
      updated.remove(day);
    } else {
      updated.add(day);
    }
    state = state.copyWith(workingDays: updated);
  }

  void clearError() => state = state.copyWith(errorMessage: null);

  void enterEditMode() => state = state.copyWith(isEditMode: true);

  void exitEditMode() {
    _loadFromCache();
    state = state.copyWith(isEditMode: false, hasSubmitted: false);
  }

  /// Called once when the screen mounts. Uses secure storage to ensure the
  /// API is only hit once per install (or until the cache is cleared). On
  /// subsequent visits the cached data is loaded instantly.
  Future<void> fetchProfileIfNeeded(BuildContext context) async {
    // final fetchedOnce = await _storage.read(key: _profileFetchedKey) == 'true';

    final fetchedOnce = await _storage.getData(key: _profileFetchedKey);

    if (fetchedOnce.data == "true") {
      await _loadFromCache();
      return;
    }

    // First visit — hit the API with up to 3 attempts.
    if (!context.mounted) return;
    await _fetchProfileWithRetry(context, maxAttempts: 3);
  }

  Future<void> _fetchProfileWithRetry(
    BuildContext context, {
    required int maxAttempts,
  }) async {
    state = state.copyWith(profileLoadStatus: ProfileLoadStatus.loading);

    await runWithOverlay(context, () async {
      for (int attempt = 1; attempt <= maxAttempts; attempt++) {
        final result = await api.getRiderProfile();

        if (result.isSuccess && result.data != null) {
          // Case 3: Profile exists — populate, cache, go read-only.
          await _markFetchedOnce();
          await _cacheProfile(result.data!);
          _populateFromProfile(result.data!);
          state = state.copyWith(
            profileLoadStatus: ProfileLoadStatus.loaded,
            hasProfile: true,
            isEditMode: false,
          );
          return;
        }

        // Detect "profile not found" vs a transient network error.
        // Adjust the string below if your backend uses a different message.
        final errorDesc =
            result.errorDescription?.toString().toLowerCase() ?? '';
        final isNotFound =
            errorDesc.contains('Dispatch profile not found') ||
            errorDesc.contains('profile') ||
            errorDesc.contains('404');

        if (isNotFound) {
          // Case 2: No profile yet — show the create form.
          await _markFetchedOnce();
          state = state.copyWith(
            profileLoadStatus: ProfileLoadStatus.notFound,
            hasProfile: false,
          );
          return;
        }

        // Transient error — wait before retrying (exponential back-off).
        if (attempt < maxAttempts) {
          await Future.delayed(Duration(seconds: attempt));
        }
      }

      // Max retries exceeded. Mark as fetched so we don't loop forever.
      // The screen will show an error state with a retry button.
      await _markFetchedOnce();
      state = state.copyWith(profileLoadStatus: ProfileLoadStatus.error);
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }

  Future<void> _loadFromCache() async {
    // final cachedJson = await _storage.read(key: _profileCacheKey);
    final cachedJson = await _storage.getData(key: _profileCacheKey);

    if (!cachedJson.isSuccess) {
      state = state.copyWith(
        profileLoadStatus: ProfileLoadStatus.notFound,
        hasProfile: false,
      );
      return;
    }
    try {
      final data = jsonDecode(cachedJson.data) as Map<String, dynamic>;
      _populateFromProfile(data);
      state = state.copyWith(
        profileLoadStatus: ProfileLoadStatus.loaded,
        hasProfile: true,
        isEditMode: false,
      );
    } catch (_) {
      state = state.copyWith(
        profileLoadStatus: ProfileLoadStatus.notFound,
        hasProfile: false,
      );
    }
  }

  Future<void> _markFetchedOnce() =>
      _storage.storeData(key: _profileFetchedKey, data: 'true');

  Future<void> _cacheProfile(Map<String, dynamic> data) =>
      _storage.storeData(key: _profileCacheKey, data: jsonEncode(data));

  /// Maps backend type strings ("car", "bike") to dropdown display values
  /// ("Car", "Motor Bike"). Extend the switch if new types are added.
  String _mapTypeToDropdown(String backendType) {
    switch (backendType.toLowerCase()) {
      case 'feet':
        return 'Feet';
      case 'bicycle':
        return 'Bicycle';
      case 'car':
        return 'Car';
      case 'motor bike':
      case 'motorbike':
      case 'bike':
        return 'Motor Bike';
      case 'bus':
        return 'Bus';
      default:
        return backendType;
    }
  }

  void _populateFromProfile(Map<String, dynamic> rawData) {
    final Map<String, dynamic> data;
    if (rawData.containsKey('vehicleInfo')) {
      // Already the flat inner object — use directly.
      data = rawData;
    } else if (rawData.containsKey('data') &&
        rawData['data'] is Map<String, dynamic>) {
      // Full envelope — unwrap.
      data = rawData['data'] as Map<String, dynamic>;
    } else {
      data = rawData;
    }

    final vehicleInfo = (data['vehicleInfo'] as Map<String, dynamic>?) ?? {};
    final documents = (data['documents'] as Map<String, dynamic>?) ?? {};
    final driverLicense =
        (documents['driverLicense'] as Map<String, dynamic>?) ?? {};
    final vehicleReg =
        (documents['vehicleRegistration'] as Map<String, dynamic>?) ?? {};
    final nin = (documents['nin'] as Map<String, dynamic>?) ?? {};
    final availability = (data['availability'] as Map<String, dynamic>?) ?? {};
    final workingDays =
        (availability['workingDays'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final backendType = vehicleInfo['type']?.toString() ?? '';
    final dropdownType = _mapTypeToDropdown(backendType);

    plateNumberController.text = vehicleInfo['plateNumber']?.toString() ?? '';
    makeController.text = vehicleInfo['make']?.toString() ?? '';
    modelController.text = vehicleInfo['model']?.toString() ?? '';
    colorController.text = vehicleInfo['color']?.toString() ?? '';
    yearController.text = vehicleInfo['year']?.toString() ?? '';
    driverLicenseNumberController.text =
        driverLicense['number']?.toString() ?? '';
    driverLicenseExpiryController.text = DateHelpers.normalizeToDateOnly(
      driverLicense['expiryDate']?.toString(),
    );
    vehicleRegNumberController.text = vehicleReg['number']?.toString() ?? '';
    vehicleRegExpiryController.text = DateHelpers.normalizeToDateOnly(
      vehicleReg['expiryDate']?.toString(),
    );
    ninNumberController.text = nin['number']?.toString() ?? '';

    selectedTransportMode.value = dropdownType.isNotEmpty ? dropdownType : null;

    state = state.copyWith(
      type: dropdownType,
      plateNumber: plateNumberController.text,
      make: makeController.text,
      model: modelController.text,
      year: yearController.text,
      color: colorController.text,
      driverLicenseNumber: driverLicenseNumberController.text,
      driverLicenseExpiry: driverLicenseExpiryController.text,
      vehicleRegNumber: vehicleRegNumberController.text,
      vehicleRegExpiry: vehicleRegExpiryController.text,
      ninNumber: ninNumberController.text,
      license: driverLicense['image']?.toString() ?? '',
      vehicleReg: vehicleReg['image']?.toString() ?? '',
      ownerNIN: nin['image']?.toString() ?? '',
      workingDays: workingDays,
    );
  }

  Future<String?> uploadToCloudinary({
    required PlatformFile file,
    required String folder,
    required Function(double progress) onProgress,
    required CancelToken cancelToken,
  }) async {
    try {
      final signatureRes = await api.getUploadSignature(folder);

      if (!signatureRes.isSuccess) {
        throw Exception("Failed to get signature");
      }

      final data = signatureRes.data!;

      final cloudName = data['cloudName'];
      final apiKey = data['apiKey'];
      final timestamp = data['timestamp'];
      final signature = data['signature'];

      final url = "https://api.cloudinary.com/v1_1/$cloudName/auto/upload";

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
        "file": fileMultipart,
        "api_key": apiKey,
        "timestamp": timestamp,
        "signature": signature,
        "folder": folder,
      });

      final response = await Dio().post(
        url,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: (sent, total) {
          if (total != -1) {
            final progress = sent / total;
            onProgress(progress);
          }
        },
      );

      return response.data['secure_url'];
    } catch (e) {
      debugPrint("UPLOAD ERROR => $e");
      return null;
    }
  }

  Future<void> uploadDriverLicense(PlatformFile file) async {
    final cancelToken = CancelToken();
    state = state.copyWith(
      isUploadingDriverLicense: true,
      licenseProgress: 0,
      cancelToken: cancelToken,
      driverLicenseFile: file,
      driverLicenseUploadFailed: false,
    );

    final url = await uploadToCloudinary(
      file: file,
      folder: "dispatch-documents",
      cancelToken: cancelToken,
      onProgress: (progress) {
        state = state.copyWith(licenseProgress: progress);
      },
    );

    if (url != null) {
      state = state.copyWith(
        license: url,
        isUploadingDriverLicense: false,
        licenseProgress: 1,
        driverLicenseUploadFailed: false,
      );
    } else {
      state = state.copyWith(
        isUploadingDriverLicense: false,
        errorMessage: "Failed to upload Driver License",
        driverLicenseUploadFailed: true,
        licenseProgress: 0,
      );
    }
  }

  Future<void> uploadNin(PlatformFile file) async {
    final cancelToken = CancelToken();

    state = state.copyWith(
      isUploadingNin: true,
      ninProgress: 0,
      cancelToken: cancelToken,
      ninFile: file,
      ninUploadFailed: false,
    );

    final url = await uploadToCloudinary(
      file: file,
      folder: "dispatch-documents",
      cancelToken: cancelToken,
      onProgress: (progress) {
        state = state.copyWith(ninProgress: progress);
      },
    );

    if (url != null) {
      state = state.copyWith(
        ownerNIN: url,
        isUploadingNin: false,
        ninProgress: 1,
        ninUploadFailed: false,
      );
    } else {
      state = state.copyWith(
        isUploadingNin: false,
        errorMessage: "Failed to upload NIN",
        ninProgress: 0,
        ninUploadFailed: true,
      );
    }
  }

  Future<void> uploadVehicleReg(PlatformFile file) async {
    final cancelToken = CancelToken();

    state = state.copyWith(
      isUploadingDriverRegistration: true,
      driverRegProgress: 0,
      cancelToken: cancelToken,
      driverRegistrationFile: file,
      driverRegUploadFailed: false,
    );

    final url = await uploadToCloudinary(
      file: file,
      folder: "dispatch-documents",
      cancelToken: cancelToken,
      onProgress: (progress) {
        state = state.copyWith(driverRegProgress: progress);
      },
    );

    if (url != null) {
      state = state.copyWith(
        vehicleReg: url,
        isUploadingDriverRegistration: false,
        driverRegProgress: 1,
        driverRegUploadFailed: false,
      );
    } else {
      state = state.copyWith(
        isUploadingDriverRegistration: false,
        errorMessage: "Failed to upload Vehicle Registration",
        driverRegProgress: 0,
        driverRegUploadFailed: true,
      );
    }
  }

  Map<String, dynamic> _buildPayload(String coverageArea) {
    return {
      'vehicleInfo': {
        'type': state.type.toLowerCase(),
        'make': state.make,
        'model': state.model,
        'year': int.tryParse(state.year) ?? 0,
        'plateNumber': state.plateNumber,
        'color': state.color,
      },

      // The backend's coverageAreas schema is an embedded document type.
      // If the PATCH (edit) endpoint later rejects this and needs plain
      // strings, change the update payload to: "coverageAreas": [coverageArea]
      'coverageAreas': [
        {
          'name': coverageArea,
          'coordinates': {'latitude': 0, 'longitude': 0},
          'radius': 0,
        },
      ],
      'documents': {
        'driverLicense': {
          'number': state.driverLicenseNumber,
          'expiryDate': state.driverLicenseExpiry,
          'image': state.license,
        },
        'vehicleRegistration': {
          'number': state.vehicleRegNumber,
          'expiryDate': state.vehicleRegExpiry,
          'image': state.vehicleReg,
        },
        'nin': {'number': state.ninNumber, 'image': state.ownerNIN},
      },
      'workingDays': state.workingDays,
    };
  }

  String _resolveCoverageArea(WidgetRef ref) {
    final authState = ref.read(authStateProvider);
    if (authState.status == AuthStatus.loggedIn && authState.user != null) {
      return authState.user!.city;
    }
    return 'default';
  }

  void validateOnSubmit() {
    final isVehicle = state.type.toLowerCase() != 'feet';

    final requiredFields = isVehicle
        ? {
            'type': state.type,
            'plateNumber': state.plateNumber,
            'make': state.make,
            'year': state.year,
            'color': state.color,
            'model': state.model,
            'ownerNIN': state.ownerNIN,
            'license': state.license,
            'vehicleReg': state.vehicleReg,
            'driverLicenseNumber': state.driverLicenseNumber,
            'driverLicenseExpiry': state.driverLicenseExpiry,
            'vehicleRegNumber': state.vehicleRegNumber,
            'vehicleRegExpiry': state.vehicleRegExpiry,
            'ninNumber': state.ninNumber,
          }
        : {'type': state.type};

    final hasEmptyField = requiredFields.values.any(
      FormValidators.isFieldEmpty,
    );
    final hasNoWorkingDays = state.workingDays.isEmpty;

    String? error;
    if (hasEmptyField) {
      error = 'Please complete all required fields';
    } else if (hasNoWorkingDays) {
      error = 'Please select at least one working day';
    }

    state = state.copyWith(hasSubmitted: true, errorMessage: error);
  }

  Future<bool> submit(WidgetRef ref) async {
    validateOnSubmit();

    if (state.errorMessage != null) return false;

    state = state.copyWith(isLoading: true, errorMessage: null, success: false);

    try {
      final payload = _buildPayload(_resolveCoverageArea(ref));

      final result = await api.createRiderProfile(payload);

      if (result.isSuccess == true) {
        await _refreshAndCache();
        state = state.copyWith(
          isLoading: false,
          success: true,
          hasProfile: true,
          isEditMode: false,
          profileLoadStatus: ProfileLoadStatus.loaded,
        );
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

  Future<bool> updateProfile(WidgetRef ref) async {
    validateOnSubmit();
    if (state.errorMessage != null) return false;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final payload = _buildPayload(_resolveCoverageArea(ref));
      final result = await api.updateRiderProfile(payload);

      if (result.isSuccess == true) {
        await _refreshAndCache();
        state = state.copyWith(
          isLoading: false,
          hasProfile: true,
          isEditMode: false,
          profileLoadStatus: ProfileLoadStatus.loaded,
        );
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

  Future<void> _refreshAndCache() async {
    final getResult = await api.getRiderProfile();
    if (getResult.isSuccess && getResult.data != null) {
      await _cacheProfile(getResult.data!);
      _populateFromProfile(getResult.data!);
    }
  }

  void cancelNinUpload() {
    state.cancelToken?.cancel("Upload cancelled");

    state = state.copyWith(isUploadingNin: false, ninProgress: 0);
  }

  void retryNinUpload() {
    if (state.ninFile != null) {
      uploadNin(state.ninFile!);
    }
  }

  void cancelVehicleRegUpload() {
    state.cancelToken?.cancel("Upload cancelled");

    state = state.copyWith(
      isUploadingDriverRegistration: false,
      driverRegProgress: 0,
    );
  }

  void retryVehicleRegUpload() {
    if (state.driverRegistrationFile != null) {
      uploadVehicleReg(state.driverRegistrationFile!);
    }
  }

  void cancelLicenseUpload() {
    state.cancelToken?.cancel("Upload cancelled");

    state = state.copyWith(isUploadingDriverLicense: false, licenseProgress: 0);
  }

  void retryLicenseUpload() {
    if (state.driverLicenseFile != null) {
      uploadDriverLicense(state.driverLicenseFile!);
    }
  }
}

final riderVehicleProfileViewmodelProvider =
    StateNotifierProvider<
      RiderVehicleProfileViewmodel,
      RiderVehicleProfileState
    >((ref) => RiderVehicleProfileViewmodel(ref.read));
