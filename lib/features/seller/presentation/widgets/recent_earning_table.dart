import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dashboard_helpers.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../models/order.dart';
import 'order_status_container.dart';

class RecentEarningTable extends ConsumerWidget {
  final List<Order> orders;
  final bool isExpanded;

  const RecentEarningTable({
    super.key,
    required this.orders,
    this.isExpanded = false,
  });

  TextStyle _getStyle({required bool isHeader, required Color color}) {
    return GoogleFonts.hind(
      fontSize: isHeader ? 16 : 14,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          // Header Row
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: isExpanded
                  ? AppColors.backgroundLight
                  : AppColors.tableHeader,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: context.isWeb ? 180.0 : 130.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Order ID",
                      style: _getStyle(
                        isHeader: true,
                        color: AppColors.textBlackGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(
                  width: context.isWeb ? 130.0 : 120.0,
                  child: Text(
                    "Product Sold",
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!context.isWeb)
                  SizedBox(
                    width: context.isWeb ? 160.0 : 130.0,
                    child: Text(
                      "Amount Earned",
                      style: _getStyle(
                        isHeader: true,
                        color: AppColors.textBlackGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                SizedBox(
                  width: context.isWeb ? 200.0 : 150.0,
                  child: Text(
                    "Customer Name",
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: context.isWeb ? 180.0 : 130.0,
                  child: Text(
                    "Order Date",
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (context.isWeb)
                  SizedBox(
                    width: context.isWeb ? 160.0 : 110.0,
                    child: Text(
                      "Amount Earned",
                      style: _getStyle(
                        isHeader: true,
                        color: AppColors.textBlackGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                    right: context.isWeb
                        ? 0
                        : isExpanded
                        ? 0
                        : 20.0,
                  ),
                  child: SizedBox(
                    width: context.isWeb ? 130.0 : 80.0,
                    child: Center(
                      child: SizedBox(
                        width: context.isWeb ? 80 : 50,
                        child: Text(
                          "Status",
                          style: _getStyle(
                            isHeader: true,
                            color: AppColors.textBlackGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Data Rows
          ...orders.map(
            (d) => Container(
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.textIconGrey.withValues(alpha: 0.2),
                    width: 1.0,
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: () => _detailedViewDialog(context, d),
                child: Row(
                  children: [
                    SizedBox(
                      width: context.isWeb ? 180.0 : 130.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          d.orderId,
                          style: _getStyle(
                            isHeader: false,
                            color: AppColors.textBlackGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: context.isWeb ? 130.0 : 120.0,
                      child: Text(
                        d.item,
                        style: _getStyle(
                          isHeader: false,
                          color: AppColors.textBodyText,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    if (!context.isWeb)
                      SizedBox(
                        width: context.isWeb ? 160.0 : 130.0,
                        child: Text(
                          formatAmount(d.amount),
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBlackGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    SizedBox(
                      width: context.isWeb ? 200.0 : 150.0,
                      child: Text(
                        d.customerName,
                        style: _getStyle(
                          isHeader: false,
                          color: AppColors.textBlackGrey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: context.isWeb ? 180.0 : 130.0,
                      child: Text(
                        formatDate(d.date),
                        style: _getStyle(
                          isHeader: false,
                          color: AppColors.textBodyText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (context.isWeb)
                      SizedBox(
                        width: context.isWeb ? 160.0 : 110.0,
                        child: Text(
                          formatAmount(d.amount),
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textBlackGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: context.isWeb
                            ? 0
                            : isExpanded
                            ? 0
                            : 20.0,
                      ),
                      child: SizedBox(
                        width: context.isWeb ? 130.0 : 80.0,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 80,
                            child: OrderStatusContainer(status: d.status),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _detailedViewDialog(BuildContext context, Order order) async {
    final spacer = const SizedBox(height: 15);
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.backgroundWhite,
          titlePadding: EdgeInsets.only(top: 16, left: 16),
          insetPadding: EdgeInsets.symmetric(horizontal: 16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Detailed View",
                style: GoogleFonts.hind(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlackGrey,
                ),
              ),
              IconButton(
                padding: EdgeInsets.only(right: context.isWeb ? 0 : 25),
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
          contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 40),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRichTextRow(label: 'OrderID', info: order.orderId),
              spacer,
              _buildRichTextRow(label: 'Product Sold', info: order.item),
              spacer,
              _buildRichTextRow(
                label: 'Customer Name',
                info: order.customerName,
              ),
              spacer,
              _buildRichTextRow(
                label: 'Order Date',
                info: formatDate(order.date),
              ),
              spacer,
              _buildRichTextRow(
                label: 'Amount Earned',
                isAmount: true,
                info: formatAmount(order.amount),
              ),
              spacer,
              Row(
                children: [
                  Text(
                    'Status:   ',
                    style: GoogleFonts.hind(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: OrderStatusContainer(status: order.status),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRichTextRow({
    required String label,
    required String info,
    bool isAmount = false,
  }) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label:  ',
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
              fontWeight: isAmount ? FontWeight.w600 : FontWeight.w500,
              color: isAmount
                  ? AppColors.textBlackGrey
                  : AppColors.textBodyText,
            ),
          ),
        ],
      ),
    );
  }
}
