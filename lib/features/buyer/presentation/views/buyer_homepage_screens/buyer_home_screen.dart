import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/constants/url.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_homepage_screens/popular_vendor_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_homepage_screens/product_categories_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_homepage_screens/products_you_like_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_homepage_screens/top_shops_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/widgets/self_delivery_card.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/auth/auth_state_notifier.dart';
import '../../../../../shared/models/login/login_response_model.dart';
import '../../../viewmodels/buyer_home_viewmodel.dart';
import 'close_shops_section.dart';

class BuyerHomeScreen extends ConsumerWidget {
  const BuyerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(buyerHomeViewModelProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          // if (state.isSearchFieldVisible)
          //   const SizedBox(height: 40),
          // const SizedBox(height: 10),
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
          ProductsYouLikeSection(products: state.allProducts),
          const SizedBox(height: 40),
          SelfDeliveryPromoCard(onPressed: () {}),
        ],
      ),
    );
  }
}
