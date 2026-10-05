import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/shimmer_widget.dart';

class OrderTableShimmer extends StatelessWidget {
  const OrderTableShimmer({
    super.key,
    required this.isWeb,
    this.isExpanded = true,
    this.rowCount = 6,
  });

  final bool isWeb;
  final bool isExpanded;
  final int rowCount;

  double get orderIdWidth => isWeb ? 180.0 : 130.0;

  double get orderDateWidth => isWeb ? 180.0 : 130.0;

  double get customerWidth => isWeb ? 200.0 : 150.0;

  double get itemWidth => isWeb ? 130.0 : 80.0;

  double get amountWidth => isWeb ? 160.0 : 110.0;

  double get deliveryWidth => isWeb ? 200.0 : 150.0;

  double get statusWidth => isWeb ? 130.0 : 80.0;

  double get actionWidth => isWeb ? 130.0 : 100.0;

  double get tableWidth {
    return orderIdWidth +
        orderDateWidth +
        customerWidth +
        itemWidth +
        amountWidth +
        (isExpanded ? deliveryWidth : 0) +
        statusWidth +
        (isExpanded ? actionWidth : 0);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: tableWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(),

            ...List.generate(rowCount, (index) => _buildDataRow(index)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.tableHeader,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          _buildHeaderCell(width: orderIdWidth, blockWidth: isWeb ? 75 : 60),

          _buildHeaderCell(width: orderDateWidth, blockWidth: isWeb ? 85 : 65),

          _buildHeaderCell(width: customerWidth, blockWidth: isWeb ? 85 : 70),

          _buildHeaderCell(width: itemWidth, blockWidth: isWeb ? 35 : 25),

          _buildHeaderCell(width: amountWidth, blockWidth: isWeb ? 60 : 50),

          if (isExpanded)
            _buildHeaderCell(
              width: deliveryWidth,
              blockWidth: isWeb ? 105 : 80,
            ),

          _buildHeaderCell(width: statusWidth, blockWidth: isWeb ? 55 : 45),

          if (isExpanded)
            _buildHeaderCell(width: actionWidth, blockWidth: isWeb ? 55 : 45),
        ],
      ),
    );
  }

  Widget _buildHeaderCell({required double width, required double blockWidth}) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: AppShimmer(
            child: Block(width: blockWidth, height: 13, radius: 3),
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(int index) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border(
          bottom: BorderSide(
            color: AppColors.textIconGrey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTextCell(width: orderIdWidth, blockWidth: isWeb ? 105 : 85),

          _buildTextCell(width: orderDateWidth, blockWidth: isWeb ? 90 : 70),

          _buildTextCell(width: customerWidth, blockWidth: isWeb ? 120 : 90),

          _buildTextCell(width: itemWidth, blockWidth: isWeb ? 55 : 40),

          _buildTextCell(width: amountWidth, blockWidth: isWeb ? 85 : 70),

          if (isExpanded)
            _buildTextCell(width: deliveryWidth, blockWidth: isWeb ? 95 : 75),

          _buildStatusCell(),

          if (isExpanded) _buildActionCell(),
        ],
      ),
    );
  }

  Widget _buildTextCell({required double width, required double blockWidth}) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AppShimmer(
          child: Block(width: blockWidth, height: 13, radius: 3),
        ),
      ),
    );
  }

  Widget _buildStatusCell() {
    return SizedBox(
      width: statusWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: AppShimmer(
            child: Block(width: isWeb ? 78 : 62, height: 26, radius: 13),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCell() {
    return SizedBox(
      width: actionWidth,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: AppShimmer(
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: const Center(child: Block(width: 4, height: 14, radius: 2)),
          ),
        ),
      ),
    );
  }
}

class OrderDetailShimmer extends StatelessWidget {
  const OrderDetailShimmer({super.key, required this.isWeb});

  final bool isWeb;

  Widget _card({required double height}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Block(width: 140, height: 18),
          SizedBox(height: 16),
          Block(height: 14),
          SizedBox(height: 10),
          Block(width: 220, height: 14),
          SizedBox(height: 10),
          Block(width: 160, height: 14),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerBlock = AppShimmer(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: const [
            Block(width: 28, height: 28, isCircle: true),
            SizedBox(width: 12),
            Block(width: 140, height: 20),
          ],
        ),
      ),
    );

    final body = AppShimmer(
      child: isWeb
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _card(height: 420)),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      _card(height: 160),
                      _card(height: 260),
                      _card(height: 140),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                _card(height: 320),
                _card(height: 140),
                _card(height: 220),
                _card(height: 140),
              ],
            ),
    );

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 40 : 16,
        vertical: isWeb ? 35 : 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [headerBlock, const SizedBox(height: 10), body],
      ),
    );
  }
}
