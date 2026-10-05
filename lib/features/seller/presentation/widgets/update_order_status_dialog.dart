import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../models/allowed_action_model.dart';
import '../../models/order_enums.dart';
import 'order_details_widgets/order_status_actions.dart';

class UpdateOrderStatusDialog extends ConsumerWidget {
  const UpdateOrderStatusDialog({
    super.key,
    required this.pageContext,
    required this.orderId,
    required this.currentStatusLabel,
    required this.allowedActions,
  });

  final BuildContext pageContext;
  final String orderId;
  final String currentStatusLabel;
  final List<AllowedAction> allowedActions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: AppColors.backgroundWhite,
      title: Text(
        'Update Order Status',
        style: GoogleFonts.hind(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlackGrey,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current status: $currentStatusLabel',
            style: GoogleFonts.hind(
              fontSize: 14,
              color: AppColors.textBodyText,
            ),
          ),
          const SizedBox(height: 16),
          if (allowedActions.isEmpty)
            Text(
              'No further status changes are available for this order.',
              style: GoogleFonts.hind(
                fontSize: 14,
                color: AppColors.textBodyText,
              ),
            )
          else
            ...allowedActions.map(
              (action) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: action.label,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 42,
                    borderRadius: 6,
                    textColor: action.status == OrderFilter.cancelled
                        ? AppColors.textRed
                        : AppColors.textWhite,
                    buttonColor: action.status == OrderFilter.cancelled
                        ? AppColors.backgroundLight
                        : AppColors.primaryDarkGreen,
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await handleStatusSelection(
                        pageContext,
                        ref,
                        orderId: orderId,
                        action: action,
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Close',
            style: GoogleFonts.hind(color: AppColors.textBodyText),
          ),
        ),
      ],
    );
  }
}
