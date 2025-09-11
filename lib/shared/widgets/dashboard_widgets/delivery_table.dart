import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/dashboard_widgets/status_chip.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/dashboard_helpers.dart';
import '../../../features/rider/models/delivery.dart';

class DeliveryTable extends StatelessWidget {
  final List<Delivery> deliveries;

  const DeliveryTable({super.key, required this.deliveries});

  Widget _buildStatusContainer(String status) {
    Color containerColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'on-going':
        containerColor = AppColors.textYellow.withValues(alpha: 0.1);
        textColor = AppColors.textYellow;
        break;
      case 'delivered':
        containerColor = AppColors.textStatusGreen.withValues(alpha: 0.1);
        textColor = AppColors.textStatusGreen;
        break;
      case 'canceled':
        containerColor = AppColors.textRed.withValues(alpha: 0.1);
        textColor = AppColors.textRed;
        break;
      default:
        // Default to a neutral style for unknown statuses
        containerColor = AppColors.textIconGrey.withValues(alpha: 0.1);
        textColor = AppColors.textBlackGrey;
    }
    return StatusChip(
      statusColor: textColor,
      containerColor: containerColor,
      status: status,
    );
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
                  width: isWeb ? 170.0 : 120.0,
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
                    width: isWeb ? 180.0 : 130.0,
                    child: Text(
                      formatDate(d.date),
                      style: _getStyle(
                        isHeader: false,
                        color: AppColors.textBodyText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: isWeb ? 170.0 : 120.0,
                    child: Text(
                      d.customer,
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
                          width: 80,
                          child: _buildStatusContainer(d.status),
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
