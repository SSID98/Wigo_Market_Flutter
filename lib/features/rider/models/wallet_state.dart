import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wigo_flutter/features/seller/presentation/views/seller_wallet_screens/seller_wallet_main_screen.dart';

import '../../../core/constants/app_colors.dart';
import '../../../gen/assets.gen.dart';
import '../../../shared/models/bank_model.dart';
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
  final SellerWalletScreenState sellerWalletScreenState;
  final WalletScreenState walletScreenState;
  final List<BankDetails> bankDetailsList;
  final BankDetails? selectedBankDetails;
  final bool isLoading;
  final bool fetchWalletLoading;
  final String? errorMessage;
  final bool hasWallet;
  final List<Bank> banks;
  final bool hasSubmitted;
  final bool isDefault;
  final bool hasWithdrawalPin;

  const WalletState({
    this.walletScreenState = WalletScreenState.overview,
    this.sellerWalletScreenState = SellerWalletScreenState.earnings,
    required this.bankDetailsList,
    this.selectedBankDetails,
    this.isLoading = false,
    this.errorMessage,
    this.hasWallet = false,
    this.banks = const [],
    this.hasSubmitted = false,
    this.isDefault = false,
    this.fetchWalletLoading = false,
    this.hasWithdrawalPin = false,
  });

  WalletState copyWith({
    SellerWalletScreenState? sellerWalletScreenState,
    WalletScreenState? walletScreenState,
    List<BankDetails>? bankDetailsList,
    BankDetails? selectedBankDetails,
    bool? isLoading,
    String? errorMessage,
    bool? hasWallet,
    List<Bank>? banks,
    bool? hasSubmitted,
    bool? isDefault,
    bool? fetchWalletLoading,
    bool? hasWithdrawalPin,
  }) {
    return WalletState(
      sellerWalletScreenState:
          sellerWalletScreenState ?? this.sellerWalletScreenState,
      walletScreenState: walletScreenState ?? this.walletScreenState,
      bankDetailsList: bankDetailsList ?? this.bankDetailsList,
      selectedBankDetails: selectedBankDetails ?? this.selectedBankDetails,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      hasWallet: hasWallet ?? this.hasWallet,
      banks: banks ?? this.banks,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      isDefault: isDefault ?? this.isDefault,
      fetchWalletLoading: fetchWalletLoading ?? this.fetchWalletLoading,
      hasWithdrawalPin: hasWithdrawalPin ?? this.hasWithdrawalPin,
    );
  }
}
