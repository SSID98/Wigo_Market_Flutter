import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';

import '../../../../../../gen/assets.gen.dart';
import '../../../../models/faqitem_class.dart';
import '../../../../viewmodels/faq_viewmodel.dart';

final expandedTileProvider = StateProvider.family<bool, int>(
  (ref, index) => false,
);

class FaqPage extends ConsumerWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqs = ref.watch(faqsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Frequently Asked Question",
          style: GoogleFonts.hind(
            fontSize: context.isWeb ? 28 : 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Find quick answers to common questions about selling on WiGo Market.",
          style: GoogleFonts.hind(
            fontSize: context.isWeb ? 18 : 14,
            color: AppColors.textBlackGrey,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 20),
        // The actual list
        ...faqs.asMap().entries.map((entry) {
          final index = entry.key;
          final faq = entry.value;
          return _buildExpansionCard(faq, context.isWeb, ref, index);
        }),
      ],
    );
  }

  Widget _buildExpansionCard(
    FAQItem faq,
    bool isWeb,
    WidgetRef ref,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhitish,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: faq.isExpanded
              ? AppColors.primaryDarkGreen
              : AppColors.borderColor,
        ),
      ),
      child: ExpansionTile(
        minTileHeight: faq.isExpanded ? 0 : null,
        initiallyExpanded: faq.isExpanded,
        childrenPadding: const EdgeInsets.only(left: 32, right: 10, bottom: 10),
        trailing: faq.isExpanded
            ? Icon(Icons.keyboard_arrow_up_rounded)
            : Icon(Icons.keyboard_arrow_down_rounded),
        shape: const Border(),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4.2),
              child: AppAssets.icons.diamondBullet.svg(
                width: isWeb ? 14 : 10,
                height: isWeb ? 14 : 10,
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                faq.question,
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textBlackGrey,
                  fontSize: isWeb ? 22 : 15,
                ),
              ),
            ),
          ],
        ),
        onExpansionChanged: (expanded) {
          ref.read(faqsProvider.notifier).toggleExpansion(index, expanded);
        },
        children: [
          Align(
            alignment: AlignmentGeometry.centerStart,
            child: Text(
              faq.answer,
              style: GoogleFonts.hind(
                color: AppColors.textBlackGrey,
                fontSize: isWeb ? 18 : 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
