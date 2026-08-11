import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/widgets/custom_loading_overlay.dart';

import '../../core/local/local_user_controller.dart';
import '../../gen/assets.gen.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  late int currentPage = 0;

  final List<Map<String, String>> riderOnboardingData = [
    {
      'image': AppAssets.images.onboarding1.path,
      'title': 'Earn Easily with WIGOMARKET',
      'description':
          'Join a trusted network of campus riders helping students and vendors deliver fast, safe, and on time within your campus.',
    },
    {
      'image': AppAssets.images.onboarding2.path,
      'title': 'Here’s What to Expect',
      'description':
          'Get delivery requests, pick up from vendors, and earn directly into your bank account, all while staying active on campus.',
    },
  ];

  final List<Map<String, String>> buyerOnboardingData = [
    {
      'image': AppAssets.images.buyerOnboarding1.path,
      'title': 'Shop Easily with WIGOMARKET',
      'description':
          'Join a trusted community of buyers shopping from verified vendors and enjoying fast, safe, and on-time deliveries anywhere on campus.',
    },
    {
      'image': AppAssets.images.buyerOnboarding2.path,
      'title': 'Here’s What to Expect',
      'description':
          'Get your goods delivered by WiGo Riders or pick up from vendors by going to their location, you can with any means convenient for you.',
    },
  ];

  final List<Map<String, String>> sellerOnboardingData = [
    {
      'image': AppAssets.images.sellerOnboarding1.path,
      'title': 'Sell Smarter with WIGOMARKET',
      'description':
          'Reach thousands of students near you, manage sales easily, and grow your business—all in one place.',
    },
    {
      'image': AppAssets.images.sellerOnboarding2.path,
      'title': 'Run Your Store Right From Your Phone.',
      'description':
          'No need for complicated tools. With WIGOMARKET, you can manage orders, update your listings, and track deliveries—all in one simple app.',
    },
  ];

  Future<void> riderNextPage(BuildContext context, WidgetRef ref) async {
    if (currentPage < riderOnboardingData.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await runWithOverlay(context, () async {
        await Future.delayed(const Duration(seconds: 1));
        ref
            .read(localUserControllerProvider.notifier)
            .saveStage(OnboardingStage.registration);
        if (context.mounted) context.push('/accountCreation');
      }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
    }
  }

  Future<void> buyerNextPage(BuildContext context, WidgetRef ref) async {
    if (currentPage < buyerOnboardingData.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await runWithOverlay(context, () async {
        await Future.delayed(const Duration(seconds: 1));
        ref
            .read(localUserControllerProvider.notifier)
            .saveStage(OnboardingStage.registration);
        if (context.mounted) context.push('/accountCreation');
      }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
    }
  }

  Future<void> sellerNextPage(BuildContext context, WidgetRef ref) async {
    if (currentPage < sellerOnboardingData.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await runWithOverlay(context, () async {
        await Future.delayed(const Duration(seconds: 1));
        ref
            .read(localUserControllerProvider.notifier)
            .saveStage(OnboardingStage.registration);
        if (context.mounted) context.push('/accountCreation');
      }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
    }
  }

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }
}

final onboardingViewModelProvider = ChangeNotifierProvider(
  (ref) => OnboardingViewModel(),
);
