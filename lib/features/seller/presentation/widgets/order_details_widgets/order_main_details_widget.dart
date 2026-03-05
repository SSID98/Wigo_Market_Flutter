import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/models/order_task_state.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/order_details_widgets/app_section_card.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/order_summary_card.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/dashboard_helpers.dart';
import '../../../../../core/constants/url.dart';
import '../../../models/order.dart';
import '../../../viewmodels/order_task_viewmodel.dart';
import '../order_status_container.dart';
import '../update_order_status_dialog.dart';

class OrderMainDetailsCard extends ConsumerWidget {
  final Order orders;

  const OrderMainDetailsCard({super.key, required this.orders});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderByIdProvider(orders.orderId));
    final isWeb = MediaQuery.of(context).size.width > 600;
    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderHeader(
            isWeb: isWeb,
            ref: ref,
            context: context,
            order: order,
          ),
          SizedBox(height: 24),
          _buildBuyerDeliverySection(isWeb, order),
          SizedBox(height: 24),
          Divider(thickness: 0.5),
          SizedBox(height: 24),
          _buildOrderSummarySection(isWeb),
        ],
      ),
    );
  }

  Widget _buildOrderHeader({
    required bool isWeb,
    required WidgetRef ref,
    required BuildContext context,
    required Order? order,
  }) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.network(
              '$networkImageUrl/orderDetailBg.png',
              fit: BoxFit.cover,
              color: AppColors.tableHeader,
              colorBlendMode: BlendMode.overlay,
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
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child:
                isWeb
                    ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildOrderDetailsColumn(
                            isWeb: isWeb,
                            order: order,
                          ),
                        ),
                        Column(
                          children: [
                            _buildCustomButton(
                              text: "Update Status",
                              isWeb: isWeb,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => UpdateOrderStatusDialog(
                                        orderId: order!.orderId,
                                        currentStatus: order.status,
                                      ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildCustomButton(
                              text: 'Contact Customer',
                              isWeb: isWeb,
                              onPressed: () {},
                              isFirstButton: false,
                            ),
                          ],
                        ),
                      ],
                    )
                    : Column(
                      children: [
                        _buildOrderDetailsColumn(isWeb: isWeb, order: order),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _buildCustomButton(
                              text: "Update Status",
                              isWeb: isWeb,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => UpdateOrderStatusDialog(
                                        orderId: order!.orderId,
                                        currentStatus: order.status,
                                      ),
                                );
                              },
                            ),
                            const SizedBox(width: 30),
                            _buildCustomButton(
                              text: 'Contact Customer',
                              isWeb: isWeb,
                              onPressed: () {},
                              isFirstButton: false,
                            ),
                          ],
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetailsColumn({
    required bool isWeb,
    required Order? order,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRichText(title: 'Order ID', value: order!.orderId, isWeb: isWeb),
        const SizedBox(height: 10),
        _buildRichText(
          title: 'Order Date & Time',
          value: '${formatDate(order.date)} • 10:32 AM',
          isWeb: isWeb,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              'Order Status: ',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 28,
              width: 85,
              child: OrderStatusContainer(status: order.status),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomButton({
    required String text,
    required bool isWeb,
    required VoidCallback onPressed,
    bool isFirstButton = true,
  }) {
    return CustomButton(
      text: text,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      onPressed: onPressed,
      borderRadius: 4.5,
      padding: EdgeInsets.zero,
      height: isWeb ? 32 : 40,
      width: 124,
      textColor:
          isFirstButton ? AppColors.textWhite : AppColors.textVidaGreen800,
      buttonColor:
          isFirstButton
              ? AppColors.primaryDarkGreen
              : AppColors.primaryLightGreen,
    );
  }

  Widget _buildRichText({
    required String title,
    required String value,
    required bool isWeb,
  }) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$title: ",
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w500,
              fontSize: isWeb ? 16 : 15,
              color: AppColors.textBodyText,
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w400,
              fontSize: isWeb ? 16 : 15,
              color: AppColors.textBlackGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyerDeliverySection(bool isWeb, Order? order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Buyer & Delivery Information Section',
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.textVidaGreen800,
          ),
        ),
        const SizedBox(height: 20),
        isWeb
            ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildInfoColumn(
                        title: 'Buyer Name',
                        value: order!.customerName,
                        isWeb: isWeb,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoColumn(
                        title: 'Delivery Address',
                        value: order.deliveryLocation,
                        isWeb: isWeb,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _buildInfoColumn(
                        title: 'Phone Number',
                        value: order.customerPhone,
                        isWeb: isWeb,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoColumn(
                        title: 'Preferred Time',
                        value: 'Between 12 PM – 2 PM',
                        isWeb: isWeb,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _buildInfoColumn(
                        title: 'Delivery Type',
                        value: order.deliveryType.displayName,
                        isWeb: isWeb,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoColumn(
                        title: 'Rider',
                        value: 'Gilbert Johnston',
                        isWeb: isWeb,
                      ),
                    ],
                  ),
                ),
              ],
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoColumn(
                      title: 'Buyer Name',
                      value: order!.customerName,
                      isWeb: isWeb,
                    ),
                    const SizedBox(height: 20),
                    _buildInfoColumn(
                      title: 'Delivery Address',
                      value: order.deliveryLocation,
                      isWeb: isWeb,
                    ),
                    const SizedBox(height: 20),
                    _buildInfoColumn(
                      title: 'Rider',
                      value: 'Gilbert Johnston',
                      isWeb: isWeb,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoColumn(
                      title: 'Phone Number',
                      value: order.customerPhone,
                      isWeb: isWeb,
                    ),
                    const SizedBox(height: 20),
                    _buildInfoColumn(
                      title: 'Preferred Time',
                      value: 'Between 12 PM – 2 PM',
                      isWeb: isWeb,
                    ),
                    const SizedBox(height: 20),
                    _buildInfoColumn(
                      title: 'Delivery Address',
                      value: order.deliveryLocation,
                      isWeb: isWeb,
                    ),
                  ],
                ),
              ],
            ),
      ],
    );
  }

  Widget _buildInfoColumn({
    required String title,
    required String value,
    required bool isWeb,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ',
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w500,
            fontSize: isWeb ? 16 : 14,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w400,
            fontSize: isWeb ? 16 : 14,
            color: AppColors.textBodyText,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummarySection(bool isWeb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w600,
            fontSize: isWeb ? 18 : 16,
            color: AppColors.textVidaGreen800,
          ),
        ),
        const SizedBox(height: 20),
        isWeb
            ? Column(
              children: [
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                  },
                  children: [
                    _buildHeaderRow(),
                    _buildRow(
                      'Indomie Noodles (40 Pack)',
                      '1',
                      '₦5,000',
                      '₦5,000',
                    ),
                    _buildRow('Peak Milk (Big Tin)', '2', '₦1,200', '₦2,400'),
                    _buildRow('Peak Milk (Big Tin)', '2', '₦1,200', '₦2,400'),
                  ],
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'Total: ₦9,800',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            )
            : Column(
              children: [
                OrderSummaryCard(
                  productName: 'Nintendo Console (Black)',
                  imageUrl: '$networkImageUrl/nintendo.png',
                  order: orders,
                ),
                OrderSummaryCard(
                  productName: 'Ps3 Gaming Controller (Black)',
                  imageUrl: '$networkImageUrl/gamePad.png',
                  order: orders,
                ),
                OrderSummaryCard(
                  productName: 'Honey (Special Honey)',
                  imageUrl: '$networkImageUrl/Honey.png',
                  order: orders,
                ),
              ],
            ),
        Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            onPressed: () {
              // showDialog(
              //   context: context,
              //   builder: (_) => const _BuyerNoteDialog(),
              // );
            },
            child: Text(
              "See all",
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: isWeb ? 18 : 16,
                color: AppColors.textOrange,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.textOrange,
              ),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildHeaderRow() {
    return const TableRow(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text('Product', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Price/Unit',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Subtotal',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  TableRow _buildRow(String p, String q, String price, String sub) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(8), child: Text(p)),
        Padding(padding: const EdgeInsets.all(8), child: Text(q)),
        Padding(padding: const EdgeInsets.all(8), child: Text(price)),
        Padding(padding: const EdgeInsets.all(8), child: Text(sub)),
      ],
    );
  }
}
