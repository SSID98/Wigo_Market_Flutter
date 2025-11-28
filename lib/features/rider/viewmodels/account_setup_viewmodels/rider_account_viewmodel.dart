// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../../../core/service/user_api_service.dart';
// import '../../models/rider_register_model_dto.dart';
//
// final riderAccountViewModelProvider =
//     StateNotifierProvider<RiderAccountViewModel, AsyncValue<void>>(
//       (ref) => RiderAccountViewModel(ref),
//     );
//
// class RiderAccountViewModel extends StateNotifier<AsyncValue<void>> {
//   RiderAccountViewModel(this.ref) : super(const AsyncData(null));
//
//   final Ref ref;
//
//   // Store all field values
//   String fullName = "";
//   String email = "";
//   String password = "";
//   String mobile = "";
//   String residentialAddress = "";
//   String residentialState = "";
//   String city = "";
//   String gender = "";
//   String modeOfTransport = "";
//   String nokMobile = "";
//
//   final api = UserApiService();
//
//   bool get isFormValid =>
//       fullName.isNotEmpty &&
//       email.isNotEmpty &&
//       password.isNotEmpty &&
//       mobile.isNotEmpty &&
//       residentialAddress.isNotEmpty &&
//       residentialState.isNotEmpty &&
//       city.isNotEmpty &&
//       modeOfTransport.isNotEmpty &&
//       gender.isNotEmpty &&
//       nokMobile.isNotEmpty;
//
//   Future<String?> registerRider() async {
//     if (!isFormValid) return "Please fill all required fields";
//
//     state = const AsyncLoading();
//
//     final model = RiderRegisterModel(
//       email: email,
//       mobile: mobile,
//       password: password,
//       fullName: fullName,
//       residentialAddress: residentialAddress,
//       city: city,
//       state: residentialState,
//       gender: gender,
//       modeOfTransport: modeOfTransport,
//       nextOfKinPhone: nokMobile,
//     );
//
//     final result = await api.registerRider(model.toJson());
//
//     if (result["success"]) {
//       state = const AsyncData(null);
//       return null; // success
//     } else {
//       state = const AsyncData(null);
//       return result["message"]; // error message
//     }
//   }
// }
