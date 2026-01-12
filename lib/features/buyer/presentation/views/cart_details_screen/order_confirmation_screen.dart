// cart_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/helper_methods.dart';
import '../../../../../gen/assets.gen.dart';
import 'order_summary_card.dart';

class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    bool isHandlingBack = false;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (isHandlingBack || didPop) return;
        isHandlingBack = true;
        showLoadingDialog(context);
        await Future.delayed(const Duration(seconds: 1));
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pop(result);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child:
            isWeb
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: OrderConfirmationDetails()),
                    const SizedBox(width: 30),
                    Expanded(
                      flex: 2,
                      child: OrderSummaryCard(
                        isFinalCheckout: true,
                        isCustomerInfo: true,
                        isCheckoutScreens: true,
                      ),
                    ),
                  ],
                )
                : Column(
                  children: [
                    OrderConfirmationDetails(),
                    const SizedBox(height: 30),
                    OrderSummaryCard(
                      isFinalCheckout: true,
                      isCheckoutScreens: true,
                      isCustomerInfo: true,
                    ),
                  ],
                ),
      ),
    );
  }
}

class OrderConfirmationDetails extends ConsumerWidget {
  const OrderConfirmationDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _iconTextRow(isWeb, onTap: () {}, text: "Back"),
            SizedBox(height: 20),
            _titleRow(isWeb, "Customer Information", () async {showLoadingDialog(context);
            await Future.delayed(const Duration(seconds: 1));
            if (!context.mounted) return;
            Navigator.of(context, rootNavigator: true).pop();
            context.push('/buyer/customerInfo');} ),
          ],
        ),
        SizedBox(height: 20),
        _textSpan('Name', 'Rosaline Uche', isWeb),
        SizedBox(height: 15),
        _textSpan(
          'Address',
          '11, New Rosaline Lane, Off Nova Road, Benin City',
          isWeb,
        ),
        SizedBox(height: 15),
        _textSpan('Contact', '0812300000', isWeb),
        const SizedBox(height: 30),
        _titleRow(isWeb, "Delivery Details", () async {
        showLoadingDialog(context);
        await Future.delayed(const Duration(seconds: 1));
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        context.push('/buyer/deliveryDetails');
        }),
        const SizedBox(height: 20),
        Text(
          "WiGo Rider",
          style: GoogleFonts.hind(
            fontSize: isWeb ? 20 : 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 30),
        _titleRow(isWeb, 'Payment Type', () async {
          showLoadingDialog(context);
          await Future.delayed(const Duration(seconds: 1));
          if (!context.mounted) return;
          Navigator.of(context, rootNavigator: true).pop();
          context.push('/buyer/deliveryDetails');
        } ),
        const SizedBox(height: 20),
        Text(
          "Cash on Delivery",
          style: GoogleFonts.hind(
            fontSize: isWeb ? 20 : 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlackGrey,
          ),
        ),
      ],
    );
  }

  Widget _iconTextRow(
    bool isWeb, {
    bool isDelivery = false,
    void Function()? onTap,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          isDelivery
              ? AppAssets.icons.checkmarkCircle.svg()
              : Icon(
                Icons.keyboard_arrow_left_rounded,
                size: isWeb ? 24 : 18,
                color: AppColors.primaryDarkGreen,
              ),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.hind(
              fontSize: isWeb ? 24 : 18,
              fontWeight: isDelivery ? FontWeight.w600 : FontWeight.w400,
              color:
                  isDelivery
                      ? AppColors.textBlack
                      : AppColors.textVidaLocaGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textSpan(String title, String subTitle, bool isWeb) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title: ',
            style: GoogleFonts.hind(
              fontSize: isWeb ? 18 : 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlackGrey,
            ),
          ),
          TextSpan(
            text: subTitle,
            style: GoogleFonts.hind(
              fontSize: isWeb ? 18 : 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlackGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleRow(bool isWeb, String text, void Function()? onTap) {
    return Row(
      mainAxisAlignment:
          isWeb ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
      children: [
        _iconTextRow(isWeb, isDelivery: true, text: text),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'Change',
            style: GoogleFonts.hind(
              fontSize: isWeb ? 18 : 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textVidaLocaGreen,
            ),
          ),
        ),
      ],
    );
  }
}