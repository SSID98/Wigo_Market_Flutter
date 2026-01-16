import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/buyer/presentation/widgets/interactive_rating_bar_widget.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helper_methods.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../viewmodels/order_viewmodel.dart';

class OrderCard extends ConsumerWidget {
  final OrderItemModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb
        ? _buildWebLayout(isWeb, context)
        : _buildMobileLayout(isWeb, context);
  }

  Widget _buildWebLayout(bool isWeb, BuildContext context) {
    return Row(
      children: [
        _imageSection(124),
        const SizedBox(width: 5),
        Expanded(child: _itemDetails(isWeb)),
        const SizedBox(width: 5),
        Expanded(child: _itemPrice(isWeb)),
        const SizedBox(width: 5),
        Expanded(child: _itemDetails(isWeb, isStatus: true)),
        const SizedBox(width: 5),
        Expanded(child: _itemPrice(isWeb, isDelivery: true)),
        const SizedBox(width: 5),
        _trackButton(isWeb, context),
      ],
    );
  }

  Widget _buildMobileLayout(bool isWeb, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageSection(104),
            const SizedBox(height: 10),
            _itemPrice(isWeb),
            const SizedBox(height: 10),
            _itemPrice(isWeb, isDelivery: true),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _itemDetails(isWeb),
              const SizedBox(height: 15),
              _itemDetails(isWeb, isStatus: true),
              const SizedBox(height: 25),
              _trackButton(isWeb, context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imageSection(double size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        order.imageUrl,
        height: size,
        width: size,
        errorBuilder: (
          BuildContext context,
          Object exception,
          StackTrace? stackTrace,
        ) {
          return const Center(
            child: Icon(
              Icons.broken_image,
              color: AppColors.textIconGrey,
              size: 50.0,
            ),
          );
        },
      ),
    );
  }

  Widget _itemDetails(bool isWeb, {bool isStatus = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          isStatus ? 'Status' : order.productName,
          style: GoogleFonts.hind(
            fontSize:
                isStatus
                    ? isWeb
                        ? 18
                        : 14
                    : isWeb
                    ? 20
                    : 16,
            fontWeight: isStatus ? FontWeight.w500 : FontWeight.w400,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: isStatus ? 10 : 15),
        if (!isStatus)
          Text(
            '|  ${order.size}  |  ${order.colorName}',
            style: GoogleFonts.hind(
              fontSize: isWeb ? 16 : 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textBodyText,
            ),
          ),
        if (isStatus)
          Container(
            height: isWeb ? 36 : 27,
            width: isWeb ? 134 : 94,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.backgroundLightPink,
              borderRadius: BorderRadius.circular(62),
            ),
            child: Center(
              child: Text(
                order.status,
                style: GoogleFonts.hind(
                  fontSize: isWeb ? 16 : 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textBlack,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _itemPrice(bool isWeb, {bool isDelivery = false}) {
    return Column(
      crossAxisAlignment:
          isDelivery ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          isDelivery ? 'Expected Delivery' : formatPrice(order.price),
          style: GoogleFonts.hind(
            fontSize: isWeb ? 20 : 16,
            fontWeight: isDelivery ? FontWeight.w500 : FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          isDelivery ? '12 April - 14 April 2025' : 'Qty: ${order.quantity}',
          style: GoogleFonts.hind(
            fontSize: isWeb ? 16 : 12,
            fontWeight: isDelivery ? FontWeight.w500 : FontWeight.w400,
            color: AppColors.textIconGrey,
          ),
        ),
      ],
    );
  }

  Widget _trackButton(bool isWeb, BuildContext context) {
    return CustomButton(
      text: 'Track Order',
      fontSize: isWeb ? 16 : 12,
      fontWeight: FontWeight.w400,
      borderRadius: isWeb ? 16 : 8,
      height: isWeb ? 50 : 35,
      width: isWeb ? 144 : 123,
      onPressed: () async {
        showLoadingDialog(context);
        await Future.delayed(const Duration(seconds: 1));
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        context.push(
          '/buyer/trackOrder',
          extra: {'productName': order.productName},
        );
      },
    );
  }

  Widget _ratingButton(bool isWeb, BuildContext context, WidgetRef ref) {
    return CustomButton(
      text: 'Rate Product',
      prefixIcon: AppAssets.icons.greenStar.svg(),
      fontSize: isWeb ? 16 : 12,
      fontWeight: FontWeight.w500,
      borderRadius: isWeb ? 16 : 32,
      height: isWeb ? 56 : 35,
      width: isWeb ? 144 : 123,
      buttonColor: Colors.transparent,
      textColor: AppColors.textVidaLocaGreen,
      borderColor: AppColors.primaryDarkGreen,
      onPressed: () async {
        showLoadingDialog(context);
        await Future.delayed(const Duration(seconds: 1));
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        _showRatingDialog(context, isWeb, ref);
      },
    );
  }

  Future<void> _showRatingDialog(
    BuildContext context,
    bool isWeb,
    WidgetRef ref,
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
                  InteractiveRatingBar(
                    initialRating: order.rating.toDouble(),
                    onRatingChanged: (rating) {
                      ref
                          .read(ordersProvider.notifier)
                          .updateRating(order.productName, rating);
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "How Is The Product?",
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w600,
                      fontSize: isWeb ? 24 : 16,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Cancel',
                          onPressed: () {},
                          fontSize: isWeb ? 18 : 14,
                          height: 50,
                          fontWeight: FontWeight.w600,
                          buttonColor: Colors.transparent,
                          textColor: AppColors.textVidaLocaGreen,
                          borderColor: AppColors.primaryDarkGreen,
                          borderRadius: 16,
                          width: double.infinity,
                          borderWidth: 2,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CustomButton(
                          text: 'Done',
                          width: double.infinity,
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Product Rated Successfully"),
                              ),
                            );
                          },
                          borderRadius: 16,
                          fontSize: isWeb ? 18 : 14,
                          height: 50,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
