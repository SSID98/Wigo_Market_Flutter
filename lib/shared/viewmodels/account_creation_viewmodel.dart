import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/service/user_api_service.dart';
import '../../core/utils/helper_methods.dart';
import '../../core/utils/validation_utils.dart';
import '../../features/rider/models/rider_register_model_dto.dart';
import '../models/location_data.dart';
import '../models/register_state.dart';
import '../models/user_role.dart';

final registerViewModelProvider =
    StateNotifierProvider<RegisterViewModel, RegisterState>(
      (ref) => RegisterViewModel(ref.read),
    );

typedef Reader = T Function<T>(ProviderListenable<T> provider);

class RegisterViewModel extends StateNotifier<RegisterState> {
  final Reader read;
  final UserApiService api;

  RegisterViewModel(this.read, {UserApiService? apiService})
    : api = apiService ?? UserApiService(),
      super(const RegisterState());

  void setRole(UserRole role) => state = state.copyWith(role: role);

  void updateFullName(String value) => state = state.copyWith(fullName: value);

  void updateEmail(String value) {
    state = state.copyWith(email: value, emailError: null);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value, passwordError: null);
  }

  void updateMobile(String value) => state = state.copyWith(mobile: value);

  void updateResidentialAddress(String value) =>
      state = state.copyWith(residentialAddress: value);

  // void updateResidentialState(String value) =>
  //     state = state.copyWith(residentialState: value, city: '');

  void updateResidentialState(String? value) {
    if (value != null) {
      final newFilteredCities = nigeriaStatesAndCities[value] ?? [];
      state = state.copyWith(
        residentialState: value,
        filteredCities: newFilteredCities,
        clearCity: true,
      );
    } else {
      state = state.copyWith(
        residentialState: '',
        filteredCities: [],
        clearCity: true,
      );
    }
  }

  void updateCity(String? value) => state = state.copyWith(city: value ?? '');

  // Rider-only
  void updateGender(String? value) => state = state.copyWith(gender: value);

  void updateNextOfKinName(String value) =>
      state = state.copyWith(nameOfNok: value);

  void updateNextOfKinPhone(String? value) =>
      state = state.copyWith(nextOfKinPhone: value);

  void updateModeOfTransport(String? value) =>
      state = state.copyWith(modeOfTransport: value);

  void clearError() => state = state.copyWith(errorMessage: null);

  Future<Map<String, dynamic>> _registerByRole(
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

    state = state.copyWith(
      hasSubmitted: true,
      emailError: emailError,
      passwordError: passwordError,
    );
  }

  // Submit
  Future<bool> submit(BuildContext context) async {
    // Validate client-side
    if (!state.canSubmit) {
      state = state.copyWith(
        errorMessage: 'Please fill all required fields for ${state.role.name}.',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, success: false);

    showLoadingDialog(context);

    try {
      final model = RiderRegisterModel(
        email: state.email,
        mobile: state.mobile,
        password: state.password,
        fullName: state.fullName,
        residentialAddress: state.residentialAddress,
        city: state.city,
        state: state.residentialState,
        gender: state.gender?.toLowerCase().trim(),
        nameOfNok: state.nameOfNok,
        nextOfKinPhone: state.nextOfKinPhone,
        modeOfTransport: state.modeOfTransport?.toLowerCase().trim(),
      );

      final payload = model.toJson();
      debugPrint('REGISTER PAYLOAD => $payload');
      debugPrint('Gender => ${state.gender}');
      debugPrint('MOT => ${state.modeOfTransport}');
      final res = await _registerByRole(state.role, payload);

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (res['success'] == true) {
        final data = res['data'];

        debugPrint('REGISTER RESPONSE => $data');
        state = state.copyWith(isLoading: false, success: true);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: res['message']?.toString(),
        );
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}
