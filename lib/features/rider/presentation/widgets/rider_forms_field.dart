import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/models/location_data.dart';
import 'package:wigo_flutter/shared/widgets/custom_text_field.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/contact_text_field.dart';
import '../../viewmodels/account_setup_viewmodels/rider_account_creation_viewmodel.dart';

class RiderFormFields extends ConsumerWidget {
  final bool web;
  final double iconHeight;
  final double iconWidth;
  final double hintFontSize;
  final Widget? suffixIcon;

  const RiderFormFields({
    super.key,
    this.web = false,
    required this.iconHeight,
    required this.iconWidth,
    required this.hintFontSize,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(riderAccountViewModelProvider);
    final spacing = const SizedBox(height: 16);

    return Column(
      children: [
        CustomTextField(
          hintText: 'eg. John Doe',
          label: 'Full Name',
          prefixIcon: AppAssets.icons.user.path,
          iconHeight: iconHeight,
          iconWidth: iconWidth,
        ),
        spacing,
        CustomTextField(
          hintText: 'johndoe112@gmail.com',
          label: 'Email address',
          prefixIcon: AppAssets.icons.mail.path,
          iconHeight: iconHeight,
          iconWidth: iconWidth,
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
        ),
        spacing,
        CustomPhoneNumberField(label: 'Phone Number'),
        spacing,
        CustomPhoneNumberField(label: 'Next of Kin Contact'),
        spacing,
        CustomDropdownField(
          label: 'Gender',
          hintText: 'Select your Gender',
          items: const ['Male', 'Female'],
          iconSize: 22,
          prefixIcon: AppAssets.icons.user.svg(
            width: iconWidth,
            height: iconHeight,
          ),
        ),
        spacing,
        CustomTextField(
          hintText: 'Enter residential address',
          label: 'Residential Address',
          prefixIcon: AppAssets.icons.home.path,
          iconHeight: iconHeight,
          iconWidth: iconWidth,
          hintTextColor: AppColors.textIconGrey,
        ),
        spacing,
        if (web)
          Row(
            children: [
              Expanded(
                child: CustomDropdownField(
                  label: 'State',
                  items: nigeriaStatesAndCities.keys.toList(),
                  iconSize: 22,
                  hintText: 'Select State',
                  value: viewModel.selectedState,
                  onChanged: viewModel.setStateValue,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: CustomDropdownField(
                  label: 'City/ Town',
                  items: viewModel.filteredCities,
                  iconSize: 22,
                  hintText: 'Select City',
                  value: viewModel.selectedCity,
                  onChanged: viewModel.setCityValue,
                ),
              ),
            ],
          )
        else ...[
          CustomDropdownField(
            label: 'State',
            items: nigeriaStatesAndCities.keys.toList(),
            iconSize: 22,
            hintText: 'Select State',
            onChanged: viewModel.setStateValue,
          ),
          spacing,
          CustomDropdownField(
            label: 'City/ Town',
            items: viewModel.filteredCities,
            iconSize: 22,
            hintText: 'Select City',
            value: viewModel.selectedCity,
            onChanged: viewModel.setCityValue,
          ),
          spacing,
        ],
        spacing,
        CustomDropdownField(
          label: 'Means of Transportation',
          items: const ['Motor Bike', 'Four Wheel'],
          iconSize: 22,
          hintText: 'Motor Bike',
          prefixIcon: AppAssets.icons.motorbike.svg(
            height: iconHeight,
            width: iconWidth,
          ),
        ),
      ],
    );
  }
}
