import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../models/order_details_model.dart';
import '../../../models/order_enums.dart';
import 'app_section_card.dart';

class OrderTimelineCard extends ConsumerWidget {
  const OrderTimelineCard({super.key, required this.timeline});

  final List<OrderTimelineEntry> timeline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Timeline",
            style: GoogleFonts.hind(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textVidaGreen800,
            ),
          ),
          const SizedBox(height: 20),
          if (timeline.isEmpty)
            Text(
              'No timeline available for this order.',
              style: GoogleFonts.hind(
                fontSize: 14,
                color: AppColors.textBodyText,
              ),
            )
          else
            ...timeline.map(
              (entry) =>
                  _TimelineTile(entry: entry, isLast: entry == timeline.last),
            ),
        ],
      ),
    );
  }
}

Widget _iconFor(OrderFilter status) {
  switch (status) {
    case OrderFilter.pending:
      return AppAssets.icons.orderReceived.svg();
    case OrderFilter.confirmed:
      return AppAssets.icons.orderConfirmed.svg();
    case OrderFilter.preparing:
      return AppAssets.icons.prepForDelivery.svg();
    case OrderFilter.pickUpReady:
      return AppAssets.icons.readyForPickup.svg();
    case OrderFilter.inTransit:
      return AppAssets.icons.outForDelivery.svg();
    case OrderFilter.delivered:
      return AppAssets.icons.productDelivered.svg();
    case OrderFilter.cancelled:
      return AppAssets.icons.cancelSquare.svg();
    case OrderFilter.all:
      return AppAssets.icons.orderReceived.svg();
  }
}

String _formatTime(DateTime? at) {
  if (at == null) return 'Pending';
  final hour24 = at.hour;
  final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
  final minute = at.minute.toString().padLeft(2, '0');
  final period = hour24 >= 12 ? 'PM' : 'AM';
  return '$hour12:$minute $period';
}

class _TimelineTile extends StatelessWidget {
  final OrderTimelineEntry entry;
  final bool isLast;

  const _TimelineTile({required this.entry, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = entry.completed
        ? const Color(0xff53B483)
        : AppColors.sliderDotColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: entry.completed ? color : Colors.transparent,
                border: Border.all(color: color),
              ),
              child: entry.completed
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: AppColors.textWhite,
                    )
                  : null,
            ),
            if (!isLast) Container(width: 5, height: 50, color: color),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.05),
              side: BorderSide(
                color: AppColors.borderColor.withValues(alpha: 0.01),
              ),
            ),
            color: AppColors.backgroundWhite,
            elevation: 0.5,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  _iconFor(entry.status),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${entry.label} ● ${_formatTime(entry.at)}',
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBodyText,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
