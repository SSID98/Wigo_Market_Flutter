class RiderRegisterModel {
  final String email;
  final String mobile;
  final String password;
  final String? gender;
  final String fullName;
  final String residentialAddress;
  final String city;
  final String state;
  final String? nameOfNok;
  final String? nextOfKinPhone;
  final String? modeOfTransport;

  RiderRegisterModel({
    required this.email,
    required this.mobile,
    required this.password,
    required this.fullName,
    required this.residentialAddress,
    required this.city,
    required this.state,
    this.gender,
    this.nameOfNok,
    this.nextOfKinPhone,
    this.modeOfTransport,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = {
      "email": email,
      "mobile": mobile,
      "password": password,
      "gender": gender,
      "fullName": fullName,
      "residentialAddress": residentialAddress,
      "city": city,
      "state": state,
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
