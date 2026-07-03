import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wigo_flutter/shared/widgets/contact_text_field.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/context_extensions.dart';
import '../../../../../core/utils/validation_utils.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/models/location_data.dart';
import '../../../../../shared/widgets/custom_avatar.dart';
import '../../../../../shared/widgets/custom_banner.dart';
import '../../../../../shared/widgets/custom_loading_overlay.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../models/rider_personal_profile_state.dart';
import '../../../viewmodels/rider_personal_profile_viewmodel.dart';

class RiderProfileAndAccountScreen extends HookConsumerWidget {
  const RiderProfileAndAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = context.isWeb;
    final state = ref.watch(riderPersonalProfileViewModelProvider);
    final vm = ref.read(riderPersonalProfileViewModelProvider.notifier);

    useEffect(() {
      Future.microtask(() {
        if (!context.mounted) return;
        vm.loadProfileOnce(ref);
      });
      return null;
    }, const []);

    if (state.profileLoadStatus == PersonalProfileLoadStatus.loading ||
        state.profileLoadStatus == PersonalProfileLoadStatus.initial) {
      return Scaffold(
        backgroundColor: isWeb
            ? AppColors.backgroundLight
            : AppColors.backgroundWhite,
        body: const Center(
          child: SpinKitDualRing(color: AppColors.primaryDarkGreen),
        ),
      );
    }

