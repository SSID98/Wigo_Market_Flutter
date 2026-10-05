import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/order_details_widgets/buyer_note_widget.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/order_details_widgets/order_main_details_widget.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/order_details_widgets/order_timeline_widget.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/order_details_widgets/payment_information_widget.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../models/order_details_model.dart';
import '../../viewmodels/order_details_viewmodel.dart';
import '../widgets/order_shimmer.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(orderDetailProvider(orderId));
    final isWeb = context.isWeb;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? 40 : 16,
            vertical: isWeb ? 35 : 10,
          ),
          child: detailAsync.when(
            loading: () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 10),
                Expanded(child: OrderDetailShimmer(isWeb: isWeb)),
              ],
            ),
            error: (err, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                Expanded(child: _buildError(context, ref)),
              ],
            ),
            data: (detail) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 10),
                  isWeb ? _buildWebLayout(detail) : _buildMobileLayout(detail),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Couldn't load this order.",
            style: GoogleFonts.hind(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => ref.invalidate(orderDetailProvider(orderId)),
            child: Text(
              'Retry',
              style: GoogleFonts.hind(
                color: AppColors.primaryDarkGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(OrderDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        OrderMainDetailsCard(order: detail),
        BuyerNoteCard(note: detail.buyerNote),
        OrderTimelineCard(timeline: detail.timeline),
        PaymentInformationWidget(payment: detail.payment),
      ],
    );
  }

  Widget _buildWebLayout(OrderDetail detail) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: OrderMainDetailsCard(order: detail)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  PaymentInformationWidget(payment: detail.payment),
                  OrderTimelineCard(timeline: detail.timeline),
                  BuyerNoteCard(note: detail.buyerNote),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: AppAssets.icons.circleArrowLeft.svg(),
        ),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            'Order Detail',
            style: GoogleFonts.hind(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlackGrey,
            ),
          ),
        ),
      ],
    );
  }
}
