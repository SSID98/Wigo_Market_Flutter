import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/seller/presentation/widgets/order_table.dart';
import 'package:wigo_flutter/features/seller/viewmodels/order_task_viewmodel.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/url.dart';

class RecentOrdersWidget extends ConsumerWidget {
  const RecentOrdersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    final orderTaskState = ref.watch(orderTaskProvider);

    return orderTaskState.orders.when(
      data: (orders) {
        final double cardHeight =
            orders.isEmpty
                ? isWeb
                    ? 420
                    : 400.0
                : isWeb
                ? 290
                : 336.0;
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
                  if (orders.isEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16, 0),
                      child: Text(
                        "Recent Orders",
                        style: GoogleFonts.hind(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: AppColors.textBlackGrey,
                        ),
                      ),
                    )
                  else
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
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  "View all",
                                  style: GoogleFonts.hind(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        color: AppColors.textOrange,
                                        offset: Offset(0, -2),
                                      ),
                                    ],
                                    color: Colors.transparent,
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
                  if (orders.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 350 : 40,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.network(
                            '$networkImageUrl/taskEmpty.png',
                            errorBuilder: (
                              BuildContext context,
                              Object exception,
                              StackTrace? stackTrace,
                            ) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: AppColors.textIconGrey,
                                  size: 50.0,
                                ),
                              );
                            },
                          ),
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
                          CustomButton(
                            text: 'Add product',
                            onPressed: () {},
                            prefixIcon: Icon(
                              CupertinoIcons.plus_circle,
                              color: AppColors.backgroundWhite,
                            ),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            height: 48.0,
                            padding: EdgeInsets.zero,
                            width: 251,
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: ListView(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: OrderTable(orders: orders),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    );
  }
}
