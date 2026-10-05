import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/core/utils/helper_methods_classes.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/dashboard_helpers.dart';
import '../../../../gen/assets.gen.dart';
import '../../models/order.dart';
import '../../models/order_enums.dart';
import '../../viewmodels/dropdown_providers.dart';
import '../views/order_detail_screen.dart';
import 'contact_customer_dialog.dart';
import 'order_details_widgets/order_status_actions.dart';
import 'order_status_container.dart';

enum ActionMenuView { main, updateStatus }

class OrderTable extends ConsumerWidget {
  final List<Order> orders;
  final bool isExpanded;

  const OrderTable({super.key, required this.orders, this.isExpanded = false});

  TextStyle _getStyle({required bool isHeader, required Color color}) {
    return GoogleFonts.hind(
      fontSize: isHeader ? 16 : 14,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = context.isWeb;
    final expandedId = ref.watch(expandedIdProvider);
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
                // if (isExpanded)
                //   Padding(
                //     padding: const EdgeInsets.only(left: 10.0),
                //     child: CustomCheckbox2(
                //       value: state.selectStatus,
                //       onChanged: notifier.toggleSelectStatus,
                //       borderRadius: 2,
                //       size: 16,
                //       checkSize: 10,
                //       borderColor: AppColors.borderColor,
                //       checkColor: AppColors.primaryDarkGreen,
                //     ),
                //   ),
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
                    right: isWeb
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
                  // if (isExpanded)
                  //   Padding(
                  //     padding: const EdgeInsets.only(left: 10.0),
                  //     child: CustomCheckbox2(
                  //       value: state.selectStatus,
                  //       onChanged: notifier.toggleSelectStatus,
                  //       borderRadius: 2,
                  //       size: 16,
                  //       checkSize: 10,
                  //       borderColor: AppColors.borderColor,
                  //       checkColor: AppColors.primaryDarkGreen,
                  //     ),
                  //   ),
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
                      '${d.itemsCount} item${d.itemsCount == 1 ? '' : 's'}',
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
                        d.deliveryType.displayName,
                        style: _getStyle(
                          isHeader: false,
                          color: AppColors.textBlackGrey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: isWeb
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
                          child: OrderStatusContainer(status: d.status),
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
                                  ref.read(expandedIdProvider.notifier).state =
                                      null;
                                  controller.isOpen
                                      ? controller.close()
                                      : controller.open();
                                },
                              );
                            },
                            style: anchorMenuStyle(),
                            menuChildren: _buildActionMenuItems(
                              context,
                              ref,
                              isWeb,
                              d,
                              expandedId,
                            ),
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

  List<Widget> _buildActionMenuItems(
    BuildContext context,
    WidgetRef ref,
    bool isWeb,
    Order d,
    String? expandedId,
  ) {
    final cancelAction = d.allowedActions
        .where((a) => a.status == OrderFilter.cancelled)
        .toList();

    return [
      MenuItemButton(
        leadingIcon: AppAssets.icons.viewOrder.svg(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrderDetailScreen(orderId: d.id)),
          );
        },
        child: Text(
          "View Order",
          style: GoogleFonts.hind(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlackGrey,
          ),
        ),
      ),

      if (d.allowedActions.isNotEmpty)
        isWeb
            ? _buildUpdateStatusSubmenuWeb(d, ref, context)
            : _buildUpdateStatusAccordionMobile(d, ref, context, expandedId),

      if (expandedId == d.id)
        ...d.allowedActions.map(
          (action) => MenuItemButton(
            onPressed: () {
              ref.read(expandedIdProvider.notifier).state = null;
              handleStatusSelection(
                context,
                ref,
                orderId: d.id,
                action: action,
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Text(
                action.label,
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
        onPressed: () {
          showContactCustomerDialog(
            context,
            ref,
            isWeb: isWeb,
            orderId: d.id,
            orderNumber: d.orderNumber,
            customerName: d.customerName,
            customerPhone: d.customerPhone,
          );
        },
        child: Text(
          "Contact Customer",
          style: GoogleFonts.hind(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlackGrey,
          ),
        ),
      ),

      if (cancelAction.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 1.0),
          child: MenuItemButton(
            leadingIcon: AppAssets.icons.cancelSquare.svg(),
            onPressed: () => handleStatusSelection(
              context,
              ref,
              orderId: d.id,
              action: cancelAction.first,
            ),
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
    ];
  }

  Widget _buildUpdateStatusSubmenuWeb(
    Order order,
    WidgetRef ref,
    BuildContext context,
  ) {
    final isOpen = ref.watch(submenuOpenProvider);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isOpen ? AppColors.tableHeader : Colors.transparent,
      ),
      child: SubmenuButton(
        onOpen: () => ref.watch(submenuOpenProvider.notifier).state = true,
        onClose: () => ref.watch(submenuOpenProvider.notifier).state = false,
        submenuIcon: WidgetStateProperty.all(
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: Icon(Icons.keyboard_arrow_right_rounded),
          ),
        ),
        leadingIcon: AppAssets.icons.updateStats.svg(),
        menuChildren: order.allowedActions
            .map(
              (action) => MenuItemButton(
                onPressed: () {
                  ref.read(submenuOpenProvider.notifier).state = false;
                  handleStatusSelection(
                    context,
                    ref,
                    orderId: order.id,
                    action: action,
                  );
                },
                child: Text(
                  action.label,
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

  Widget _buildUpdateStatusAccordionMobile(
    Order order,
    WidgetRef ref,
    BuildContext context,
    String? expandedId,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: expandedId == order.id ? 10 : 0),
      child: InkWell(
        onTap: () {
          final notifier = ref.read(expandedIdProvider.notifier);
          notifier.state = (expandedId == order.id) ? null : order.id;
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: expandedId == order.id
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
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                Icon(
                  expandedId == order.id
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
