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
import 'package:wigo_flutter/gen/assets.gen.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/custom_search_field.dart';

import '../../../../../core/auth/auth_state_notifier.dart';
import '../../../../../shared/models/login/login_response_model.dart';
import '../../../viewmodels/buyer_home_viewmodel.dart';
import 'close_shops_section.dart';

class BuyerHomeScreen extends ConsumerStatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  ConsumerState<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends ConsumerState<BuyerHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref
          .read(buyerHomeViewModelProvider.notifier)
          .updateSearchQuery(_searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(buyerHomeViewModelProvider);
    final vmNotifier = ref.read(buyerHomeViewModelProvider.notifier);
    final isSearching = state.searchQuery.isNotEmpty;
    final isWeb = MediaQuery.of(context).size.width > 600;
    return PopScope(
      canPop: !state.isSearchFieldVisible && state.searchQuery.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          vmNotifier.resetSearch();
        }
      },
      child: Stack(
        children: [
          SingleChildScrollView(
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
                            searchQuery: state.searchQuery,
                            products: vmNotifier.filteredProducts,
                          )
                          : Column(
                            key: const ValueKey('home-content'),
                            children: [
                              if (state.isSearchFieldVisible)
                                const SizedBox(height: 40),
                              const SizedBox(height: 10),
                              CustomButton(
                                text: 'Test login',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                onPressed: () {
                                  ref
                                      .read(authStateProvider.notifier)
                                      .login(
                                        LoginResponseModel(
                                          id: 'dev-id',
                                          activeRole: 'buyer',
                                          token: 'fake-token',
                                          role: [],
                                          status: '',
                                        ),
                                      );
                                },
                              ),
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
                              ProductsYouLikeSection(
                                products: state.allProducts,
                              ),
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
          if (state.isSearchFieldVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomSearchField(searchController: _searchController),
              ),
            ),
        ],
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

// if (_searchQuery.isNotEmpty && !didPop) {
// setState(() {
// _searchQuery = '';
// _searchController.clear();
// });
// }

// void _showDropdownMenu(bool isMenu) {
//   final overlay = Overlay.of(context);
//
//   _overlayEntry1 = OverlayEntry(
//     builder:
//         (context) => Stack(
//           children: [
//             isMenu
//                 ? Positioned.fill(
//                   child: GestureDetector(
//                     onTap: _closeDropdownMenu,
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
//                       child: Container(
//                         color: Colors.black.withValues(alpha: 0.02),
//                       ),
//                     ),
//                   ),
//                 )
//                 : Positioned.fill(
//                   child: GestureDetector(
//                     onTap: _closeDropdownMenu,
//                     child: Container(color: Colors.transparent),
//                   ),
//                 ),
//
//             Positioned(
//               top: isMenu ? 60 : 90,
//               right: isMenu ? 16 : 120,
//               child: StatefulBuilder(
//                 builder: (context, setState) {
//                   return isMenu
//                       ? CustomDropdownMenu(
//                         onClose: _closeDropdownMenu,
//                         onCategoriesPress: () {
//                           setState(() {
//                             _showingCategories = !_showingCategories;
//                           });
//                         },
//                         showCategories: _showingCategories,
//                       )
//                       : UserDropDownMenu();
//                 },
//               ),
//             ),
//           ],
//         ),
//   );
//
//   overlay.insert(_overlayEntry1!);
// }
