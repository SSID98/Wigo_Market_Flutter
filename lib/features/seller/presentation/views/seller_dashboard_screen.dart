import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/features/rider/presentation/widgets/dashboard_screen_widgets/earning_history_widget.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/dashboard_widgets/business_analytics_widget.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/dashboard_widgets/getting_started_widget.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/dashboard_widgets/quick_action_widget.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/dashboard_widgets/recent_earnings_widget.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/dashboard_widgets/recent_orders_widget.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../core/auth/auth_state.dart';
import '../../../../core/auth/auth_state_notifier.dart';
import '../../../../gen/assets.gen.dart';
import '../../../rider/presentation/widgets/dashboard_screen_widgets/account_setup_status_widget.dart';
import '../../viewmodels/seller_dashboard_viewmodel.dart';

class SellerDashboardScreen extends ConsumerWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(sellerDashboardViewModelProvider.notifier);
    // final state = ref.watch(sellerDashboardViewModelProvider);
    final screenSize = MediaQuery.of(context).size;
    final authState = ref.watch(authStateProvider);
    final user = authState.status == AuthStatus.loggedIn
        ? authState.user
        : null;
    final hasWallet = user?.hasWallet ?? false;
    final hasWalletPin = user?.hasWithdrawalPin ?? false;
    final hasStore = user?.store != null;
    final paymentStatus = hasWallet && hasWalletPin
        ? SetupStatus.completed
        : SetupStatus.pending;
    final storeStatus = hasStore ? SetupStatus.completed : SetupStatus.pending;
    final walletCompleted = hasWallet == true;
    final double setupProgress = walletCompleted ? 0.1 : 0.7;

    final steps = _buildSteps(
      paymentStatus: paymentStatus,
      storeStatus: storeStatus,
      paymentOntap: () {},
    );

    return context.isWeb
        ? _buildWebLayout(
            screenSize,
            ref,
            context,
            steps,
            setupProgress,
            walletCompleted,
            viewModel,
          )
        : _buildMobileLayout(
            screenSize,
            ref,
            context,
            steps,
            setupProgress,
            walletCompleted,
            viewModel,
          );
  }

  List<AccountSetupStep> _buildSteps({
    required SetupStatus paymentStatus,
    required SetupStatus storeStatus,
    required void Function()? paymentOntap,
  }) {
    return [
      AccountSetupStep(
        title: 'Personal \nInformation',
        iconAsset: AppAssets.icons.vehicleDoc.svg(
          height: kIsWeb ? 42.76 : 25.22,
          width: kIsWeb ? 49 : 28.9,
        ),
        status: SetupStatus.completed,
        onTap: () {},
      ),
      AccountSetupStep(
        title: 'Payment \nInformation',
        iconAsset: AppAssets.icons.payInfo.svg(
          height: kIsWeb ? 42.76 : 25.22,
          width: kIsWeb ? 49 : 28.9,
        ),
        status: paymentStatus,
        onTap: paymentOntap,
      ),
      AccountSetupStep(
        title: 'Business/shop \nInformation',
        iconAsset: AppAssets.icons.businessInfo.svg(
          height: kIsWeb ? 42.76 : 25.22,
          width: kIsWeb ? 49 : 28.9,
        ),
        status: storeStatus,
        onTap: () {},
      ),
    ];
  }

  Widget _buildMobileLayout(
    Size screenSize,
    WidgetRef ref,
    BuildContext context,
    List<AccountSetupStep> steps,
    double setupProgress,
    bool walletCompleted,
    SellerDashboardViewModel viewModel,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            _buildHeader(ref: ref),
            if (!walletCompleted)
              AccountSetup(
                title: 'Complete Your Account Setup',
                subtitle:
                    'You\'re almost there! Add your store details and payment info to start selling on WIGOMARKET.',
                steps: steps,
                progress: setupProgress,
                isSeller: true,
                onCompletePressed: () =>
                    viewModel.navigateToSellerPaymentSetup(context, ref),
                isWeb: false,
              ),
            BusinessAnalyticsWidget(),
            QuickActionWidget(),
            RecentOrdersWidget(),
            GettingStartedWidget(),
            RecentEarningsWidget(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildWebLayout(
    Size screenSize,
    WidgetRef ref,
    BuildContext context,
    List<AccountSetupStep> steps,
    double setupProgress,
    bool walletCompleted,
    SellerDashboardViewModel viewModel,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 35),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(ref: ref),
              const SizedBox(height: 10.0),
              if (!walletCompleted)
                AccountSetup(
                  title: 'Complete Your Account Setup',
                  subtitle:
                      'You\'re almost there! Add your store details and payment info to start selling on WIGOMARKET.',
                  steps: steps,
                  progress: setupProgress,
                  onCompletePressed: () =>
                      viewModel.navigateToSellerPaymentSetup(context, ref),
                  isSeller: true,
                  isWeb: true,
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        BusinessAnalyticsWidget(),
                        QuickActionWidget(),
                        RecentOrdersWidget(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        GettingStartedWidget(),
                        EarningHistoryWidget(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({required WidgetRef ref}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: GoogleFonts.hind(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          'Track your store performance at a glance',
          style: GoogleFonts.hind(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textBlackGrey,
          ),
        ),
      ],
    );
  }
}
