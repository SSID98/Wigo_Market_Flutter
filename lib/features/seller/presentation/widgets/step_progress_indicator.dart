import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool isWeb;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = currentStep / totalSteps;

    return Row(
      children: [
        SizedBox(
          height: isWeb ? 52 : 27,
          width: isWeb ? 52 : 27,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(3.1416),
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: isWeb ? 11 : 5,
                  backgroundColor: AppColors.buttonOrange.withValues(
                    alpha: 0.2,
                  ),
                  valueColor: AlwaysStoppedAnimation(AppColors.buttonOrange),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$currentStep/$totalSteps',
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w700,
                        fontSize: isWeb ? 14 : 7,
                        color: AppColors.textBlueishBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
