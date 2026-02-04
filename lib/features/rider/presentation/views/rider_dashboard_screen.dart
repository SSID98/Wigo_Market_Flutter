import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/rider/models/rider_dashboard_state.dart';
import 'package:wigo_flutter/features/rider/presentation/widgets/dashboard_screen_widgets/earning_history_widget.dart';
import 'package:wigo_flutter/features/rider/presentation/widgets/switch.dart';
import 'package:wigo_flutter/features/rider/viewmodels/rider_dashboard_viewmodel.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../core/auth/auth_state_notifier.dart';
import '../../../../gen/assets.gen.dart';
import '../widgets/dashboard_screen_widgets/account_setup_status_widget.dart';
import '../widgets/dashboard_screen_widgets/current_location_widget.dart';
import '../widgets/dashboard_screen_widgets/earning_overview_widget.dart';
import '../widgets/dashboard_screen_widgets/recent_deliveries_widget.dart';

class RiderDashboardScreen extends ConsumerWidget {
  RiderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(riderDashboardViewModelProvider.notifier);
    final state = ref.watch(riderDashboardViewModelProvider);
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb
        ? _buildWebLayout(screenSize, viewModel, state, ref)
        : _buildMobileLayout(screenSize, viewModel, state, ref);
  }

  final steps = [
    AccountSetupStep(
      title: 'Payment \nInformation',
      iconAsset: AppAssets.icons.payInfo.svg(
        height: kIsWeb ? 42.76 : 30.12,
        width: kIsWeb ? 49 : 34.51,
      ),
      status: SetupStatus.pending,
      onTap: () {
        // navigate to payment info
      },
    ),
    AccountSetupStep(
      title: 'Vehicle \nDocuments',
      iconAsset: AppAssets.icons.vehicleDoc.svg(
        height: kIsWeb ? 42.76 : 30.12,
        width: kIsWeb ? 49 : 34.51,
      ),
      status: SetupStatus.completed,
      onTap: () {
        // navigate to vehicle docs
      },
    ),
  ];

  Widget _buildMobileLayout(
    Size screenSize,
    RiderDashboardViewModel viewModel,
    RiderDashboardState state,
    WidgetRef ref,
  ) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              _buildHeader(
                titleFontSize: 16.0,
                descriptionFontSize: 12.0,
                availabilityFontSize: 16,
                switchHeight: 16.0,
                switchWidth: 31.0,
                thumbDiameter: 12,
                viewModel: viewModel,
                state: state,
                ref: ref,
              ),
              AccountSetup(
                title: 'Complete Your Account Setup',
                subtitle:
                    'Just one more step! Complete your rider profile and start accepting delivery requests today',
                steps: steps,
                progress: 0.4,
                // optional; omit to compute automatically
                onCompletePressed: () {},
                isWeb: false,
              ),
              EarningOverviewWidget(),
              RecentDeliveriesWidget(),
              CurrentLocationWidget(),
              EarningHistoryWidget(),
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
                _buildHeader(
                  titleFontSize: 20.0,
                  descriptionFontSize: 24.0,
                  availabilityFontSize: 24,
                  viewModel: viewModel,
                  switchHeight: 26.0,
                  switchWidth: 49.0,
                  thumbDiameter: 20.0,
                  state: state,
                  ref: ref,
                ),
                const SizedBox(height: 10.0),
                AccountSetup(
                  title: 'Complete Your Account Setup',
                  subtitle:
                      'Just one more step! Complete your rider profile and start accepting delivery requests today',
                  steps: steps,
                  progress: 0.4,
                  // optional; omit to compute automatically
                  onCompletePressed: () {},
                  isWeb: true,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          EarningOverviewWidget(),
                          RecentDeliveriesWidget(),
                          CurrentLocationWidget(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(child: EarningHistoryWidget()),
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

  Widget _buildHeader({
    required double titleFontSize,
    required double descriptionFontSize,
    required double availabilityFontSize,
    required double switchHeight,
    required double switchWidth,
    required double thumbDiameter,
    required RiderDashboardViewModel viewModel,
    required RiderDashboardState state,
    required WidgetRef ref,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, Emmanuel',
          style: GoogleFonts.hind(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 5.0),
        CustomButton(
          text: 'Logout',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          onPressed: () {
            ref.read(authStateProvider.notifier).logout();
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ready to deliver today?',
              style: GoogleFonts.hind(
                fontSize: descriptionFontSize,
                fontWeight: FontWeight.w400,
                color: AppColors.textBlackGrey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 7.0),
              child: Row(
                children: [
                  Text(
                    'Availability',
                    style: GoogleFonts.hind(
                      fontSize: availabilityFontSize,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  CustomSwitch(
                    value: state.isAvailable,
                    onChanged: viewModel.toggleSwitch,
                    thumbColour: AppColors.accentWhite,
                    activeColor: AppColors.switchGreen,
                    inactiveColor: AppColors.accentGrey,
                    height: switchHeight,
                    width: switchWidth,
                    thumbDiameter: thumbDiameter,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
