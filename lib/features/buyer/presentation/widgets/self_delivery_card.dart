import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/url.dart';
import '../../../../shared/widgets/custom_button.dart';

class SelfDeliveryPromoCard extends StatelessWidget {
  final VoidCallback onPressed;

  const SelfDeliveryPromoCard({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    const double aspectRatio = 2.5;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        color: AppColors.backgroundPeach,
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? 32.0 : 16.0,
                  vertical: isWeb ? 16.0 : 8.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Self Delivery',
                      style: GoogleFonts.hind(
                        fontSize: isWeb ? 32 : 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textWhite,
                      ),
                    ),
                    Text(
                      'Pick Up your orders from these available walk-in shops, No delays, No extra charge!',
                      style: GoogleFonts.hind(
                        fontSize: isWeb ? 16 : 9,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textWhite,
                      ),
                    ),
                    const SizedBox(height: 25),
                    CustomButton(
                      text: 'Shop Now',
                      fontSize: isWeb ? 16 : 9,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.buttonOrange,
                      buttonColor: AppColors.backgroundWhite,
                      onPressed: onPressed,
                      height: isWeb ? 40 : 22.35,
                      borderRadius: 4.47,
                      width: isWeb ? 143 : 80.12,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 5,
              child: Image.network(
                '$networkImageUrl/selfDeliver.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                errorBuilder:
                    (context, error, stackTrace) => Center(
                      child: Icon(
                        Icons.delivery_dining,
                        size: isWeb ? 80 : 50,
                        color: AppColors.backgroundWhite,
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
