import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/dashboard_helpers.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';
import 'package:wigo_flutter/shared/widgets/dashboard_widgets/status_chip.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../viewmodels/rider_dashboard_viewmodel.dart';

class EarningHistoryWidget extends ConsumerWidget {
  const EarningHistoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(riderDashboardViewModelProvider);
    final isWeb = MediaQuery.of(context).size.width > 600;
    return dashboardState.earningHistory.when(
      data: (transactions) {
        final double cardHeight = transactions.isEmpty
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
                      "Earning History",
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
                            "No transactions yet.",
                            style: GoogleFonts.hind(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: AppColors.textBlackGrey,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isWeb ? 20.0 : 0,
                            ),
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
                          final displayDate = trx.deliveredAt ?? trx.date;
                          final leadingIcon = trx.isDelivered
                              ? AppAssets.icons.received.svg(
                                  height: 35,
                                  width: 35,
                                )
                              : trx.isCancelled
                              ? AppAssets.icons.rejected.svg(
                                  height: 35,
                                  width: 35,
                                )
                              : AppAssets.icons.pending.svg(
                                  height: 35,
                                  width: 35,
                                );

                          final title = trx.isDelivered
                              ? 'Received'
                              : trx.isCancelled
                              ? 'Cancelled'
                              : trx.status;

                          final chipColor = trx.isDelivered
                              ? AppColors.textStatusGreen
                              : trx.isCancelled
                              ? AppColors.textRed
                              : AppColors.textYellow;

                          final chipLabel = trx.isDelivered
                              ? 'Successful'
                              : trx.isCancelled
                              ? 'Cancelled'
                              : trx.status;
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            elevation: 8,
                            color: AppColors.backgroundWhite,
                            shadowColor: AppColors.shadowColor.withValues(
                              alpha: 0.23,
                            ),
                            child: ListTile(
                              horizontalTitleGap: 10,
                              leading: leadingIcon,
                              title: Text(
                                title,
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
                                    displayDate != null
                                        ? formatDateWithTime(displayDate)
                                        : '—',
                                    style: GoogleFonts.hind(
                                      fontSize: 12,
                                      color: AppColors.textIconGrey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
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
                                    statusColor: chipColor,
                                    containerColor: chipColor.withValues(
                                      alpha: 0.1,
                                    ),
                                    status: chipLabel,
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
      loading: () => const Center(
        child: SpinKitDualRing(color: AppColors.primaryDarkGreen),
      ),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}
