import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/models/location_data.dart';
import 'package:wigo_flutter/shared/widgets/custom_text_field.dart';

import '../../core/providers/role_selection_provider.dart';
import '../../gen/assets.gen.dart';
import '../models/user_role.dart';
import '../viewmodels/account_creation_viewmodel.dart';
import 'contact_text_field.dart';

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
    final role = ref.watch(userRoleProvider);
    final isSeller = role == UserRole.seller;
    final isRider = role == UserRole.dispatch;

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
        ),
        spacing,
        CustomTextField(
          hintText: 'johndoe112@gmail.com',
          label: 'Email address',
          prefixIcon: AppAssets.icons.mail.path,
          iconHeight: iconHeight,
          iconWidth: iconWidth,
          hintTextColor: AppColors.textBodyText,
          hasError: regState.hasSubmitted && regState.emailError != null,
          errorMessage: regState.hasSubmitted ? regState.emailError : null,
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
          hasError: regState.hasSubmitted && regState.passwordError != null,
          errorMessage: regState.hasSubmitted ? regState.passwordError : null,
          onChanged: notifier.updatePassword,
        ),
        spacing,
        CustomPhoneNumberField(
          label: 'Phone Number',
          onChanged: notifier.updateMobile,
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
          ),
          spacing,
          CustomPhoneNumberField(
            label: 'Next of Kin Contact',
            onChanged: notifier.updateNextOfKinPhone,
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
            value: regState.gender,
            prefixIcon: AppAssets.icons.user.svg(
              width: iconWidth,
              height: iconHeight,
            ),
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
            value: regState.gender,
            prefixIcon: AppAssets.icons.user.svg(
              width: iconWidth,
              height: iconHeight,
            ),
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
                      regState.residentialState.isEmpty
                          ? null
                          : regState.residentialState,
                  onChanged: (val) {
                    notifier.updateResidentialState(val ?? '');
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: CustomDropdownField(
                  label: 'City/ Town',
                  items: regState.filteredCities,
                  hintText: 'Select City',
                  value: regState.city.isEmpty ? null : regState.city,
                  onChanged: notifier.updateCity,
                ),
              ),
            ],
          )
        else ...[
          CustomDropdownField(
            label: 'State',
            items: nigeriaStatesAndCities.keys.toList(),
            hintText: 'Select State',
            value:
                regState.residentialState.isEmpty
                    ? null
                    : regState.residentialState,
            onChanged: (val) {
              notifier.setStateValue(val);
            },
          ),
          spacing,
          CustomDropdownField(
            label: 'City/ Town',
            items:
                regState.residentialState.isEmpty
                    ? []
                    : regState.filteredCities,
            hintText: 'Select City',
            value: regState.city.isEmpty ? null : regState.city,
            onChanged:
                regState.residentialState.isEmpty
                    ? null
                    : (val) => notifier.updateCity(val),
          ),
        ],
        spacing,
        if (isRider)
          CustomDropdownField(
            label: 'Means of Transportation',
            items: const ['Feet', 'Bicycle', 'Car', 'Bike', 'Bus'],
            hintText: 'Bike',
            value: regState.modeOfTransport,
            onChanged: notifier.updateModeOfTransport,
            prefixIcon: AppAssets.icons.motorbike.svg(
              height: iconHeight,
              width: iconWidth,
            ),
          ),
      ],
    );
  }
}
