import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/dashboard_widgets/status_chip.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dashboard_helpers.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_checkbox_2.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../models/order.dart';
import '../../models/order_task_state.dart';
import '../../viewmodels/dropdown_providers.dart';
import '../../viewmodels/order_task_viewmodel.dart';

enum ActionMenuView { main, updateStatus }

class OrderTable extends ConsumerWidget {
  final List<Order> orders;
  final bool isExpanded;

  const OrderTable({super.key, required this.orders, this.isExpanded = false});

  Widget _buildStatusContainer(OrderFilter status) {
    Color containerColor;
    Color textColor;

    switch (status) {
      case OrderFilter.pending:
        containerColor = Color(0xffF5F593).withValues(alpha: 0.50);
        textColor = AppColors.textYellow;
        break;
      case OrderFilter.delivered:
        containerColor = AppColors.textStatusGreen.withValues(alpha: 0.15);
        textColor = AppColors.textStatusGreen;
        break;
      case OrderFilter.cancelled:
        containerColor = AppColors.textRed.withValues(alpha: 0.15);
        textColor = AppColors.textRed;
      case OrderFilter.preparing:
        containerColor = Color(0xffE08D40).withValues(alpha: 0.15);
        textColor = Color(0xffE08D40);
      case OrderFilter.pickUpReady:
        containerColor = Color(0xffBA29FF).withValues(alpha: 0.15);
        textColor = Color(0xffBA29FF);
      case OrderFilter.inTransit:
        containerColor = Color(0xff6226EF).withValues(alpha: 0.15);
        textColor = Color(0xff6226EF);
      case OrderFilter.confirmed:
        containerColor = Color(0xff3463ED).withValues(alpha: 0.25);
        textColor = Color(0xff3463ED);
        break;
      default:
        // Default to a neutral style for unknown statuses
        containerColor = AppColors.textIconGrey.withValues(alpha: 0.1);
        textColor = AppColors.textBlackGrey;
    }
    return StatusChip(
      statusColor: textColor,
      containerColor: containerColor,
      status: status.displayName,
      borderRadius: 4.5,
      topPadding: 1.5,
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    final state = ref.watch(orderTaskProvider);
    final notifier = ref.read(orderTaskProvider.notifier);
    final expandedId = ref.watch(expandedStatusIdProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          // Header Row
          Container(
            height: 50,
            decoration: BoxDecoration(
              color:
                  isExpanded
                      ? AppColors.backgroundLight
                      : AppColors.tableHeader,
            ),
            child: Row(
              children: [
                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: CustomCheckbox2(
                      value: state.selectStatus,
                      onChanged: notifier.toggleSelectStatus,
                      borderRadius: 2,
                      size: 16,
                      checkSize: 10,
                      borderColor: AppColors.borderColor,
                      checkColor: AppColors.primaryDarkGreen,
                    ),
                  ),
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
                    "Order Date",
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
                    "Item",
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
                    "Amount",
                    style: _getStyle(
                      isHeader: true,
                      color: AppColors.textBlackGrey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isExpanded)
                  SizedBox(
                    width: isWeb ? 200.0 : 150.0,
                    child: Text(
                      "Delivery Type",
                      style: _getStyle(
                        isHeader: true,
                        color: AppColors.textBlackGrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(
                    right:
                        isWeb
                            ? 0
                            : isExpanded
                            ? 0
                            : 20.0,
                  ),
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
                if (isExpanded)
                  SizedBox(
                    width: isWeb ? 130.0 : 100.0,
                    child: Center(
                      child: SizedBox(
                        width: isWeb ? 80 : 50,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Action",
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
              child: Row(
                children: [
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: CustomCheckbox2(
                        value: state.selectStatus,
                        onChanged: notifier.toggleSelectStatus,
                        borderRadius: 2,
                        size: 16,
                        checkSize: 10,
                        borderColor: AppColors.borderColor,
                        checkColor: AppColors.primaryDarkGreen,
                      ),
                    ),
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
                      d.item,
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
                      formatAmount(d.amount),
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBodyText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isExpanded)
                    SizedBox(
                      width: isWeb ? 200.0 : 150.0,
                      child: Text(
                        d.deliveryType,
                        style: _getStyle(
                          isHeader: false,
                          color: AppColors.textBlackGrey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(
                      right:
                          isWeb
                              ? 0
                              : isExpanded
                              ? 0
                              : 20.0,
                    ),
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
                  if (isExpanded)
                    SizedBox(
                      width: isWeb ? 130.0 : 100.0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 90,
                          child: MenuAnchor(
                            crossAxisUnconstrained: true,
                            alignmentOffset: const Offset(-150, -20),
                            builder: (context, controller, child) {
                              return IconButton(
                                icon: AppAssets.icons.action.svg(),
                                onPressed: () {
                                  ref
                                      .read(expandedStatusIdProvider.notifier)
                                      .state = null;
                                  controller.isOpen
                                      ? controller.close()
                                      : controller.open();
                                },
                              );
                            },
                            style: MenuStyle(
                              backgroundColor: WidgetStateProperty.all(
                                AppColors.backgroundWhite,
                              ),
                              elevation: WidgetStateProperty.all(6),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                              ),
                            ),
                            menuChildren: [
                              MenuItemButton(
                                leadingIcon: AppAssets.icons.viewOrder.svg(),
                                onPressed: () {},
                                child: Text(
                                  "View Order",
                                  style: GoogleFonts.hind(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textBlackGrey,
                                  ),
                                ),
                              ),
                              isWeb
                                  ? _buildUpdateStatusSubmenuWeb(d, ref)
                                  : Padding(
                                    padding: EdgeInsets.only(
                                      top: expandedId == d.orderId ? 10 : 0,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        final notifier = ref.read(
                                          expandedStatusIdProvider.notifier,
                                        );
                                        notifier.state =
                                            (expandedId == d.orderId)
                                                ? null
                                                : d.orderId;
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          color:
                                              expandedId == d.orderId
                                                  ? AppColors.tableHeader
                                                  : Colors.transparent,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 15,
                                            bottom: 15,
                                            left: 12,
                                            right: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              AppAssets.icons.updateStats.svg(),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  "Update Status",
                                                  style: GoogleFonts.hind(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColors.textBlackGrey,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 50),
                                              Icon(
                                                expandedId == d.orderId
                                                    ? Icons
                                                        .keyboard_arrow_up_rounded
                                                    : Icons
                                                        .keyboard_arrow_down_rounded,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              if (expandedId == d.orderId)
                                ...OrderFilter.values
                                    .where((e) => e != OrderFilter.all)
                                    .map(
                                      (status) => MenuItemButton(
                                        onPressed: () {
                                          // 1. Update the status in your backend/state
                                          ref
                                              .read(orderTaskProvider.notifier)
                                              .updateOrderStatus(
                                                d.orderId,
                                                status,
                                              );

                                          // 2. IMPORTANT: Manually close the MenuAnchor
                                          // You might need to pass the controller or use a GlobalKey
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 35,
                                          ),
                                          child: Text(
                                            status.displayName,
                                            style: GoogleFonts.hind(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textBodyText,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              MenuItemButton(
                                leadingIcon: AppAssets.icons.contactCusto.svg(),
                                onPressed:
                                    () => _showContactCustomerDialog(
                                      context,
                                      isWeb,
                                      d,
                                    ),
                                child: Text(
                                  "Contact Customer",
                                  style: GoogleFonts.hind(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textBlackGrey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 1.0),
                                child: MenuItemButton(
                                  leadingIcon:
                                      AppAssets.icons.cancelSquare.svg(),
                                  onPressed: () {},
                                  child: Text(
                                    "Cancel Order",
                                    style: GoogleFonts.hind(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textBlackGrey,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateStatusSubmenuWeb(Order order, WidgetRef ref) {
    final notifier = ref.read(orderTaskProvider.notifier);
    final isOpen = ref.watch(submenuOpenProvider);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isOpen ? AppColors.tableHeader : Colors.transparent,
      ),
      child: SubmenuButton(
        onOpen: () {
          ref.watch(submenuOpenProvider.notifier).state = true;
        },
        onClose: () {
          ref.watch(submenuOpenProvider.notifier).state = false;
        },
        submenuIcon: WidgetStateProperty.all(
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: Icon(Icons.keyboard_arrow_right_rounded),
          ),
        ),
        leadingIcon: AppAssets.icons.updateStats.svg(),
        menuChildren:
            OrderFilter.values
                .where((e) => e != OrderFilter.all)
                .map(
                  (status) => MenuItemButton(
                    onPressed: () {
                      notifier.updateOrderStatus(order.orderId, status);
                      ref.read(submenuOpenProvider.notifier).state = false;
                    },
                    child: Text(
                      status.displayName,
                      style: GoogleFonts.hind(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBodyText,
                      ),
                    ),
                  ),
                )
                .toList(),
        child: Text(
          "Update Status",
          style: GoogleFonts.hind(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlackGrey,
          ),
        ),
      ),
    );
  }

  Future<void> _showContactCustomerDialog(
    BuildContext context,
    bool isWeb,
    Order order,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.backgroundWhite,
          titlePadding: EdgeInsets.only(top: 16, left: 16),
          insetPadding: EdgeInsets.symmetric(horizontal: 16),
          title: Row(
            children: [
              AppAssets.icons.contactCusto.svg(),
              const SizedBox(width: 8),
              Text(
                "Contact Customer",
                style: GoogleFonts.hind(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBlackGrey,
                ),
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.only(right: isWeb ? 0 : 25),
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
          contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 40),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 72,
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRichTextRow(
                          label: 'Customer',
                          info: order.customerName,
                        ),
                        if (isWeb)
                          _buildRichTextRow(
                            label: 'OrderID',
                            info: order.orderId,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!isWeb)
                          _buildRichTextRow(
                            label: 'OrderID',
                            info: order.orderId,
                          ),
                        _buildRichTextRow(
                          label: 'Phone',
                          info: order.customerPhone,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Need to clarify an order, delivery time, or product issue? Send a message directly to the buyer.",
                style: GoogleFonts.hind(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textBlackGrey,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Type your message here...',
                fillColor: AppColors.backgroundLight,
                contentPadding: EdgeInsets.all(16),
                minLines: 6,
                maxLines: 8,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancel',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 48,
                      borderRadius: 6,
                      textColor: AppColors.textBlackGrey,
                      buttonColor: AppColors.backgroundLight,
                      width: double.infinity,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomButton(
                      text: 'Send',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 48,
                      borderRadius: 6,
                      width: double.infinity,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRichTextRow({required String label, required String info}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
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
              fontWeight: FontWeight.w400,
              color: AppColors.textBlackGrey,
            ),
          ),
        ],
      ),
    );
  }
}
