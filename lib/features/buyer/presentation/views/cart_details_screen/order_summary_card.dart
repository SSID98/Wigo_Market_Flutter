import 'dart:ui';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import '../../../../../core/utils/helper_methods.dart';
import '../../../../../core/utils/price_formatter.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../viewmodels/buyer_cart_viewmodel.dart';

class OrderSummaryCard extends ConsumerWidget {
  const OrderSummaryCard({
    super.key,
    this.isCustomerInfo = false,
    this.isCheckoutScreens = false,
    this.isFinalCheckout = false,
  });

  final bool isCustomerInfo;
  final bool isCheckoutScreens;
  final bool isFinalCheckout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    final subtotal = ref.watch(cartSubtotalProvider);
    const double deliveryFee = 0.0;
    const double discount = 0.0;
    final double total = subtotal + deliveryFee - discount;
    final canCheckout = subtotal > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w600,
            fontSize: isWeb ? 24 : 16,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 15),
        _summaryRow("Subtotal", formatPrice(subtotal), isWeb, isBlack: true),
        const SizedBox(height: 15),
        _summaryRow(
          "Delivery Fee",
          deliveryFee == 0 ? "---" : formatPrice(deliveryFee),
          isWeb,
        ),
        const SizedBox(height: 15),
        _summaryRow(
          "Discount",
          discount == 0 ? "---" : "₦$discount",
          isWeb,
          isDiscount: true,
        ),
        const SizedBox(height: 15),
        Container(
          decoration: DottedDecoration(
            shape: Shape.line,
            linePosition: LinePosition.bottom,
            color: AppColors.borderColor1,
            dash: const <int>[6, 6],
          ),
        ),
        const SizedBox(height: 20),
        _summaryRow("Total", formatPrice(total), isTotal: true, isWeb),
        const SizedBox(height: 20),
        if (!isCheckoutScreens)
          CustomButton(
            text: "Go to Checkout",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 50,
            width: isWeb ? 411 : double.infinity,
            onPressed:
                canCheckout
                    ? () async {
                      showLoadingDialog(context);
                      await Future.delayed(const Duration(seconds: 1));
                      if (!context.mounted) return;
                      Navigator.of(context, rootNavigator: true).pop();
                      context.push('/buyer/customerInfo');
                    }
                    : null,
            borderRadius: 16,
          ),
        if (isCheckoutScreens)
          CustomButton(
            text: "Make Payment",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 50,
            width: isWeb ? 411 : double.infinity,
            onPressed:
                isFinalCheckout
                    ? () async {
                      showLoadingDialog(context);
                      await Future.delayed(const Duration(seconds: 1));
                      if (!context.mounted) return;
                      Navigator.of(context, rootNavigator: true).pop();
                      try {
                        await ref
                            .read(cartProvider.notifier)
                            .processCheckout(ref);
                        if (context.mounted) {
                          _showDeliveryConfirmationDialog(context, isWeb);
                          Navigator.pop(context);
                          context.go('/buyerHomeScreen');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    }
                    : null,
            borderRadius: 16,
          ),
        const SizedBox(height: 40),
        if (isCustomerInfo)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'By proceeding, you are automatically accepting the ',
                  style: GoogleFonts.hind(
                    color: AppColors.textBlack,
                    fontSize: isWeb ? 16 : 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: GoogleFonts.hind(
                    color: AppColors.textVidaLocaGreen,
                    fontSize: isWeb ? 16 : 12,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        if (!isCustomerInfo)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppAssets.icons.securityCheck.svg(),
              SizedBox(width: 6),
              Text(
                "100% Secure Payment",
                style: GoogleFonts.hind(
                  color: AppColors.textBlackGrey,
                  fontWeight: FontWeight.w700,
                  fontSize: isWeb ? 14 : 12,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _summaryRow(
    String label,
    String value,
    bool isWeb, {
    bool isDiscount = false,
    bool isBlack = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.hind(
            fontSize:
                isTotal
                    ? isWeb
                        ? 20
                        : 16
                    : isWeb
                    ? 18
                    : 14,
            color:
                isTotal
                    ? AppColors.textBlack
                    : isBlack
                    ? AppColors.textNeutral950
                    : AppColors.textBodyText,
            fontWeight: isTotal ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.hind(
            fontSize:
                isTotal
                    ? isWeb
                        ? 20
                        : 16
                    : isWeb
                    ? 18
                    : 14,
            fontWeight: FontWeight.w600,
            color: isDiscount ? AppColors.textRed : AppColors.textBlack,
          ),
        ),
      ],
    );
  }

  Future<void> _showDeliveryConfirmationDialog(
    BuildContext context,
    bool isWeb,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 15),
            insetPadding: EdgeInsets.zero,
            iconPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: AppColors.backgroundWhite,
            titlePadding: EdgeInsets.zero,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 15),
                Padding(
                  padding: EdgeInsets.only(right: isWeb ? 0 : 25, top: 10),
                  child: GestureDetector(
                    child: const Icon(Icons.close),
                    onTap: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppAssets.icons.doubleTickSuccessful.svg(),
                  const SizedBox(height: 20),
                  Text(
                    "Delivery Confirmed",
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w700,
                      fontSize: isWeb ? 24 : 16,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Thank You For Shopping With Us, Check The Order Details Page For More Updates On The Product You Ordered.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w400,
                      fontSize: isWeb ? 16 : 12,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
