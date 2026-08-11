import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/custom_banner.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../gen/assets.gen.dart';
import '../../models/delivery_model.dart';
import '../../viewmodels/delivery_task_viewmodel.dart';
import '../widgets/delivery_detail_card.dart';

class DeliveryDetailScreen extends ConsumerWidget {
  final Delivery delivery;

  const DeliveryDetailScreen({super.key, required this.delivery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(deliveryTaskProvider);
    final notifier = ref.read(deliveryTaskProvider.notifier);

    ref.listen(deliveryTaskProvider.select((s) => s.actionError), (_, error) {
      if (error != null && context.mounted) {
        showErrorBanner(error, context);
        // ScaffoldMessenger.of(context)
        //   ..hideCurrentSnackBar()
        //   ..showSnackBar(
        //     SnackBar(
        //       content: Text(error),
        //       backgroundColor: Colors.red.shade700,
        //       behavior: SnackBarBehavior.floating,
        //     ),
        //   );
        notifier.clearActionError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: AppAssets.icons.arrowLeft.svg(),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Text(
                'Back',
                style: GoogleFonts.hind(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlackGrey,
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: DeliveryDetailCard(
                delivery: delivery,
                isActionLoading: state.isActionLoading,
                onAction: (actionType) =>
                    _handleAction(context, delivery, actionType, notifier),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    Delivery delivery,
    DeliveryActionType actionType,
    DeliveryTaskViewModel notifier,
  ) async {
    switch (actionType) {
      case DeliveryActionType.select:
        final success = await notifier.selectOrder(delivery.id);
        if (success && context.mounted) {
          _showSuccess(context, 'Order accepted! Head to the pickup location.');
          Navigator.of(context).pop();
        }

      case DeliveryActionType.markPickedUp:
        final success = await notifier.updateOrderStatus(
          delivery.id,
          'picked_up',
        );
        if (success && context.mounted) {
          _showSuccess(context, 'Order marked as picked up.');
          Navigator.of(context).pop();
        }

      case DeliveryActionType.markInTransit:
        final success = await notifier.updateOrderStatus(
          delivery.id,
          'in_transit',
        );
        if (success && context.mounted) {
          _showSuccess(context, 'Order is now in transit.');
          Navigator.of(context).pop();
        }

      case DeliveryActionType.confirmDelivery:
        final (success, amount) = await notifier.confirmDelivery(delivery.id);
        if (success && context.mounted) {
          final amountText = amount != null
              ? ' ₦${amount.toStringAsFixed(2)} has been credited to your wallet.'
              : '';
          _showSuccess(context, 'Delivery confirmed!$amountText');
          Navigator.of(context).pop();
        }
    }
  }

  void _showSuccess(BuildContext context, String message) {
    showSuccessBanner(message, context);
    // ScaffoldMessenger.of(context)
    //   ..hideCurrentSnackBar()
    //   ..showSnackBar(
    //     SnackBar(
    //       content: Text(message),
    //       backgroundColor: Colors.green.shade700,
    //       behavior: SnackBarBehavior.floating,
    //     ),
    //   );
  }
}

// class DeliveryDetailScreen extends StatelessWidget {
//   final Delivery delivery;
//
//   const DeliveryDetailScreen({super.key, required this.delivery});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundLight,
//       body: Column(
//         children: [
//           Row(
//             children: [
//               IconButton(
//                 icon: AppAssets.icons.arrowLeft.svg(),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//               Text(
//                 "Back",
//                 style: GoogleFonts.hind(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.textBlackGrey,
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: DeliveryDetailCard(delivery: delivery),
//           ),
//         ],
//       ),
//     );
//   }
// }
