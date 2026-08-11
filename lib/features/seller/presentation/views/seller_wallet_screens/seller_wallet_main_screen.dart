import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_wallet_screens/wallet_add_bank_account_screen.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_wallet_screens/wallet_edit_bank_account_screen.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_wallet_screens/wallet_payment_methods_screen.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_wallet_screens/wallet_withdrawal_screen.dart';
import 'package:wigo_flutter/features/rider/viewmodels/edit_bank_account_viewmodel.dart';
import 'package:wigo_flutter/features/seller/presentation/views/seller_wallet_screens/earning_transactions_screen.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../rider/models/wallet_state.dart';

enum EarningFilter { earnings, paymentMethods }

enum SellerWalletScreenState {
  earnings,
  paymentMethods,
  setupPin,
  pinSuccess,
  addBankAccount,
  editBankAccount,
}

class SellerWalletMainScreen extends ConsumerWidget {
  const SellerWalletMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editBankAccountProvider);
    final notifier = ref.read(editBankAccountProvider.notifier);
    notifier.ensureWalletFetched();
    final isWeb = context.isWeb;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(notifier, isWeb, state, ref, context),
          _buildBody(state, notifier, isWeb),
        ],
      ),
    );
  }

  Widget _buildHeader(
    EditBankAccountViewModel notifier,
    bool isWeb,
    WalletState state,
    WidgetRef ref,
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          if (state.sellerWalletScreenState ==
                  SellerWalletScreenState.editBankAccount &&
              !isWeb)
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 5.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      notifier.navigateBackToList(ref);
                    },
                    child: AppAssets.icons.arrowLeft.svg(),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Back',
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                ],
              ),
            ),
          if (state.sellerWalletScreenState ==
                  SellerWalletScreenState.editBankAccount &&
              !isWeb)
            Divider(color: AppColors.dividerColor.withValues(alpha: 0.2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    isWeb ? "Earnings & Transactions" : "Earnings",
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: AppColors.textBlackGrey,
                    ),
                  ),

                  if (isWeb) ...[
                    const SizedBox(height: 10),
                    Text(
                      'See what you’ve earned and track every payment—all in one place.',
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                  ],
                ],
              ),
              if (state.sellerWalletScreenState ==
                      SellerWalletScreenState.earnings &&
                  isWeb)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomButton(
                    text: 'Withdraw',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              WalletWithdrawalScreen(isSeller: true),
                        ),
                      );
                    },
                    fontSize: 18,
                    height: 41,
                    fontWeight: FontWeight.w500,
                    prefixIcon: AppAssets.icons.download.svg(),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(right: isWeb ? 700.0 : 0),
            child: _buildFilterBar(notifier, isWeb),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(EditBankAccountViewModel notifier, bool isWeb) {
    final filters = EarningFilter.values;
    final filterNames = {
      EarningFilter.earnings: "Earnings",
      EarningFilter.paymentMethods: "Payment Methods",
    };

    return Container(
      height: isWeb ? 48 : 36,
      color: AppColors.backgroundWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(filters.length, (index) {
          final filter = filters[index];
          return _buildFilterTab(filter, filterNames[filter]!, notifier, isWeb);
        }),
      ),
    );
  }

  Widget _buildFilterTab(
    EarningFilter filter,
    String name,
    EditBankAccountViewModel notifier,
    bool isWeb,
  ) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(editBankAccountProvider);
        final isSelected = _getEarningFilter(state) == filter;
        return GestureDetector(
          onTap: () async {
            if (filter == EarningFilter.paymentMethods) {
              notifier.navigateToSellerPaymentSetup(context);
            } else {
              notifier.setSellerWalletScreenState(
                _getWalletScreenStateForFilter(filter, state),
              );
            }
          },
          child: Container(
            color: isSelected
                ? AppColors.primaryLightGreen
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
            child: Text(
              name,
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w500,
                fontSize: isWeb ? 18 : 12,
                color: AppColors.textDarkDarkerGreen,
              ),
            ),
          ),
        );
      },
    );
  }

  EarningFilter _getEarningFilter(WalletState state) {
    if (state.sellerWalletScreenState == SellerWalletScreenState.earnings) {
      return EarningFilter.earnings;
    } else {
      return EarningFilter.paymentMethods;
    }
  }

  SellerWalletScreenState _getWalletScreenStateForFilter(
    EarningFilter filter,
    WalletState state,
  ) {
    switch (filter) {
      case EarningFilter.earnings:
        return SellerWalletScreenState.earnings;
      case EarningFilter.paymentMethods:
        throw UnimplementedError(
          'paymentMethods is handled by navigateToPaymentSetup(), not this switch.',
        );
    }
  }

  Widget _buildBody(
    WalletState state,
    EditBankAccountViewModel notifier,
    bool isWeb,
  ) {
    switch (state.sellerWalletScreenState) {
      case SellerWalletScreenState.earnings:
        return EarningsAndTransactionsScreen();
      case SellerWalletScreenState.paymentMethods:
      case SellerWalletScreenState.setupPin:
      case SellerWalletScreenState.pinSuccess:
        return PaymentMethodScreen();
      case SellerWalletScreenState.addBankAccount:
        return AddBankAccountScreen(isWeb: isWeb);
      case SellerWalletScreenState.editBankAccount:
        final bankToEdit = state.selectedBankDetails;
        if (bankToEdit == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notifier.setSellerWalletScreenState(
              SellerWalletScreenState.addBankAccount,
            );
          });
          return const Center(
            child: SpinKitDualRing(color: AppColors.primaryDarkGreen),
          );
        }
        return EditBankAccountScreen(bankDetails: bankToEdit);
    }
  }
}
