import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import '../../../../../gen/assets.gen.dart';
import '../quick_action_card.dart';

class QuickActionWidget extends StatelessWidget {
  const QuickActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Container(
      height: 170,
      margin: EdgeInsets.only(top: isWeb ? 18 : 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white70.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isWeb ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Action',
              style: GoogleFonts.hind(
                fontSize: isWeb ? 20 : 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 17),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  QuickActionCard(
                    text: 'Add New Product',
                    isSelected: true,
                    onTap: () {},
                    icon: AppAssets.icons.recentDeliveries.svg(),
                    borderColor: AppColors.textPurple,
                  ),
                  QuickActionCard(
                    text: 'Manage Orders',
                    isSelected: false,
                    onTap: () {},
                    icon: AppAssets.icons.quickActionCart.svg(),
                    borderColor: AppColors.radioBlue,
                  ),
                  QuickActionCard(
                    text: 'Manage Inventory',
                    isSelected: false,
                    onTap: () {},
                    icon: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Color(0xffD85583).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(67.14),
                      ),
                      child: Center(
                        child: AppAssets.icons.manageInventory.svg(),
                      ),
                    ),
                    borderColor: AppColors.textPink,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
