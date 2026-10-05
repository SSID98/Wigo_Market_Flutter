import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/custom_banner.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../models/allowed_action_model.dart';
import '../../../models/order_enums.dart';
import '../../../viewmodels/order_details_viewmodel.dart';

Future<void> handleStatusSelection(
  BuildContext context,
  WidgetRef ref, {
  required String orderId,
  required AllowedAction action,
}) async {
  String? reason;
  if (action.status == OrderFilter.cancelled) {
    reason = await showCancelReasonDialog(context);
    if (reason == null) return;
  }

  final error = await ref
      .read(orderActionsProvider)
      .updateStatus(orderId, action.status, reason: reason);

  if (!context.mounted) return;
  if (error != null) {
    showErrorBanner(error, context);
  }
  if (error == null) {
    showSuccessBanner('Order status updated to ${action.label}.', context);
  }
}

Future<String?> showCancelReasonDialog(BuildContext context) {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.backgroundWhite,
        title: Text(
          'Cancel this order?',
          style: GoogleFonts.hind(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlackGrey,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Let the buyer know why - this is required.',
              style: GoogleFonts.hind(
                fontSize: 14,
                color: AppColors.textBodyText,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'e.g. Item out of stock',
                filled: true,
                fillColor: AppColors.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Back',
              style: GoogleFonts.hind(color: AppColors.textBodyText),
            ),
          ),
          TextButton(
            onPressed: () {
              final reason = controller.text.trim();
              if (reason.isEmpty) return;
              Navigator.of(dialogContext).pop(reason);
            },
            child: Text(
              'Cancel Order',
              style: GoogleFonts.hind(
                color: AppColors.textRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}
