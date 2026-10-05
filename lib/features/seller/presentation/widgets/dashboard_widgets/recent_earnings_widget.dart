import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/constants/dashboard_helpers.dart';
import 'package:wigo_flutter/features/seller/models/seller_earnings_models.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/earning_status_chip.dart';
import 'package:wigo_flutter/features/seller/viewmodels/recent_earnings_viewmodel.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';

import '../../../../../core/utils/context_extensions.dart';
import '../../../models/earnings_formatters.dart';
import '../earnings_shimmer.dart';

class RecentEarningsWidget extends ConsumerWidget {
  const RecentEarningsWidget({super.key});

  static const double _webHeight = 893;
  static const double _emptyMobileHeight = 353;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recentEarningsViewModelProvider);
    final isWeb = context.isWeb;

    return state.when(
      loading: () => _shell(
        isWeb: isWeb,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_title(), const RecentEarningsListShimmer(itemCount: 5)],
        ),
      ),
      error: (error, _) => _shell(
        isWeb: isWeb,
        height: isWeb ? _webHeight : _emptyMobileHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(),
            Expanded(
              child: _buildError(
                error is String
                    ? error
                    : 'Something went wrong. Please try again.',
                () => ref
                    .read(recentEarningsViewModelProvider.notifier)
                    .refresh(),
              ),
            ),
          ],
        ),
      ),
      data: (earnings) {
        if (earnings.isEmpty) {
          return _shell(
            isWeb: isWeb,
            height: isWeb ? _webHeight : _emptyMobileHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_title(), _buildEmpty()],
            ),
          );
        }

        return _shell(
          isWeb: isWeb,
          height: isWeb ? _webHeight : null,
          child: Column(
            mainAxisSize: isWeb ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title(),
              if (isWeb)
                Expanded(child: _buildList(earnings, isWeb, shrink: false))
              else
                _buildList(earnings, isWeb, shrink: true),
              if (!isWeb) const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _shell({required bool isWeb, required Widget child, double? height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: height,
        child: Card(
          shadowColor: Colors.white70.withValues(alpha: 0.06),
          color: AppColors.backgroundWhite,
          elevation: 1,
          margin: EdgeInsets.only(top: isWeb ? 18 : 12),
          child: child,
        ),
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        'Recent Earning',
        style: GoogleFonts.hind(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: AppColors.textBlackGrey,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Column(
          children: [
            AppAssets.icons.earningHistory.svg(),
            const SizedBox(height: 5),
            AppAssets.icons.ellipse.svg(),
            const SizedBox(height: 23.0),
            Text(
              'No Earning yet.',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Once you start selling or receive your first payout, your transaction history will show up here.',
                textAlign: TextAlign.center,
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.textBodyText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 36,
              color: AppColors.textRed,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.hind(
                fontSize: 14,
                color: AppColors.textBodyText,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                'Try again',
                style: GoogleFonts.hind(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    List<RecentEarning> earnings,
    bool isWeb, {
    required bool shrink,
  }) {
    return ListView.builder(
      shrinkWrap: shrink,
      physics: shrink ? const NeverScrollableScrollPhysics() : null,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: earnings.length,
      itemBuilder: (context, index) => _buildItem(earnings[index], isWeb),
    );
  }

  Widget _buildItem(RecentEarning earning, bool isWeb) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 8,
      color: AppColors.backgroundWhite,
      shadowColor: AppColors.shadowColor.withValues(alpha: 0.23),
      child: ListTile(
        horizontalTitleGap: 10,
        leading: Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: AppColors.primaryLightGreen,
            borderRadius: BorderRadius.circular(29.87),
          ),
          child: Center(
            child: AppAssets.icons.totalSale.svg(
              colorFilter: const ColorFilter.mode(
                AppColors.primaryDarkGreen,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        title: Text(
          earning.title,
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w500,
            color: AppColors.textBlackGrey,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              earning.earnedAt == null
                  ? '—'
                  : formatDateWithTime(earning.earnedAt!),
              style: GoogleFonts.hind(
                fontSize: 12,
                color: AppColors.textIconGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatNaira(earning.amount),
              style: GoogleFonts.notoSans(
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackGrey,
                fontSize: 14,
              ),
            ),
            SizedBox(height: isWeb ? 4 : 10),
            EarningStatusChip.card(
              status: earning.status,
              label: earning.statusLabel,
            ),
          ],
        ),
      ),
    );
  }
}
