import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../models/order_task_state.dart';
import '../../viewmodels/order_task_viewmodel.dart';

class UpdateOrderStatusDialog extends ConsumerStatefulWidget {
  final String orderId;
  final OrderFilter currentStatus;

  const UpdateOrderStatusDialog({
    super.key,
    required this.orderId,
    required this.currentStatus,
  });

  @override
  ConsumerState<UpdateOrderStatusDialog> createState() =>
      _UpdateOrderStatusDialogState();
}

class _UpdateOrderStatusDialogState
    extends ConsumerState<UpdateOrderStatusDialog> {
  late OrderFilter selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    final statuses =
        OrderFilter.values.where((e) => e != OrderFilter.all).toList();
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 18),
      backgroundColor: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Update Order Status",
              style: GoogleFonts.hind(
                fontSize: isWeb ? 18 : 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textNeutral950,
              ),
            ),

            const SizedBox(height: 20),

            GridView.builder(
              shrinkWrap: true,
              itemCount: statuses.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 25,
                crossAxisSpacing: 12,
                childAspectRatio: 2.6,
              ),
              itemBuilder: (context, index) {
                final status = statuses[index];

                final isSelected = selectedStatus == status;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedStatus = status;
                    });

                    ref
                        .read(orderTaskProvider.notifier)
                        .updateOrderStatus(widget.orderId, status);

                    Future.delayed(const Duration(milliseconds: 300), () {
                      ref
                          .read(orderTaskProvider.notifier)
                          .updateOrderStatus(widget.orderId, status);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.primaryLightGreen
                              : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      status.displayName,
                      style: GoogleFonts.hind(
                        fontSize: isWeb ? 18 : 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
