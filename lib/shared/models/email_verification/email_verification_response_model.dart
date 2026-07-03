class EmailVerificationResponseModel {
  final String id;
  final String activeRole;
  final String token;
  final String refreshToken;
  final String expiresAt;

  EmailVerificationResponseModel({
    required this.id,
    required this.activeRole,
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
  });

  EmailVerificationResponseModel copyWith({
    String? token,
    String? id,
    String? activeRole,
    String? refreshToken,
    String? expiresAt,
  }) {
    return EmailVerificationResponseModel(
      token: token ?? this.token,
      id: id ?? this.id,
      activeRole: activeRole ?? this.activeRole,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  factory EmailVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    final userData = json.containsKey('user') ? json['user'] : json;
    return EmailVerificationResponseModel(
      id: userData["_id"] ?? "",
      activeRole: userData["activeRole"] ?? json["activeRole"] ?? "",
      token: json["token"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
      expiresAt: userData["tokenExpiresAt"] ?? "",
    );
  }
}
