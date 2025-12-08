class LoginResponseModel {
  final String id;
  final String status;
  final List<String> role;
  final String activeRole;
  final String token;

  LoginResponseModel({
    required this.id,
    required this.status,
    required this.role,
    required this.activeRole,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json["_id"] ?? "",
      status: json["status"] ?? "",
      role: List<String>.from(json["role"] ?? []),
      activeRole: json["activeRole"] ?? "",
      token: json["token"] ?? "",
    );
  }
}
