import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/dashboard_helpers.dart';
import 'package:wigo_flutter/features/seller/viewmodels/seller_dashboard_viewmodel.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';
import 'package:wigo_flutter/shared/widgets/dashboard_widgets/status_chip.dart';

import '../../../../../core/constants/app_colors.dart';

class RecentEarningsWidget extends ConsumerWidget {
  const RecentEarningsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(sellerDashboardViewModelProvider);
    final isWeb = MediaQuery.of(context).size.width > 600;
    return dashboardState.recentEarnings.when(
      data: (transactions) {
        final double cardHeight =
            transactions.isEmpty
                ? isWeb
                    ? 893
                    : 353.0
                : isWeb
                ? 893
                : 419.0;
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: cardHeight,
            child: Card(
              shadowColor: Colors.white70.withValues(alpha: 0.06),
              color: AppColors.backgroundWhite,
              elevation: 1,
              margin: EdgeInsets.only(top: isWeb ? 18 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      "Recent Earning",
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                  ),

                  if (transactions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppAssets.icons.earningHistory.svg(),
                          const SizedBox(height: 5),
                          AppAssets.icons.ellipse.svg(),
                          const SizedBox(height: 23.0),
                          Text(
                            "No Earning yet.",
                            style: GoogleFonts.hind(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: AppColors.textBlackGrey,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Once you start selling or receive your first payout, your transaction history will show up here.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.hind(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppColors.textBodyText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final trx = transactions[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 8,
                            color: AppColors.backgroundWhite,
                            shadowColor: AppColors.shadowColor.withValues(
                              alpha: 0.23,
                            ),
                            child: ListTile(
                              horizontalTitleGap: 10,
                              leading: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLightGreen,
                                  borderRadius: BorderRadius.circular(29.87),
                                ),
                                child: Center(
                                  child: AppAssets.icons.totalSale.svg(
                                    colorFilter: ColorFilter.mode(
                                      AppColors.primaryDarkGreen,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              // trx.status == "Received"
                              //     ? AppAssets.icons.received.svg(
                              //       height: 35,
                              //       width: 35,
                              //     )
                              //     : trx.status == "Pending"
                              //     ? AppAssets.icons.pending.svg(
                              //       height: 35,
                              //       width: 35,
                              //     )
                              //     : AppAssets.icons.rejected.svg(
                              //       height: 35,
                              //       width: 35,
                              //     ),
                              title: Text(
                                'Sales',
                                style: GoogleFonts.hind(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textBlackGrey,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(
                                    formatDateWithTime(trx.date),
                                    style: GoogleFonts.hind(
                                      fontSize: 12,
                                      color: AppColors.textIconGrey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  Text(
                                    formatAmount(trx.amount),
                                    style: GoogleFonts.notoSans(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textBlackGrey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: isWeb ? 4 : 10),
                                  StatusChip(
                                    width: 80,
                                    alignment: Alignment.center,
                                    statusColor:
                                        trx.status == "Received"
                                            ? AppColors.textStatusGreen
                                            : trx.status == "Pending"
                                            ? AppColors.textYellow
                                            : AppColors.textRed,
                                    containerColor:
                                        trx.status == "Received"
                                            ? AppColors.textStatusGreen
                                                .withValues(alpha: 0.1)
                                            : trx.status == "Pending"
                                            ? AppColors.textYellow.withValues(
                                              alpha: 0.1,
                                            )
                                            : AppColors.textRed.withValues(
                                              alpha: 0.1,
                                            ),
                                    status:
                                        trx.status == "Received"
                                            ? 'Successful'
                                            : trx.status,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
