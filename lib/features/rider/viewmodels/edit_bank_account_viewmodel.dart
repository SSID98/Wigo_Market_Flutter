import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wigo_flutter/features/rider/models/wallet_state.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/network/network.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../shared/models/bank_model.dart';
import '../../../shared/widgets/custom_banner.dart';
import '../../../shared/widgets/custom_loading_overlay.dart';
import '../models/bank_details.dart';
import '../service/rider_api_service.dart';

class EditBankAccountViewModel extends StateNotifier<WalletState> {
  final Reader read;
  final RiderApiService _apiService;
  final accountNumberController = TextEditingController();
  final accountNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final ValueNotifier<Bank?> selectedBankName = ValueNotifier(null);

  // void init() {
  //   selectedBankName.value = state.selectedBankDetails?.selectedBank;
  // }

  EditBankAccountViewModel(this.read, {RiderApiService? apiService})
    : _apiService = apiService ?? read(riderApiServiceProvider),
      super(const WalletState(bankDetailsList: [])) {
    fetchWallet();
  }

  @override
  void dispose() {
    accountNumberController.dispose();
    accountNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  // EditBankAccountViewModel()
  //   : super(
  //       WalletState(
  //         bankDetailsList: [
  //           BankDetails.empty('1').copyWith(isDefault: true),
  //           BankDetails.empty('2'),
  //           BankDetails.empty('3'),
  //         ],
  //       ),
  //     );

  // void navigateToOverview() {
  //   state = state.copyWith(walletScreenState: WalletScreenState.overview);
  // }

  // void _syncBankNotifier() {
  //   final bankFromState = state.selectedBankDetails?.selectedBank;
  //
  //   if (selectedBankName.value != bankFromState) {
  //     selectedBankName.value = bankFromState;
  //   }
  // }

  Future<void> fetchBanks(BuildContext context) async {
    await runWithOverlay(context, () async {
      state = state.copyWith(isLoading: true);
      try {
        final result = await _apiService.getBanks();

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
        state = state.copyWith(isLoading: false);
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }

  Future<void> getAccountName(BuildContext context) async {
    await runWithOverlay(context, () async {
      state = state.copyWith(isLoading: true);
      try {
        final result = await _apiService.resolveAccount(
          accountNumber: state.selectedBankDetails?.accountNumber ?? '',
          bankCode: state.selectedBankDetails?.selectedBank?.code ?? '',
        );

        debugPrint(
          "Account Number: ${state.selectedBankDetails?.accountNumber}",
        );
        debugPrint(
          "Bank Code: ${state.selectedBankDetails?.selectedBank?.code}",
        );
        debugPrint(
          "Bank Name: ${state.selectedBankDetails?.selectedBank?.name}",
        );

        if (result.isSuccess && result.data != null) {
          final response = result.data!;

          final accountName = response['data']['account_name'];

          state = state.copyWith(
            selectedBankDetails: state.selectedBankDetails?.copyWith(
              accountHolderName: accountName,
            ),
          );

          accountNameController.text =
              state.selectedBankDetails?.accountHolderName ?? '';

          debugPrint(
            "Account Name: ${state.selectedBankDetails?.accountHolderName}",
          );

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
        state = state.copyWith(isLoading: false);
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }

  void updateSelectedBank(Bank? bank, BuildContext context) {
    state = state.copyWith(
      selectedBankDetails: state.selectedBankDetails?.copyWith(
        selectedBank: bank,
      ),
    );
    selectedBankName.value = bank;

    _maybeResolveAccount(context);
  }

  void _maybeResolveAccount(BuildContext context) {
    final accountNumber = state.selectedBankDetails?.accountNumber;
    final bankCode = state.selectedBankDetails?.selectedBank?.code;

    final isValidAccountNumber = accountNumber?.length == 10;
    final hasBank = bankCode != null && bankCode.isNotEmpty;

    if (isValidAccountNumber && hasBank) {
      getAccountName(context);
    }
    return;
  }

  void updateAccountName(String value) => state = state.copyWith(
    selectedBankDetails: state.selectedBankDetails?.copyWith(
      accountHolderName: value,
    ),
  );

  void updateAccountNumber(String value, BuildContext context) {
    state = state.copyWith(
      selectedBankDetails: state.selectedBankDetails?.copyWith(
        accountNumber: value,
      ),
    );
    _maybeResolveAccount(context);
  }

  void updatePhoneNumber(String value) => state = state.copyWith(
    selectedBankDetails: state.selectedBankDetails?.copyWith(
      phoneNumber: value,
    ),
  );

  void toggleDefault(bool? value) {
    state = state.copyWith(isDefault: value ?? false);
  }

  Future<void> fetchWallet() async {
    state = state.copyWith(fetchWalletLoading: true, errorMessage: null);

    final response = await _apiService.getWallet();

    if (response.isSuccess && response.data != null) {
      final data = response.data!;
      final accountsRaw = data['bankAccounts'] as List<dynamic>? ?? [];

      final parsedList = accountsRaw.map((acc) {
        return BankDetails(
          id: acc['_id'],
          // selectedBank: acc['bankName'],
          selectedBank: Bank(id: 0, code: 'bankCode', name: acc['bankName']),
          accountNumber: acc['accountNumber'],
          accountHolderName: acc['accountName'],
          phoneNumber: acc['phoneNumber'],
          isDefault: acc['isDefault'],
        );
      }).toList();

      state = state.copyWith(
        fetchWalletLoading: false,
        hasWallet: true,
        bankDetailsList: parsedList,
      );
    } else {
      state = state.copyWith(
        fetchWalletLoading: false,
        hasWallet: false,
        bankDetailsList: [],
      );
    }
  }

  void startEditBankAccount(BankDetails bankDetails) {
    accountNumberController.text = bankDetails.isEmpty
        ? ''
        : bankDetails.accountNumber;
    accountNameController.text = bankDetails.isEmpty
        ? ''
        : bankDetails.accountHolderName;
    phoneNumberController.text = bankDetails.isEmpty
        ? ''
        : bankDetails.phoneNumber;
    selectedBankName.value = bankDetails.isEmpty
        ? null
        : bankDetails.selectedBank;

    state = state.copyWith(
      selectedBankDetails: bankDetails,
      isDefault: !bankDetails.isEmpty && bankDetails.isDefault,
      walletScreenState: WalletScreenState.editBankAccount,
    );
  }

  bool validateOnSubmit() {
    final requiredFields = {
      "accountName": state.selectedBankDetails?.accountHolderName,
      "accountNumber": state.selectedBankDetails?.accountNumber,
      "bankName": state.selectedBankDetails?.selectedBank?.name,
      "phoneNumber": state.selectedBankDetails?.phoneNumber,
    };

    final hasEmpty = requiredFields.values.any(FormValidators.isFieldEmpty);

    state = state.copyWith(
      hasSubmitted: true,
      errorMessage: hasEmpty ? 'Please fix the highlighted fields' : null,
    );

    return !hasEmpty;
  }

  Future<bool> saveBankDetails(BuildContext context) async {
    final isValid = validateOnSubmit();

    if (!isValid) {
      showErrorBanner('Please fix the highlighted fields', context);
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final payload = {
      "accountName": accountNameController.text,
      "accountNumber": accountNumberController.text,
      "bankName": selectedBankName.value?.name ?? "",
      "phoneNumber": phoneNumberController.text,
    };

    bool isSuccess = false;

    if (!state.hasWallet) {
      // 1. No wallet exists, call create
      final res = await _apiService.createWallet(payload);
      isSuccess = res.isSuccess;
    } else if (state.selectedBankDetails?.isEmpty ?? true) {
      // 2. Wallet exists, adding a new account
      final res = await _apiService.addBankAccount(payload);
      isSuccess = res.isSuccess;

      // If they checked default, we might need to set it after adding
      if (isSuccess && state.isDefault) {
        // In a real app, you'd extract the new ID from the response to set it.
        // For now, refreshing the wallet gets the updated data.
      }
    } else {
      // 3. Existing account "Edit" - Primarily handling the default checkbox
      // If the API had an update endpoint, it would go here.
      if (state.isDefault && state.selectedBankDetails != null) {
        final res = await _apiService.setDefaultBankAccount(
          state.selectedBankDetails!.id,
        );
        isSuccess = res.isSuccess;
      } else {
        isSuccess = true; // No actual endpoint to update fields provided
      }
    }

    if (isSuccess) {
      await fetchWallet(); // Refresh list
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Failed to save bank details.",
      );
      return false;
    }
  }

  void setWalletScreenState(WalletScreenState newState) {
    state = state.copyWith(walletScreenState: newState);
  }

  // void startEditBankAccount(BankDetails bankDetails) {
  //   state = state.copyWith(
  //     selectedBankDetails: bankDetails,
  //     walletScreenState: WalletScreenState.editBankAccount,
  //   );
  // }

  void cancelEditBankAccount() {
    state = state.copyWith(
      selectedBankDetails: null,
      walletScreenState: WalletScreenState.addBankAccount,
    );
  }

  void updateBankDetails({
    required String bankId,
    required Bank newBankName,
    required String newAccountNumber,
    required String newAccountHolderName,
    required String newPhoneNumber,
    required bool newIsDefault,
    // required WidgetRef ref,
    // required WalletScreenState returnToState,
  }) {
    final updatedList = state.bankDetailsList.map((bank) {
      if (bank.id == bankId) {
        return bank.copyWith(
          selectedBank: newBankName,
          accountNumber: newAccountNumber,
          accountHolderName: newAccountHolderName,
          phoneNumber: newPhoneNumber,
          isDefault: newIsDefault,
          isEmpty: false,
        );
      } else if (newIsDefault == true) {
        return bank.copyWith(isDefault: false);
      }
      return bank;
    }).toList();

    state = state.copyWith(
      bankDetailsList: updatedList,
      selectedBankDetails: null,
      // walletScreenState: returnToState,
    );
    // ref.invalidate(editBankAccountProvider);
  }

  Future<void> clearBankDetails(String bankId, BuildContext context) async {
    state = state.copyWith(isLoading: true);
    await runWithOverlay(context, () async {
      final response = await _apiService.deleteBankAccount(bankId);

      if (response.isSuccess) {
        await fetchWallet();
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Failed to delete account.",
        );
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }

  BankDetails? getDefaultBankAccount() {
    return state.bankDetailsList.cast<BankDetails?>().firstWhere(
      (bank) => bank != null && bank.isDefault,
      orElse: () => null,
    );
  }

  // void clearBankDetails(String bankId) {
  //   final clearedBankWasDefault = state.bankDetailsList
  //       .firstWhere((b) => b.id == bankId)
  //       .isDefault;
  //
  //   final updatedList = state.bankDetailsList.map((bank) {
  //     if (bank.id == bankId) {
  //       return BankDetails.empty(bankId);
  //     }
  //     return bank;
  //   }).toList();
  //
  //   if (clearedBankWasDefault) {
  //     final firstTile = updatedList.firstWhere(
  //       (b) => b.id == '1',
  //       orElse: () => updatedList.first,
  //     );
  //     if (firstTile.isEmpty) {
  //       final listWithNewDefault = updatedList.map((bank) {
  //         if (bank.id == firstTile.id) {
  //           return bank.copyWith(isDefault: true);
  //         }
  //         return bank.copyWith(isDefault: false);
  //       }).toList();
  //       state = state.copyWith(
  //         bankDetailsList: listWithNewDefault,
  //         walletScreenState: WalletScreenState.addBankAccount,
  //       );
  //       return;
  //     }
  //   }
  // }

  // BankDetails? getDefaultBankAccount() {
  //   // Find the first bank account that is marked as default.
  //   final defaultBank = state.bankDetailsList.cast<BankDetails?>().firstWhere(
  //     (bank) => bank != null && bank.isDefault,
  //     orElse: () => null,
  //   );
  //
  //   // If we find a default bank but it's empty, we should treat it as needing setup.
  //   if (defaultBank != null && defaultBank.isEmpty) {
  //     return null;
  //   }
  //
  //   return defaultBank;
  // }

  void navigateBackToList(WidgetRef ref) {
    ref.read(editBankAccountProvider.notifier).cancelEditBankAccount();
  }
}

final editBankAccountProvider =
    StateNotifierProvider<EditBankAccountViewModel, WalletState>(
      (ref) => EditBankAccountViewModel(ref.read),
    );
