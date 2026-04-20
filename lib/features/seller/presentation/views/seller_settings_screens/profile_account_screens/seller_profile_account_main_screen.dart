import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/presentation/views/seller_settings_screens/profile_account_screens/seller_business_details_screen.dart';
import 'package:wigo_flutter/features/seller/presentation/views/seller_settings_screens/profile_account_screens/seller_payment_details_screen.dart';
import 'package:wigo_flutter/features/seller/presentation/views/seller_settings_screens/profile_account_screens/seller_personal_details_screen.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/context_extensions.dart';
import '../../../../../../gen/assets.gen.dart';

enum ProfileScreenState { personal, business, payout }

final settingsTabProvider = StateProvider<ProfileScreenState>(
  (ref) => ProfileScreenState.personal,
);

class SellerProfileAccountMainScreen extends ConsumerWidget {
  const SellerProfileAccountMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(settingsTabProvider);

    return Scaffold(
      appBar: context.isWeb
          ? null
          : AppBar(
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: AppAssets.icons.backCircleArrow.svg(),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: context.width * 0.24),
                      Text(
                        "Profile & Account",
                        style: GoogleFonts.hind(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlackGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              surfaceTintColor: Colors.transparent,
              backgroundColor: AppColors.backgroundWhite,
              automaticallyImplyLeading: false,
            ),
      backgroundColor: context.isWeb
          ? AppColors.backgroundLight
          : AppColors.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: context.isWeb
            ? Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    margin: EdgeInsets.only(bottom: 20, top: 20),
                    shadowColor: Colors.white70.withValues(alpha: 0.06),
                    color: AppColors.backgroundWhite,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildHeader(context, ref),
                          const SizedBox(height: 20),
                          _buildBody(activeTab),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Column(
                children: [
                  const SizedBox(height: 25),
                  _buildHeader(context, ref),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(child: _buildBody(activeTab)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.isWeb ? 40 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (context.isWeb) ...[
            Text(
              "Profile & Account",
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 8),
          ],
          _buildFilterBar(context.isWeb, ref, context),
        ],
      ),
    );
  }

  Widget _buildFilterBar(bool isWeb, WidgetRef ref, BuildContext context) {
    final activeTab = ref.watch(settingsTabProvider);
    return Container(
      color: AppColors.backgroundLight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTabButton(
              ref,
              isWeb ? "Personal Details" : "Personal",
              ProfileScreenState.personal,
              activeTab,
              isWeb,
            ),
            _buildTabButton(
              ref,
              isWeb ? "Business/Shop Details" : "Business/Shop",
              ProfileScreenState.business,
              activeTab,
              isWeb,
            ),
            _buildTabButton(
              ref,
              isWeb ? "Payout Details" : "Payout",
              ProfileScreenState.payout,
              activeTab,
              isWeb,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(
    WidgetRef ref,
    String label,
    ProfileScreenState tab,
    ProfileScreenState activeTab,
    bool isWeb,
  ) {
    final isSelected = tab == activeTab;
    return Expanded(
      child: SizedBox(
        height: 34,
        child: GestureDetector(
          onTap: () => ref.read(settingsTabProvider.notifier).state = tab,
          child: Container(
            color: isSelected
                ? AppColors.primaryLightGreen
                : Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              textAlign: TextAlign.center,
              label,
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.textDarkDarkerGreen,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ProfileScreenState state) {
    switch (state) {
      case ProfileScreenState.personal:
        return SellerPersonalDetailsScreen();
      case ProfileScreenState.business:
        return SellerBusinessDetailsScreen();
      case ProfileScreenState.payout:
        return SellerPaymentDetailsScreen();
    }
  }
}
