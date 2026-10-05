import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/constants/dashboard_helpers.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/features/seller/models/seller_earnings_models.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/earning_status_chip.dart';

import '../../models/earnings_formatters.dart';

enum EarningsColumn { orderId, product, customer, date, amount, status }

class EarningsTableMetrics {
  const EarningsTableMetrics({required this.isWeb});

  final bool isWeb;

  static const double headerHeight = 50;
  static const double rowHeight = 60;

  List<EarningsColumn> get columns => isWeb
      ? const [
          EarningsColumn.orderId,
          EarningsColumn.product,
          EarningsColumn.customer,
          EarningsColumn.date,
          EarningsColumn.amount,
          EarningsColumn.status,
        ]
      : const [
          EarningsColumn.orderId,
          EarningsColumn.product,
          EarningsColumn.amount,
          EarningsColumn.customer,
          EarningsColumn.date,
          EarningsColumn.status,
        ];

  double widthOf(EarningsColumn column) => switch (column) {
    EarningsColumn.orderId => isWeb ? 170 : 120,
    EarningsColumn.product => isWeb ? 230 : 170,
    EarningsColumn.customer => isWeb ? 200 : 150,
    EarningsColumn.date => isWeb ? 170 : 130,
    EarningsColumn.amount => isWeb ? 160 : 130,
    EarningsColumn.status => isWeb ? 170 : 150,
  };

  String labelOf(EarningsColumn column) => switch (column) {
    EarningsColumn.orderId => 'Order ID',
    EarningsColumn.product => 'Product Sold',
    EarningsColumn.customer => 'Customer Name',
    EarningsColumn.date => 'Order Date',
    EarningsColumn.amount => 'Amount Earned',
    EarningsColumn.status => 'Status',
  };

  double get tableWidth =>
      columns.fold<double>(0, (sum, column) => sum + widthOf(column));
}

class SellerEarningsTable extends StatelessWidget {
  const SellerEarningsTable({super.key, required this.earnings});

  final List<SellerEarning> earnings;

  TextStyle _style({required bool isHeader, required Color color}) {
    return GoogleFonts.hind(
      fontSize: isHeader ? 16 : 14,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  Widget _cell(double width, Widget child) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Align(alignment: Alignment.centerLeft, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metrics = EarningsTableMetrics(isWeb: context.isWeb);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: metrics.tableWidth,
        child: Column(
          children: [
            _buildHeader(metrics),
            for (final earning in earnings)
              _buildRow(context, earning, metrics),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(EarningsTableMetrics metrics) {
    return Container(
      height: EarningsTableMetrics.headerHeight,
      decoration: const BoxDecoration(color: AppColors.backgroundLight),
      child: Row(
        children: [
          for (final column in metrics.columns)
            _cell(
              metrics.widthOf(column),
              Text(
                metrics.labelOf(column),
                style: _style(isHeader: true, color: AppColors.textBlackGrey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    SellerEarning earning,
    EarningsTableMetrics metrics,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _showDetails(context, earning),
        child: Container(
          height: EarningsTableMetrics.rowHeight,
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            border: Border(
              bottom: BorderSide(
                color: AppColors.textIconGrey.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              for (final column in metrics.columns)
                _cell(
                  metrics.widthOf(column),
                  _buildCellContent(column, earning),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCellContent(EarningsColumn column, SellerEarning earning) {
    switch (column) {
      case EarningsColumn.orderId:
        return Text(
          earning.orderNumber,
          style: _style(isHeader: false, color: AppColors.textBlackGrey),
          overflow: TextOverflow.ellipsis,
        );
      case EarningsColumn.product:
        return Text(
          earning.productSold,
          style: _style(isHeader: false, color: AppColors.textBodyText),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        );
      case EarningsColumn.customer:
        return Text(
          earning.customerName,
          style: _style(isHeader: false, color: AppColors.textBlackGrey),
          overflow: TextOverflow.ellipsis,
        );
      case EarningsColumn.date:
        return Text(
          earning.orderDate == null ? '—' : formatDate(earning.orderDate!),
          style: _style(isHeader: false, color: AppColors.textBodyText),
          overflow: TextOverflow.ellipsis,
        );
      case EarningsColumn.amount:
        return Text(
          formatNaira(earning.amountEarned),
          style: GoogleFonts.notoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlackGrey,
          ),
          overflow: TextOverflow.ellipsis,
        );
      case EarningsColumn.status:
        return EarningStatusChip.table(
          status: earning.status,
          label: earning.statusLabel,
        );
    }
  }

  Future<void> _showDetails(BuildContext context, SellerEarning earning) {
    const spacer = SizedBox(height: 15);
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.backgroundWhite,
          titlePadding: const EdgeInsets.only(top: 16, left: 16),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Detailed View',
                style: GoogleFonts.hind(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlackGrey,
                ),
              ),
              IconButton(
                padding: EdgeInsets.only(right: context.isWeb ? 0 : 25),
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 40,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _richRow('Order ID', earning.orderNumber),
                spacer,
                _productsBlock(earning),
                spacer,
                _richRow('Customer Name', earning.customerName),
                spacer,
                _richRow(
                  'Order Date',
                  earning.orderDate == null
                      ? '—'
                      : formatDate(earning.orderDate!),
                ),
                spacer,
                if (earning.hasRefund) ...[
                  _richRow('Gross Amount', formatNaira(earning.grossAmount)),
                  spacer,
                  _richRow(
                    'Refunded',
                    '-${formatNaira(earning.refundedAmount)}',
                  ),
                  spacer,
                ],
                _richRow(
                  'Amount Earned',
                  formatNaira(earning.amountEarned),
                  isAmount: true,
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
                    EarningStatusChip.table(
                      status: earning.status,
                      label: earning.statusLabel,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _productsBlock(SellerEarning earning) {
    if (earning.products.length <= 1) {
      return _richRow('Product Sold', earning.productSold);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Products Sold:',
          style: GoogleFonts.hind(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 6),
        for (final product in earning.products)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '• ${product.title} × ${product.quantity}',
              style: GoogleFonts.hind(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textBodyText,
              ),
            ),
          ),
      ],
    );
  }

  Widget _richRow(String label, String info, {bool isAmount = false}) {
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
