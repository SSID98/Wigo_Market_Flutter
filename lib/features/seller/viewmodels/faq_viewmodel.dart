import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/faqitem_class.dart';

class FAQsNotifier extends StateNotifier<List<FAQItem>> {
  FAQsNotifier() : super(dummyFAQs);

  void setFAQs(List<FAQItem> faqs) {
    state = faqs;
  }

  void toggleExpansion(int index, bool expanded) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) state[i].copyWith(isExpanded: expanded) else state[i],
    ];
  }

  Future<void> fetchFAQsFromApi() async {
    // Example: pretend we hit an API
    await Future.delayed(const Duration(seconds: 1));
    final List<FAQItem> apiData = [];
    state = apiData;
  }
}

final List<FAQItem> dummyFAQs = [
  FAQItem(
    question: "How do I add a product to my store?",
    answer:
        "Go to your Seller Dashboard, click on “Add Product”, then choose between a Single Version or Multiple Version product. Fill in the required details like product name, category, images, price, and stock. Once done, click “Publish” to make it live on your storefront.",
  ),
  FAQItem(
    question:
        "What’s the difference between Single Version and Variant Products?",
    answer: "Oga do test and trial find out the answer yourself shuuuu",
  ),
  FAQItem(
    question: "How do I update or edit my product details after publishing?",
    answer: "Come you this pikin, no stress me ooo",
  ),
  FAQItem(
    question: "How do I change my email, password, or account details?",
    answer: "Really? you had to ask such a yeye question?",
  ),
  FAQItem(
    question: "How do I contact WiGo Market Support for help?",
    answer: "Contact for what na, you wan send funds?",
  ),
  FAQItem(
    question: "How do I contact WiGo Market Support for help?",
    answer: "Contact for what na, you wan send funds?",
  ),
  FAQItem(
    question: "How do I contact WiGo Market Support for help?",
    answer: "Contact for what na, you wan send funds?",
  ),
  FAQItem(
    question: "How do I contact WiGo Market Support for help?",
    answer: "Contact for what na, you wan send funds?",
  ),
  FAQItem(
    question: "How do I contact WiGo Market Support for help?",
    answer: "Contact for what na, you wan send funds?",
  ),
  FAQItem(
    question: "How do I contact WiGo Market Support for help?",
    answer: "Contact for what na, you wan send funds?",
  ),
  FAQItem(
    question: "How do I contact WiGo Market Support for help?",
    answer: "Contact for what na, you wan send funds?",
  ),
  FAQItem(
    question: "How do I contact WiGo Market Support for help?",
    answer: "Contact for what na, you wan send funds?",
  ),
];

final faqsProvider = StateNotifierProvider<FAQsNotifier, List<FAQItem>>(
  (ref) => FAQsNotifier(),
);
