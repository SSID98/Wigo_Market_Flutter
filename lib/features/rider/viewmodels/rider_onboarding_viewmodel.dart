import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiderOnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  late int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'Earn Easily with WIGOMARKET',
      'description':
          'Join a trusted network of campus riders helping students and vendors deliver fast, safe, and on time within your campus.',
    },
    {
      'image': 'assets/images/onboarding2.png',
      'title': 'Here’s What to Expect',
      'description':
          'Get delivery requests, pick up from vendors, and earn directly into your bank account, all while staying active on campus.',
    },
  ];

  void nextPage() {
    if (currentPage < onboardingData.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {}
  }

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }
}

final riderOnboardingViewModelProvider = ChangeNotifierProvider(
  (ref) => RiderOnboardingViewModel(),
);
