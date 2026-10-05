import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../models/order.dart';
import '../../../navigation/seller_tab_navigation.dart';
import '../../../viewmodels/recent_orders_live_viewmodel.dart';
import '../order_shimmer.dart';
import '../order_table.dart';

class RecentOrdersWidget extends ConsumerWidget {
  const RecentOrdersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = context.isWeb;
    final recentOrders = ref.watch(recentOrdersLiveProvider);

    final cardHeight = isWeb ? 290.0 : 380.0;

    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(10),
      child: SizedBox(
        height: cardHeight,
        width: double.infinity,
        child: Card(
          shadowColor: Colors.white70.withValues(alpha: 0.06),
          color: AppColors.backgroundWhite,
          elevation: 1,
          margin: EdgeInsets.only(top: isWeb ? 18 : 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: 9,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Orders",
                          style: GoogleFonts.hind(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: AppColors.textBlackGrey,
                          ),
                        ),
                        if (recentOrders.value != null &&
                            recentOrders.value!.isNotEmpty)
                          InkWell(
                            onTap: () => goToSellerTab(ref, SellerTab.orders),
                            child: Text(
                              "View all",
                              style: GoogleFonts.hind(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textOrange,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.textOrange,
                                decorationThickness: 1.3,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Review and manage your most recent orders quickly.",
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildBody(ref, isWeb, recentOrders)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    WidgetRef ref,
    bool isWeb,
    AsyncValue<List<Order>> recentOrders,
  ) {
    return recentOrders.when(
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: OrderTableShimmer(isWeb: isWeb, isExpanded: false, rowCount: 3),
      ),
      error: (err, _) => Center(
        child: Text(
          "Couldn't load recent orders.",
          style: GoogleFonts.hind(fontSize: 14, color: AppColors.textBodyText),
        ),
      ),
      data: (orders) {
        if (orders.isEmpty) {
          return _buildEmptyState(ref, isWeb);
        }
        return ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: OrderTable(orders: orders),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(WidgetRef ref, bool isWeb) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 350 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssets.images.taskEmpty.path),
          const SizedBox(height: 20.0),
          Text(
            "No Orders Yet",
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Your recent orders will show up here once customers start buying from your store. Stay ready!',
            textAlign: TextAlign.center,
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.textBodyText,
            ),
          ),
          const SizedBox(height: 25.0),
        ],
      ),
    );
  }
}
