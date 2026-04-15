import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  bool get isWeb => width > 800;

  bool get isMobile => width <= 500;

  bool get isTablet => width > 500 && width <= 800;
}
