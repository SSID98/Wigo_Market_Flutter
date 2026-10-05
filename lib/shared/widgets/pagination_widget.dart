import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../gen/assets.gen.dart';

class PaginationWidget extends StatelessWidget {
  const PaginationWidget({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.count,
    required this.onPressedBack,
    required this.onPressedEnd,
    required this.onPressedForward,
    required this.onPressedStart,
    required this.onSelected,
    this.rowsPerPageOptions = const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    required this.rowsPerPage,
    this.isDeliveries = false,
    this.isEarning = false,
    this.showPage = false,
    required this.labelPerPage,
  });

  final int totalPages, currentPage, count;
  final void Function()? onPressedStart,
      onPressedBack,
      onPressedForward,
      onPressedEnd;
  final bool isEarning, isDeliveries, showPage;
  final Function(int) onSelected;
  final int rowsPerPage;
  final List<int> rowsPerPageOptions;
  final String labelPerPage;

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return const SizedBox.shrink();
    }
    final isWeb = context.isWeb;
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
                  labelPerPage,
                  style: GoogleFonts.hind(
                    fontSize: isWeb ? 16 : 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textEdufacilisBlack,
                  ),
                ),
                SizedBox(width: isWeb ? 15 : 7),
                InkWell(
                  onTap: () => _showRowsPerPagePicker(context, isWeb),
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: AppColors.borderColor1,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rowsPerPage.toString(),
                          style: GoogleFonts.hind(
                            fontSize: isWeb ? 16 : 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textEdufacilisBlack,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 18,
                          color: AppColors.textBlackGrey,
                        ),
                      ],
                    ),
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

  void _showRowsPerPagePicker(BuildContext context, bool isWeb) {
    final options = ({...rowsPerPageOptions, rowsPerPage}.toList()
      ..sort());
    int selectedValue = rowsPerPage;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.hind(color: AppColors.textBlackGrey),
                      ),
                    ),
                    Text(
                      'Select $labelPerPage',
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textEdufacilisBlack,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        onSelected(selectedValue);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Done',
                        style: GoogleFonts.hind(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDarkGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40.0,
                  scrollController: FixedExtentScrollController(
                    initialItem: options
                        .indexOf(rowsPerPage)
                        .clamp(0, options.length - 1),
                  ),
                  onSelectedItemChanged: (index) {
                    selectedValue = options[index];
                  },
                  children: options.map((val) {
                    return Center(
                      child: Text(
                        '$val',
                        style: GoogleFonts.hind(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textEdufacilisBlack,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaginationIconContainer(void Function()? onPressed,
      Widget icon,
      double size,) {
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
