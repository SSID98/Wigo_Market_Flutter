import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/shared/models/email_verification/email_verification_response_model.dart';

import '../../shared/models/bank_model.dart';
import '../feedback_models/response_status_model.dart';
import '../network/network.dart';

class UserApiService {
  final NetworkService _networkService;

  UserApiService(this._networkService);

  Future<ResponseStatusModel<JsonMap>> registerRider(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post("/user/register/delivery", data: payload),
    );
  }

  Future<ResponseStatusModel<JsonMap>> registerBuyer(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/user/register/buyer', data: payload),
    );
  }

  Future<ResponseStatusModel<JsonMap>> registerSeller(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/user/register/seller', data: payload),
    );
  }

  Future<ResponseStatusModel<JsonMap>> registerSellerBusiness(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/store/create', data: payload),
    );
  }

  Future<ResponseStatusModel<JsonMap>> getUploadSignature(String folder) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/upload/signature', data: {"folder": folder}),
    );
  }

  Future<ResponseStatusModel<EmailVerificationResponseModel>> verifyEmail({
    required String email,
    required String code,
  }) {
    return _networkService.request<EmailVerificationResponseModel>(
      () => _networkService.post(
        '/user/verify',
        data: {"email": email, "code": code},
      ),
      parser: (json) => EmailVerificationResponseModel.fromJson(json),
    );
  }

  Future<ResponseStatusModel<JsonMap>> forgotPassword(String email) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post(
        '/user/forgot-password-token',
        data: {"email": email},
      ),
    );
  }

  Future<ResponseStatusModel<JsonMap>> verifyToken({
    required String email,
    required String code,
  }) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post(
        '/user/verify-reset-token',
        data: {"code": code, "email": email},
      ),
    );
  }

  Future<ResponseStatusModel<JsonMap>> resetPassword({
    required String email,
    required String password,
    required String resetSession,
  }) async {
    return _networkService.request<JsonMap>(
      () => _networkService.put(
        '/user/reset-password',
        data: {
          "email": email,
          "password": password,
          "resetSession": resetSession,
        },
      ),
    );
  }

  Future<ResponseStatusModel<JsonMap>> resolveAccount({
    required String accountNumber,
    required String bankCode,
  }) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post(
        '/flutterwave/accounts/resolve',
        data: {"account_number": accountNumber, "account_bank": bankCode},
      ),
    );
  }

  Future<ResponseStatusModel<JsonMap>> createWallet({
    required Map<String, dynamic> payload,
  }) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/wallet/create', data: payload),
    );
  }

  Future<ResponseStatusModel<List<Bank>>> getBanks({
    String country = "NG",
  }) async {
    return _networkService.request<List<Bank>>(
      () => _networkService.get(
        '/flutterwave/banks',
        query: {"country": country},
      ),
      parser: (data) {
        final list = data['data'] as List;
        return list.map((e) => Bank.fromJson(e)).toList();
      },
    );
  }
}

final userApiServiceProvider = Provider<UserApiService>((ref) {
  return UserApiService(ref.read(networkServiceProvider));
});
