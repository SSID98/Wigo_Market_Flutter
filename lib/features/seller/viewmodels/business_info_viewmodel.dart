import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/seller/models/seller_business_register_state.dart';
import 'package:wigo_flutter/shared/widgets/custom_loading_overlay.dart';

import '../../../core/network/network.dart';
import '../../../core/service/user_api_service.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../shared/models/location_data.dart';

final businessInfoViewmodelProvider =
    StateNotifierProvider<BusinessInfoViewModel, SellerBusinessRegisterState>(
      (ref) => BusinessInfoViewModel(ref.read),
    );

class BusinessInfoViewModel extends StateNotifier<SellerBusinessRegisterState> {
  final Reader read;
  final UserApiService api;

  BusinessInfoViewModel(this.read, {UserApiService? apiService})
    : api = apiService ?? read(userApiServiceProvider),
      super(const SellerBusinessRegisterState());

  final ValueNotifier<String?> selectedState = ValueNotifier(null);
  final ValueNotifier<String?> selectedCity = ValueNotifier(null);
  final ValueNotifier<String?> selectedBusiness = ValueNotifier(null);

  void updateBusinessName(String value) => state = state.copyWith(name: value);

  void updateBusinessEmail(String value) =>
      state = state.copyWith(storeEmail: value);

  void updateBusinessPhone(String value) =>
      state = state.copyWith(storeMobile: value);

  void updateLogo(String value) => state = state.copyWith(storeImage: value);

  void updateNin(String value) => state = state.copyWith(ownerNIN: value);

  void updateBusinessType(String? value) {
    state = state.copyWith(businessType: value ?? '');
    selectedBusiness.value = value;
  }

  void updateBusinessAddress(String value) =>
      state = state.copyWith(address: value);

  void updateBusinessState(String? value) {
    if (value != null) {
      final newFilteredCities = nigeriaStatesAndCities[value] ?? [];
      state = state.copyWith(state: value, filteredCities: newFilteredCities);
      selectedState.value = value;
    } else {
      state = state.copyWith(state: '', filteredCities: []);
    }
  }

  void toggleAgreeToTerms(bool? value) {
    state = state.copyWith(agreeToTerms: value ?? false);
  }

  void updateBusinessCity(String? value) {
    state = state.copyWith(city: value ?? '');
    selectedCity.value = value;
  }

  void updateBusinessDescription(String? value) =>
      state = state.copyWith(description: value);

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

  Future<void> uploadStoreImage(PlatformFile file) async {
    final cancelToken = CancelToken();
    state = state.copyWith(
      isUploadingStoreImage: true,
      storeImageProgress: 0,
      cancelToken: cancelToken,
      storeImageFile: file,
      storeImageUploadFailed: false,
    );

    final url = await uploadToCloudinary(
      file: file,
      folder: "stores",
      cancelToken: cancelToken,
      onProgress: (progress) {
        state = state.copyWith(storeImageProgress: progress);
      },
    );

    if (url != null) {
      state = state.copyWith(
        storeImage: url,
        isUploadingStoreImage: false,
        storeImageProgress: 1,
        storeImageUploadFailed: false,
      );
    } else {
      state = state.copyWith(
        isUploadingStoreImage: false,
        errorMessage: "Failed to upload image",
        storeImageUploadFailed: true,
        storeImageProgress: 0,
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
      folder: "store-nin",
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

  Future<bool> fetchLocation() async {
    state = state.copyWith(isFetchingLocation: true, locationError: null);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isFetchingLocation: false,
          locationError:
              "Location services are disabled. Please enable them in settings.",
        );
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(
            isFetchingLocation: false,
            locationError: "Location permission denied.",
          );
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          isFetchingLocation: false,
          locationError:
              "Location permission permanently denied. Please enable it in app settings.",
        );
        return false;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      state = state.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
        isFetchingLocation: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isFetchingLocation: false,
        locationError: "Failed to get location: ${e.toString()}",
      );
      return false;
    }
  }

  void validateOnSubmit() {
    final emailError = FormValidators.validateEmail(state.storeEmail);

    final requiredFields = {
      "name": state.name,
      "storeMobile": state.storeMobile,
      "address": state.address,
      "city": state.city,
      "state": state.state,
      "ownerNIN": state.ownerNIN,
    };

    final hasEmpty = requiredFields.values.any(FormValidators.isFieldEmpty);

    String? errorMessage;
    if (emailError != null) {
      errorMessage = emailError;
    } else if (hasEmpty) {
      errorMessage = "Please complete all required fields";
    }

    state = state.copyWith(hasSubmitted: true, errorMessage: errorMessage);
  }

  Future<bool> submit(BuildContext context) async {
    validateOnSubmit();

    final emailError = FormValidators.validateEmail(state.storeEmail);

    if (emailError != null || state.errorMessage != null) {
      return false;
    }

    if (!state.agreeToTerms) {
      state = state.copyWith(errorMessage: "You must agree to terms.");
      return false;
    }

    final locationFetched = await fetchLocation();
    if (!locationFetched) {
      state = state.copyWith(
        errorMessage:
            state.locationError ?? "Could not get location. Please try again.",
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, success: false);

    if (!context.mounted) return true;

    final result = await runWithOverlay<bool>(context, () async {
      try {
        final payload = {
          "name": state.name,
          "storeEmail": state.storeEmail,
          "storeMobile": state.storeMobile,
          "address": state.address,
          "state": state.state,
          "city": state.city,
          "ownerNIN": state.ownerNIN,
          "businessType": state.businessType,
          if (state.storeImage != null) "storeImage": state.storeImage,
          if (state.description != null && state.description!.isNotEmpty)
            "description": state.description,
          "location": {
            "type": "Point",
            "coordinates": [state.longitude, state.latitude],
          },
        };

        final result = await api.registerSellerBusiness(payload);

        if (result.isSuccess) {
          state = state.copyWith(isLoading: false, success: true);
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
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
    return result;
  }

  void cancelStoreUpload() {
    state.cancelToken?.cancel("Upload cancelled");

    state = state.copyWith(isUploadingStoreImage: false, storeImageProgress: 0);
  }

  void cancelNinUpload() {
    state.cancelToken?.cancel("Upload cancelled");

    state = state.copyWith(isUploadingNin: false, ninProgress: 0);
  }

  void retryUploadStoreImage() {
    if (state.storeImageFile != null) {
      uploadStoreImage(state.storeImageFile!);
    }
  }

  void retryUploadNin() {
    if (state.ninFile != null) {
      uploadNin(state.ninFile!);
    }
  }
}
