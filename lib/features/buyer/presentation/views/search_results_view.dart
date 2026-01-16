import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/url.dart';
import '../../viewmodels/buyer_home_viewmodel.dart';
import '../widgets/product_card.dart';

String normalizeText(String text) {
  return removeDiacritics(text).toLowerCase();
}

class SearchResultsView extends ConsumerWidget {
  final String searchQuery;

  // final List<Product> products;

  const SearchResultsView({
    super.key,
    required this.searchQuery,
    // required this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    final results = ref
        .read(buyerHomeViewModelProvider.notifier)
        .searchProducts(searchQuery);
    // final normalizedQuery = normalizeText(searchQuery);
    // final filtered =
    //     products
    //         .where(
    //           (p) => normalizeText(p.productName).contains(normalizedQuery),
    //         )
    //         .toList();

    if (results.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Results for “$searchQuery”',
            style: GoogleFonts.hind(
              fontSize: isWeb ? 32 : 20,
              fontWeight: isWeb ? FontWeight.w500 : FontWeight.w600,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Image.network(
              '$networkImageUrl/searchFailed.png',
              height: isWeb ? 237 : 137,
              width: isWeb ? 321 : 185,
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
          ),
          if (!isWeb) const SizedBox(height: 10),
          Center(
            child: Text(
              'Something Went Wrong',
              style: GoogleFonts.hind(
                fontSize: isWeb ? 40 : 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlackGrey,
              ),
            ),
          ),
          SizedBox(height: isWeb ? 10 : 20),
          Center(
            child: Text(
              'We can’t find the item you are looking for.',
              style: GoogleFonts.hind(
                fontSize: isWeb ? 24 : 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textBlackGrey,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'Results for “$searchQuery”',
          style: GoogleFonts.hind(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: results.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? 5 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final product = results[index];
            return ProductCard(product: product);
          },
        ),
      ],
    );
  }
}
