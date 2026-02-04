class UserProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String status;
  final List<String> roles;
  final String activeRole;
  final Map<String, dynamic> permissions;

  UserProfileModel.fromJson(Map<String, dynamic> json)
    : id = json['_id'],
      fullName = json['fullName'],
      email = json['email'],
      status = json['status'],
      roles = List<String>.from(json['role']),
      activeRole = json['activeRole'],
      permissions = json['permissions'];
}
