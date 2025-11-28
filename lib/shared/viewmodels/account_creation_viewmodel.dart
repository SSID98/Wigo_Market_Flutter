import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/service/user_api_service.dart';
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

  // update methods called from UI
  void setStateValue(String? value) {
    if (value != null) {
      final newFilteredCities = nigeriaStatesAndCities[value] ?? [];
      state = state.copyWith(
        residentialState: value,
        filteredCities: newFilteredCities,
        city: null, // Always reset city when state changes
      );
    } else {
      state = state.copyWith(
        residentialState: null,
        filteredCities: [],
        city: null,
      );
    }
  }

  void setRole(UserRole role) => state = state.copyWith(role: role);

  void updateFullName(String value) => state = state.copyWith(fullName: value);

  void updateEmail(String value) => state = state.copyWith(email: value);

  void updatePassword(String value) => state = state.copyWith(password: value);

  void updateMobile(String value) => state = state.copyWith(mobile: value);

  void updateResidentialAddress(String value) =>
      state = state.copyWith(residentialAddress: value);

  void updateResidentialState(String value) =>
      state = state.copyWith(residentialState: value, city: '');

  void updateCity(String? value) => state = state.copyWith(city: value);

  // Rider-only
  void updateGender(String? value) => state = state.copyWith(gender: value);

  void updateNextOfKinPhone(String? value) =>
      state = state.copyWith(nextOfKinPhone: value);

  void updateModeOfTransport(String? value) =>
      state = state.copyWith(modeOfTransport: value);

  // error/clear
  void clearError() => state = state.copyWith(errorMessage: null);

  // Submit
  Future<bool> submit() async {
    // Validate client-side
    if (!state.canSubmit) {
      state = state.copyWith(
        errorMessage: 'Please fill all required fields for ${state.role.name}.',
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, success: false);

    try {
      final model = RiderRegisterModel(
        email: state.email,
        mobile: state.mobile,
        password: state.password,
        fullName: state.fullName,
        residentialAddress: state.residentialAddress,
        city: state.city,
        state: state.residentialState,
        gender: state.gender,
        nextOfKinPhone: state.nextOfKinPhone,
        modeOfTransport: state.modeOfTransport,
      );

      final payload = model.toJson();

      // Choose endpoint depending on role
      // For buyer you may want a different endpoint or payload
      final res = await api.registerRider(payload);

      if (res['success'] == true) {
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
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}
