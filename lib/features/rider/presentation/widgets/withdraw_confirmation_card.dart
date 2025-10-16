import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/rider/models/bank_details.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_button.dart';

class WithdrawalConfirmationCard extends StatelessWidget {
  final BankDetails details;
  final bool isWeb;
  final Widget body;
  final String amount;
  final void Function()? onConfirm;
  final void Function()? onCancel;

  const WithdrawalConfirmationCard({
    super.key,
    required this.details,
    required this.amount,
    required this.onConfirm,
    this.isWeb = false,
    required this.body,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColors.backgroundWhite,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Withdrawal Summary",
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Forgot Pin?",
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.textVidaLocaGreen,
              ),
            ),
            const SizedBox(height: 20),
            AppAssets.icons.doubleTickOrange.svg(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'You are about to withdraw',
                      style: GoogleFonts.hind(
                        fontSize: isWeb ? 20 : 18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                    TextSpan(
                      text: ' #$amount ',
                      style: GoogleFonts.notoSans(
                        fontSize: isWeb ? 20 : 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textOrange,
                      ),
                    ),
                    TextSpan(
                      text: 'from your balance?',
                      style: GoogleFonts.hind(
                        fontSize: isWeb ? 20 : 18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            body,
            const SizedBox(height: 30),
            CustomButton(
              fontWeight: FontWeight.w500,
              text: 'Confirm Withdrawal',
              onPressed: onConfirm,
              width: double.infinity,
              height: 48,
              fontSize: isWeb ? 18 : 14,
              buttonColor: AppColors.textOrange,
            ),
            const SizedBox(height: 10),
            // Cancel Button
            CustomButton(
              text: 'Cancel',
              onPressed:
                  isWeb
                      ? onCancel
                      : () {
                        if (!isWeb) {
                          Navigator.of(context).pop();
                        }
                      },
              width: double.infinity,
              height: 48,
              fontSize: isWeb ? 18 : 14,
              buttonColor: Colors.transparent,
              borderColor: AppColors.textOrange,
              textColor: AppColors.textOrange,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
