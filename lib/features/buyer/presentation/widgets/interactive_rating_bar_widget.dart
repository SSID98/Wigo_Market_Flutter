import 'package:flutter/material.dart';

import '../../../../gen/assets.gen.dart';

class InteractiveRatingBar extends StatefulWidget {
  /// The initial rating to display (e.g., 3.0 stars).
  final double initialRating;

  /// The maximum number of stars (e.g., 5).
  final int starCount;

  /// Callback function triggered when the user taps a star.
  /// It returns the new integer rating (1 to starCount).
  final ValueChanged<int> onRatingChanged;

  const InteractiveRatingBar({
    super.key,
    this.initialRating = 0,
    this.starCount = 5,
    required this.onRatingChanged,
  });

  @override
  State<InteractiveRatingBar> createState() => _InteractiveRatingBarState();
}

class _InteractiveRatingBarState extends State<InteractiveRatingBar> {
  // Current rating is stored as an integer because the user taps whole stars.
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    // Initialize current rating based on the initial rating provided (rounded).
    _currentRating = widget.initialRating.round();
  }

  // Helper method to build a single star widget.
  Widget _buildStar(int index) {
    // The index starts at 0, representing the 1st star.
    final starNumber = index + 1;

    // Determine if the star should be filled based on the current rating.
    final isFilled = starNumber <= _currentRating;

    // Use GestureDetector to handle the tap for interactive rating.
    return GestureDetector(
      onTap: () {
        // 1. Update the local state
        setState(() {
          _currentRating = starNumber;
        });
        // 2. Notify the parent widget of the change
        widget.onRatingChanged(_currentRating);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child:
            isFilled
                ? AppAssets.icons.star.svg(height: 19)
                : AppAssets.icons.starOutline.svg(height: 19),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      // Create a list of stars based on starCount
      children: List.generate(widget.starCount, (index) => _buildStar(index)),
    );
  }
}
