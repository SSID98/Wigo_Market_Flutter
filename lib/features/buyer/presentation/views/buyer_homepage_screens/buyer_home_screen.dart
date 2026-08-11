import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_homepage_screens/popular_vendor_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_homepage_screens/product_categories_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_homepage_screens/products_you_like_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/views/buyer_homepage_screens/top_shops_section.dart';
import 'package:wigo_flutter/features/buyer/presentation/widgets/self_delivery_card.dart';

import '../../../../../gen/assets.gen.dart';
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
          Image.asset(AppAssets.images.sellYourProducts.path),
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
          SelfDeliveryPromoCard(),
        ],
      ),
    );
  }
}
