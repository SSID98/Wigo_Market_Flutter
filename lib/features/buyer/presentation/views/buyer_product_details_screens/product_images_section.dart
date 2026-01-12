import 'package:flutter/material.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

class ProductImagesSection extends StatelessWidget {
  final String imageUrl;

  const ProductImagesSection({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(10),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
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
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  height: isWeb ? 97 : 82,
                  width: isWeb ? 94 : 85,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.primaryLightGreen),
                  ),
                  child: Image.network(
                    imageUrl,
                    errorBuilder: (
                      BuildContext context,
                      Object exception,
                      StackTrace? stackTrace,
                    ) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: AppColors.textIconGrey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
