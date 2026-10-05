import 'package:flutter/material.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/earnings_table.dart';

import '../../../../shared/widgets/shimmer_widget.dart';

class EarningCardsShimmer extends StatelessWidget {
  const EarningCardsShimmer({super.key, required this.isWeb});

  final bool isWeb;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWeb ? 3 : 2,
        childAspectRatio: isWeb ? 1.8 : 1.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: isWeb ? 24 : 19,
      ),
      itemBuilder: (_, __) => _EarningCardSkeleton(isWeb: isWeb),
    );
  }
}

class _EarningCardSkeleton extends StatelessWidget {
  const _EarningCardSkeleton({required this.isWeb});

  final bool isWeb;

  Widget _bar(double widthFactor, double height, {double radius = 4}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Block(height: height, radius: radius),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isWeb ? 16 : 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Block(width: 17, height: 17, isCircle: true),
                const SizedBox(width: 8),
                Expanded(child: _bar(0.7, 12, radius: 3)),
              ],
            ),
            const Spacer(),
            _bar(0.75, isWeb ? 28 : 22, radius: 5),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class EarningTableShimmer extends StatelessWidget {
  const EarningTableShimmer({
    super.key,
    required this.isWeb,
    this.rowCount = 5,
  });

  final bool isWeb;
  final int rowCount;

  double _blockWidth(EarningsColumn column, {required bool header}) {
    final w = isWeb;
    switch (column) {
      case EarningsColumn.orderId:
        return header ? (w ? 65 : 55) : (w ? 90 : 70);
      case EarningsColumn.product:
        return header ? (w ? 85 : 75) : (w ? 150 : 110);
      case EarningsColumn.customer:
        return header ? (w ? 100 : 85) : (w ? 110 : 90);
      case EarningsColumn.date:
        return header ? (w ? 75 : 65) : (w ? 90 : 75);
      case EarningsColumn.amount:
        return header ? (w ? 95 : 85) : (w ? 80 : 70);
      case EarningsColumn.status:
        return header ? (w ? 50 : 45) : (w ? 78 : 70);
    }
  }

  Widget _cell(EarningsTableMetrics m, EarningsColumn column, Widget child) {
    return SizedBox(
      width: m.widthOf(column),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Align(alignment: Alignment.centerLeft, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metrics = EarningsTableMetrics(isWeb: isWeb);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: SizedBox(
        width: metrics.tableWidth,
        child: Column(
          children: [
            Container(
              height: EarningsTableMetrics.headerHeight,
              color: AppColors.backgroundLight,
              child: Row(
                children: [
                  for (final column in metrics.columns)
                    _cell(
                      metrics,
                      column,
                      AppShimmer(
                        child: Block(
                          width: _blockWidth(column, header: true),
                          height: 13,
                          radius: 3,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            for (var i = 0; i < rowCount; i++)
              Container(
                height: EarningsTableMetrics.rowHeight,
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.textIconGrey.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    for (final column in metrics.columns)
                      _cell(
                        metrics,
                        column,
                        AppShimmer(
                          child: column == EarningsColumn.status
                              ? Block(
                                  width: _blockWidth(column, header: false),
                                  height: 24,
                                  radius: 12,
                                )
                              : Block(
                                  width: _blockWidth(column, header: false),
                                  height: 13,
                                  radius: 3,
                                ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class RecentEarningsListShimmer extends StatelessWidget {
  const RecentEarningsListShimmer({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < itemCount; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 8,
              color: AppColors.backgroundWhite,
              shadowColor: AppColors.shadowColor.withValues(alpha: 0.23),
              child: SizedBox(
                height: 72,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AppShimmer(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Block(width: 28, height: 28, isCircle: true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Block(width: 60, height: 13, radius: 3),
                              SizedBox(height: 8),
                              Block(width: 110, height: 10, radius: 3),
                            ],
                          ),
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Block(width: 70, height: 14, radius: 3),
                            SizedBox(height: 8),
                            Block(width: 80, height: 22, radius: 6),
                          ],
                        ),
                      ],
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
