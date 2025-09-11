import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';

import '../../../core/constants/app_colors.dart';
import '../custom_button.dart';

class ProgressCard extends StatelessWidget {
  final double progress;
  final VoidCallback onPressed;
  final bool isWeb;

  const ProgressCard({
    super.key,
    required this.progress,
    required this.onPressed,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();

    return Container(
      width: isWeb ? 167 : double.infinity,
      height: isWeb ? 200 : 220,
      padding: EdgeInsets.all(isWeb ? 16 : 26),
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
          const SizedBox(height: 5),
          SizedBox(
            height: 90,
            width: 90,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(3.1416),
                  child: CircularProgressIndicator(
                    value: progress.clamp(0, 1),
                    strokeWidth: 14,
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
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: AppColors.textVidaLocaGreen,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppAssets.icons.completed.svg(),
                          Text(
                            'Completed',
                            style: GoogleFonts.hind(
                              fontWeight: FontWeight.w600,
                              fontSize: 8,
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
      ),
    );
  }
}
