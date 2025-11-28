class RiderRegisterModel {
  final String email;
  final String mobile;
  final String password;
  final String fullName;
  final String residentialAddress;
  final String city;
  final String state;
  final String? gender;
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
    this.nextOfKinPhone,
    this.modeOfTransport,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = {
      "email": email,
      "mobile": mobile,
      "password": password,
      "fullName": fullName,
      "residentialAddress": residentialAddress,
      "city": city,
      "state": state,
    };

    // Put optional rider-only fields if present
    if (gender != null && gender!.isNotEmpty) m['gender'] = gender;
    if (nextOfKinPhone != null && nextOfKinPhone!.isNotEmpty) {
      m['nextOfKin'] = {
        // backend expects nested object earlier — if backend expects only phone you can adapt
        "mobile": nextOfKinPhone,
      };
    }
    if (modeOfTransport != null && modeOfTransport!.isNotEmpty) {
      m['modeOfTransport'] = modeOfTransport;
    }

    return m;
  }
}
