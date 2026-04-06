import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/constants/url.dart';
import 'package:wigo_flutter/features/seller/presentation/views/single_product_version_view/single_product_info_screen.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../gen/assets.gen.dart';

class AddProductScreen extends ConsumerWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: AppAssets.icons.addproductBackArrow.svg(),
              ),
              SizedBox(width: isWeb ? 10 : 80),
              Text(
                "Add Product",
                style: GoogleFonts.hind(
                  color: AppColors.textBlackGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          _buildMobileHeader(),
          const SizedBox(height: 30),
          _buildMobileView(context),
        ],
      ),
    );
  }

  Widget _buildMobileView(BuildContext context) {
    return Column(
      children: [
        _buildAddProductCard(
          icon: AppAssets.icons.singleproduct.svg(),
          title: "Single Version Product",
          subtitle:
              "Choose this if your product has only one version — no size or color variations.",
          body:
              "Example: You're selling a pack of AA batteries that comes in only one size and type. No color or size variations — just one version.",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SingleProductInfoScreen()),
            );
          },
        ),
        const SizedBox(height: 40),
        _buildAddProductCard(
          icon: AppAssets.icons.multipleProduct.svg(),
          title: "Multiple Version Product",
          subtitle:
              "Choose this if your product comes in different versions — like sizes, colors, or types.",
          body:
              "Example: You’re selling a pair of sneakers that comes in 3 sizes (40, 41, 42) and 2 colors (black and white). ",
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMobileHeader() {
    return Stack(
      children: [
        Positioned(
          top: 4,
          left: 5,
          child: AppAssets.icons.addProductBgOverlayy.svg(
            height: 130.31,
            width: 137.68,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('$networkImageUrl/addProductBgMobile.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Need help adding your product?",
                  style: GoogleFonts.hind(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Want to make sure your product shows up right and gets noticed? Learn how to add a product to your storefront in a few easy steps.",
                  style: GoogleFonts.hind(
                    color: AppColors.clampBgColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                CustomButton(
                  text: "Learn How",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 40,
                  width: double.infinity,
                  buttonColor: AppColors.backgroundWhite,
                  borderColor: AppColors.textOrange,
                  textColor: AppColors.textOrange,
                  borderRadius: 6,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 15,
          child: AppAssets.icons.addProductBgOverlay.svg(
            height: 130.31,
            width: 137.68,
          ),
        ),
      ],
    );
  }

  Widget _buildAddProductCard({
    required Widget icon,
    required String title,
    required String subtitle,
    required String body,
    required void Function()? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderColor1, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 40),
        child: Column(
          children: [
            icon,
            const SizedBox(height: 25),
            Text(
              title,
              style: GoogleFonts.hind(
                color: AppColors.textDarkerGreen,
                fontWeight: FontWeight.w600,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
              subtitle,
              style: GoogleFonts.hind(
                color: AppColors.textBlackGrey,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
              body,
              style: GoogleFonts.hind(
                color: AppColors.textBodyText,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Add Product",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 48,
              borderRadius: 4,
              width: double.infinity,
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
