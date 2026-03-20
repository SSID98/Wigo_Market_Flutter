import 'package:flutter/material.dart';
import 'package:wigo_flutter/features/seller/models/seller_product_task_state.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/dashboard_widgets/status_chip.dart';

class ProductStatusContainer extends StatelessWidget {
  final SellerProductStatus productStatus;

  const ProductStatusContainer({super.key, required this.productStatus});

  @override
  Widget build(BuildContext context) {
    Color containerColor;
    Color textColor;

    switch (productStatus) {
      case SellerProductStatus.active:
        containerColor = AppColors.textStatusGreen.withValues(alpha: 0.15);
        textColor = AppColors.textStatusGreen;
        break;
      case SellerProductStatus.outOfStock:
        containerColor = AppColors.textRed.withValues(alpha: 0.15);
        textColor = AppColors.textRed;
      case SellerProductStatus.hidden:
        containerColor = Color(0xffE08D40).withValues(alpha: 0.15);
        textColor = Color(0xffE08D40);
      case SellerProductStatus.draft:
        containerColor = Color(0xff3463ED).withValues(alpha: 0.25);
        textColor = Color(0xff3463ED);
        break;
      default:
        // Default to a neutral style for unknown statuses
        containerColor = AppColors.textIconGrey.withValues(alpha: 0.1);
        textColor = AppColors.textBlackGrey;
    }
    return StatusChip(
      statusColor: textColor,
      containerColor: containerColor,
      status: productStatus.displayName,
      borderRadius: 4.5,
      topPadding: 1.5,
    );
  }
}
