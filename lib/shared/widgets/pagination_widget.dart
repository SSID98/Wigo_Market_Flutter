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
    this.showPage = false,
  });

  final int totalPages, currentPage, count;
  final void Function()? onPressedStart,
      onPressedBack,
      onPressedForward,
      onPressedEnd;
  final bool isEarning, isDeliveries, showPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (count == 0) {
      return const SizedBox.shrink();
    }
    final state = ref.watch(walletOverviewTransactionProvider);
    final notifier = ref.read(walletOverviewTransactionProvider.notifier);
    final isWeb = MediaQuery.of(context).size.width > 800;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: isWeb ? 12 : 0),
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
                    fontSize: isWeb ? 16 : 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textEdufacilisBlack,
                  ),
                ),
                SizedBox(width: isWeb ? 15 : 7),
                Container(
                  height: 30,
                  width: 60,
                  // padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.borderColor1, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Current value
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 4.0,
                          right: 4.0,
                          top: 3,
                        ),
                        child: Text(
                          state.rowsPerPage.toString(),
                          style: GoogleFonts.hind(
                            fontSize: isWeb ? 16 : 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textEdufacilisBlack,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 9,
                              width: 13,
                              child: GestureDetector(
                                onTap:
                                    state.rowsPerPage < 10
                                        ? () => notifier.setRowsPerPage(
                                          state.rowsPerPage + 1,
                                        )
                                        : null,
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
                              child: GestureDetector(
                                onTap:
                                    state.rowsPerPage > 1
                                        ? () => notifier.setRowsPerPage(
                                          state.rowsPerPage - 1,
                                        )
                                        : null,
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
          if (isWeb && isEarning || showPage)
            Text(
              "Page $currentPage of $totalPages",
              style: GoogleFonts.hind(
                fontSize: isWeb ? 16 : 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textEdufacilisBlack,
              ),
            ),
          if ((isEarning && !isWeb && !showPage) || isDeliveries)
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
            isWeb ? 32 : 27,
          ),
          const SizedBox(width: 5),
          _buildPaginationIconContainer(
            onPressedBack,
            Icon(
              Icons.chevron_left,
              size: isWeb ? 18 : 12,
              color: AppColors.textBlackGrey,
            ),
            isWeb ? 32 : 27,
          ),
          const SizedBox(width: 5),
          _buildPaginationIconContainer(
            onPressedForward,
            Icon(
              Icons.chevron_right,
              size: isWeb ? 18 : 12,
              color: AppColors.textBlackGrey,
            ),
            isWeb ? 32 : 27,
          ),
          const SizedBox(width: 5),
          _buildPaginationIconContainer(
            onPressedEnd,
            AppAssets.icons.arrowsFoward.svg(
              height: isWeb ? 18 : 12,
              width: isWeb ? 18 : 12,
            ),
            isWeb ? 32 : 27,
          ),
          const SizedBox(width: 5),
          if ((isEarning && !isWeb && !showPage) || isDeliveries)
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
