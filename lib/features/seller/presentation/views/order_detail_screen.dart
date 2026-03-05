import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/order_details_widgets/buyer_note_widget.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/order_details_widgets/order_main_details_widget.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/order_details_widgets/order_timeline_widget.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/order_details_widgets/payment_information_widget.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../models/order.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb
        ? _buildWebLayout(screenSize, context)
        : _buildMobileLayout(screenSize, context);
  }

  Widget _buildMobileLayout(Size screenSize, BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              _buildHeader(context),
              const SizedBox(height: 10),
              OrderMainDetailsCard(orders: order),
              BuyerNoteCard(),
              OrderTimelineCard(),
              PaymentInformationWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebLayout(Size screenSize, BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 35),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                const SizedBox(height: 10.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: OrderMainDetailsCard(orders: order),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          PaymentInformationWidget(),
                          OrderTimelineCard(),
                          BuyerNoteCard(),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
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
