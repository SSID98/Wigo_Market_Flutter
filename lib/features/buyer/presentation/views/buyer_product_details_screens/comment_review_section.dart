import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../models/review_model.dart';
import '../../widgets/static_rating_bar.dart';

class CommentsAndReviewSection extends StatelessWidget {
  CommentsAndReviewSection({super.key});

  final List<Review> dummyReviews = [
    Review(
      reviewerName: 'Kelechi N.',
      rating: 3.0,
      comment:
          'I’m a drummer and ordered an electronic drum kit — arrived earlier than expected and everything was perfectly packed. Customer service was super responsive too!',
    ),
    Review(
      reviewerName: 'Wade Warren',
      rating: 4.5,
      comment:
          'Exceeded my expectations! Great value and super fast shipping. '
          'Highly recommend this seller.',
    ),
    Review(
      reviewerName: 'Emmanuel Uche',
      rating: 2.0,
      comment:
          'Very disappointed. The item arrived broken, and I am still waiting '
          'for a response from customer service regarding the refund.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Comments & Reviews',
            style: GoogleFonts.hind(
              fontSize: isWeb ? 24 : 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          itemCount: dummyReviews.length,
          itemBuilder: (context, index) {
            final review = dummyReviews[index];
            return ReviewEntry(review: review);
          },
        ),
      ],
    );
  }
}

class ReviewEntry extends StatelessWidget {
  final Review review;

  const ReviewEntry({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StaticRatingBar(rating: review.rating),
          const SizedBox(height: 10.0),
          Text(
            review.comment,
            style: GoogleFonts.hind(
              fontSize: 12,
              color: AppColors.textBlackGrey,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            review.reviewerName,
            style: GoogleFonts.hind(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlackGrey,
            ),
          ),
        ],
      ),
    );
  }
}
