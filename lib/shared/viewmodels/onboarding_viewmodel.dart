import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/url.dart';
import '../../core/local/local_user_controller.dart';
import '../../core/utils/helper_methods.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  late int currentPage = 0;

  final List<Map<String, String>> riderOnboardingData = [
    {
      'image': '$networkImageUrl/onboarding1.png',
      'title': 'Earn Easily with WIGOMARKET',
      'description':
          'Join a trusted network of campus riders helping students and vendors deliver fast, safe, and on time within your campus.',
    },
    {
      'image': '$networkImageUrl/onboarding2.png',
      'title': 'Here’s What to Expect',
      'description':
          'Get delivery requests, pick up from vendors, and earn directly into your bank account, all while staying active on campus.',
    },
  ];

  final List<Map<String, String>> buyerOnboardingData = [
    {
      'image': '$networkImageUrl/buyerOnboarding1.png',
      'title': 'Shop Easily with WIGOMARKET',
      'description':
          'Join a trusted community of buyers shopping from verified vendors and enjoying fast, safe, and on-time deliveries anywhere on campus.',
    },
    {
      'image': '$networkImageUrl/buyerOnboarding2.png',
      'title': 'Here’s What to Expect',
      'description':
          'Get your goods delivered by WiGo Riders or pick up from vendors by going to their location, you can with any means convenient for you.',
    },
  ];

  final List<Map<String, String>> sellerOnboardingData = [
    {
      'image': '$networkImageUrl/sellerOnboarding1.png',
      'title': 'Sell Smarter with WIGOMARKET',
      'description':
          'Reach thousands of students near you, manage sales easily, and grow your business—all in one place.',
    },
    {
      'image': '$networkImageUrl/sellerOnboarding2.png',
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
      if (!context.mounted) return;
      ref
          .read(localUserControllerProvider)
          .saveStage(OnboardingStage.registration);
      showLoadingDialog(context);
      await Future.delayed(const Duration(seconds: 1));
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      context.go('/accountCreation');
    }
  }

  Future<void> buyerNextPage(BuildContext context, WidgetRef ref) async {
    if (currentPage < buyerOnboardingData.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      ref
          .read(localUserControllerProvider)
          .saveStage(OnboardingStage.registration);
      showLoadingDialog(context);
      await Future.delayed(const Duration(seconds: 1));
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      context.go('/accountCreation');
    }
  }

  Future<void> sellerNextPage(BuildContext context, WidgetRef ref) async {
    if (currentPage < sellerOnboardingData.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      ref
          .read(localUserControllerProvider)
          .saveStage(OnboardingStage.registration);
      showLoadingDialog(context);
      await Future.delayed(const Duration(seconds: 1));
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      context.go('/accountCreation');
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
