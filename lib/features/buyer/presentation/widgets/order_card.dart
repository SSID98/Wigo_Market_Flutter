import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../viewmodels/order_viewmodel.dart';

class OrderCard extends StatelessWidget {
  final OrderItemModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb ? _buildWebLayout(isWeb) : _buildMobileLayout(isWeb);
  }

  Widget _buildWebLayout(bool isWeb) {
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
        _trackButton(isWeb),
      ],
    );
  }

  Widget _buildMobileLayout(bool isWeb) {
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
              _trackButton(isWeb),
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

  Widget _trackButton(bool isWeb) {
    return CustomButton(
      text: 'Track Order',
      fontSize: isWeb ? 16 : 12,
      fontWeight: FontWeight.w400,
      borderRadius: isWeb ? 16 : 8,
      height: isWeb ? 50 : 35,
      width: isWeb ? 144 : 123,
      onPressed: () {},
    );
  }
}

// onTap: () async {
// showLoadingDialog(context);
// await Future.delayed(const Duration(seconds: 1));
// if (!context.mounted) return;
// Navigator.of(context, rootNavigator: true).pop();
// context.push('/buyer/product-details', extra: {'product': product});
// },
