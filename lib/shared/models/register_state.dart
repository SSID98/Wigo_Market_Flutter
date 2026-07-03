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
  final bool hasSubmitted;
  final bool agreeToTerms;

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
    this.hasSubmitted = false,
    this.agreeToTerms = false,
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
    bool? hasSubmitted,
    bool? agreeToTerms,
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
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = {
      "email": email,
      "mobile": mobile,
      "password": password,
      "gender": gender,
      "fullName": fullName,
      "residentialAddress": residentialAddress,
      "city": city,
      "state": residentialState,
    };

    // Put optional rider-only fields if present
    if (nextOfKinPhone != null &&
        nextOfKinPhone!.isNotEmpty &&
        nameOfNok != null &&
        nameOfNok!.isNotEmpty) {
      m['nextOfKin'] = {"name": nameOfNok, "mobile": nextOfKinPhone};
    }
    if (modeOfTransport != null && modeOfTransport!.isNotEmpty) {
      m['modeOfTransport'] = modeOfTransport;
    }

    return m;
  }
}
