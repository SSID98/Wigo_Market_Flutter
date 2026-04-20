import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/seller/presentation/views/seller_settings_screens/seller_help_support_screens/contact_support_page.dart';
import 'package:wigo_flutter/features/seller/presentation/views/seller_settings_screens/seller_help_support_screens/tutorial_guide_page.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/context_extensions.dart';
import '../../../../../../gen/assets.gen.dart';
import 'faq_page.dart';

enum HelpTab { faq, support, tutorial }

final helpTabProvider = StateProvider<HelpTab>((ref) => HelpTab.faq);

class SellerHelpAndSupportMainScreen extends ConsumerWidget {
  const SellerHelpAndSupportMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(helpTabProvider);

    return Scaffold(
      appBar: context.isWeb
          ? null
          : AppBar(
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: AppAssets.icons.backCircleArrow.svg(),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: context.width * 0.20),
                      Text(
                        "Help and Support",
                        style: GoogleFonts.hind(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlackGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              surfaceTintColor: Colors.transparent,
              backgroundColor: AppColors.backgroundLight,
              automaticallyImplyLeading: false,
            ),
      backgroundColor: AppColors.backgroundLight,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: context.isWeb
            ? Expanded(
                child: Column(
                  children: [
                    Text(
                      "Help and Support",
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "We’re here to help! Explore FAQs, tutorials, or contact our support team to get the assistance you need.",
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                    _buildFilterBar(context.isWeb, ref, context),
                    Card(
                      margin: EdgeInsets.only(bottom: 20, top: 20),
                      shadowColor: Colors.white70.withValues(alpha: 0.06),
                      color: AppColors.backgroundWhite,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(6.0),
                          bottomRight: Radius.circular(6.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _getHelpPage(activeTab),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  const SizedBox(height: 25),
                  _buildFilterBar(context.isWeb, ref, context),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Card(
                        margin: EdgeInsets.only(bottom: 20),
                        shadowColor: Colors.white70.withValues(alpha: 0.06),
                        color: AppColors.backgroundWhite,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppColors.borderColor),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _getHelpPage(activeTab),
                                const SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFilterBar(bool isWeb, WidgetRef ref, BuildContext context) {
    final activeTab = ref.watch(helpTabProvider);
    return Card(
      margin: EdgeInsets.zero,
      shadowColor: Colors.white70.withValues(alpha: 0.06),
      color: AppColors.backgroundWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.0),
          topRight: Radius.circular(6.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTabButton(ref, "FAQ’S", HelpTab.faq, activeTab, isWeb, context),
          _buildTabButton(
            ref,
            "Contact Support",
            HelpTab.support,
            activeTab,
            isWeb,
            context,
          ),
          _buildTabButton(
            ref,
            "Tutorial & Guild",
            HelpTab.tutorial,
            activeTab,
            isWeb,
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    WidgetRef ref,
    String label,
    HelpTab tab,
    HelpTab activeTab,
    bool isWeb,
    BuildContext context,
  ) {
    final isSelected = tab == activeTab;
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(helpTabProvider.notifier).state = tab,
        child: Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: context.width * 0.02,
            right: context.width * 0.02,
          ),
          child: Column(
            children: [
              Text(
                textAlign: TextAlign.center,
                label,
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: isSelected
                      ? AppColors.primaryDarkGreen
                      : AppColors.textBlackGrey,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                height: 3.5,
                width: context.width * 0.13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.0),
                    topRight: Radius.circular(6.0),
                  ),
                  color: isSelected
                      ? AppColors.primaryDarkGreen
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getHelpPage(HelpTab tab) {
    switch (tab) {
      case HelpTab.faq:
        return const FaqPage();
      case HelpTab.support:
        return const ContactSupportPage();
      case HelpTab.tutorial:
        return const TutorialGuidePage();
    }
  }
}
