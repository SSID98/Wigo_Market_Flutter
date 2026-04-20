class FAQItem {
  final String question;
  final String answer;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  FAQItem copyWith({String? question, String? answer, bool? isExpanded}) {
    return FAQItem(
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
