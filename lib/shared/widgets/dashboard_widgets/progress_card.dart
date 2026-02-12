import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';

import '../../../core/constants/app_colors.dart';
import '../custom_button.dart';

class ProgressCard extends StatelessWidget {
  final double progress;
  final VoidCallback onPressed;
  final bool isWeb;
  final bool isSeller;

  const ProgressCard({
    super.key,
    required this.progress,
    required this.onPressed,
    required this.isWeb,
    this.isSeller = false,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();

    return Container(
      width:
          isSeller
              ? isWeb
                  ? 167
                  : 181
              : isWeb
              ? 167
              : double.infinity,
      height:
          isSeller
              ? isWeb
                  ? 200
                  : 87
              : isWeb
              ? 200
              : 220,
      padding: EdgeInsets.fromLTRB(
        isWeb
            ? 16
            : isSeller
            ? 20
            : 26,
        isWeb
            ? 16
            : isSeller
            ? 16
            : 26,
        isWeb
            ? 16
            : isSeller
            ? 16
            : 26,
        isWeb
            ? 16
            : isSeller
            ? 9
            : 26,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accentGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: isSeller && !isWeb ? 0 : 5),
          Row(
            children: [
              SizedBox(
                height: isSeller && !isWeb ? 60 : 90,
                width: isSeller && !isWeb ? 60 : 90,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.1416),
                      child: CircularProgressIndicator(
                        value: progress.clamp(0, 1),
                        strokeWidth: isSeller && !isWeb ? 11 : 14,
                        backgroundColor: AppColors.clampBgColor,
                        valueColor: AlwaysStoppedAnimation(
                          AppColors.clampValueColor,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$pct%',
                            style: GoogleFonts.hind(
                              fontWeight:
                                  isSeller && !isWeb
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                              fontSize: isSeller && !isWeb ? 15 : 22,
                              color: AppColors.textVidaLocaGreen,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!isSeller && isWeb)
                                AppAssets.icons.completed.svg(),
                              Text(
                                'Completed',
                                style: GoogleFonts.hind(
                                  fontWeight:
                                      isSeller && !isWeb
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                  fontSize: isSeller && !isWeb ? 7 : 8,
                                  color: AppColors.textBlackGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isWeb && isSeller) ...[
                const SizedBox(width: 15.0),
                CustomButton(
                  text: 'Complete Setup',
                  onPressed: onPressed,
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  width: 63,
                  height: 18,
                  borderRadius: 11.26,
                  padding: EdgeInsets.zero,
                ),
              ],
            ],
          ),
          if (!isSeller || isWeb) ...[
            const SizedBox(height: 34.0),
            CustomButton(
              text: 'Complete Setup',
              onPressed: onPressed,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              width: isWeb ? 130 : 200,
              height: isWeb ? 32 : 35,
              borderRadius: 20,
              padding: EdgeInsets.zero,
            ),
          ],
        ],
      ),
    );
  }
}
