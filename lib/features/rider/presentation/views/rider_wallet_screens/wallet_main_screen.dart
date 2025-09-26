import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_wallet_screens/wallet_overview_transactions_screen.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_wallet_screens/wallet_payment_methods_screen.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../models/delivery_task_state.dart';
import '../../../viewmodels/delivery_task_viewmodel.dart';

enum EarningFilter { overview, transactions, paymentMethods }

class WalletMainScreen extends ConsumerWidget {
  const WalletMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deliveryTaskProvider);
    final notifier = ref.read(deliveryTaskProvider.notifier);
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(notifier, isWeb, state),
          _buildBody(state, notifier, isWeb),
        ],
      ),
    );
  }

  Widget _buildHeader(
    DeliveryTaskViewModel notifier,
    bool isWeb,
    DeliveryTaskState state,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Manage your earnings and withdrawals",
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w600,
                  fontSize: isWeb ? 24 : 16,
                  color: AppColors.textBlackGrey,
                ),
              ),
              if (state.walletScreenState == WalletScreenState.overview &&
                  isWeb)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomButton(
                    text: 'Withdraw',
                    onPressed: () {},
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

  Widget _buildFilterBar(DeliveryTaskViewModel notifier, bool isWeb) {
    final filters = EarningFilter.values;
    final filterNames = {
      EarningFilter.overview: "Overview",
      EarningFilter.transactions: "Transactions",
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
    DeliveryTaskViewModel notifier,
    bool isWeb,
  ) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(deliveryTaskProvider);
        final isSelected = _getEarningFilter(state) == filter;
        return GestureDetector(
          onTap: () {
            notifier.setWalletScreenState(
              _getWalletScreenStateForFilter(filter),
            );
          },
          child: Container(
            color:
                isSelected ? AppColors.primaryLightGreen : Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
            child: Row(
              children: [
                Text(
                  name,
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w500,
                    fontSize: isWeb ? 18 : 12,
                    color: AppColors.textDarkDarkerGreen,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  EarningFilter _getEarningFilter(DeliveryTaskState state) {
    if (state.walletScreenState == WalletScreenState.overview) {
      return EarningFilter.overview;
    } else if (state.walletScreenState == WalletScreenState.transactions) {
      return EarningFilter.transactions;
    } else {
      return EarningFilter.paymentMethods;
    }
  }

  WalletScreenState _getWalletScreenStateForFilter(EarningFilter filter) {
    switch (filter) {
      case EarningFilter.overview:
        return WalletScreenState.overview;
      case EarningFilter.transactions:
        return WalletScreenState.transactions;
      case EarningFilter.paymentMethods:
        return WalletScreenState.paymentMethods;
    }
  }

  Widget _buildBody(
    DeliveryTaskState state,
    DeliveryTaskViewModel notifier,
    bool isWeb,
  ) {
    switch (state.walletScreenState) {
      case WalletScreenState.overview:
        return WalletOverviewAndTransactionsScreen(isWeb: isWeb);
      case WalletScreenState.transactions:
        return WalletOverviewAndTransactionsScreen(
          isWeb: isWeb,
          isOverView: false,
        );
      case WalletScreenState.paymentMethods:
      case WalletScreenState.setupPin:
      case WalletScreenState.pinSuccess:
        return PaymentMethodScreen(isWeb: isWeb);
    }
  }
}
