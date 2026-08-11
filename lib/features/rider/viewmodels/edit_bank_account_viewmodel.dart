import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wigo_flutter/features/rider/models/wallet_state.dart';
import 'package:wigo_flutter/features/seller/presentation/views/seller_wallet_screens/seller_wallet_main_screen.dart';

import '../../../core/auth/auth_state_notifier.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/local/secure_storage.dart';
import '../../../core/network/network.dart';
import '../../../core/utils/helper_methods_classes.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../shared/models/bank_model.dart';
import '../../../shared/widgets/custom_banner.dart';
import '../../../shared/widgets/custom_loading_overlay.dart';
import '../models/bank_details.dart';
import '../service/rider_api_service.dart';
import 'global_navigation_viewmodel.dart';

class EditBankAccountViewModel extends StateNotifier<WalletState> {
  final Reader read;
  final RiderApiService _apiService;
  final accountNumberController = TextEditingController();
  final accountNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final ValueNotifier<Bank?> selectedBankName = ValueNotifier(null);

  BankDetails? _originalEditBankDetails;

  bool _walletFetchScheduledOrDone = false;

  Timer? walletRetryTimer;

  EditBankAccountViewModel(this.read, {RiderApiService? apiService})
    : _apiService = apiService ?? read(riderApiServiceProvider),
      super(
        WalletState(
          bankDetailsList: const [],
          hasWallet: read(authStateProvider).user?.hasWallet ?? false,
          hasWithdrawalPin:
              read(authStateProvider).user?.hasWithdrawalPin ?? false,
        ),
      ) {
    _persistWalletSetupStatusToStorage();
  }

