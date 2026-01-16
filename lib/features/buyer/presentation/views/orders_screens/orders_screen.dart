import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/buyer/presentation/widgets/self_delivery_card.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/helper_methods.dart';
import '../../../viewmodels/order_viewmodel.dart';
import '../../widgets/order_card.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final notifier = ref.read(ordersProvider.notifier);
    bool isHandlingBack = false;
    final isWeb = MediaQuery.of(context).size.width > 600;

    if (!notifier.isInitialized && orders.isEmpty) {
      return Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                color: AppColors.primaryDarkGreen,
                strokeWidth: 8,
              ),
            ),
          ),
        ),
      );
    }

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
        child:
            orders.isEmpty
                ? const Center(child: Text("You haven't made any orders yet."))
                : Column(
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
                      text: "Back",
                    ),
                    SizedBox(height: 20),
                    _iconTextRow(isWeb, text: "Your Orders", isDelivery: true),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            OrderCard(order: orders[index]),
                            Divider(),
                          ],
                        );
                      },
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
    bool isDelivery = false,
    void Function()? onTap,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          isDelivery
              ? SizedBox.shrink()
              : Icon(
                Icons.keyboard_arrow_left_rounded,
                size: isWeb ? 30 : 18,
                color: AppColors.primaryDarkGreen,
              ),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.hind(
              fontSize: isWeb ? 30 : 18,
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
}
