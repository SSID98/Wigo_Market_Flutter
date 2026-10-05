import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_banner.dart';
import '../../viewmodels/order_details_viewmodel.dart';

Future<void> showContactCustomerDialog(
  BuildContext pageContext,
  WidgetRef ref, {
  required bool isWeb,
  required String orderId,
  required String orderNumber,
  required String customerName,
  required String customerPhone,
}) {
  final messageController = TextEditingController();
  bool isSending = false;

  return showDialog(
    context: pageContext,
    barrierDismissible: false,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (_, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppColors.backgroundWhite,
            titlePadding: const EdgeInsets.only(top: 16, left: 16),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Row(
              children: [
                AppAssets.icons.contactCusto.svg(),
                const SizedBox(width: 8),
                Text(
                  "Contact Customer",
                  style: GoogleFonts.hind(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.only(right: isWeb ? 0 : 25),
                  icon: const Icon(Icons.close),
                  onPressed: isSending
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 40,
            ),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 72,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _richRow(label: 'Customer', info: customerName),
                            if (isWeb)
                              _richRow(label: 'OrderID', info: orderNumber),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!isWeb)
                              _richRow(label: 'OrderID', info: orderNumber),
                            _richRow(label: 'Phone', info: customerPhone),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Need to clarify an order, delivery time, or product "
                    "issue? Send a message directly to the buyer.",
                    style: GoogleFonts.hind(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: messageController,
                    hintText: 'Type your message here...',
                    fillColor: AppColors.backgroundLight,
                    contentPadding: const EdgeInsets.all(16),
                    minLines: 6,
                    maxLines: 8,
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Cancel',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 48,
                          borderRadius: 6,
                          textColor: AppColors.textBlackGrey,
                          buttonColor: AppColors.backgroundLight,
                          width: double.infinity,
                          onPressed: () {
                            if (isSending) return;
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CustomButton(
                          text: isSending ? 'Sending...' : 'Send',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 48,
                          borderRadius: 6,
                          width: double.infinity,
                          prefixIcon: isSending
                              ? const SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: SpinKitDualRing(
                                    color: AppColors.accentWhite,
                                  ),
                                )
                              : null,
                          onPressed: () async {
                            if (isSending) return;
                            final message = messageController.text.trim();
                            if (message.isEmpty) return;
                            setState(() => isSending = true);
                            final error = await ref
                                .read(orderActionsProvider)
                                .contactCustomer(orderId, message);
                            if (!dialogContext.mounted) return;
                            Navigator.of(dialogContext).pop();
                            if (!pageContext.mounted) return;
                            if (error != null) {
                              showSuccessBanner(error, pageContext);
                            } else {
                              showSuccessBanner(
                                'Message sent to $customerName.',
                                pageContext,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _richRow({required String label, required String info}) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: '$label: ',
          style: GoogleFonts.hind(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlackGrey,
          ),
        ),
        TextSpan(
          text: info,
          style: GoogleFonts.hind(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textBlackGrey,
          ),
        ),
      ],
    ),
  );
}
