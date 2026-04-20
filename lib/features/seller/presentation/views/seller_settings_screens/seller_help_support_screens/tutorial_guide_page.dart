import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/text_column.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../../core/utils/context_extensions.dart';
import '../../../../../../gen/assets.gen.dart';

class TileData {
  final Widget icon;
  final String title;
  final String subtitle;

  TileData({required this.icon, required this.title, required this.subtitle});
}

class TutorialGuidePage extends StatelessWidget {
  const TutorialGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TileData> tileData = [
      TileData(
        icon: AppAssets.icons.addProd.svg(
          width: context.isWeb ? 141 : 55,
          height: context.isWeb ? 110 : 59,
        ),
        title: "How To Add a Product to Your Store",
        subtitle:
            "Learn how to list single or variant products with images, descriptions, and pricing.",
      ),
      TileData(
        icon: AppAssets.icons.manageOrders.svg(
          width: context.isWeb ? 141 : 55,
          height: context.isWeb ? 110 : 59,
        ),
        title: "Manage Your Orders",
        subtitle:
            "Understand how to track, update, and fulfill customer orders from your dashboard.",
      ),
      TileData(
        icon: AppAssets.icons.trackSales.svg(
          width: context.isWeb ? 141 : 55,
          height: context.isWeb ? 110 : 59,
        ),
        title: "How to Track Your Sales and Store Performance",
        subtitle:
            "Learn how to monitor your daily sales, product performance, and customer trends—all in one dashboard.",
      ),
    ];
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tutorial & Guilds",
            style: GoogleFonts.hind(
              fontSize: context.isWeb ? 28 : 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Learn how to grow your business and sell better on WiGo Market",
            style: GoogleFonts.hind(
              fontSize: context.isWeb ? 18 : 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textBlackGrey,
            ),
          ),

          const SizedBox(height: 10),
          Text(
            "What would you like to learn?",
            style: GoogleFonts.hind(
              fontSize: context.isWeb ? 24 : 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textOrange,
            ),
          ),
          const SizedBox(height: 20),
          context.isWeb
              ? Column(
                  children: tileData.map((tile) {
                    return _buildWebListTile(
                      icon: tile.icon,
                      isWeb: context.isWeb,
                      title: tile.title,
                      subtitle: tile.subtitle,
                    );
                  }).toList(),
                )
              : Column(
                  children: tileData.map((tile) {
                    return _buildMobileListTile(
                      icon: tile.icon,
                      isWeb: context.isWeb,
                      title: tile.title,
                      subtitle: tile.subtitle,
                    );
                  }).toList(),
                ),
          const SizedBox(height: 15),
          Text(
            "Need more help?",
            style: GoogleFonts.hind(
              fontSize: context.isWeb ? 24 : 15,
              fontWeight: context.isWeb ? FontWeight.w600 : FontWeight.w700,
              color: AppColors.textOrange,
            ),
          ),
          RichText(
            text: TextSpan(
              style: GoogleFonts.hind(
                fontSize: context.isWeb ? 18 : 14,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: "Visit our ",
                  style: GoogleFonts.hind(color: AppColors.textBlackGrey),
                ),
                TextSpan(
                  text: "Help & Support ",
                  style: GoogleFonts.hind(color: AppColors.textDeliveryFee),
                ),
                TextSpan(
                  text: "section if you have any questions.",
                  style: GoogleFonts.hind(color: AppColors.textBlackGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileListTile({
    required Widget icon,
    required bool isWeb,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      color: AppColors.backgroundWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
        side: BorderSide(color: AppColors.borderColor.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Padding(padding: const EdgeInsets.only(bottom: 45.0), child: icon),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextColumn(
                    title: title,
                    titleFontSize: 13,
                    subtitle1: subtitle,
                    isMainSubTitle: true,
                    subtitleFontSize: 12,
                  ),
                  const SizedBox(height: 10),
                  _buildCustomButton(isWeb),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebListTile({
    required Widget icon,
    required bool isWeb,
    required String title,
    required String subtitle,
  }) {
    return Card(
      color: AppColors.backgroundWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
        side: BorderSide(color: AppColors.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            buildTextColumn(
              title: title,
              titleFontSize: 22,
              subtitle1: subtitle,
              isMainSubTitle: true,
              subtitleFontSize: 18,
            ),
            const SizedBox(width: 10),
            _buildCustomButton(isWeb),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomButton(bool isWeb) {
    return CustomButton(
      text: "Learn How",
      fontSize: isWeb ? 16 : 12,
      fontWeight: FontWeight.w500,
      suffixIcon: AppAssets.icons.arrowRight.svg(),
      onPressed: () {},
      borderRadius: 4,
      height: isWeb ? 48 : 28,
      width: double.infinity,
    );
  }
}
