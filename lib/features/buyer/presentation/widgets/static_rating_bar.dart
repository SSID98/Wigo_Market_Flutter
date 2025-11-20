import 'package:flutter/material.dart';

import '../../../../gen/assets.gen.dart';

/// A read-only widget that displays a fixed rating using star icons.
class StaticRatingBar extends StatelessWidget {
  /// The fixed rating to display (e.g., 3.0 stars).
  final double rating;

  /// The maximum number of stars.
  final int starCount;

  const StaticRatingBar({super.key, required this.rating, this.starCount = 5});

  // Helper method to build a single star widget.
  Widget _buildStar(int index) {
    // The index starts at 0, representing the 1st star.
    final starNumber = index + 1;

    // Determine if the star should be filled (for static display, we can use fractional ratings)
    final isFilled = starNumber <= rating;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child:
          isFilled
              ? AppAssets.icons.star.svg(height: 19)
              : AppAssets.icons.starOutline.svg(height: 19),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) => _buildStar(index)),
    );
  }
}
