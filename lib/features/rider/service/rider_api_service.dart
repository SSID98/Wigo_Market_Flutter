import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/feedback_models/response_status_model.dart';
import '../../../core/network/network.dart';
import '../../../shared/models/bank_model.dart';
import '../models/earning_overview_model.dart';

class RiderApiService {
  final NetworkService _networkService;

  RiderApiService(this._networkService);

  Future<ResponseStatusModel<JsonMap>> updateAvailability(bool isOnline) async {
    return _networkService.request<JsonMap>(() {
      final String statusValue = isOnline ? "online" : "offline";

      return _networkService.put(
        '/delivery-agent/availability',
        data: {"status": statusValue},
      );
    });
  }

  Future<ResponseStatusModel<JsonMap>> createRiderProfile(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/delivery-agent/profile', data: payload),
    );
  }

  Future<ResponseStatusModel<JsonMap>> getRiderProfile() async {
    return _networkService.request<JsonMap>(
      () => _networkService.get('/delivery-agent/profile'),
    );
  }

  Future<ResponseStatusModel<JsonMap>> updateRiderProfile(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.put('/delivery-agent/profile', data: payload),
    );
  }

  Future<ResponseStatusModel<JsonMap>> getUploadSignature(String folder) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/upload/signature', data: {"folder": folder}),
    );
  }

  Future<ResponseStatusModel<JsonMap>> createWalletPin(String pin) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/wallet/pin', data: {"pin": pin}),
    );
  }

  Future<ResponseStatusModel<JsonMap>> createWallet(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/wallet/create', data: payload),
    );
  }

  Future<ResponseStatusModel<JsonMap>> getWallet() async {
    return _networkService.request<JsonMap>(
      () => _networkService.get('/wallet'),
    );
  }

  Future<ResponseStatusModel<JsonMap>> addBankAccount(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/wallet/bank-account', data: payload),
    );
  }

  Future<ResponseStatusModel<JsonMap>> setDefaultBankAccount(
    String accountId,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.put('/wallet/bank-account/$accountId/default'),
    );
  }

  Future<ResponseStatusModel<JsonMap>> deleteBankAccount(
    String accountId,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.delete('/wallet/bank-account/$accountId'),
    );
  }

  Future<ResponseStatusModel<JsonMap>> makeWithdrawal(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.post('/wallet/withdraw', data: payload),
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

  Future<ResponseStatusModel<JsonMap>> updateRiderPersonalProfile(
    Map<String, dynamic> payload,
  ) async {
    return _networkService.request<JsonMap>(
      () => _networkService.put('/delivery-agent/account', data: payload),
    );
  }

  Future<ResponseStatusModel<EarningsOverview>> getEarningsOverview() async {
    return _networkService.request<EarningsOverview>(
      () => _networkService.get('/delivery-agent/earnings/overview'),
      parser: (json) => EarningsOverview.fromJson(json["data"]),
    );
  }
}

final riderApiServiceProvider = Provider<RiderApiService>((ref) {
  return RiderApiService(ref.read(networkServiceProvider));
});
