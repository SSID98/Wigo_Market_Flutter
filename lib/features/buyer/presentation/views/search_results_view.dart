// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../../core/constants/app_colors.dart';
// import '../../models/product_model.dart';
// import '../widgets/product_card.dart';
//
// class SearchResultsView extends StatelessWidget {
//   final String searchQuery;
//   final List<Product> products;
//
//   const SearchResultsView({
//     super.key,
//     required this.searchQuery,
//     required this.products,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final isWeb = MediaQuery.of(context).size.width > 800;
//
//     // Filter products by name
//     final filtered =
//         products
//             .where(
//               (p) => p.productName.toLowerCase().contains(
//                 searchQuery.toLowerCase(),
//               ),
//             )
//             .toList();
//
//     if (filtered.isEmpty) {
//       return Center(
//         child: Text(
//           'No results found for "$searchQuery"',
//           style: GoogleFonts.hind(fontSize: 16, color: AppColors.textBlackGrey),
//         ),
//       );
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Heading
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Text(
//             'Results for "$searchQuery"',
//             style: GoogleFonts.hind(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: AppColors.textBlack,
//             ),
//           ),
//         ),
//
//         // Grid layout
//         Expanded(
//           child: GridView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             itemCount: filtered.length,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: isWeb ? 5 : 2,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 0.8,
//             ),
//             itemBuilder: (context, index) {
//               final product = filtered[index];
//               return ProductCard(product: product);
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
