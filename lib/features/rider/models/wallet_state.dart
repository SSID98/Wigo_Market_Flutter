import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../gen/assets.gen.dart';
import 'bank_details.dart';

Map<String, ({Color color, Widget icon})> bankTileConfig = {
  '1': (
    color: AppColors.buttonLighterGreen,
    icon: AppAssets.icons.greenWallet.svg(
      height: kIsWeb ? 60 : 32,
      width: kIsWeb ? 60 : 32,
    ),
  ),
  '2': (
    color: AppColors.sellerCardColor,
    icon: AppAssets.icons.brownWallet.svg(
      height: kIsWeb ? 60 : 32,
      width: kIsWeb ? 60 : 32,
    ),
  ),
  '3': (
    color: AppColors.riderCardColor,
    icon: AppAssets.icons.blueWallet.svg(
      height: kIsWeb ? 60 : 32,
      width: kIsWeb ? 60 : 32,
    ),
  ),
};

enum WalletScreenState {
  overview,
  transactions,
  paymentMethods,
  setupPin,
  pinSuccess,
  addBankAccount,
  editBankAccount,
}

class WalletState {
  final WalletScreenState walletScreenState;
  final List<BankDetails> bankDetailsList;
  final BankDetails? selectedBankDetails;

  const WalletState({
    this.walletScreenState = WalletScreenState.overview,
    required this.bankDetailsList,
    this.selectedBankDetails,
  });

  WalletState copyWith({
    WalletScreenState? walletScreenState,
    List<BankDetails>? bankDetailsList,
    BankDetails? selectedBankDetails,
  }) {
    return WalletState(
      walletScreenState: walletScreenState ?? this.walletScreenState,
      bankDetailsList: bankDetailsList ?? this.bankDetailsList,
      selectedBankDetails: selectedBankDetails,
    );
  }
}
