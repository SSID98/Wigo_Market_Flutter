import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/dashboard_widgets/status_chip.dart';
import '../../models/order_task_state.dart';

class OrderStatusContainer extends StatelessWidget {
  final OrderFilter status;

  const OrderStatusContainer({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color containerColor;
    Color textColor;

    switch (status) {
      case OrderFilter.pending:
        containerColor = Color(0xffF5F593).withValues(alpha: 0.50);
        textColor = AppColors.textYellow;
        break;
      case OrderFilter.delivered:
        containerColor = AppColors.textStatusGreen.withValues(alpha: 0.15);
        textColor = AppColors.textStatusGreen;
        break;
      case OrderFilter.cancelled:
        containerColor = AppColors.textRed.withValues(alpha: 0.15);
        textColor = AppColors.textRed;
      case OrderFilter.preparing:
        containerColor = Color(0xffE08D40).withValues(alpha: 0.15);
        textColor = Color(0xffE08D40);
      case OrderFilter.pickUpReady:
        containerColor = Color(0xffBA29FF).withValues(alpha: 0.15);
        textColor = Color(0xffBA29FF);
      case OrderFilter.inTransit:
        containerColor = Color(0xff6226EF).withValues(alpha: 0.15);
        textColor = Color(0xff6226EF);
      case OrderFilter.confirmed:
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
      status: status.displayName,
      borderRadius: 4.5,
      topPadding: 1.5,
    );
  }
}
