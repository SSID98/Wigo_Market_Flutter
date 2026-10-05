import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../navigation/seller_tab_navigation.dart';
import '../../views/add_product_screen.dart';
import '../quick_action_card.dart';

const _tapHighlightDuration = Duration(milliseconds: 180);

class QuickActionWidget extends ConsumerStatefulWidget {
  const QuickActionWidget({super.key});

  @override
  ConsumerState<QuickActionWidget> createState() => _QuickActionWidgetState();
}

class _QuickActionWidgetState extends ConsumerState<QuickActionWidget> {
  int? _tappedIndex;

  Future<void> _handleTap(int index, VoidCallback navigate) async {
    setState(() => _tappedIndex = index);
    await Future.delayed(_tapHighlightDuration);
    if (!mounted) return;
    setState(() => _tappedIndex = null);
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = context.isWeb;
    return Container(
      height: 170,
      margin: EdgeInsets.only(top: isWeb ? 18 : 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white70.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isWeb ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Action',
              style: GoogleFonts.hind(
                fontSize: isWeb ? 20 : 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 17),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  QuickActionCard(
                    text: 'Add New Product',
                    isSelected: _tappedIndex == 0,
                    onTap: () => _handleTap(
                      0,
                      () => pushOnSellerTab(
                        ref,
                        SellerTab.products,
                        (_) => const AddProductScreen(),
                      ),
                    ),
                    icon: AppAssets.icons.recentDeliveries.svg(),
                    borderColor: AppColors.textPurple,
                  ),
                  QuickActionCard(
                    text: 'Manage Orders',
                    isSelected: _tappedIndex == 1,
                    onTap: () => _handleTap(
                      1,
                      () => goToSellerTab(ref, SellerTab.orders),
                    ),
                    icon: AppAssets.icons.quickActionCart.svg(),
                    borderColor: AppColors.radioBlue,
                  ),
                  QuickActionCard(
                    text: 'Manage Inventory',
                    isSelected: _tappedIndex == 2,
                    onTap: () => _handleTap(
                      2,
                      () => goToSellerTab(ref, SellerTab.products),
                    ),
                    icon: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xffD85583).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(67.14),
                      ),
                      child: Center(
                        child: AppAssets.icons.manageInventory.svg(),
                      ),
                    ),
                    borderColor: AppColors.textPink,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
