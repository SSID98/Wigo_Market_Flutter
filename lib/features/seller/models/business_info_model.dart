class BusinessInfoState {
  final String businessName;
  final String? businessType;
  final String businessAddress;
  final String businessState;
  final String businessCity;
  final String? businessDescription;
  final String? orderPreference;
  final List<String> filteredCities;
  final bool isLoading;
  final bool agreeToTerms;
  final String? errorMessage;
  final bool success;
  final bool hasSubmitted;

  const BusinessInfoState({
    this.businessName = '',
    this.businessType,
    this.businessAddress = '',
    this.businessState = '',
    this.businessCity = '',
    this.businessDescription,
    this.orderPreference,
    this.filteredCities = const [],
    this.isLoading = false,
    this.errorMessage,
    this.success = false,
    this.hasSubmitted = false,
    this.agreeToTerms = false,
  });

  BusinessInfoState copyWith({
    String? businessName,
    String? businessType,
    String? businessAddress,
    String? businessState,
    String? businessCity,
    String? businessDescription,
    String? orderPreference,
    bool? isLoading,
    String? errorMessage,
    bool? success,
    bool? agreeToTerms,
    List<String>? filteredCities,
    bool clearCity = false,
    bool? hasSubmitted,
  }) {
    return BusinessInfoState(
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      businessAddress: businessAddress ?? this.businessAddress,
      businessState: businessState ?? this.businessState,
      businessCity: clearCity ? '' : (businessCity ?? this.businessCity),
      businessDescription: businessDescription ?? this.businessDescription,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      orderPreference: orderPreference ?? this.orderPreference,
      success: success ?? this.success,
      filteredCities: filteredCities ?? this.filteredCities,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
    );
  }
}
