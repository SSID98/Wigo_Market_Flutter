import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/url.dart';
import 'package:wigo_flutter/shared/widgets/custom_avatar.dart';

import '../../../../../core/constants/app_colors.dart';

class TopShopsSection extends StatelessWidget {
  const TopShopsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Shops',
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.w700,
            fontSize: isWeb ? 25.16 : 18,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'See Sellers People Patronise the Most',
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w500,
            fontSize: isWeb ? 14 : 12,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _topShopsFrame(isWeb),
            _topShopsFrame(isWeb),
            _topShopsFrame(isWeb),
            _topShopsFrame(isWeb),
          ],
        ),
      ],
    );
  }

  Widget _topShopsFrame(bool isWeb) {
    return Column(
      children: [
        CustomAvatar(
          showBottomText: true,
          showLeftTexts: false,
          borderColor: AppColors.clampBgColor,
          avatarPadding: EdgeInsetsGeometry.only(left: 18),
          bottomText: Text(
            'StageCraft Supplies',
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: isWeb ? 14 : 9,
              color: AppColors.textBlackGrey,
            ),
          ),
          mainAxisAlignment: MainAxisAlignment.start,
          backgroundImage: NetworkImage('$networkImageUrl/topShops.png'),
        ),
      ],
    );
  }
}
