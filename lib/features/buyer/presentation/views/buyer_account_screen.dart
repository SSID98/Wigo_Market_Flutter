import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/contact_text_field.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/models/location_data.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../../core/utils/helper_methods.dart';
import '../../../../shared/viewmodels/location_notifier.dart';

class BuyerAccountScreen extends StatelessWidget {
  const BuyerAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    bool isHandlingBack = false;
    final buyerInfoSection = _BuyerInfoSection();

    return isWeb
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: buyerInfoSection,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Save',
              onPressed: () {},
              fontSize: 18,
              fontWeight: FontWeight.w500,
              borderRadius: 16,
              height: 50,
              width: 616,
            ),
            const SizedBox(height: 20),
          ],
        )
        : PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (isHandlingBack || didPop) return;
            isHandlingBack = true;
            showLoadingDialog(context);
            await Future.delayed(const Duration(seconds: 1));
            if (!context.mounted) return;
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context).pop(result);
          },
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                color: AppColors.shadowColor.withValues(alpha: 0.09),
                width: 3,
              ),
            ),
            margin: EdgeInsets.only(bottom: 20, top: 10),
            color: AppColors.backgroundWhite,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SingleChildScrollView(child: buyerInfoSection),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Save',
                    onPressed: () {},
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 45,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
  }
}

class _BuyerInfoSection extends ConsumerWidget {
  const _BuyerInfoSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationProvider);
    final notifier = ref.read(locationProvider.notifier);
    final isWeb = MediaQuery.of(context).size.width > 800;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Update your Personal Information",
              style: GoogleFonts.hind(
                fontSize: isWeb ? 24 : 16,
                fontWeight: isWeb ? FontWeight.w600 : FontWeight.w700,
                color: AppColors.textBlackGrey,
              ),
            ),
            if (isWeb) _editButton(isWeb: isWeb),
          ],
        ),
        if (!isWeb) ...[
          const SizedBox(height: 20),
          _editButton(isWeb: isWeb),
          const SizedBox(height: 20),
        ],
        const SizedBox(height: 10),
        CustomTextField(
          hintText: 'e.g John Doe',
          label: 'Full Name',
          prefixIcon: AppAssets.icons.user.path,
          hintTextColor: AppColors.textBlack,
        ),
        GridView.builder(
          padding: EdgeInsets.only(top: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? 2 : 1,
            crossAxisSpacing: isWeb ? 13 : 0,
            mainAxisSpacing: 13,
            mainAxisExtent: 85,
          ),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return CustomTextField(
                  hintText: 'johndoe@gmail.com',
                  label: 'Email Address',
                  prefixIcon: AppAssets.icons.mail.path,
                  hintTextColor: AppColors.textBlackGrey,
                );
              case 1:
                return CustomPhoneNumberField(
                  label: 'Phone Number',
                  contentPadding: EdgeInsets.only(bottom: isWeb ? 3.5 : 0),
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
        CustomTextField(
          hintText: 'Enter residential address',
          label: 'Residential Address',
          prefixIcon: AppAssets.icons.mail.path,
          hintTextColor: AppColors.textBlackGrey,
        ),
        GridView.builder(
          padding: EdgeInsets.only(top: 10, bottom: 40),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? 2 : 1,
            crossAxisSpacing: isWeb ? 13 : 0,
            mainAxisSpacing: 5,
            mainAxisExtent: 85,
          ),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return CustomDropdownField(
                  label: 'State',
                  items: nigeriaStatesAndCities.keys.toList(),
                  hintText: 'Select State',
                  value:
                      location.selectedState.isEmpty
                          ? null
                          : location.selectedState,
                  onChanged: (val) {
                    notifier.setStateValue(val);
                  },
                  labelTextColor: AppColors.textBlack,
                );
              case 1:
                return CustomDropdownField(
                  label: 'City/ Town',
                  items: location.availableCities,
                  hintText: 'Select City',
                  value:
                      location.selectedCity.isEmpty
                          ? null
                          : location.selectedCity,
                  onChanged: notifier.updateCity,
                  labelTextColor: AppColors.textBlack,
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Update Password",
              style: GoogleFonts.hind(
                fontSize: isWeb ? 24 : 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackGrey,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'Enter Current Password',
              label: 'Current Password',
              isPassword: true,
              prefixIcon: AppAssets.icons.lock.path,
              suffixIcon: Icon(Icons.visibility_outlined),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              hintText: 'Enter New Password',
              label: 'New Password',
              isPassword: true,
              prefixIcon: AppAssets.icons.lock.path,
              suffixIcon: Icon(Icons.visibility_outlined),
            ),
          ],
        ),
      ],
    );
  }

  Widget _editButton({required bool isWeb}) {
    return Row(
      children: [
        AppAssets.icons.edit.svg(height: isWeb ? 24 : 18),
        const SizedBox(width: 4),
        Text(
          "Edit Profile",
          style: GoogleFonts.hind(
            fontSize: isWeb ? 18 : 14,
            fontWeight: FontWeight.w400,
            color: AppColors.primaryDarkGreen,
          ),
        ),
      ],
    );
  }
}
