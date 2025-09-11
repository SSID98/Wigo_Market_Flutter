import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/dashboard_widgets/progress_card.dart';
import 'package:wigo_flutter/shared/widgets/dashboard_widgets/step_card.dart';

import '../../../../../../core/constants/app_colors.dart';

enum SetupStatus { pending, completed }

class AccountSetupStep {
  final String title;
  final SvgPicture iconAsset;
  final SetupStatus status;
  final VoidCallback? onTap;

  const AccountSetupStep({
    required this.title,
    required this.iconAsset,
    required this.status,
    this.onTap,
  });
}

class AccountSetup extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<AccountSetupStep> steps;

  final double? progress;
  final VoidCallback onCompletePressed;
  final bool isWeb;

  const AccountSetup({
    super.key,
    required this.title,
    required this.subtitle,
    required this.steps,
    this.progress,
    required this.onCompletePressed,
    this.isWeb = false,
  });

  double _computeProgress() {
    if (progress != null) return progress!.clamp(0, 1);
    if (steps.isEmpty) return 0;
    final done = steps.where((s) => s.status == SetupStatus.completed).length;
    return done / steps.length;
  }

  @override
  Widget build(BuildContext context) {
    final value = _computeProgress();

    return Container(
      margin: EdgeInsets.only(top: 5.0),
      height: isWeb ? 258 : 170.0,
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white70.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 20 : 10,
        vertical: isWeb ? 20 : 6,
      ),
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth > 720 || isWeb;

            final stepsWrap = _StepsWrap(steps: steps, isWeb: wide);

            final progressCard = ProgressCard(
              progress: value,
              onPressed: onCompletePressed,
              isWeb: wide,
            );

            return wide
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _HeaderAndSteps(
                        title: title,
                        subtitle: subtitle,
                        isWeb: wide,
                        child: stepsWrap,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: progressCard,
                    ),
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderAndSteps(
                      title: title,
                      subtitle: subtitle,
                      isWeb: false,
                      child: stepsWrap,
                    ),
                    const SizedBox(height: 20),
                    progressCard,
                  ],
                );
          },
        ),
      ),
    );
  }
}

class _HeaderAndSteps extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final bool isWeb;

  const _HeaderAndSteps({
    required this.title,
    required this.subtitle,
    required this.child,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w600,
            fontSize: isWeb ? 20 : 16,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w400,
            fontSize: isWeb ? 16 : 12,
            color: AppColors.textBlackGrey,
          ),
        ),
        SizedBox(height: isWeb ? 30 : 17),
        child,
      ],
    );
  }
}

class _StepsWrap extends StatelessWidget {
  final List<AccountSetupStep> steps;
  final bool isWeb;

  const _StepsWrap({required this.steps, required this.isWeb});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 450,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: StepCard(step: steps[0], height: isWeb ? 115 : 86)),
          const SizedBox(width: 9),
          Expanded(child: StepCard(step: steps[1], height: isWeb ? 115 : 86)),
        ],
      ),
    );
  }
}
