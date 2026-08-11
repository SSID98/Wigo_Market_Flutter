import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/feedback_models/response_status_model.dart';
import 'package:wigo_flutter/core/local/secure_storage.dart';
import 'package:wigo_flutter/shared/widgets/custom_loading_overlay.dart';

import '../../core/local/local_user_controller.dart';
import '../../core/network/network.dart';
import '../../core/service/user_api_service.dart';
import '../../core/utils/validation_utils.dart';
import '../models/location_data.dart';
import '../models/register_state.dart';
import '../models/user_role.dart';

final registerViewModelProvider =
    StateNotifierProvider<RegisterViewModel, RegisterState>((ref) {
      final localUser = ref.read(localUserControllerProvider);
      final roleString = localUser.role;

      final roleEnum = UserRole.values.firstWhere(
        (e) => e.name == roleString,
        orElse: () => UserRole.buyer,
      );

      return RegisterViewModel(ref.read, initialRole: roleEnum);
    });

class RegisterViewModel extends StateNotifier<RegisterState> {
  final Reader read;
  final UserApiService api;

  RegisterViewModel(
    this.read, {
    UserApiService? apiService,
    required UserRole initialRole,
  }) : api = apiService ?? read(userApiServiceProvider),
       super(RegisterState(role: initialRole));

  final ValueNotifier<String?> selectedState = ValueNotifier(null);
  final ValueNotifier<String?> selectedCity = ValueNotifier(null);
  final ValueNotifier<String?> selectedGender = ValueNotifier(null);
  final ValueNotifier<String?> selectedTransport = ValueNotifier(null);

  void setRole(UserRole role) => state = state.copyWith(role: role);

  void updateFullName(String value) => state = state.copyWith(fullName: value);

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  void updateMobile(String value) => state = state.copyWith(mobile: value);

  void updateResidentialAddress(String value) =>
      state = state.copyWith(residentialAddress: value);

  void updateResidentialState(String? value) {
    if (value != null) {
      final newFilteredCities = nigeriaStatesAndCities[value] ?? [];
      state = state.copyWith(
        residentialState: value,
        filteredCities: newFilteredCities,
      );
      selectedState.value = value;
    } else {
      state = state.copyWith(residentialState: '', filteredCities: []);
    }
  }

  void updateCity(String? value) {
    state = state.copyWith(city: value ?? '');
    selectedCity.value = value;
  }

  void updateGender(String? value) {
    state = state.copyWith(gender: value);
    selectedGender.value = value;
  }

  void updateNextOfKinName(String value) =>
      state = state.copyWith(nameOfNok: value);

  void updateNextOfKinPhone(String? value) =>
      state = state.copyWith(nextOfKinPhone: value);

  void updateModeOfTransport(String? value) {
    state = state.copyWith(modeOfTransport: value);
    selectedTransport.value = value;
  }

  void toggleAgreeToTerms(bool? value) {
    state = state.copyWith(agreeToTerms: value ?? false);
  }

  Future<ResponseStatusModel> _registerByRole(
    UserRole role,
    Map<String, dynamic> payload,
  ) {
    switch (role) {
      case UserRole.dispatch:
        return api.registerRider(payload);
      case UserRole.buyer:
        return api.registerBuyer(payload);
      case UserRole.seller:
        return api.registerSeller(payload);
    }
  }

  void validateOnSubmit() {
    final emailError = FormValidators.validateEmail(state.email);
    final passwordError = FormValidators.validateSignupPassword(state.password);

    final requiredFields = {
      "fullName": state.fullName,
      "email": state.email,
      "mobile": state.mobile,
      "address": state.residentialAddress,
      "city": state.city,
      "state": state.residentialState,
    };

    if (state.role == UserRole.dispatch) {
      requiredFields.addAll({
        "nok": state.nameOfNok ?? '',
        "nok phone": state.nextOfKinPhone ?? '',
        "gender": state.gender ?? '',
        "transport": state.modeOfTransport ?? '',
      });
    } else if (state.role == UserRole.seller) {
      requiredFields["gender"] = state.gender ?? '';
    }

    final hasEmpty = requiredFields.values.any(FormValidators.isFieldEmpty);

    String? errorMessage;
    if (emailError != null || passwordError != null) {
      errorMessage = 'Please fix the highlighted fields';
    } else if (hasEmpty) {
      errorMessage =
          'Please complete all required fields for ${state.role.name}';
    }

    state = state.copyWith(hasSubmitted: true, errorMessage: errorMessage);
  }

  Future<bool> submit(BuildContext context) async {
    validateOnSubmit();

    final emailError = FormValidators.validateEmail(state.email);
    final passwordError = FormValidators.validateSignupPassword(state.password);

    if (emailError != null ||
        passwordError != null ||
        state.errorMessage != null) {
      return false;
    }

    if (!state.agreeToTerms) {
      state = state.copyWith(errorMessage: "You must agree to the terms");
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, success: false);

    final result = await runWithOverlay<bool>(context, () async {
      try {
        final model = RegisterState(
          email: state.email,
          mobile: state.mobile,
          password: state.password,
          fullName: state.fullName,
          residentialAddress: state.residentialAddress,
          city: state.city,
          residentialState: state.residentialState,
          gender: state.gender?.toLowerCase().trim(),
          nameOfNok: state.nameOfNok,
          nextOfKinPhone: state.nextOfKinPhone,
          modeOfTransport: state.modeOfTransport?.toLowerCase().trim(),
        );

        final payload = model.toJson();
        debugPrint('REGISTER PAYLOAD => $payload');
        final result = await _registerByRole(state.role, payload);

        if (result.isSuccess && result.data != null) {
          final storage = SecureStorage();
          await storage.storeData(key: 'mobile', data: state.mobile);

          state = state.copyWith(
            isLoading: false,
            success: true,
            email: "",
            mobile: '',
            password: '',
            fullName: '',
            residentialAddress: '',
            city: '',
            residentialState: '',
            gender: '',
            nameOfNok: '',
            nextOfKinPhone: '',
            modeOfTransport: '',
          );
          return true;
        }
        final errorMessage =
            result.errorDescription?.toString() ?? 'Registration failed';

        if (errorMessage.toLowerCase().contains('Unexpected error')) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Unexpected error. Please try again.',
          );
          return false;
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
}
