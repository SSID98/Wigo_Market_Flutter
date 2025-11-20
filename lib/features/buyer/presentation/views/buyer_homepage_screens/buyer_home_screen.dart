import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/constants/url.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_homepage_screens/popular_vendor_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_homepage_screens/product_categories_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_homepage_screens/products_you_like_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_homepage_screens/top_shops_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/footer_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/search_results_view.dart';
import 'package:wigo_flutter/features/buyer/presentation/widgets/self_delivery_card.dart';
import 'package:wigo_flutter/features/buyer/presentation/widgets/user_dropdown_menu.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';
import 'package:wigo_flutter/shared/widgets/custom_search_field.dart';

import '../../../../../shared/widgets/dashboard_widgets/custom_app_bar.dart';
import '../../../models/product_model.dart';
import '../../widgets/custom_dropdown_menu.dart';
import 'close_shops_section.dart';

class BuyerHomeScreen extends ConsumerStatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  ConsumerState<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends ConsumerState<BuyerHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearchFieldVisible = false;

  final List<Product> _products = [
    Product(
      imageUrl: '$networkImageUrl/nintendo.png',
      amount: '10,027.61',
      slashedAmount: '12,053.69',
      productName: 'Nintendo Gaming Console',
      rating: 4.0,
      reviews: 67,
      categoryName: 'Gaming',
    ),
    Product(
      imageUrl: '$networkImageUrl/gamePad.png',
      amount: '10,027.61',
      slashedAmount: '12,053.69',
      productName: 'PS3 Game pad with type C USB',
      rating: 4.0,
      reviews: 67,
      categoryName: 'Gaming',
    ),
    Product(
      imageUrl: '$networkImageUrl/wristwatch.png',
      amount: '10,027.61',
      slashedAmount: '12,053.69',
      productName: 'Quartz Wrist Watch',
      rating: 4.0,
      reviews: 67,
      categoryName: 'Jewelry',
    ),
    Product(
      imageUrl: '$networkImageUrl/phones.png',
      amount: '10,027.61',
      slashedAmount: '12,053.69',
      productName: 'Small Button Phone',
      rating: 4.0,
      reviews: 67,
      categoryName: 'Gadgets',
    ),
    Product(
      imageUrl: '$networkImageUrl/Honey.png',
      amount: '10,027.61',
      slashedAmount: '12,053.69',
      productName: 'Special Honey',
      rating: 4.0,
      reviews: 67,
      categoryName: 'Beverages',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  OverlayEntry? _overlayEntry1;
  bool _showingCategories = false;

  void _showDropdownMenu(bool isMenu) {
    final overlay = Overlay.of(context);

    _overlayEntry1 = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              isMenu
                  ? Positioned.fill(
                    child: GestureDetector(
                      onTap: _closeDropdownMenu,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.02),
                        ),
                      ),
                    ),
                  )
                  : Positioned.fill(
                    child: GestureDetector(
                      onTap: _closeDropdownMenu,
                      child: Container(color: Colors.transparent),
                    ),
                  ),

              Positioned(
                top: isMenu ? 60 : 90,
                right: isMenu ? 16 : 120,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return isMenu
                        ? CustomDropdownMenu(
                          onClose: _closeDropdownMenu,
                          onCategoriesPress: () {
                            setState(() {
                              _showingCategories = !_showingCategories;
                            });
                          },
                          showCategories: _showingCategories,
                        )
                        : UserDropDownMenu();
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

  void _showSearchField() {
    setState(() {
      _isSearchFieldVisible = !_isSearchFieldVisible;

      if (!_isSearchFieldVisible) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _searchQuery.isNotEmpty;
    final isWeb = MediaQuery.of(context).size.width > 600;
    return PopScope(
      canPop: !_isSearchFieldVisible && _searchQuery.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() {
            if (_searchQuery.isNotEmpty) {
              _searchQuery = '';
              _searchController.clear();
              _isSearchFieldVisible = false;
            } else if (_isSearchFieldVisible) {
              _isSearchFieldVisible = false;
            }
          });
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.backgroundWhit,
            appBar: CustomAppBar(
              isWeb: isWeb,
              isBuyer: true,
              onUserPress: () {
                _showDropdownMenu(false);
              },
              onMobileMenuPress: () {
                _showDropdownMenu(true);
              },
              onMobileSearchPress: _showSearchField,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isWeb) _webHeader(isWeb),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child:
                        isSearching
                            ? SearchResultsView(
                              searchQuery: _searchQuery,
                              products: _products,
                            )
                            : Column(
                              children: [
                                if (_isSearchFieldVisible)
                                  const SizedBox(height: 30),
                                const SizedBox(height: 10),
                                Image.network(
                                  '$networkImageUrl/sellYourProducts.png',
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
                                const SizedBox(height: 25),
                                TopShopsSection(),
                                const SizedBox(height: 20),
                                ProductCategoriesSection(),
                                const SizedBox(height: 20),
                                CloseShopSection(),
                                const SizedBox(height: 20),
                                PopularVendorsSection(),
                                const SizedBox(height: 20),
                                ProductsYouLikeSection(products: _products),
                                const SizedBox(height: 40),
                                SelfDeliveryPromoCard(onPressed: () {}),
                              ],
                            ),
                  ),
                  const SizedBox(height: 30),
                  FooterSection(),
                ],
              ),
            ),
          ),
          if (_isSearchFieldVisible)
            Positioned(
              top: 97,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomSearchField(
                  searchController: _searchController,
                  // Ensure you add the onChanged handler here!
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget _buildFooter(bool isWeb) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Image.network(
  //         '$networkImageUrl/logo3.png',
  //         errorBuilder: (
  //           BuildContext context,
  //           Object exception,
  //           StackTrace? stackTrace,
  //         ) {
  //           return const Center(
  //             child: Icon(
  //               Icons.broken_image,
  //               color: AppColors.textIconGrey,
  //               size: 50.0,
  //             ),
  //           );
  //         },
  //       ),
  //       const SizedBox(height: 20),
  //       _buildTextProperties(
  //         'Empowering campus communities through smart commerce and Easy Buying and Selling.',
  //         isWeb,
  //         isBodyText: true,
  //       ),
  //       const SizedBox(height: 30),
  //       _buildTextProperties('Latest', isWeb),
  //       const SizedBox(height: 10),
  //       _buildTextProperties('Orders', isWeb),
  //       const SizedBox(height: 30),
  //       _buildTextProperties('Privacy Policy', isWeb),
  //       const SizedBox(height: 10),
  //       _buildTextProperties('Cookie Policy', isWeb),
  //       const SizedBox(height: 10),
  //       _buildTextProperties('Refund Policy', isWeb),
  //       const SizedBox(height: 30),
  //       _buildTextProperties('About Us', isWeb),
  //       const SizedBox(height: 10),
  //       _buildTextProperties('Support', isWeb),
  //       const SizedBox(height: 10),
  //       _buildTextProperties('For Riders', isWeb),
  //       const SizedBox(height: 10),
  //       _buildTextProperties('Become A Seller', isWeb),
  //       const SizedBox(height: 20),
  //       Divider(),
  //       _buildTextProperties(
  //         '© 2025 wiGO MARKET. All rights reserved.',
  //         isWeb,
  //         isBodyText: true,
  //       ),
  //       const SizedBox(height: 10),
  //       Padding(
  //         padding: EdgeInsets.only(right: 150.0, bottom: 20),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             AppAssets.icons.greenFacebook.svg(
  //               height: isWeb ? 50 : 34,
  //               width: isWeb ? 50 : 34,
  //             ),
  //             AppAssets.icons.x.svg(
  //               height: isWeb ? 50 : 34,
  //               width: isWeb ? 50 : 34,
  //             ),
  //             AppAssets.icons.instagram.svg(
  //               height: isWeb ? 50 : 34,
  //               width: isWeb ? 50 : 34,
  //             ),
  //             AppAssets.icons.linkedin.svg(
  //               height: isWeb ? 50 : 34,
  //               width: isWeb ? 50 : 34,
  //             ),
  //             AppAssets.icons.youtube.svg(
  //               height: isWeb ? 50 : 34,
  //               width: isWeb ? 50 : 34,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

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

// if (_searchQuery.isNotEmpty && !didPop) {
// setState(() {
// _searchQuery = '';
// _searchController.clear();
// });
// }
