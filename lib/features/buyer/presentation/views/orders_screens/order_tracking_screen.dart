// cart_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/buyer/presentation/widgets/self_delivery_card.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/helper_methods.dart';
import '../../../../../gen/assets.gen.dart';
import '../../widgets/order_status_step.dart';

class OrdersTrackingScreen extends ConsumerWidget {
  final String productName;

  const OrdersTrackingScreen({super.key, required this.productName});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _iconTextRow(
                    isWeb,
                    onTap: () async {
                      showLoadingDialog(context);
                      await Future.delayed(const Duration(seconds: 1));
                      if (!context.mounted) return;
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(height: 20),
                  _iconTextRow(isWeb, isCustomer: true),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Product: $productName',
              style: GoogleFonts.hind(
                fontSize: isWeb ? 18 : 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Seller: TrendyFoots NG',
              style: GoogleFonts.hind(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primaryDarkGreen,
                color: AppColors.primaryDarkGreen,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Estimated Delivery:  August 15 – August 19, 2025',
              style: GoogleFonts.hind(
                fontSize: isWeb ? 18 : 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Order Status Timeline',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w700,
                color: AppColors.textBlack,
                fontSize: isWeb ? 20 : 15,
              ),
            ),
            const SizedBox(height: 20),
            OrderStatusStep(
              title: 'Order Placed',
              date: 'Monday, 04-08',
              subtitle:
                  'We\'ve Received Your Order, Kindly Wait For Confirmation',
              isCompleted: true,
            ),
            OrderStatusStep(
              title: 'Order Confirmed',
              date: 'Monday, 04-08',
              subtitle:
                  'Your Order Has Been Received. Seller Has Been Notified And Payment Is Securely Held.',
              isCompleted: true,
            ),
            OrderStatusStep(
              title: 'Out For Delivery',
              date: 'Pending Pickup And Dispatch By The Courier.',
              isCompleted: true,
              dashCount: 6,
            ),
            OrderStatusStep(
              title: 'Delivered',
              isCompleted: false,
              isLast: true,
            ),
            const SizedBox(height: 150),
            SelfDeliveryPromoCard(),
          ],
        ),
      ),
    );
  }

  Widget _iconTextRow(
    bool isWeb, {
    bool isCustomer = false,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          isCustomer
              ? AppAssets.icons.checkmarkCircle.svg()
              : Icon(
                Icons.keyboard_arrow_left_rounded,
                size: isWeb ? 24 : 18,
                color: AppColors.primaryDarkGreen,
              ),
          const SizedBox(width: 4),
          Text(
            isCustomer ? "Product Details" : "Back",
            style: GoogleFonts.hind(
              fontSize: isWeb ? 24 : 18,
              fontWeight: isCustomer ? FontWeight.w600 : FontWeight.w400,
              color:
                  isCustomer
                      ? AppColors.textBlack
                      : AppColors.textVidaLocaGreen,
            ),
          ),
        ],
      ),
    );
  }
}
