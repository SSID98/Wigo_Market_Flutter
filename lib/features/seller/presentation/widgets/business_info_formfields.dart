import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/seller/viewmodels/business_info_viewmodel.dart';
import 'package:wigo_flutter/shared/models/location_data.dart';
import 'package:wigo_flutter/shared/widgets/custom_text_field.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_checkbox_2.dart';
import '../../../../shared/widgets/upload_box.dart';

class BusinessInfoFormFields extends ConsumerWidget {
  final bool web;
  final double iconHeight;
  final double iconWidth;
  final double hintFontSize;

  const BusinessInfoFormFields({
    super.key,
    this.web = false,
    required this.iconHeight,
    required this.iconWidth,
    required this.hintFontSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(businessInfoViewmodelProvider);
    final notifier = ref.read(businessInfoViewmodelProvider.notifier);
    final spacing = const SizedBox(height: 16);

    return Column(
      children: [
        CustomTextField(
          hintText: 'eg., Dmobile Tech',
          label: 'Shop/Business Name',
          prefixIcon: AppAssets.icons.user.path,
          iconHeight: iconHeight,
          iconWidth: iconWidth,
          hintTextColor: AppColors.textBodyText,
          onChanged: notifier.updateBusinessName,
        ),
        spacing,
        CustomDropdownField(
          label: 'Type of Business',
          hintText: 'Select Type of Business',
          items: const ['Retail', 'Wholesale'],
          iconWidth: 22,
          iconHeight: 22,
          onChanged: notifier.updateBusinessType,
          value: state.businessType,
          prefixIcon: AppAssets.icons.store.svg(
            width: iconWidth,
            height: iconHeight,
          ),
        ),
        spacing,
        CustomTextField(
          hintText: 'Enter your Business address',
          label: 'Business address',
          prefixIcon: AppAssets.icons.home.path,
          iconHeight: iconHeight,
          iconWidth: iconWidth,
          hintTextColor: AppColors.textIconGrey,
          onChanged: notifier.updateBusinessAddress,
        ),
        spacing,
        if (web)
          Row(
            children: [
              Expanded(
                child: CustomDropdownField(
                  label: 'State',
                  items: nigeriaStatesAndCities.keys.toList(),
                  hintText: 'Select State',
                  value:
                      state.businessState.isEmpty ? null : state.businessState,
                  onChanged: (val) {
                    notifier.updateBusinessState(val);
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: CustomDropdownField(
                  label: 'City/ Town',
                  items: state.filteredCities,
                  hintText: 'Select City',
                  value: state.businessCity.isEmpty ? null : state.businessCity,
                  onChanged: notifier.updateBusinessCity,
                ),
              ),
            ],
          )
        else ...[
          CustomDropdownField(
            label: 'State',
            items: nigeriaStatesAndCities.keys.toList(),
            hintText: 'Select State',
            value: state.businessState.isEmpty ? null : state.businessState,
            onChanged: (val) {
              notifier.updateBusinessState(val);
            },
          ),
          spacing,
          CustomDropdownField(
            label: 'City/ Town',
            items: state.filteredCities,
            hintText: 'Select City',
            value: state.businessCity.isEmpty ? null : state.businessCity,
            onChanged: notifier.updateBusinessCity,
          ),
          spacing,
          CustomTextField(
            label: '',
            labelRichText: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Business Description ',
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.textBlack,
                    ),
                  ),
                  TextSpan(
                    text: '(optional)',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.textBodyText,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            isRichText: true,
            hintText: 'Give a brief description about your business',
            hintFontStyle: FontStyle.italic,
            onChanged: notifier.updateBusinessDescription,
            contentPadding: EdgeInsets.all(10),
            minLines: 5,
            maxLines: 8,
          ),
          spacing,
          CustomDropdownField(
            label: 'Order Preference',
            hintText: 'Select Order Preferences',
            items: const ['Male', 'Female'],
            iconWidth: 22,
            iconHeight: 22,
            onChanged: notifier.updateOrderPreference,
            value: state.orderPreference,
          ),
          const SizedBox(height: 4),
          Text(
            'Choose how you prefer to fulfill your customer orders. This will be shown to buyers during checkout.',
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w400,
              color: AppColors.textBodyText,
              fontSize: 14,
            ),
          ),
          spacing,
          UploadBox(
            hintText: "JPEG, PNG, PDG, and MP4 formats, up to 50MB",
            label: 'Upload your NIN document for Verification',
            prefixIcon1: AppAssets.icons.cloud.svg(),
            prefixIcon2: AppAssets.icons.cloud.svg(),
            hintTextColor: AppColors.textBodyText,
            labelFontSize: 16,
          ),
          spacing,
          UploadBox(
            hintText: "JPEG, PNG, PDG, and MP4 formats, up to 50MB",
            label: '',
            isRichText: true,
            richText: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Upload Store Logo or Cover Photo ',
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: AppColors.textBlack,
                    ),
                  ),
                  TextSpan(
                    text: '(optional but encouraged)',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.textBodyText,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            prefixIcon1: AppAssets.icons.cloud.svg(),
            prefixIcon2: AppAssets.icons.cloud.svg(),
            hintTextColor: AppColors.textBodyText,
          ),
          spacing,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCheckbox2(
                value: state.agreeToTerms,
                onChanged: notifier.toggleAgreeToTerms,
                size: 19,
                checkSize: 12,
                borderColor: AppColors.primaryDarkGreen,
                checkColor: AppColors.primaryDarkGreen,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  " I agree to allow Wigo Market to track my shop location to be used for deliveries and customer navigation. Your location is only shared with buyers and delivery agents for order fulfillment and is protected under our privacy policy.",
                  style: GoogleFonts.hind(
                    fontSize: web ? 16 : 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textBlackGrey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
