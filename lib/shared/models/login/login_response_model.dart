class LoginResponseModel {
  final String id;
  final String status;
  final List<String> role;
  final String activeRole;
  final String token;
  final String fullName;
  final String email;
  final String refreshToken;
  final String expiresAt;
  final String city;
  final String mobile;
  final String state;
  final String address;
  final String image;
  final Map<String, dynamic>? dispatchProfile;
  final Map<String, dynamic>? store;
  final bool hasWallet;
  final bool hasWithdrawalPin;
  final String nextOfKinName;
  final String nextOfKinMobile;

  LoginResponseModel({
    required this.id,
    required this.status,
    required this.role,
    required this.activeRole,
    required this.token,
    required this.fullName,
    required this.email,
    required this.refreshToken,
    required this.expiresAt,
    required this.city,
    required this.mobile,
    required this.state,
    required this.address,
    required this.image,
    this.dispatchProfile,
    this.store,
    required this.hasWallet,
    this.hasWithdrawalPin = false,
    this.nextOfKinName = '',
    this.nextOfKinMobile = '',
  });

  LoginResponseModel copyWith({
    String? token,
    String? id,
    String? status,
    List<String>? role,
    String? activeRole,
    String? fullName,
    String? email,
    String? refreshToken,
    String? expiresAt,
    String? city,
    String? mobile,
    String? state,
    String? address,
    String? image,
    Map<String, dynamic>? dispatchProfile,
    Map<String, dynamic>? store,
    bool? hasWallet,
    bool? hasWithdrawalPin,
    String? nextOfKinName,
    String? nextOfKinMobile,
  }) {
    return LoginResponseModel(
      token: token ?? this.token,
      id: id ?? this.id,
      status: status ?? this.status,
      role: role ?? this.role,
      activeRole: activeRole ?? this.activeRole,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      city: city ?? this.city,
      mobile: mobile ?? this.mobile,
      state: state ?? this.state,
      address: address ?? this.address,
      image: image ?? this.image,
      dispatchProfile: dispatchProfile ?? this.dispatchProfile,
      store: store ?? this.store,
      hasWallet: hasWallet ?? this.hasWallet,
      hasWithdrawalPin: hasWithdrawalPin ?? this.hasWithdrawalPin,
      nextOfKinName: nextOfKinName ?? this.nextOfKinName,
      nextOfKinMobile: nextOfKinMobile ?? this.nextOfKinMobile,
    );
  }

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final userData = json.containsKey('user') ? json['user'] : json;
    final nextOfKinMap = userData["nextOfKin"] is Map<String, dynamic>
        ? userData["nextOfKin"] as Map<String, dynamic>
        : null;
    return LoginResponseModel(
      id: userData["_id"] ?? "",
      status: userData["status"] ?? "",
      role: List<String>.from(userData["role"] ?? json["roles"] ?? []),
      activeRole: userData["activeRole"] ?? json["activeRole"] ?? "",
      token: json["token"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
      fullName: userData["fullName"] ?? "",
      email: userData["email"] ?? "",
      expiresAt: userData["tokenExpiresAt"] ?? "",
      city: userData["city"] ?? "",
      mobile: userData["mobile"] ?? "",
      state: userData["state"] ?? "",
      address: userData["residentialAddress"] ?? "",
      image: userData["image"] ?? "",
      dispatchProfile: userData["dispatchProfile"] as Map<String, dynamic>?,
      store: userData["store"] as Map<String, dynamic>?,
      hasWallet: userData["hasWallet"] ?? false,
      hasWithdrawalPin: userData["hasWithdrawalPin"] ?? false,
      nextOfKinName: nextOfKinMap?["nextOfKin"]["name"] ?? "",
      nextOfKinMobile: nextOfKinMap?["nextOfKin"]["mobile"] ?? "",
    );
  }
}
