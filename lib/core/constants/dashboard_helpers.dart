import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';

import '../../features/rider/presentation/widgets/account_setup_status_widget.dart';
import 'app_colors.dart';

String statusText(SetupStatus s) {
  switch (s) {
    case SetupStatus.completed:
      return 'Completed';
    case SetupStatus.pending:
      return 'Pending';
    // case SetupStatus.inReview:
    //   return 'In review';
    // case SetupStatus.rejected:
    //   return 'Rejected';
  }
}

Widget statusIcon(SetupStatus s) {
  switch (s) {
    case SetupStatus.completed:
      return AppAssets.icons.statusChip2.svg(
        height: kIsWeb ? 16 : 11.27,
        width: kIsWeb ? 16 : 11.27,
      );
    case SetupStatus.pending:
      return AppAssets.icons.statusChip1.svg(
        height: kIsWeb ? 16 : 11.27,
        width: kIsWeb ? 16 : 11.27,
      );
    // case SetupStatus.inReview:
    //   return 'In review';
    // case SetupStatus.rejected:
    //   return 'Rejected';
  }
}

class StatusPalette {
  final Color bg;

  const StatusPalette(this.bg);
}

StatusPalette statusColors(SetupStatus s) {
  switch (s) {
    case SetupStatus.completed:
      return StatusPalette(AppColors.primaryDarkGreen);
    case SetupStatus.pending:
      return StatusPalette(AppColors.buttonOrange);
    // case SetupStatus.inReview:
    //   return StatusPalette(Colors.blue, Colors.blue.shade700);
    // case SetupStatus.rejected:
    //   return StatusPalette(Colors.red, Colors.red.shade600);
  }
}

String formatDate(DateTime date) {
  final dayFormatter = DateFormat('d');
  final monthFormatter = DateFormat('MMM');
  final yearFormatter = DateFormat('yyyy');
  final day = int.parse(dayFormatter.format(date));
  String suffix = 'th';
  if (day == 1 || day == 21 || day == 31) {
    suffix = 'st';
  } else if (day == 2 || day == 22) {
    suffix = 'nd';
  } else if (day == 3 || day == 23) {
    suffix = 'rd';
  }
  return '${monthFormatter.format(date)} $day$suffix, ${yearFormatter.format(date)}';
}

String formatDateWithTime(DateTime date) {
  final dateFormatter = DateFormat('MMM d, yyyy');
  final timeFormatter = DateFormat('h:mma').format(date).toLowerCase();
  return '${dateFormatter.format(date)} | $timeFormatter';
}

String formatAmount(double amount) {
  final formatter = NumberFormat('#,###', 'en_US');
  return '₦${formatter.format(amount)}';
}
