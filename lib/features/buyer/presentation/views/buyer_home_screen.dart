import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/constants/url.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/close_shops_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/popular_vendor_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/product_categories_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/products_you_like_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/top_shops_section.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';

import '../../../../shared/widgets/dashboard_widgets/custom_app_bar.dart';
import '../widgets/categories_dropdown_menu.dart';
import '../widgets/custom_dropdown_menu.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  OverlayEntry? _overlayEntry1;
  bool _showingCategories = false;

  void _showDropdownMenu() {
    final overlay = Overlay.of(context);

    _overlayEntry1 = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeDropdownMenu,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                    child: Container(
                      color: Colors.black.withValues(
                        alpha: 0.02,
                      ), // optional dim
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 60,
                right: 16,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return CustomDropdownMenu(
                      onClose: _closeDropdownMenu,
                      onCategoriesPress: () {
                        setState(() {
                          _showingCategories = !_showingCategories;
                        });
                      },
                      showCategories: _showingCategories,
                    );
                  },
                ),
              ),
            ],
          ),
    );

    overlay.insert(_overlayEntry1!);
  }

  void _closeDropdownMenu() {
    _overlayEntry1?.remove();
    _overlayEntry1 = null;
  }

  void _showCategoriesDropdown() {
    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Positioned.fill(
              //   child: GestureDetector(
              //     onTap: _closeCategoryDropdownMenu,
              //     child: BackdropFilter(
              //       filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              //       child: Container(
              //         color: Colors.black.withValues(alpha: 0.02),
              //       ),
              //     ),
              //   ),
              // ),
              Positioned(
                bottom: 50,
                right: 16,
                child: CategoriesDropdownMenu(),
              ),
            ],
          ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      backgroundColor: AppColors.backgroundWhit,
      appBar: CustomAppBar(
        isWeb: isWeb,
        isBuyer: true,
        onMenuPress: _showDropdownMenu,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isWeb) _webHeader(isWeb),
            const SizedBox(height: 10),
            Image.network('$networkImageUrl/sellYourProducts.png'),
            const SizedBox(height: 25),
            TopShopsSection(),
            const SizedBox(height: 20),
            ProductCategoriesSection(),
            const SizedBox(height: 20),
            CloseShopSection(),
            const SizedBox(height: 20),
            PopularVendorsSection(),
            const SizedBox(height: 20),
            ProductsYouLikeSection(),
            const SizedBox(height: 40),
            Image.network('$networkImageUrl/selfDelivery.png'),
            const SizedBox(height: 30),
            Image.network('$networkImageUrl/logo3.png'),
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
        ),
      ),
    );
  }

  Widget _webHeader(bool isWeb) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTextProperties('Latest', isWeb, isBottomText: false),
        Row(
          children: [
            _buildTextProperties('Categories', isWeb, isBottomText: false),
            const SizedBox(width: 5),
            AppAssets.icons.arrowDown.svg(),
          ],
        ),
        _buildTextProperties('Support', isWeb, isBottomText: false),
        _buildTextProperties('Become a Seller', isWeb, isBottomText: false),
        _buildTextProperties('For Riders', isWeb, isBottomText: false),
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
