import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/rider/viewmodels/rider_profile_account_viewmodel.dart';
import 'package:wigo_flutter/shared/widgets/contact_text_field.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/models/location_data.dart';
import '../../../../../shared/widgets/custom_avatar.dart';
import '../../../../../shared/widgets/custom_text_field.dart';

class ProfileAndAccountScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const ProfileAndAccountScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    final vehicleInfoSection = _VehicleInfoSection(
      showSaveInside: isWeb,
      showUpdatePassword: true,
    );

    return Scaffold(
      appBar:
          isWeb
              ? null
              : AppBar(
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(10),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          child: AppAssets.icons.arrowLeft.svg(),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "Back",
                          style: GoogleFonts.hind(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textBlackGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                surfaceTintColor: Colors.transparent,
                backgroundColor: AppColors.backgroundWhite,
                automaticallyImplyLeading: false,
              ),
      backgroundColor:
          isWeb ? AppColors.backgroundLight : AppColors.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child:
            isWeb
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      margin: EdgeInsets.only(bottom: 20, top: 20),
                      shadowColor: Colors.white70.withValues(alpha: 0.06),
                      color: AppColors.backgroundWhite,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: vehicleInfoSection,
                      ),
                    ),
                  ],
                )
                : Card(
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
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(child: vehicleInfoSection),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Save',
                        onPressed: () {},
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 45,
                        width: 335,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
      ),
    );
  }
}

// VEHICLE INFO SECTION
class _VehicleInfoSection extends ConsumerWidget {
  final bool showSaveInside;
  final bool showUpdatePassword;

  const _VehicleInfoSection({
    required this.showSaveInside,
    required this.showUpdatePassword,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    final viewModel = ref.watch(riderProfileAccountViewModelProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Personal Information",
                style: GoogleFonts.hind(
                  fontSize: isWeb ? 24 : 16,
                  fontWeight: isWeb ? FontWeight.w600 : FontWeight.w700,
                  color: AppColors.textBlackGrey,
                ),
              ),
              if (showSaveInside) ...[
                const SizedBox(height: 20),
                Row(
                  children: [
                    AppAssets.icons.edit.svg(),
                    const SizedBox(width: 4),
                    Text(
                      "Edit Profile",
                      style: GoogleFonts.hind(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryDarkGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: 15),
          CustomAvatar(
            crossAxisAlignment: CrossAxisAlignment.center,
            avatarAlign:
                isWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
            radius: 50,
            showLeftTexts: isWeb ? true : false,
            showBottomText: isWeb ? false : true,
          ),
          GridView.builder(
            padding: EdgeInsets.only(top: 10),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
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
                    hintText: 'e.g John Doe',
                    label: 'Full Name',
                    prefixIcon: AppAssets.icons.user.path,
                    hintTextColor: AppColors.textBlack,
                  );
                case 1:
                  return CustomTextField(
                    hintText: 'johndoe@gmail.com',
                    label: 'Email Address',
                    prefixIcon: AppAssets.icons.mail.path,
                    hintTextColor: AppColors.textBlackGrey,
                  );
                case 2:
                  return CustomPhoneNumberField(label: 'Phone Number');
                case 3:
                  return CustomPhoneNumberField(label: 'Next of Kin Contact');
                case 4:
                  return CustomDropdownField(
                    label: 'Gender',
                    hintText: 'Select your Gender',
                    items: const ['Male', 'Female'],
                    iconWidth: 22,
                    iconHeight: 22,
                    prefixIcon: AppAssets.icons.user.svg(),
                    labelTextColor: AppColors.textBlack,
                  );
                case 5:
                  return CustomDropdownField(
                    label: 'Means of Transportation',
                    items: const ['Car', 'Motor Bike'],
                    hintText: 'Car',
                    prefixIcon: AppAssets.icons.car.svg(),
                    labelTextColor: AppColors.textBlack,
                    hintTextColor: AppColors.textBlackGrey,
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
                    onChanged: viewModel.setStateValue,
                    labelTextColor: AppColors.textBlack,
                  );
                case 1:
                  return CustomDropdownField(
                    label: 'City/ Town',
                    items: viewModel.filteredCities,
                    hintText: 'Select City',
                    value: viewModel.selectedCity,
                    onChanged: viewModel.setCityValue,
                    labelTextColor: AppColors.textBlack,
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
          if (showUpdatePassword) ...[
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
        ],
      ),
    );
  }
}
