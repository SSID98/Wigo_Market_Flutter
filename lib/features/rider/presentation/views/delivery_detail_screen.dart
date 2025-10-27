import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../gen/assets.gen.dart';
import '../../models/delivery.dart';
import '../widgets/delivery_detail_card.dart';

class DeliveryDetailScreen extends StatelessWidget {
  final Delivery delivery;

  const DeliveryDetailScreen({super.key, required this.delivery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: AppAssets.icons.arrowLeft.svg(),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Text(
                "Back",
                style: GoogleFonts.hind(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlackGrey,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: DeliveryDetailCard(delivery: delivery),
          ),
        ],
      ),
    );
  }
}
