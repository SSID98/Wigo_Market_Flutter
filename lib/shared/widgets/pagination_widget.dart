import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/rider/viewmodels/wallet_overview_transaction_viewmodel.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../gen/assets.gen.dart';

class PaginationWidget extends ConsumerWidget {
  const PaginationWidget({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.count,
    required this.onPressedBack,
    required this.onPressedEnd,
    required this.onPressedForward,
    required this.onPressedStart,
    this.isDeliveries = false,
    this.isEarning = false,
  });

  final int totalPages, currentPage, count;
  final void Function()? onPressedStart,
      onPressedBack,
      onPressedForward,
      onPressedEnd;
  final bool isEarning, isDeliveries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (count == 0) {
      return const SizedBox.shrink();
    }
    final state = ref.watch(walletOverviewTransactionProvider);
    final notifier = ref.read(walletOverviewTransactionProvider.notifier);
    final isWeb = MediaQuery.of(context).size.width > 800;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12),
      child: Row(
        children: [
          if (isDeliveries)
            Text(
              "Page $currentPage of $totalPages",
              style: GoogleFonts.hind(
                fontSize: isWeb ? 16 : 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textEdufacilisBlack,
              ),
            ),
          if (isEarning)
            Row(
              children: [
                Text(
                  "Rows per page",
                  style: GoogleFonts.hind(
                    fontSize: isWeb ? 16 : 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textEdufacilisBlack,
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.borderColor1, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Current value
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          state.rowsPerPage.toString(),
                          style: GoogleFonts.hind(
                            fontSize: isWeb ? 16 : 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textEdufacilisBlack,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 9,
                              width: 13,
                              child: InkWell(
                                onTap:
                                    state.rowsPerPage < 10
                                        ? () => notifier.setRowsPerPage(
                                          state.rowsPerPage + 1,
                                        )
                                        : null,
                                borderRadius: BorderRadius.circular(4),
                                child: Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 16,
                                  color: AppColors.textBlackGrey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 9,
                              width: 13,
                              child: InkWell(
                                onTap:
                                    state.rowsPerPage > 1
                                        ? () => notifier.setRowsPerPage(
                                          state.rowsPerPage - 1,
                                        )
                                        : null,
                                borderRadius: BorderRadius.circular(4),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: AppColors.textBlackGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const Spacer(),
          if (isWeb && isEarning)
            Text(
              "Page $currentPage of $totalPages",
              style: GoogleFonts.hind(
                fontSize: isWeb ? 16 : 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textEdufacilisBlack,
              ),
            ),
          if ((isEarning && !isWeb) || isDeliveries)
            Text(
              '$currentPage',
              style: GoogleFonts.hind(
                fontSize: isWeb ? 16 : 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textEdufacilisBlack,
              ),
            ),
          const SizedBox(width: 5),
          _buildPaginationIconContainer(
            onPressedStart,
            AppAssets.icons.arrowsBack.svg(
              height: isWeb ? 18 : 12,
              width: isWeb ? 18 : 12,
            ),
            isWeb ? 32 : 22,
          ),
          const SizedBox(width: 5),
          _buildPaginationIconContainer(
            onPressedBack,
            Icon(
              Icons.chevron_left,
              size: isWeb ? 18 : 12,
              color: AppColors.textBlackGrey,
            ),
            isWeb ? 32 : 22,
          ),
          const SizedBox(width: 5),
          _buildPaginationIconContainer(
            onPressedForward,
            Icon(
              Icons.chevron_right,
              size: isWeb ? 18 : 12,
              color: AppColors.textBlackGrey,
            ),
            isWeb ? 32 : 22,
          ),
          const SizedBox(width: 5),
          _buildPaginationIconContainer(
            onPressedEnd,
            AppAssets.icons.arrowsFoward.svg(
              height: isWeb ? 18 : 12,
              width: isWeb ? 18 : 12,
            ),
            isWeb ? 32 : 22,
          ),
          const SizedBox(width: 5),
          if ((isEarning && !isWeb) || isDeliveries)
            Text(
              '$totalPages',
              style: GoogleFonts.hind(
                fontSize: isWeb ? 16 : 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textEdufacilisBlack,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaginationIconContainer(
    void Function()? onPressed,
    Widget icon,
    double size,
  ) {
    return Container(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.borderColor1, width: 1),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
