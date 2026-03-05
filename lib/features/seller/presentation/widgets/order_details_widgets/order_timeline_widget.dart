import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../models/timeline_item_model.dart';
import 'app_section_card.dart';

class OrderTimelineCard extends ConsumerWidget {
  const OrderTimelineCard({super.key});

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
          _TimelineTile(
            label: "Order received",
            icon: AppAssets.icons.orderReceived.svg(),
            item: TimelineItem(
              stage: OrderStage.received,
              time: "10:00 AM",
              isCompleted: true,
            ),
          ),
          _TimelineTile(
            label: "Order confirmed",
            icon: AppAssets.icons.orderConfirmed.svg(),
            item: TimelineItem(
              stage: OrderStage.confirmed,
              time: "10:00 AM",
              isCompleted: true,
            ),
          ),
          _TimelineTile(
            label: "Preparing for Delivery",
            icon: AppAssets.icons.prepForDelivery.svg(),
            item: TimelineItem(
              stage: OrderStage.preparing,
              time: "10:00 AM",
              isCompleted: true,
            ),
          ),
          _TimelineTile(
            label: "Ready for Pickup",
            icon: AppAssets.icons.readyForPickup.svg(),
            item: TimelineItem(
              stage: OrderStage.ready,
              time: "10:00 AM",
              isCompleted: false,
            ),
          ),
          _TimelineTile(
            label: "Out for Delivery",
            icon: AppAssets.icons.outForDelivery.svg(),
            item: TimelineItem(
              stage: OrderStage.outForDelivery,
              time: "10:00 AM",
              isCompleted: false,
            ),
          ),
          _TimelineTile(
            label: "Delivered",
            icon: AppAssets.icons.productDelivered.svg(),
            item: TimelineItem(
              stage: OrderStage.delivered,
              time: "10:00 AM",
              isCompleted: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final TimelineItem item;
  final Widget icon;
  final String label;

  const _TimelineTile({
    required this.item,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        item.isCompleted ? Color(0xff53B483) : AppColors.sliderDotColor;

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
                color: item.isCompleted ? color : Colors.transparent,
                border: Border.all(color: color),
              ),
              child:
                  item.isCompleted
                      ? const Icon(
                        Icons.check,
                        size: 14,
                        color: AppColors.textWhite,
                      )
                      : null,
            ),
            Container(width: 5, height: 50, color: color),
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
                  icon,
                  const SizedBox(width: 8),
                  Text(
                    '$label ● ${item.time}',
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBodyText,
                      fontSize: 16,
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
