import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/dashboard_widgets/delivery_table.dart';
import '../../../viewmodels/rider_dashboard_viewmodel.dart';

class RecentDeliveriesWidget extends ConsumerWidget {
  const RecentDeliveriesWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    final dashboardState = ref.watch(riderDashboardViewModelProvider);

    return dashboardState.recentDeliveries.when(
      data: (deliveries) {
        final double cardHeight =
            deliveries.isEmpty
                ? isWeb
                    ? 291
                    : 277.0
                : isWeb
                ? 290
                : 336.0;
        return ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(10),
          child: SizedBox(
            height: cardHeight,
            width: double.infinity,
            child: Card(
              shadowColor: Colors.white70.withValues(alpha: 0.06),
              color: AppColors.backgroundWhite,
              elevation: 1,
              margin: EdgeInsets.only(top: isWeb ? 18 : 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (deliveries.isEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16, 0),
                      child: Text(
                        "Recent Deliveries",
                        style: GoogleFonts.hind(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: AppColors.textBlackGrey,
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        top: 16.0,
                        bottom: 9,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Recent Deliveries",
                                style: GoogleFonts.hind(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: AppColors.textBlackGrey,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  "View all",
                                  style: GoogleFonts.hind(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        color: AppColors.textOrange,
                                        offset: Offset(0, -2),
                                      ),
                                    ],
                                    color: Colors.transparent,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.textOrange,
                                    decorationThickness: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "Manage recent deliveries faster, stay organized, and keep earning.",
                            style: GoogleFonts.hind(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.textBlackGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (deliveries.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 350 : 40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppAssets.icons.recentDeliveries.svg(),
                          const SizedBox(height: 10.0),
                          Text(
                            "No Active Deliveries yet",
                            style: GoogleFonts.hind(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: AppColors.textBlackGrey,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Your recent deliveries will show up here once you start accepting orders. Stay ready, opportunities are always around the corner!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.hind(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.textBodyText,
                            ),
                          ),
                          const SizedBox(height: 25.0),
                          CustomButton(
                            text: 'View Active Deliveries',
                            onPressed: () {},
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            height: 36.0,
                            padding: EdgeInsets.zero,
                            width: 251,
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: ListView(
                        children: [
                          Center(child: DeliveryTable(deliveries: deliveries)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}
