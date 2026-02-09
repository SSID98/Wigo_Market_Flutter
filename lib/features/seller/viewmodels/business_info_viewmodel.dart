import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/features/seller/models/business_info_model.dart';

import '../../../core/service/user_api_service.dart';
import '../../../shared/models/location_data.dart';

final businessInfoViewmodelProvider =
    StateNotifierProvider<BusinessInfoViewModel, BusinessInfoState>(
      (ref) => BusinessInfoViewModel(ref.read),
    );

typedef Reader = T Function<T>(ProviderListenable<T> provider);

class BusinessInfoViewModel extends StateNotifier<BusinessInfoState> {
  final Reader read;
  final UserApiService api;

  BusinessInfoViewModel(this.read, {UserApiService? apiService})
    : api = apiService ?? UserApiService(),
      super(const BusinessInfoState());

  void updateBusinessName(String value) =>
      state = state.copyWith(businessName: value);

  void updateBusinessAddress(String value) =>
      state = state.copyWith(businessAddress: value);

  void updateBusinessState(String? value) {
    if (value != null) {
      final newFilteredCities = nigeriaStatesAndCities[value] ?? [];
      state = state.copyWith(
        businessState: value,
        filteredCities: newFilteredCities,
        clearCity: true,
      );
    } else {
      state = state.copyWith(
        businessState: '',
        filteredCities: [],
        clearCity: true,
      );
    }
  }

  void toggleAgreeToTerms(bool? value) {
    state = state.copyWith(agreeToTerms: value ?? false);
  }

  void updateBusinessCity(String? value) =>
      state = state.copyWith(businessCity: value ?? '');

  void updateBusinessType(String? value) =>
      state = state.copyWith(businessType: value);

  void updateBusinessDescription(String? value) =>
      state = state.copyWith(businessDescription: value);

  void updateOrderPreference(String? value) =>
      state = state.copyWith(orderPreference: value);

  void clearError() => state = state.copyWith(errorMessage: null);

  // void validateOnSubmit() {
  //   final emailError = FormValidators.validateEmail(state.email);
  //   final passwordError = FormValidators.validateSignupPassword(state.password);
  //
  //   state = state.copyWith(
  //     hasSubmitted: true,
  //     emailError: emailError,
  //     passwordError: passwordError,
  //   );
  // }
  //
  // // Submit
  // Future<bool> submit(BuildContext context) async {
  //   // Validate client-side
  //   if (!state.canSubmit) {
  //     state = state.copyWith(
  //       errorMessage: 'Please fill all required fields for ${state.role.name}.',
  //     );
  //     return false;
  //   }
  //
  //   state = state.copyWith(isLoading: true, errorMessage: null, success: false);
  //
  //   showLoadingDialog(context);
  //
  //   try {
  //     final model = RiderRegisterModel(
  //       email: state.email,
  //       mobile: state.mobile,
  //       password: state.password,
  //       fullName: state.fullName,
  //       residentialAddress: state.residentialAddress,
  //       city: state.city,
  //       state: state.residentialState,
  //       gender: state.gender?.toLowerCase().trim(),
  //       nameOfNok: state.nameOfNok,
  //       nextOfKinPhone: state.nextOfKinPhone,
  //       modeOfTransport: state.modeOfTransport?.toLowerCase().trim(),
  //     );
  //
  //     final payload = model.toJson();
  //     debugPrint('REGISTER PAYLOAD => $payload');
  //     debugPrint('Gender => ${state.gender}');
  //     debugPrint('MOT => ${state.modeOfTransport}');
  //     final res = await _registerByRole(state.role, payload);
  //
  //     if (context.mounted) {
  //       Navigator.of(context, rootNavigator: true).pop();
  //     }
  //
  //     if (res['success'] == true) {
  //       final data = res['data'];
  //
  //       debugPrint('REGISTER RESPONSE => $data');
  //       state = state.copyWith(isLoading: false, success: true);
  //       return true;
  //     } else {
  //       state = state.copyWith(
  //         isLoading: false,
  //         errorMessage: res['message']?.toString(),
  //       );
  //       return false;
  //     }
  //   } catch (e) {
  //     if (context.mounted) {
  //       Navigator.of(context, rootNavigator: true).pop();
  //     }
  //     state = state.copyWith(isLoading: false, errorMessage: e.toString());
  //     return false;
  //   }
  // }
}
