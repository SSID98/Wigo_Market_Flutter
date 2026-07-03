import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wigo_flutter/core/local/secure_storage.dart';
import 'package:wigo_flutter/shared/widgets/custom_loading_overlay.dart';

import '../../core/constants/app_colors.dart';
import '../../core/network/network.dart';
import '../../core/service/user_api_service.dart';
import '../../core/utils/validation_utils.dart';
import '../models/bank_model.dart';
import '../widgets/custom_banner.dart';

class BankViewModel extends StateNotifier<BankState> {
  final Reader read;
  final UserApiService api;

  BankViewModel(this.read, {UserApiService? apiService})
    : api = apiService ?? read(userApiServiceProvider),
      super(BankState());

  final accountNameController = TextEditingController();
  final ValueNotifier<Bank?> selectedBankName = ValueNotifier(null);

  Future<void> fetchBanks(BuildContext context) async {
    await runWithOverlay(context, () async {
      state = state.copyWith(isLoading: true);
      try {
        final result = await api.getBanks();

        if (result.isSuccess && result.data != null) {
          final banks = result.data;
          state = state.copyWith(banks: banks, isLoading: false);
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage:
                'Unable to get banks. Please check your network and try again',
          );
          if (!context.mounted) return;
          if (state.errorMessage != null) {
            showErrorBanner(state.errorMessage!, context);
          }
        }
      } catch (e, st) {
        AsyncError(e, st);
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }

  Future<void> getAccountName(BuildContext context) async {
    await runWithOverlay(context, () async {
      state = state.copyWith(isLoading: true);
      try {
        final result = await api.resolveAccount(
          accountNumber: state.accountNumber,
          bankCode: state.selectedBank?.code ?? '',
        );

        debugPrint("Account Number: ${state.accountNumber}");
        debugPrint("Bank Code: ${state.selectedBank?.code}");
        debugPrint("Bank Name: ${state.selectedBank?.name}");

        if (result.isSuccess && result.data != null) {
          final response = result.data!;

          final accountName = response['data']['account_name'];

          state = state.copyWith(accountName: accountName);

          accountNameController.text = state.accountName;

          debugPrint("Account Name: ${state.accountName}");

          state = state.copyWith(isLoading: false);
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Unable to get Account name.',
          );

          if (!context.mounted) return;
          if (state.errorMessage != null) {
            showErrorBanner(state.errorMessage!, context);
          }
        }
      } catch (e, st) {
        AsyncError(e, st);
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }

  void updateSelectedBank(Bank? bank, BuildContext context) {
    state = state.copyWith(selectedBank: bank);
    selectedBankName.value = bank;

    _maybeResolveAccount(context);
  }

  void _maybeResolveAccount(BuildContext context) {
    final accountNumber = state.accountNumber;
    final bankCode = state.selectedBank?.code;

    final isValidAccountNumber = accountNumber.length == 10;
    final hasBank = bankCode != null && bankCode.isNotEmpty;

    if (isValidAccountNumber && hasBank) {
      getAccountName(context);
    }
    return;
  }

  void updateAccountName(String value) =>
      state = state.copyWith(accountName: value);

  void updateAccountNumber(String value, BuildContext context) {
    state = state.copyWith(accountNumber: value);
    _maybeResolveAccount(context);
  }

  bool validateOnSubmit() {
    final requiredFields = {
      "accountName": state.accountName,
      "accountNumber": state.accountNumber,
      "bankName": state.selectedBank?.name,
    };

    final hasEmpty = requiredFields.values.any(FormValidators.isFieldEmpty);

    state = state.copyWith(
      hasSubmitted: true,
      errorMessage: hasEmpty ? 'Please fix the highlighted fields' : null,
    );

    return !hasEmpty;
  }

  Future<bool> submit(BuildContext context) async {
    final isValid = validateOnSubmit();

    if (!isValid) {
      showErrorBanner('Please fix the highlighted fields', context);
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await runWithOverlay(context, () async {
      try {
        final storage = SecureStorage();

        final userMobile = await storage.getData(key: "mobile");

        final payload = {
          "accountName": state.accountName,
          "accountNumber": state.accountNumber,
          "bankName": state.selectedBank?.name,
          "phoneNumber": userMobile.data,
        };

        final result = await api.createWallet(payload: payload);

        if (result.isSuccess && result.data != null) {
          await storage.deleteData(key: "mobile");

          return true;
        } else {
          state = state.copyWith(
            errorMessage: result.errorDescription?.toString(),
          );

          if (context.mounted && state.errorMessage != null) {
            showErrorBanner(state.errorMessage!, context);
          }
          return false;
        }
      } catch (e, st) {
        AsyncError(e, st);
        return false;
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
    state = state.copyWith(isLoading: false);
    return result;
  }
}

final bankProvider = StateNotifierProvider<BankViewModel, BankState>(
  (ref) => BankViewModel(ref.read),
);
