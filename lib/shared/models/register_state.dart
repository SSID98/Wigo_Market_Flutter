import 'package:wigo_flutter/shared/models/user_role.dart';

class RegisterState {
  final String fullName;
  final String email;
  final String password;
  final String mobile;
  final String residentialAddress;
  final String residentialState;
  final String city;
  final String? gender;
  final String? nameOfNok;
  final String? nextOfKinPhone;
  final String? modeOfTransport;
  final UserRole role;
  final List<String> filteredCities;
  final bool isLoading;
  final String? errorMessage;
  final bool success;

  const RegisterState({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.mobile = '',
    this.residentialAddress = '',
    this.residentialState = '',
    this.city = '',
    this.gender,
    this.nameOfNok,
    this.nextOfKinPhone,
    this.filteredCities = const [],
    this.modeOfTransport,
    this.role = UserRole.buyer,
    this.isLoading = false,
    this.errorMessage,
    this.success = false,
  });

  RegisterState copyWith({
    String? fullName,
    String? email,
    String? password,
    String? mobile,
    String? residentialAddress,
    String? residentialState,
    String? city,
    String? gender,
    String? nameOfNok,
    String? nextOfKinPhone,
    String? modeOfTransport,
    UserRole? role,
    bool? isLoading,
    String? errorMessage,
    bool? success,
    List<String>? filteredCities,
    bool clearCity = false,
  }) {
    return RegisterState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      mobile: mobile ?? this.mobile,
      residentialAddress: residentialAddress ?? this.residentialAddress,
      residentialState: residentialState ?? this.residentialState,
      city: clearCity ? '' : (city ?? this.city),
      gender: gender ?? this.gender,
      nameOfNok: nameOfNok ?? this.nameOfNok,
      nextOfKinPhone: nextOfKinPhone ?? this.nextOfKinPhone,
      modeOfTransport: modeOfTransport ?? this.modeOfTransport,
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      success: success ?? this.success,
      filteredCities: filteredCities ?? this.filteredCities,
    );
  }

  bool get isBuyer => role == UserRole.buyer;

  bool get isRider => role == UserRole.rider;

  // minimal required check based on role
  bool get canSubmit {
    if (isRider) {
      return fullName.isNotEmpty &&
          email.isNotEmpty &&
          password.length >= 8 &&
          mobile.isNotEmpty &&
          residentialAddress.isNotEmpty &&
          residentialState.isNotEmpty &&
          city.isNotEmpty &&
          (nameOfNok?.isNotEmpty ?? false) &&
          (nextOfKinPhone?.isNotEmpty ?? false) &&
          (modeOfTransport?.isNotEmpty ?? false) &&
          (gender?.isNotEmpty ?? false);
    } else {
      // buyer
      return fullName.isNotEmpty &&
          email.isNotEmpty &&
          password.length >= 8 &&
          mobile.isNotEmpty &&
          residentialAddress.isNotEmpty &&
          residentialState.isNotEmpty &&
          city.isNotEmpty;
    }
  }
}
