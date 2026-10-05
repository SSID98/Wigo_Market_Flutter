import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/order_details_widgets/app_section_card.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/order_summary_card.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/dashboard_helpers.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../models/order_details_model.dart';
import '../contact_customer_dialog.dart';
import '../order_status_container.dart';
import '../update_order_status_dialog.dart';

const int _inlineItemLimit = 3;

class OrderMainDetailsCard extends ConsumerWidget {
  final OrderDetail order;

  const OrderMainDetailsCard({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = context.isWeb;
    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderHeader(isWeb: isWeb, ref: ref, context: context),
          SizedBox(height: 24),
          _buildBuyerDeliverySection(isWeb),
          SizedBox(height: 24),
          Divider(thickness: 0.5),
          SizedBox(height: 24),
          _buildOrderSummarySection(isWeb, context),
        ],
      ),
    );
  }

  Widget _buildOrderHeader({
    required bool isWeb,
    required WidgetRef ref,
    required BuildContext context,
  }) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              AppAssets.images.orderDetailBg.path,
              fit: BoxFit.cover,
              color: AppColors.tableHeader,
              colorBlendMode: BlendMode.overlay,
              errorBuilder:
                  (
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
            child: isWeb
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildOrderDetailsColumn(isWeb: isWeb)),
                      _buildActionButtons(isWeb, context, ref),
                    ],
                  )
                : Column(
                    children: [
                      _buildOrderDetailsColumn(isWeb: isWeb),
                      const SizedBox(height: 20),
                      _buildActionButtons(isWeb, context, ref),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isWeb, BuildContext context, WidgetRef ref) {
    final buttons = <Widget>[
      if (order.allowedActions.isNotEmpty)
        _buildCustomButton(
          text: "Update Status",
          isWeb: isWeb,
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => UpdateOrderStatusDialog(
                pageContext: context,
                orderId: order.id,
                currentStatusLabel: order.statusLabel,
                allowedActions: order.allowedActions,
              ),
            );
          },
        ),
      _buildCustomButton(
        text: 'Contact Customer',
        isWeb: isWeb,
        isFirstButton: false,
        onPressed: () {
          showContactCustomerDialog(
            context,
            ref,
            isWeb: isWeb,
            orderId: order.id,
            orderNumber: order.orderNumber,
            customerName: order.buyer.name,
            customerPhone: order.buyer.mobile,
          );
        },
      ),
    ];

    if (isWeb) {
      return Column(
        children: [
          for (int i = 0; i < buttons.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            buttons[i],
          ],
        ],
      );
    }
    return Row(
      children: [
        for (int i = 0; i < buttons.length; i++) ...[
          if (i > 0) const SizedBox(width: 30),
          buttons[i],
        ],
      ],
    );
  }

  Widget _buildOrderDetailsColumn({required bool isWeb}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRichText(
          title: 'Order ID',
          value: order.orderNumber,
          isWeb: isWeb,
        ),
        const SizedBox(height: 10),
        _buildRichText(
          title: 'Order Date & Time',
          value: '${formatDate(order.orderDate)} • 10:32 AM',
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
      textColor: isFirstButton
          ? AppColors.textWhite
          : AppColors.textVidaGreen800,
      buttonColor: isFirstButton
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

  Widget _buildBuyerDeliverySection(bool isWeb) {
    final buyer = order.buyer;
    final delivery = order.delivery;
    final preferredTime = delivery.preferredTime ?? 'Not specified';
    final riderName = delivery.riderName ?? 'Not yet assigned';
    final address = delivery.address ?? 'Not specified';
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
                          value: buyer.name,
                          isWeb: isWeb,
                        ),
                        const SizedBox(height: 20),
                        _buildInfoColumn(
                          title: 'Delivery Address',
                          value: address,
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
                          value: buyer.mobile,
                          isWeb: isWeb,
                        ),
                        const SizedBox(height: 20),
                        _buildInfoColumn(
                          title: 'Preferred Time',
                          value: preferredTime,
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
                          value: delivery.type,
                          isWeb: isWeb,
                        ),
                        const SizedBox(height: 20),
                        _buildInfoColumn(
                          title: 'Rider',
                          value: riderName,
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
                        value: buyer.name,
                        isWeb: isWeb,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoColumn(
                        title: 'Delivery Address',
                        value: address,
                        isWeb: isWeb,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoColumn(
                        title: 'Rider',
                        value: riderName,
                        isWeb: isWeb,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoColumn(
                        title: 'Phone Number',
                        value: buyer.mobile,
                        isWeb: isWeb,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoColumn(
                        title: 'Preferred Time',
                        value: preferredTime,
                        isWeb: isWeb,
                      ),
                      const SizedBox(height: 20),
                      _buildInfoColumn(
                        title: 'Delivery Address',
                        value: delivery.type,
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

  Widget _buildOrderSummarySection(bool isWeb, BuildContext context) {
    final items = order.items;
    final visibleItems = items.take(_inlineItemLimit).toList();
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
        if (items.isEmpty)
          Text(
            'No items on this order.',
            style: GoogleFonts.hind(
              fontSize: 14,
              color: AppColors.textBodyText,
            ),
          )
        else if (isWeb)
          Column(
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
                  ...visibleItems.map(
                    (item) => _buildRow(
                      item.title,
                      '${item.quantity}',
                      formatAmount(item.unitPrice),
                      formatAmount(item.subtotal),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Total: ${formatAmount(order.summary.total)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          )
        else
          Column(
            children: visibleItems
                .map((item) => OrderSummaryCard(item: item))
                .toList(),
          ),
        if (items.length > _inlineItemLimit)
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () => _showAllItemsDialog(context),
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

  void _showAllItemsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.backgroundWhite,
          title: Text(
            'All Items (${order.items.length})',
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColors.textVidaGreen800,
            ),
          ),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                children: order.items
                    .map((item) => OrderSummaryCard(item: item))
                    .toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Close',
                style: GoogleFonts.hind(color: AppColors.textBodyText),
              ),
            ),
          ],
        );
      },
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
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(p, overflow: TextOverflow.ellipsis),
        ),
        Padding(padding: const EdgeInsets.all(8), child: Text(q)),
        Padding(padding: const EdgeInsets.all(8), child: Text(price)),
        Padding(padding: const EdgeInsets.all(8), child: Text(sub)),
      ],
    );
  }
}
