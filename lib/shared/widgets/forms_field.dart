import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/shared/models/location_data.dart';
import 'package:wigo_flutter/shared/widgets/custom_text_field.dart';

import '../../core/local/local_user_controller.dart';
import '../../core/utils/validation_utils.dart';
import '../../gen/assets.gen.dart';
import '../models/user_role.dart';
import '../viewmodels/account_creation_viewmodel.dart';
import 'contact_text_field.dart';
import 'custom_checkbox_widget.dart';

class FormFields extends ConsumerWidget {
  final bool web;
  final double iconHeight;
  final double iconWidth;
  final double hintFontSize;
  final Widget? suffixIcon;

  const FormFields({
    super.key,
    this.web = false,
    required this.iconHeight,
    required this.iconWidth,
    required this.hintFontSize,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regState = ref.watch(registerViewModelProvider);
    final notifier = ref.read(registerViewModelProvider.notifier);
    final spacing = const SizedBox(height: 16);
    final localUser = ref.watch(localUserControllerProvider);
    final role = localUser.role;
    final isSeller = role == UserRole.seller.name;
    final isRider = role == UserRole.dispatch.name;

    return Column(
      children: [
        CustomTextField(
          hintText: 'eg. John Doe',
          label: 'Full Name',
          prefixIcon: AppAssets.icons.user.path,
          iconHeight: iconHeight,
          iconWidth: iconWidth,
          hintTextColor: AppColors.textBodyText,
          onChanged: notifier.updateFullName,
          hasError: regState.hasSubmitted && regState.fullName.isEmpty,
          errorMessage: regState.hasSubmitted && regState.fullName.isEmpty
              ? "This field is required"
              : null,
        ),
        spacing,
        CustomTextField(
          hintText: 'johndoe112@gmail.com',
          label: 'Email address',
          prefixIcon: AppAssets.icons.mail.path,
          iconHeight: iconHeight,
          iconWidth: iconWidth,
          hintTextColor: AppColors.textBodyText,
          hasError:
              regState.hasSubmitted &&
              FormValidators.validateEmail(regState.email) != null,
          errorMessage: regState.hasSubmitted
              ? FormValidators.validateEmail(regState.email)
              : null,
          onChanged: notifier.updateEmail,
        ),
        spacing,
        CustomTextField(
          hintText: '●●●●●●●●●●●●●●',
          hintFontSize: hintFontSize,
          label: 'Password',
          isPassword: true,
          helperText:
              'At least 8 character containing a capital letter, a lower letter and a numeric character',
          prefixIcon: AppAssets.icons.lock.path,
          iconHeight: iconHeight,
          iconWidth: iconWidth,
          suffixIcon: suffixIcon,
          hintTextColor: AppColors.textBlackGrey,
          hasError:
              regState.hasSubmitted &&
              FormValidators.validateSignupPassword(regState.password) != null,
          errorMessage: regState.hasSubmitted
              ? FormValidators.validateSignupPassword(regState.password)
              : null,
          onChanged: notifier.updatePassword,
        ),
        spacing,
        CustomPhoneNumberField(
          label: 'Phone Number',
          onChanged: notifier.updateMobile,
          hasError: regState.hasSubmitted && regState.mobile.isEmpty,
          errorMessage: regState.hasSubmitted && regState.mobile.isEmpty
              ? "This field is required"
              : null,
          // contentPadding: EdgeInsets.only(bottom: 1),
        ),
        if (isRider) ...[
          spacing,
          CustomTextField(
            hintText: 'eg. Peter Doe',
            label: 'Name of Next of Kin',
            prefixIcon: AppAssets.icons.user.path,
            iconHeight: iconHeight,
            iconWidth: iconWidth,
            hintTextColor: AppColors.textBodyText,
            onChanged: notifier.updateNextOfKinName,
            hasError:
                regState.hasSubmitted && (regState.nameOfNok?.isEmpty ?? true),
            errorMessage:
                regState.hasSubmitted && (regState.nameOfNok?.isEmpty ?? true)
                ? "This field is required"
                : null,
          ),
          spacing,
          CustomPhoneNumberField(
            label: 'Next of Kin Contact',
            onChanged: notifier.updateNextOfKinPhone,
            hasError:
                regState.hasSubmitted &&
                (regState.nextOfKinPhone?.isEmpty ?? true),
            errorMessage:
                regState.hasSubmitted &&
                    (regState.nextOfKinPhone?.isEmpty ?? true)
                ? "This field is required"
                : null,
            // contentPadding: EdgeInsets.only(bottom: 1),
          ),
          spacing,
          CustomDropdownField(
            label: 'Gender',
            hintText: 'Select your Gender',
            items: const ['Male', 'Female'],
            iconWidth: 22,
            iconHeight: 22,
            onChanged: notifier.updateGender,
            value: notifier.selectedGender,
            prefixIcon: AppAssets.icons.user.svg(
              width: iconWidth,
              height: iconHeight,
            ),
            hasError:
                regState.hasSubmitted && (regState.gender?.isEmpty ?? true),
            errorMessage:
                regState.hasSubmitted && (regState.gender?.isEmpty ?? true)
                ? "This field is required"
                : null,
          ),
        ],
        if (isSeller) ...[
          spacing,
          CustomDropdownField(
            label: 'Gender',
            hintText: 'Select your Gender',
            items: const ['Male', 'Female'],
            iconWidth: 22,
            iconHeight: 22,
            onChanged: notifier.updateGender,
            value: notifier.selectedGender,
            prefixIcon: AppAssets.icons.user.svg(
              width: iconWidth,
              height: iconHeight,
            ),
            hasError:
                regState.hasSubmitted && (regState.gender?.isEmpty ?? true),
            errorMessage:
                regState.hasSubmitted && (regState.gender?.isEmpty ?? true)
                ? "This field is required"
                : null,
          ),
        ],
        spacing,
        CustomTextField(
          hintText: 'Enter residential address',
          label: 'Residential Address',
          prefixIcon: AppAssets.icons.home.path,
          iconHeight: iconHeight,
          iconWidth: iconWidth,
          hintTextColor: AppColors.textIconGrey,
          onChanged: notifier.updateResidentialAddress,
          hasError:
              regState.hasSubmitted && regState.residentialAddress.isEmpty,
          errorMessage:
              regState.hasSubmitted && regState.residentialAddress.isEmpty
              ? "This field is required"
              : null,
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
                  value: regState.residentialState.isEmpty
                      ? null
                      : notifier.selectedState,
                  onChanged: (val) {
                    notifier.updateResidentialState(val);
                  },
                  hasError:
                      regState.hasSubmitted &&
                      regState.residentialState.isEmpty,
                  errorMessage:
                      regState.hasSubmitted && regState.residentialState.isEmpty
                      ? "This field is required"
                      : null,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: CustomDropdownField(
                  label: 'City/ Town',
                  items: regState.filteredCities,
                  hintText: 'Select City',
                  value: regState.city.isEmpty ? null : notifier.selectedCity,
                  onChanged: notifier.updateCity,
                  hasError: regState.hasSubmitted && regState.city.isEmpty,
                  errorMessage: regState.hasSubmitted && regState.city.isEmpty
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
            value: regState.residentialState.isEmpty
                ? null
                : notifier.selectedState,
            onChanged: (val) {
              notifier.updateResidentialState(val);
            },
            hasError:
                regState.hasSubmitted && regState.residentialState.isEmpty,
            errorMessage:
                regState.hasSubmitted && regState.residentialState.isEmpty
                ? "This field is required"
                : null,
          ),
          spacing,
          CustomDropdownField(
            label: 'City/ Town',
            items: regState.residentialState.isEmpty
                ? []
                : regState.filteredCities,
            hintText: 'Select City',
            value: regState.city.isEmpty ? null : notifier.selectedCity,
            onChanged: regState.residentialState.isEmpty
                ? null
                : (val) => notifier.updateCity(val),
            hasError: regState.hasSubmitted && regState.city.isEmpty,
            errorMessage: regState.hasSubmitted && regState.city.isEmpty
                ? "This field is required"
                : null,
          ),
        ],
        spacing,
        if (isRider)
          CustomDropdownField(
            label: 'Means of Transportation',
            items: const ['Feet', 'Bicycle', 'Car', 'Bike', 'Bus'],
            hintText: 'Bike',
            value: notifier.selectedTransport,
            onChanged: notifier.updateModeOfTransport,
            prefixIcon: AppAssets.icons.motorbike.svg(
              height: iconHeight,
              width: iconWidth,
            ),
            hasError:
                regState.hasSubmitted &&
                (regState.modeOfTransport?.isEmpty ?? true),
            errorMessage:
                regState.hasSubmitted &&
                    (regState.modeOfTransport?.isEmpty ?? true)
                ? "This field is required"
                : null,
          ),
        spacing,
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Row(
            children: [
              CustomCheckBox(
                sizedBoxHeight: context.isWeb ? 34 : 11,
                value: regState.agreeToTerms,
                onChanged: notifier.toggleAgreeToTerms,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "I agree to wiGO MARKET ",
                        style: GoogleFonts.hind(
                          fontSize: context.isWeb ? 16 : 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textBlackGrey,
                        ),
                      ),
                      TextSpan(
                        text: "Terms of services",
                        style: GoogleFonts.hind(
                          fontSize: context.isWeb ? 16 : 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textOrange,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            /// Handle terms tap
                          },
                      ),
                      TextSpan(
                        text: " and ",
                        style: GoogleFonts.hind(
                          fontSize: context.isWeb ? 16 : 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textBlackGrey,
                        ),
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: GoogleFonts.hind(
                          fontSize: context.isWeb ? 16 : 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textOrange,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            /// Handle privacy tap
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
