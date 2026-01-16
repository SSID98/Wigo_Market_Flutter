import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  final double height;
  final double dashHeight;
  final double dashSpacing;
  final Color color;
  final int dashCount;

  const DashedLine({
    super.key,
    this.height = 40,
    this.dashHeight = 4,
    this.dashSpacing = 4,
    this.dashCount = 12,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    // final dashCount = (height / (dashHeight + dashSpacing)).floor();
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        children: List.generate(dashCount, (_) {
          return Container(
            width: 1,
            height: dashHeight,
            color: color,
            margin: EdgeInsets.only(bottom: dashSpacing),
          );
        }),
      ),
    );
  }
}
