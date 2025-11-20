import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/url.dart';
import '../../../../gen/assets.gen.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          '$networkImageUrl/logo3.png',
          errorBuilder: (
            BuildContext context,
            Object exception,
            StackTrace? stackTrace,
          ) {
            return const Center(
              child: Icon(
                Icons.broken_image,
                color: AppColors.textIconGrey,
                size: 50.0,
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        _buildTextProperties(
          'Empowering campus communities through smart commerce and Easy Buying and Selling.',
          isWeb,
          isBodyText: true,
        ),
        const SizedBox(height: 30),
        _buildTextProperties('Latest', isWeb),
        const SizedBox(height: 10),
        _buildTextProperties('Orders', isWeb),
        const SizedBox(height: 30),
        _buildTextProperties('Privacy Policy', isWeb),
        const SizedBox(height: 10),
        _buildTextProperties('Cookie Policy', isWeb),
        const SizedBox(height: 10),
        _buildTextProperties('Refund Policy', isWeb),
        const SizedBox(height: 30),
        _buildTextProperties('About Us', isWeb),
        const SizedBox(height: 10),
        _buildTextProperties('Support', isWeb),
        const SizedBox(height: 10),
        _buildTextProperties('For Riders', isWeb),
        const SizedBox(height: 10),
        _buildTextProperties('Become A Seller', isWeb),
        const SizedBox(height: 20),
        Divider(),
        _buildTextProperties(
          '© 2025 wiGO MARKET. All rights reserved.',
          isWeb,
          isBodyText: true,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(right: 150.0, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppAssets.icons.greenFacebook.svg(
                height: isWeb ? 50 : 34,
                width: isWeb ? 50 : 34,
              ),
              AppAssets.icons.x.svg(
                height: isWeb ? 50 : 34,
                width: isWeb ? 50 : 34,
              ),
              AppAssets.icons.instagram.svg(
                height: isWeb ? 50 : 34,
                width: isWeb ? 50 : 34,
              ),
              AppAssets.icons.linkedin.svg(
                height: isWeb ? 50 : 34,
                width: isWeb ? 50 : 34,
              ),
              AppAssets.icons.youtube.svg(
                height: isWeb ? 50 : 34,
                width: isWeb ? 50 : 34,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextProperties(
    String text,
    bool isWeb, {
    bool isBottomText = true,
    bool isBodyText = false,
  }) {
    return Text(
      text,
      style: GoogleFonts.hind(
        fontWeight: FontWeight.w400,
        fontSize:
            isWeb
                ? isBottomText
                    ? 16
                    : 18
                : 14,
        color:
            isBottomText
                ? isBodyText
                    ? AppColors.textBodyText
                    : AppColors.textBlackGrey
                : AppColors.textBlack,
      ),
    );
  }
}
