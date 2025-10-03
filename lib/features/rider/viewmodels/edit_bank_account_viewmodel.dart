import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/features/rider/models/wallet_state.dart';

import '../models/bank_details.dart';

class EditBankAccountViewModel extends StateNotifier<WalletState> {
  EditBankAccountViewModel()
    : super(
        WalletState(
          bankDetailsList: [
            BankDetails.empty('1').copyWith(isDefault: true),
            BankDetails.empty('2'),
            BankDetails.empty('3'),
          ],
        ),
      );

  void navigateToWithdrawal() {
    state = state.copyWith(walletScreenState: WalletScreenState.withdrawal);
  }

  void navigateToOverview() {
    state = state.copyWith(walletScreenState: WalletScreenState.overview);
  }

  void setWalletScreenState(WalletScreenState newState) {
    state = state.copyWith(walletScreenState: newState);
  }

  void startEditBankAccount(BankDetails bankDetails) {
    state = state.copyWith(
      selectedBankDetails: bankDetails,
      walletScreenState: WalletScreenState.editBankAccount,
    );
  }

  void cancelEditBankAccount() {
    // If we came from the withdrawal screen, go back there, otherwise go to addBankAccount
    final targetState =
        state.walletScreenState == WalletScreenState.editBankAccount
            ? WalletScreenState.addBankAccount
            : WalletScreenState.withdrawal;

    state = state.copyWith(
      selectedBankDetails: null,
      walletScreenState: targetState,
    );
  }

  void updateBankDetails({
    required String bankId,
    required String newBankName,
    required String newAccountNumber,
    required String newAccountHolderName,
    required String newPhoneNumber,
    required bool newIsDefault,
    required WalletScreenState returnToState,
  }) {
    final updatedList =
        state.bankDetailsList.map((bank) {
          if (bank.id == bankId) {
            return bank.copyWith(
              bankName: newBankName,
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
      walletScreenState: returnToState,
    );
  }

  void clearBankDetails(String bankId) {
    final clearedBankWasDefault =
        state.bankDetailsList.firstWhere((b) => b.id == bankId).isDefault;

    final updatedList =
        state.bankDetailsList.map((bank) {
          if (bank.id == bankId) {
            return BankDetails.empty(bankId);
          }
          return bank;
        }).toList();

    if (clearedBankWasDefault) {
      final firstTile = updatedList.firstWhere(
        (b) => b.id == '1',
        orElse: () => updatedList.first,
      );
      if (firstTile.isEmpty) {
        final listWithNewDefault =
            updatedList.map((bank) {
              if (bank.id == firstTile.id) {
                return bank.copyWith(isDefault: true);
              }
              return bank.copyWith(isDefault: false);
            }).toList();
        state = state.copyWith(
          bankDetailsList: listWithNewDefault,
          walletScreenState: WalletScreenState.addBankAccount,
        );
        return;
      }
    }
  }

  BankDetails? getDefaultBankAccount() {
    // Find the first bank account that is marked as default.
    final defaultBank = state.bankDetailsList.cast<BankDetails?>().firstWhere(
      (bank) => bank != null && bank.isDefault,
      orElse: () => null,
    );

    // If we find a default bank but it's empty, we should treat it as needing setup.
    if (defaultBank != null && defaultBank.isEmpty) {
      return null;
    }

    return defaultBank;
  }
}

final editBankAccountProvider =
    StateNotifierProvider<EditBankAccountViewModel, WalletState>(
      (ref) => EditBankAccountViewModel(),
    );
