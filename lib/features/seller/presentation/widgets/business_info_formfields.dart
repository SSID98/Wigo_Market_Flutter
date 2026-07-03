import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/seller/viewmodels/business_info_viewmodel.dart';
import 'package:wigo_flutter/shared/models/location_data.dart';
import 'package:wigo_flutter/shared/widgets/contact_text_field.dart';
import 'package:wigo_flutter/shared/widgets/custom_text_field.dart';

import '../../../../core/utils/context_extensions.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_checkbox_2.dart';
import '../../../../shared/widgets/upload_box.dart';

class BusinessInfoFormFields extends ConsumerWidget {
  final double iconHeight;
  final double iconWidth;
  final double hintFontSize;

  const BusinessInfoFormFields({
    super.key,
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
          onChanged: notifier.updateBusinessName,
          hasError: state.hasSubmitted && state.name.isEmpty,
          errorMessage: state.hasSubmitted && state.name.isEmpty
              ? "This field is required"
              : null,
        ),
        spacing,
        CustomTextField(
          hintText: 'eg., dmobile@gmail.com',
          label: 'Shop/Business Email',
          prefixIcon: AppAssets.icons.user.path,
          iconHeight: iconHeight,
          iconWidth: iconWidth,
          onChanged: notifier.updateBusinessEmail,
          hasError:
              state.hasSubmitted &&
              FormValidators.validateEmail(state.storeEmail) != null,
          errorMessage: state.hasSubmitted
              ? FormValidators.validateEmail(state.storeEmail)
              : null,
        ),
        spacing,
        CustomPhoneNumberField(
          label: 'Shop/Business Phone',
          onChanged: notifier.updateBusinessPhone,
          hasError: state.hasSubmitted && state.storeMobile.isEmpty,
          errorMessage: state.hasSubmitted && state.storeMobile.isEmpty
              ? "This field is required"
              : null,
        ),
        spacing,
        CustomDropdownField(
          label: 'Type of Business',
          hintText: 'Select Type of Business',
          items: const ['Retail', 'Wholesale'],
          iconWidth: 22,
          iconHeight: 22,
          onChanged: (val) {
            notifier.updateBusinessType(val);
          },
          hasError: state.hasSubmitted && state.businessType.isEmpty,
          errorMessage: state.hasSubmitted && state.businessType.isEmpty
              ? "This field is required"
              : null,
          value: notifier.selectedBusiness,
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
          hasError: state.hasSubmitted && state.address.isEmpty,
          errorMessage: state.hasSubmitted && state.address.isEmpty
              ? "This field is required"
              : null,
        ),
        spacing,
        if (context.isWeb)
          Row(
            children: [
              Expanded(
                child: CustomDropdownField(
                  label: 'State',
                  items: nigeriaStatesAndCities.keys.toList(),
                  hintText: 'Select State',
                  value: state.state.isEmpty ? null : notifier.selectedState,
                  onChanged: (val) {
                    notifier.updateBusinessState(val);
                  },
                  hasError: state.hasSubmitted && state.state.isEmpty,
                  errorMessage: state.hasSubmitted && state.state.isEmpty
                      ? "This field is required"
                      : null,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: CustomDropdownField(
                  label: 'City/ Town',
                  items: state.filteredCities,
                  hintText: 'Select City',
                  value: state.city.isEmpty ? null : notifier.selectedCity,
                  onChanged: notifier.updateBusinessCity,
                  hasError: state.hasSubmitted && state.city.isEmpty,
                  errorMessage: state.hasSubmitted && state.city.isEmpty
                      ? "This field is required"
                      : null,
                ),
              ),
            ],
          )
        else ...[
          CustomDropdownField(
            label: 'State',
            items: nigeriaStatesAndCities.keys.toList(),
            hintText: 'Select State',
            value: state.state.isEmpty ? null : notifier.selectedState,
            onChanged: (val) {
              notifier.updateBusinessState(val);
            },
            hasError: state.hasSubmitted && state.state.isEmpty,
            errorMessage: state.hasSubmitted && state.state.isEmpty
                ? "This field is required"
                : null,
          ),
          spacing,
          CustomDropdownField(
            label: 'City/ Town',
            items: state.filteredCities,
            hintText: 'Select City',
            value: state.city.isEmpty ? null : notifier.selectedCity,
            onChanged: notifier.updateBusinessCity,
            hasError: state.hasSubmitted && state.city.isEmpty,
            errorMessage: state.hasSubmitted && state.city.isEmpty
                ? "This field is required"
                : null,
          ),
          spacing,
          CustomTextField(
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
          // spacing,
          // CustomDropdownField(
          //   label: 'Order Preference',
          //   hintText: 'Select Order Preferences',
          //   items: const ['Male', 'Female'],
          //   iconWidth: 22,
          //   iconHeight: 22,
          //   onChanged: notifier.updateOrderPreference,
          //   value: state.orderPreference,
          // ),
          // const SizedBox(height: 4),
          // Text(
          //   'Choose how you prefer to fulfill your customer orders. This will be shown to buyers during checkout.',
          //   style: GoogleFonts.hind(
          //     fontWeight: FontWeight.w400,
          //     color: AppColors.textBodyText,
          //     fontSize: 14,
          //   ),
          // ),
          spacing,
          UploadBox(
            hintText: "JPEG, PNG, PDG, and MP4 formats, up to 50MB",
            label: 'Upload your NIN document for Verification',
            prefixIcon1: AppAssets.icons.cloud.svg(),
            prefixIcon2: AppAssets.icons.cloud.svg(
              colorFilter: ColorFilter.mode(
                AppColors.primaryDarkGreen,
                BlendMode.srcIn,
              ),
            ),
            prefixIconError: AppAssets.icons.cloud.svg(
              colorFilter: ColorFilter.mode(AppColors.textRed, BlendMode.srcIn),
            ),
            hintTextColor: AppColors.textBodyText,
            labelFontSize: 16,
            onFileSelected: (file) {
              ref.read(businessInfoViewmodelProvider.notifier).uploadNin(file);
            },
            isUploading: state.isUploadingNin,
            progress: state.ninProgress,
            onCancel: notifier.cancelNinUpload,
            onRetry: notifier.retryUploadNin,
            uploadFailed: state.ninUploadFailed,
            hasError: state.hasSubmitted && state.ownerNIN.isEmpty,
            errorMessage: state.hasSubmitted && state.ownerNIN.isEmpty
                ? "This field is required"
                : null,
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
            prefixIcon2: AppAssets.icons.cloud.svg(
              colorFilter: ColorFilter.mode(
                AppColors.primaryDarkGreen,
                BlendMode.srcIn,
              ),
            ),
            hintTextColor: AppColors.textBodyText,
            onFileSelected: (file) {
              ref
                  .read(businessInfoViewmodelProvider.notifier)
                  .uploadStoreImage(file);
            },
            isUploading: state.isUploadingStoreImage,
            progress: state.storeImageProgress,
            onCancel: notifier.cancelStoreUpload,
            onRetry: notifier.retryUploadStoreImage,
            uploadFailed: state.storeImageUploadFailed,
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
                    fontSize: context.isWeb ? 16 : 14,
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
