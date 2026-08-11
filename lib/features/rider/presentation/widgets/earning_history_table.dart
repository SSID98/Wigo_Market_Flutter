import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/dashboard_widgets/status_chip.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dashboard_helpers.dart';
import '../../models/earning_history_model.dart';

class EarningsHistoryTable extends StatelessWidget {
  final List<EarningHistoryOrder> orders;

  const EarningsHistoryTable({super.key, required this.orders});

  Widget _buildStatusContainer(EarningHistoryOrder order) {
    final isCancelled = order.isCancelled;
    final containerColor = isCancelled
        ? AppColors.textRed.withValues(alpha: 0.1)
        : AppColors.textStatusGreen.withValues(alpha: 0.1);
    final textColor = isCancelled
        ? AppColors.textRed
        : AppColors.textStatusGreen;

    return StatusChip(
      statusColor: textColor,
      containerColor: containerColor,
      status: order.displayStatus,
    );
  }

  TextStyle _getStyle({required bool isHeader, required Color color}) {
    return GoogleFonts.hind(
      fontSize: isHeader ? 16 : 14,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: const BoxDecoration(color: AppColors.tableHeader),
            child: Row(
              children: [
                SizedBox(
                  width: isWeb ? 180.0 : 130.0,
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
                  width: isWeb ? 180.0 : 130.0,
                  child: Text(
                    "Delivery Date",
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: isWeb ? 200.0 : 150.0,
                  child: Text(
                    "Customer",
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: isWeb ? 130.0 : 80.0,
                  child: Text(
                    "Items",
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: isWeb ? 160.0 : 110.0,
                  child: Text(
                    "Earnings",
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: isWeb ? 0 : 20.0),
                  child: SizedBox(
                    width: isWeb ? 130.0 : 80.0,
                    child: Center(
                      child: SizedBox(
                        width: isWeb ? 80 : 50,
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
          ...orders.map(
            (order) => Container(
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
              child: Row(
                children: [
                  SizedBox(
                    width: isWeb ? 180.0 : 130.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        order.orderNumber.isNotEmpty
                            ? order.orderNumber
                            : order.orderId,
                        style: _getStyle(
                          isHeader: false,
                          color: AppColors.textBlackGrey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: isWeb ? 180.0 : 130.0,
                    child: Text(
                      _formatDate(order.deliveredAt ?? order.date),
                      style: _getStyle(
                        isHeader: false,
                        color: AppColors.textBodyText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: isWeb ? 200.0 : 150.0,
                    child: Text(
                      order.customer,
                      style: _getStyle(
                        isHeader: false,
                        color: AppColors.textBlackGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: isWeb ? 130.0 : 80.0,
                    child: Text(
                      '${order.itemCount} item${order.itemCount == 1 ? '' : 's'}',
                      style: _getStyle(
                        isHeader: false,
                        color: AppColors.textBodyText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: isWeb ? 160.0 : 110.0,
                    child: Text(
                      formatAmount(order.amount),
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBodyText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: isWeb ? 0 : 20.0),
                    child: SizedBox(
                      width: isWeb ? 130.0 : 80.0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 80,
                          child: _buildStatusContainer(order),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
