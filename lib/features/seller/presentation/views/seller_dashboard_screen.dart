import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/rider/models/rider_dashboard_state.dart';
import 'package:wigo_flutter/features/rider/presentation/widgets/dashboard_screen_widgets/earning_history_widget.dart';
import 'package:wigo_flutter/features/rider/viewmodels/rider_dashboard_viewmodel.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/dashboard_widgets/business_analytics_widget.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/dashboard_widgets/getting_started_widget.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/dashboard_widgets/quick_action_widget.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/dashboard_widgets/recent_earnings_widget.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/dashboard_widgets/recent_orders_widget.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../core/auth/auth_state_notifier.dart';
import '../../../../gen/assets.gen.dart';
import '../../../rider/presentation/widgets/dashboard_screen_widgets/account_setup_status_widget.dart';

class SellerDashboardScreen extends ConsumerWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(riderDashboardViewModelProvider.notifier);
    final state = ref.watch(riderDashboardViewModelProvider);
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    final steps = [
      AccountSetupStep(
        title: 'Personal \nInformation',
        iconAsset: AppAssets.icons.vehicleDoc.svg(
          height: isWeb ? 42.76 : 25.22,
          width: isWeb ? 49 : 28.9,
        ),
        status: SetupStatus.completed,
        onTap: () {},
      ),
      AccountSetupStep(
        title: 'Business/shop \nInformation',
        iconAsset: AppAssets.icons.businessInfo.svg(
          height: isWeb ? 42.76 : 25.22,
          width: isWeb ? 49 : 28.9,
        ),
        status: SetupStatus.pending,
        onTap: () {},
      ),
      AccountSetupStep(
        title: 'Payment \nInformation',
        iconAsset: AppAssets.icons.payInfo.svg(
          height: isWeb ? 42.76 : 25.22,
          width: isWeb ? 49 : 28.9,
        ),
        status: SetupStatus.pending,
        onTap: () {},
      ),
    ];
    return isWeb
        ? _buildWebLayout(screenSize, viewModel, state, ref, steps)
        : _buildMobileLayout(screenSize, viewModel, state, ref, steps);
  }

  Widget _buildMobileLayout(
    Size screenSize,
    RiderDashboardViewModel viewModel,
    RiderDashboardState state,
    WidgetRef ref,
    List<AccountSetupStep> steps,
  ) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              _buildHeader(ref: ref),
              AccountSetup(
                title: 'Complete Your Account Setup',
                subtitle:
                    'You\'re almost there! Add your store details and payment info to start selling on WIGOMARKET.',
                steps: steps,
                progress: 0.4,
                isSeller: true,
                // optional; omit to compute automatically
                onCompletePressed: () {},
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
      ),
    );
  }

  Widget _buildWebLayout(
    Size screenSize,
    RiderDashboardViewModel viewModel,
    RiderDashboardState state,
    WidgetRef ref,
    List<AccountSetupStep> steps,
  ) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 35),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(ref: ref),
                const SizedBox(height: 10.0),
                AccountSetup(
                  title: 'Complete Your Account Setup',
                  subtitle:
                      'You\'re almost there! Add your store details and payment info to start selling on WIGOMARKET.',
                  steps: steps,
                  progress: 0.4,
                  // optional; omit to compute automatically
                  onCompletePressed: () {},
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
        CustomButton(
          text: 'Logout',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          onPressed: () {
            ref.read(authStateProvider.notifier).logout();
          },
        ),
      ],
    );
  }
}
