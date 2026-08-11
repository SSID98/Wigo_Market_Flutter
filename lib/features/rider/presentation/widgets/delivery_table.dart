import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/dashboard_widgets/status_chip.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dashboard_helpers.dart';
import '../../models/delivery_model.dart';

class DeliveryTable extends StatelessWidget {
  final List<Delivery> deliveries;

  const DeliveryTable({super.key, required this.deliveries});

  Widget _buildStatusContainer(String displayStatus) {
    Color containerColor;
    Color textColor;

    switch (displayStatus.toLowerCase()) {
      case 'new request':
        // pending_assignment — available but not yet this rider's order.
        // Should not normally appear here (endpoint excludes the unassigned
        // pool), but handled defensively.
        containerColor = AppColors.textOrange.withValues(alpha: 0.1);
        textColor = AppColors.textOrange;
        break;
      case 'assigned':
      case 'picked up':
      case 'in transit':
        // Ongoing sub-statuses — rider has accepted and is working the order.
        containerColor = AppColors.textYellow.withValues(alpha: 0.1);
        textColor = AppColors.textYellow;
        break;
      case 'delivered':
        containerColor = AppColors.textStatusGreen.withValues(alpha: 0.1);
        textColor = AppColors.textStatusGreen;
        break;
      case 'cancelled':
        containerColor = AppColors.textRed.withValues(alpha: 0.1);
        textColor = AppColors.textRed;
        break;
      default:
        containerColor = AppColors.textIconGrey.withValues(alpha: 0.1);
        textColor = AppColors.textBlackGrey;
    }
    return StatusChip(
      statusColor: textColor,
      containerColor: containerColor,
      status: displayStatus,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 30) return '${diff.inDays}d ago';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  TextStyle _getStyle({required bool isHeader, required Color color}) {
    return GoogleFonts.hind(
      fontSize: isHeader ? 16 : 14,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          // Header Row
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
                    "Delivery Fee",
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
          // Data Rows
          ...deliveries.map(
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
              child: Row(
                children: [
                  SizedBox(
                    width: isWeb ? 180.0 : 130.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        d.orderNumber,
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
                      _formatDate(d.createdAt),
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
                      d.customerName,
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
                      d.items,
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
                      formatAmount(d.fee),
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
                          width: isWeb ? 100 : 80,
                          child: _buildStatusContainer(d.displayStatus),
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