  @override
  void dispose() {
    accountNumberController.dispose();
    accountNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _persistFlag(String key, bool value) async {
    final userId = read(authStateProvider).user?.id;
    if (userId == null) return;
    final storage = SecureStorage();
    await storage.storeData(key: userKey(key, userId), data: value.toString());
  }

  Future<void> _persistWalletSetupStatusToStorage() async {
    await _persistFlag('hasWallet', state.hasWallet);
    await _persistFlag('hasWithdrawalPin', state.hasWithdrawalPin);
  }

  Future<void> markPinAsCreated() async {
    state = state.copyWith(hasWithdrawalPin: true);
    await _persistFlag('hasWithdrawalPin', true);
    try {
      await read(authStateProvider.notifier).init();
      syncWalletSetupFlagsFromAuth();
    } catch (_) {
      // Non-fatal — local state & storage are already correct.
    }
  }

  void syncWalletSetupFlagsFromAuth() {
    final authUser = read(authStateProvider).user;
    if (authUser == null) return;
    final authHasWallet = authUser.hasWallet;
    final authHasPin = authUser.hasWithdrawalPin;

    if (authHasWallet != state.hasWallet ||
        authHasPin != state.hasWithdrawalPin) {
      state = state.copyWith(
        hasWallet: authHasWallet,
        hasWithdrawalPin: authHasPin,
      );
      _persistWalletSetupStatusToStorage();
    }
  }

  void ensureWalletFetched() {
    Future.microtask(() {
      syncWalletSetupFlagsFromAuth();

      if (_walletFetchScheduledOrDone) return;
      if (!state.hasWallet) return;
      _walletFetchScheduledOrDone = true;
      _attemptWalletFetch();
    });
  }

  Future<void> _attemptWalletFetch() async {
    final success = await fetchWallet();
    if (!success) {
      walletRetryTimer = Timer(const Duration(seconds: 5), _attemptWalletFetch);
    }
  }

  Future<bool> fetchWallet() async {
    state = state.copyWith(fetchWalletLoading: true, errorMessage: null);

    final response = await _apiService.getWallet();

    if (response.isSuccess && response.data != null) {
      final data = response.data!;
      final accountsRaw = data['bankAccounts'] as List<dynamic>? ?? [];

      final parsedList = accountsRaw.map((acc) {
        return BankDetails(
          id: acc['_id'],
          selectedBank: Bank(
            id: 0,
            code: acc['bankCode'] ?? '',
            name: acc['bankName'],
          ),
          accountNumber: acc['accountNumber'],
          accountHolderName: acc['accountName'],
          phoneNumber: acc['phoneNumber'],
          isDefault: acc['isDefault'] ?? false,
        );
      }).toList();

      state = state.copyWith(
        fetchWalletLoading: false,
        hasWallet: true,
        bankDetailsList: parsedList,
      );
      return true;
    } else {
      // Network/server hiccup — NOT evidence the wallet doesn't exist.
      state = state.copyWith(fetchWalletLoading: false);
      return false;
    }
  }

  Future<void> fetchBanks(BuildContext context) async {
    await runWithOverlay(context, () async {
      state = state.copyWith(isLoading: true);
      try {
        final result = await _apiService.getBanks();

        if (result.isSuccess && result.data != null) {
          final banks = result.data;
          state = state.copyWith(banks: banks, isLoading: false);
          _syncSelectedBankWithFetchedList();
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

  void startEditBankAccount(BankDetails bankDetails) {
    _originalEditBankDetails = bankDetails;

    accountNumberController.text = bankDetails.isEmpty
        ? ''
        : bankDetails.accountNumber;
    accountNameController.text = bankDetails.isEmpty
        ? ''
        : bankDetails.accountHolderName;
    phoneNumberController.text = bankDetails.isEmpty
        ? ''
        : bankDetails.phoneNumber;

    state = state.copyWith(
      selectedBankDetails: bankDetails,
      isDefault: !bankDetails.isEmpty && bankDetails.isDefault,
      hasSubmitted: false,
      walletScreenState: WalletScreenState.editBankAccount,
    );

    _syncSelectedBankWithFetchedList();
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

    final wasWalletCreation = !state.hasWallet;
    bool isSuccess = false;

    if (!state.hasWallet) {
      // 1. No wallet exists, call create
      final res = await _apiService.createWallet(payload);
      isSuccess = res.isSuccess;
      if (isSuccess) {
        state = state.copyWith(hasWallet: true);
        _persistFlag('hasWallet', true);
        try {
          await read(authStateProvider.notifier).init();
          syncWalletSetupFlagsFromAuth();
        } catch (_) {}
      }
    } else if (state.selectedBankDetails?.isEmpty ?? true) {
      // 2. Wallet exists, adding a new account
      final res = await _apiService.addBankAccount(payload);
      isSuccess = res.isSuccess;
      if (isSuccess && state.isDefault) {
        await fetchWallet();
        final newAccount = state.bankDetailsList
            .cast<BankDetails?>()
            .firstWhere(
              (b) =>
                  b != null &&
                  b.accountNumber == accountNumberController.text &&
                  b.selectedBank?.name == (selectedBankName.value?.name ?? ''),
              orElse: () => null,
            );
        if (newAccount != null && !newAccount.isDefault) {
          final defaultRes = await _apiService.setDefaultBankAccount(
            newAccount.id,
          );
          isSuccess = defaultRes.isSuccess;
        }
      }
    } else {
      // 3. Editing an existing account — partial update only
      final original = _originalEditBankDetails;
      final updatePayload = <String, dynamic>{};

      if (original == null ||
          accountNameController.text != original.accountHolderName) {
        updatePayload['accountName'] = accountNameController.text;
      }
      if (original == null ||
          accountNumberController.text != original.accountNumber) {
        updatePayload['accountNumber'] = accountNumberController.text;
      }
      if (original == null ||
          selectedBankName.value?.name != original.selectedBank?.name) {
        if (selectedBankName.value != null) {
          updatePayload['bankName'] = selectedBankName.value!.name;
          updatePayload['bankCode'] = selectedBankName.value!.code;
        }
      }
      if (original == null ||
          phoneNumberController.text != original.phoneNumber) {
        updatePayload['phoneNumber'] = phoneNumberController.text;
      }

      isSuccess = true;

      if (updatePayload.isNotEmpty) {
        final res = await _apiService.updateBankAccount(
          state.selectedBankDetails!.id,
          updatePayload,
        );
        isSuccess = res.isSuccess;
      }

      if (isSuccess && state.isDefault && !(original?.isDefault ?? false)) {
        final defaultRes = await _apiService.setDefaultBankAccount(
          state.selectedBankDetails!.id,
        );
        isSuccess = defaultRes.isSuccess;
      }
    }

    if (isSuccess) {
      _originalEditBankDetails = null;
      await fetchWallet();
      state = state.copyWith(
        selectedBankDetails: null,
        walletScreenState: (wasWalletCreation && !state.hasWithdrawalPin)
            ? WalletScreenState.setupPin
            : WalletScreenState.addBankAccount,
      );
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
    state = state.copyWith(
      walletScreenState: newState,
      selectedBankDetails: newState == WalletScreenState.editBankAccount
          ? state.selectedBankDetails
          : null,
    );
  }

  void setSellerWalletScreenState(SellerWalletScreenState newState) {
    state = state.copyWith(
      sellerWalletScreenState: newState,
      selectedBankDetails: newState == SellerWalletScreenState.editBankAccount
          ? state.selectedBankDetails
          : null,
    );
  }

  void _syncSelectedBankWithFetchedList() {
    final targetName = state.selectedBankDetails?.selectedBank?.name;

    if (targetName == null || targetName.isEmpty || state.banks.isEmpty) {
      selectedBankName.value = null;
      return;
    }

    final matches = state.banks.where(
      (b) => b.name.toLowerCase() == targetName.toLowerCase(),
    );
    final match = matches.isNotEmpty ? matches.first : null;

    selectedBankName.value = match;

    if (match != null) {
      state = state.copyWith(
        selectedBankDetails: state.selectedBankDetails?.copyWith(
          selectedBank: match,
        ),
      );
    }
  }

  Future<void> navigateToPaymentSetup(BuildContext context) async {
    await runWithOverlay(context, () async {
      await Future.delayed(const Duration(seconds: 1), () {
        syncWalletSetupFlagsFromAuth();

        final hasWallet = state.hasWallet;
        final hasPin = state.hasWithdrawalPin;

        final targetState = (hasWallet && !hasPin)
            ? WalletScreenState.setupPin
            : WalletScreenState.addBankAccount;

        setWalletScreenState(targetState);
        read(globalNavigationViewModelProvider.notifier).setIndex(3);
      });
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }

  Future<void> navigateToSellerPaymentSetup(BuildContext context) async {
    await runWithOverlay(context, () async {
      await Future.delayed(const Duration(seconds: 1), () {
        syncWalletSetupFlagsFromAuth();

        final hasWallet = state.hasWallet;
        final hasPin = state.hasWithdrawalPin;

        final targetState = (hasWallet && !hasPin)
            ? SellerWalletScreenState.setupPin
            : SellerWalletScreenState.addBankAccount;

        setSellerWalletScreenState(targetState);
        read(globalNavigationViewModelProvider.notifier).setIndex(3);
      });
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }

  void cancelEditBankAccount() {
    _originalEditBankDetails = null;
    state = state.copyWith(
      selectedBankDetails: null,
      walletScreenState: WalletScreenState.addBankAccount,
    );
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
        if (!context.mounted) return;
        if (response.errorDescription != null) {
          showErrorBanner(response.errorDescription!, context);
        }
      }
    }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
  }

  BankDetails? getDefaultBankAccount() {
    return state.bankDetailsList.cast<BankDetails?>().firstWhere(
      (bank) => bank != null && bank.isDefault,
      orElse: () => null,
    );
  }

  void navigateBackToList(WidgetRef ref) {
    ref.read(editBankAccountProvider.notifier).cancelEditBankAccount();
  }
}

final editBankAccountProvider =
    StateNotifierProvider<EditBankAccountViewModel, WalletState>((ref) {
      ref.watch(authStateProvider.select((s) => s.user?.id));

      final notifier = EditBankAccountViewModel(ref.read);

      ref.listen<({bool? hasWallet, bool? hasWithdrawalPin})>(
        authStateProvider.select(
          (s) => (
            hasWallet: s.user?.hasWallet,
            hasWithdrawalPin: s.user?.hasWithdrawalPin,
          ),
        ),
        (previous, next) {
          Future.microtask(() => notifier.syncWalletSetupFlagsFromAuth());
        },
        fireImmediately: true,
      );

      return notifier;
    });
