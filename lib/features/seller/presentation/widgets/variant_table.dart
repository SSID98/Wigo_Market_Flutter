import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/viewmodels/mulitple_products_viewmodel.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_checkbox_2.dart';

class VariantTable extends ConsumerWidget {
  const VariantTable({super.key});

  TextStyle _getStyle({required bool isHeader, required Color color}) {
    return GoogleFonts.hind(
      fontSize: isHeader ? 16 : 14,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    final state = ref.watch(multipleProductsProvider);
    final vm = ref.read(multipleProductsProvider.notifier);
    final variants = state.variants;
    final allSelected = state.selectAll;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          // Header Row
          Container(
            height: 50,
            decoration: BoxDecoration(color: AppColors.backgroundLight),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CustomCheckbox2(
                    value: allSelected,
                    onChanged: (val) => vm.toggleSelectAll(val),
                    borderRadius: 2,
                    size: 16,
                    checkSize: 10,
                    borderColor: allSelected
                        ? AppColors.primaryDarkGreen
                        : AppColors.borderColor,
                    checkColor: AppColors.primaryDarkGreen,
                  ),
                ),
                SizedBox(
                  width: isWeb ? 180.0 : 130.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Color",
                      style: _getStyle(
                        isHeader: true,
                        color: AppColors.textBlackGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(
                  width: isWeb ? 180.0 : 130.0,
                  child: Text(
                    "Size",
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: isWeb ? 200.0 : 150.0,
                  child: Text(
                    "Price",
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: isWeb ? 200.0 : 150.0,
                  child: Text(
                    "Stock Qty",
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: isWeb ? 130.0 : 100.0,
                  child: Center(
                    child: SizedBox(
                      width: isWeb ? 80 : 50,
                      child: Text(
                        "SKU",
                        style: _getStyle(
                          isHeader: true,
                          color: AppColors.textBlackGrey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Data Rows
          ...variants.asMap().entries.map((entry) {
            int idx = entry.key;
            var v = entry.value;
            return Container(
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.textIconGrey.withValues(alpha: 0.2),
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: CustomCheckbox2(
                      value: v.isSelected,
                      onChanged: (_) => vm.toggleSelection(idx),
                      borderRadius: 2,
                      size: 16,
                      checkSize: 10,
                      borderColor: v.isSelected
                          ? AppColors.primaryDarkGreen
                          : AppColors.borderColor,
                      checkColor: AppColors.primaryDarkGreen,
                    ),
                  ),
                  SizedBox(
                    width: isWeb ? 180.0 : 130.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Color(
                                int.parse(v.colorHex.replaceFirst('#', '0xFF')),
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            v.colorName,
                            style: _getStyle(
                              isHeader: false,
                              color: AppColors.textBodyText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: isWeb ? 180.0 : 130.0,
                    child: Text(
                      v.size,
                      style: _getStyle(
                        isHeader: false,
                        color: AppColors.textBodyText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: isWeb ? 200.0 : 150.0,
                    child: Text(
                      v.price,
                      style: _getStyle(
                        isHeader: false,
                        color: AppColors.textBodyText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: isWeb ? 200.0 : 150.0,
                    child: Text(
                      v.stock,
                      style: _getStyle(
                        isHeader: false,
                        color: AppColors.textBodyText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: isWeb ? 0 : 20.0),
                    child: SizedBox(
                      width: isWeb ? 130.0 : 80.0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          v.sku,
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textBodyText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