    if (state.profileLoadStatus == PersonalProfileLoadStatus.error) {
      return Scaffold(
        backgroundColor: isWeb
            ? AppColors.backgroundLight
            : AppColors.backgroundWhite,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 56,
                  color: AppColors.textIconGrey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Could not load your profile.\nPlease try again.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.hind(
                    fontSize: 15,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Retry',
                  onPressed: () => vm.loadProfileOnce(ref),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 45,
                  width: 180,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final bool isReadOnly = !state.isEditMode;

    return Scaffold(
      backgroundColor: isWeb
          ? AppColors.backgroundLight
          : AppColors.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
        child: isWeb
            ? _buildWebLayout(context, ref, isReadOnly)
            : _buildMobileLayout(context, ref, isReadOnly),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    bool isReadOnly,
  ) {
    final state = ref.watch(riderPersonalProfileViewModelProvider);
    final vm = ref.read(riderPersonalProfileViewModelProvider.notifier);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: AppAssets.icons.arrowLeft.svg(),
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Back',
                    style: GoogleFonts.hind(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textBlackGrey,
                    ),
                  ),
                ],
              ),
              if (isReadOnly)
                _buildCustomButton(onPressed: vm.enterEditMode)
              else
                _buildCustomButton(onPressed: vm.exitEditMode, isEdit: false),
            ],
          ),
        ),
        const Divider(),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 5),
                _buildPersonalInfoSection(context, ref, isReadOnly),
                const SizedBox(height: 30),
                _buildPasswordSection(context, ref, isReadOnly),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),

        if (!isReadOnly) ...[
          CustomButton(
            text: 'Update',
            onPressed: state.isLoading
                ? null
                : () async {
                    final ok = await runWithOverlay(
                      context,
                      () async => vm.updateProfile(),
                      spinner: SpinKitDualRing(
                        color: AppColors.primaryDarkGreen,
                      ),
                    );
                    if (!context.mounted) return;
                    if (ok) {
                      showSuccessBanner(
                        'Profile updated successfully',
                        context,
                      );
                    } else {
                      final freshState = ref.read(
                        riderPersonalProfileViewModelProvider,
                      );
                      showErrorBanner(
                        freshState.errorMessage ?? 'An error occurred',
                        context,
                      );
                    }
                  },
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 45,
            width: double.infinity,
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildWebLayout(BuildContext context, WidgetRef ref, bool isReadOnly) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 20, top: 20),
              shadowColor: Colors.white70.withValues(alpha: 0.06),
              color: AppColors.backgroundWhite,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildPersonalInfoSection(context, ref, isReadOnly),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(bottom: 20),
              shadowColor: Colors.white70.withValues(alpha: 0.06),
              color: AppColors.backgroundWhite,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildPasswordSection(context, ref, isReadOnly),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(
    BuildContext context,
    WidgetRef ref,
    bool isReadOnly,
  ) {
    final isWeb = context.isWeb;
    final state = ref.watch(riderPersonalProfileViewModelProvider);
    final vm = ref.read(riderPersonalProfileViewModelProvider.notifier);

    final ImageProvider<Object>? backgroundImage = state.image.isNotEmpty
        ? NetworkImage(state.image)
        : null;

    final bool hasFieldError =
        !isReadOnly &&
        state.hasSubmitted &&
        (state.fullName.isEmpty || state.mobile.isEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personal Information',
                style: GoogleFonts.hind(
                  fontSize: isWeb ? 24 : 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlackGrey,
                ),
              ),
              if (isWeb) ...[
                if (isReadOnly)
                  IconButton(
                    icon: AppAssets.icons.edit.svg(),
                    tooltip: 'Edit profile',
                    onPressed: vm.enterEditMode,
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textRed,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        icon: const Icon(Icons.close_rounded, size: 18),
                        label: Text(
                          'Cancel',
                          style: GoogleFonts.hind(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: vm.exitEditMode,
                      ),
                      const SizedBox(width: 8),
                      CustomButton(
                        text: 'Update',
                        onPressed: state.isLoading
                            ? null
                            : () async {
                                final ok = await runWithOverlay(
                                  context,
                                  () async => vm.updateProfile(),
                                  spinner: SpinKitDualRing(
                                    color: AppColors.primaryDarkGreen,
                                  ),
                                );
                                if (!context.mounted) return;
                                if (ok) {
                                  showSuccessBanner(
                                    'Profile updated successfully',
                                    context,
                                  );
                                } else {
                                  final freshState = ref.read(
                                    riderPersonalProfileViewModelProvider,
                                  );
                                  showErrorBanner(
                                    freshState.errorMessage ??
                                        'An error occurred',
                                    context,
                                  );
                                }
                              },
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 41,
                        width: 153,
                      ),
                    ],
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 15),

        CustomAvatar(
          crossAxisAlignment: CrossAxisAlignment.center,
          avatarAlign: isWeb
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          radius: 50,
          profileName: state.fullName.isNotEmpty ? state.fullName : null,
          profileEmail: state.email.isNotEmpty ? state.email : null,
          backgroundImage: backgroundImage,
          showLeftTexts: isWeb,
          showEmail: isWeb,
          showBottomText: isReadOnly && !isWeb,
          isEditMode: !isReadOnly,
          isUploadingPhoto: state.isUploadingPhoto,
          photoUploadFailed: state.photoUploadFailed,
          imageErrorMessage: state.photoErrorMessage,
          onImageSelected: (file) => vm.uploadProfilePhoto(file),
        ),
        const SizedBox(height: 15),

        GridView.builder(
          padding: const EdgeInsets.only(top: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? 2 : 1,
            crossAxisSpacing: isWeb ? 13 : 0,
            mainAxisSpacing: 13,
            mainAxisExtent: hasFieldError ? 100 : 85,
          ),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return CustomTextField(
                  controller: vm.fullNameController,
                  hintText: 'e.g John Doe',
                  label: 'Full Name',
                  prefixIcon: AppAssets.icons.user.path,
                  hintTextColor: AppColors.textBlack,
                  enabled: !isReadOnly,
                  onChanged: vm.updateFullName,
                  hasError:
                      !isReadOnly &&
                      state.hasSubmitted &&
                      state.fullName.trim().isEmpty,
                  errorMessage:
                      !isReadOnly &&
                          state.hasSubmitted &&
                          state.fullName.trim().isEmpty
                      ? 'This field is required'
                      : null,
                );
              case 1:
                return CustomTextField(
                  controller: vm.emailController,
                  hintText: 'johndoe@gmail.com',
                  label: 'Email Address',
                  prefixIcon: AppAssets.icons.mail.path,
                  hintTextColor: AppColors.textBlackGrey,
                  enabled: false,
                );

              case 2:
                return CustomPhoneNumberField(
                  label: 'Phone Number',
                  controller: vm.mobileController,
                  enabled: !isReadOnly,
                  onChanged: vm.updateMobile,
                  contentPadding: EdgeInsets.only(bottom: isWeb ? 3.5 : 0),
                  hasError:
                      !isReadOnly &&
                      state.hasSubmitted &&
                      state.mobile.trim().isEmpty,
                  errorMessage:
                      !isReadOnly &&
                          state.hasSubmitted &&
                          state.mobile.trim().isEmpty
                      ? 'This field is required'
                      : null,
                );

              case 3:
                return CustomTextField(
                  controller: vm.nextOfKinNameController,
                  hintText: 'e.g Jane Doe',
                  label: 'Next of Kin Name',
                  prefixIcon: AppAssets.icons.user.path,
                  hintTextColor: AppColors.textBlackGrey,
                  enabled: !isReadOnly,
                  onChanged: vm.updateNextOfKinName,
                );

              case 4:
                return CustomPhoneNumberField(
                  label: 'Next of Kin Contact',
                  controller: vm.nextOfKinMobileController,
                  enabled: !isReadOnly,
                  onChanged: vm.updateNextOfKinMobile,
                  contentPadding: EdgeInsets.only(bottom: isWeb ? 3.5 : 0),
                );

              // case 5:
              //   return CustomDropdownField(
              //     label: 'Gender',
              //     hintText: 'Select your Gender',
              //     items: isReadOnly ? [] : const ['Male', 'Female'],
              //     iconWidth: 22,
              //     iconHeight: 22,
              //     prefixIcon: AppAssets.icons.user.svg(),
              //     labelTextColor: AppColors.textBlack,
              //     value: vm.selectedGender,
              //     onChanged: isReadOnly ? null : vm.updateGender,
              //   );

              default:
                return const SizedBox.shrink();
            }
          },
        ),

        CustomTextField(
          controller: vm.residentialAddressController,
          hintText: 'Enter residential address',
          label: 'Residential Address',
          prefixIcon: AppAssets.icons.mail.path,
          hintTextColor: AppColors.textBlackGrey,
          enabled: !isReadOnly,
          onChanged: vm.updateResidentialAddress,
        ),
        const SizedBox(height: 13),

        GridView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
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
            final cityItems = state.filteredCities.isNotEmpty
                ? state.filteredCities
                : (nigeriaStatesAndCities[state.residentialState] ??
                      <String>[]);
            switch (index) {
              case 0:
                return CustomDropdownField(
                  label: 'State',
                  items: nigeriaStatesAndCities.keys.toList(),
                  hintText: 'Select State',
                  value: state.residentialState.isEmpty
                      ? null
                      : vm.selectedState,
                  onChanged: isReadOnly ? null : vm.updateResidentialState,
                  labelTextColor: AppColors.textBlack,
                );
              case 1:
                return CustomDropdownField(
                  label: 'City / Town',
                  items: cityItems,
                  hintText: 'Select City',
                  value: state.city.isEmpty ? null : vm.selectedCity,
                  onChanged: isReadOnly ? null : vm.updateCity,
                  labelTextColor: AppColors.textBlack,
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Widget _buildPasswordSection(
    BuildContext context,
    WidgetRef ref,
    bool isReadOnly,
  ) {
    final isWeb = context.isWeb;
    final state = ref.watch(riderPersonalProfileViewModelProvider);
    final vm = ref.read(riderPersonalProfileViewModelProvider.notifier);

    final bool isChangingPassword =
        state.currentPassword.isNotEmpty || state.newPassword.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Update Password',
          style: GoogleFonts.hind(
            fontSize: isWeb ? 24 : 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: vm.currentPasswordController,
          hintText: 'Enter Current Password',
          label: 'Current Password',
          isPassword: true,
          prefixIcon: AppAssets.icons.lock.path,
          suffixIcon: const Icon(Icons.visibility_outlined),
          enabled: !isReadOnly,
          onChanged: vm.updateCurrentPassword,
          hasError:
              !isReadOnly &&
              state.hasSubmitted &&
              isChangingPassword &&
              FormValidators.validateSignupPassword(state.currentPassword) !=
                  null,
          errorMessage: !isReadOnly && state.hasSubmitted && isChangingPassword
              ? FormValidators.validateSignupPassword(state.currentPassword)
              : null,
        ),
        const SizedBox(height: 15),
        CustomTextField(
          controller: vm.newPasswordController,
          hintText: 'Enter New Password',
          label: 'New Password',
          isPassword: true,
          prefixIcon: AppAssets.icons.lock.path,
          suffixIcon: const Icon(Icons.visibility_outlined),
          enabled: !isReadOnly,
          onChanged: vm.updateNewPassword,
          hasError:
              !isReadOnly &&
              state.hasSubmitted &&
              isChangingPassword &&
              FormValidators.validateSignupPassword(state.newPassword) != null,
          errorMessage: !isReadOnly && state.hasSubmitted && isChangingPassword
              ? FormValidators.validateSignupPassword(state.newPassword)
              : null,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildCustomButton({
    bool isEdit = true,
    required VoidCallback onPressed,
  }) {
    return CustomButton(
      text: isEdit ? 'Edit Profile' : 'Cancel Edit',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 41.31,
      width: 130,
      prefixIcon: isEdit
          ? AppAssets.icons.pencilEdit.svg()
          : const Icon(Icons.close_rounded, color: AppColors.accentRed),
      onPressed: onPressed,
      borderRadius: 4,
    );
  }
}
