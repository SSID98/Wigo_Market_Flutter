import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: child,
    );
  }
}

class Block extends StatelessWidget {
  const Block({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.radius = 4,
    this.isCircle = false,
  });

  final double width;
  final double height;
  final double radius;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(radius),
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final int rowCount;
  final bool tallContent;

  const ShimmerCard({
    super.key,
    required this.rowCount,
    this.tallContent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Block(width: 140, height: 15),
          const SizedBox(height: 12),
          Container(height: 1, color: AppColors.backgroundWhite),
          const SizedBox(height: 12),
          ...List.generate(
            rowCount,
            (i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  const Block(width: 100, height: 12),
                  const SizedBox(width: 20),
                  Expanded(child: Block(height: tallContent ? 40 : 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
