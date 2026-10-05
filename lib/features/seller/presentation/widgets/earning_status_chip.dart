import 'package:flutter/material.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/widgets/dashboard_widgets/status_chip.dart';

import '../../models/seller_earnings_models.dart';

class EarningStatusChip extends StatelessWidget {
  const EarningStatusChip.table({
    super.key,
    required this.status,
    required this.label,
  }) : _isCard = false;

  const EarningStatusChip.card({
    super.key,
    required this.status,
    required this.label,
  }) : _isCard = true;

  final EarningStatus status;
  final String label;
  final bool _isCard;

  (Color, Color) _colors() {
    final alpha = _isCard ? 0.1 : 0.15;
    switch (status) {
      case EarningStatus.paid:
        return (
          AppColors.textStatusGreen,
          AppColors.textStatusGreen.withValues(alpha: alpha),
        );
      case EarningStatus.partiallyRefunded:
        const orange = Color(0xffE08D40);
        return (orange, orange.withValues(alpha: alpha));
      case EarningStatus.refunded:
        return (AppColors.textRed, AppColors.textRed.withValues(alpha: alpha));
      case EarningStatus.unknown:
        return (
          AppColors.textBlackGrey,
          AppColors.textIconGrey.withValues(alpha: 0.1),
        );
    }
  }

  double get _width => label.length > 11 ? 124 : 80;

  @override
  Widget build(BuildContext context) {
    final (textColor, containerColor) = _colors();

    if (_isCard) {
      return StatusChip(
        width: _width,
        alignment: Alignment.center,
        statusColor: textColor,
        containerColor: containerColor,
        status: label,
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: _width,
        child: StatusChip(
          statusColor: textColor,
          containerColor: containerColor,
          status: label,
          borderRadius: 4.5,
          topPadding: 1.5,
        ),
      ),
    );
  }
}
