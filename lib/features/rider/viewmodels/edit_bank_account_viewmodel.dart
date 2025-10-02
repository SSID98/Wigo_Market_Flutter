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
    state = state.copyWith(
      selectedBankDetails: null,
      walletScreenState: WalletScreenState.addBankAccount,
    );
  }

  void updateBankDetails({
    required String bankId,
    required String newBankName,
    required String newAccountNumber,
    required String newAccountHolderName,
    required String newPhoneNumber,
    required bool newIsDefault,
  }) {
    final updatedList =
        state.bankDetailsList.map((bank) {
          if (bank.id == bankId) {
            // 1. The bank being edited: use the submitted values
            return bank.copyWith(
              bankName: newBankName,
              accountNumber: newAccountNumber,
              accountHolderName: newAccountHolderName,
              phoneNumber: newPhoneNumber,
              isDefault: newIsDefault,
              isEmpty: false,
            );
          } else if (newIsDefault == true) {
            // ISSUE 1 FIX: If the user just set a new default,
            // unset the default status for all other accounts.
            return bank.copyWith(isDefault: false);
          }
          // 3. Otherwise, return the bank as is.
          return bank;
        }).toList();

    state = state.copyWith(
      bankDetailsList: updatedList,
      selectedBankDetails: null, // Clear selection
      walletScreenState:
          WalletScreenState.addBankAccount, // Go back to list view
    );
  }

  void clearBankDetails(String bankId) {
    // If the bank being cleared was the default, make the first non-empty bank the default,
    // or if none, Bank 1 gets the default status.
    final clearedBankWasDefault =
        state.bankDetailsList.firstWhere((b) => b.id == bankId).isDefault;

    final updatedList =
        state.bankDetailsList.map((bank) {
          if (bank.id == bankId) {
            // Reset to an empty state for this tile
            return BankDetails.empty(bankId);
          }
          return bank;
        }).toList();

    // Logic to re-assign default if the cleared bank was the default
    if (clearedBankWasDefault) {
      final firstTile = updatedList.firstWhere(
        (b) => b.id == '1',
        orElse: () => updatedList.first,
      );
      if (firstTile.isEmpty) {
        // If we cleared the default, make the remaining first tile the new default, even if empty.
        final listWithNewDefault =
            updatedList.map((bank) {
              if (bank.id == firstTile.id) {
                return bank.copyWith(isDefault: true);
              }
              return bank.copyWith(isDefault: false); // Ensure others are unset
            }).toList();
        state = state.copyWith(
          bankDetailsList: listWithNewDefault,
          walletScreenState: WalletScreenState.addBankAccount,
        );
        return;
      }
    }
  }
}

final editBankAccountProvider =
    StateNotifierProvider<EditBankAccountViewModel, WalletState>(
      (ref) => EditBankAccountViewModel(),
    );
