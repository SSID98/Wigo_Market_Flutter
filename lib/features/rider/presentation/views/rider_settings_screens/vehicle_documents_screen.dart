import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wigo_flutter/core/utils/context_extensions.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/custom_loading_overlay.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/helper_methods_classes.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_banner.dart';
import '../../../../../shared/widgets/custom_single_date_picker.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../../../shared/widgets/upload_box.dart';
import '../../../models/rider_vehicle_profile_state.dart';
import '../../../viewmodels/rider_vehicle_profile_viewmodel.dart';

class VehicleAndDocumentsScreen extends HookConsumerWidget {
  const VehicleAndDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = context.isWeb;
    final state = ref.watch(riderVehicleProfileViewmodelProvider);
    final vm = ref.read(riderVehicleProfileViewmodelProvider.notifier);

    useEffect(() {
      Future.microtask(() {
        if (!context.mounted) return;
        vm.fetchProfileIfNeeded(context);
      });
      return null;
    }, const []);

    if (state.profileLoadStatus == ProfileLoadStatus.error) {
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
                  Icons.wifi_off_rounded,
                  size: 56,
                  color: AppColors.textIconGrey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Could not reach the server.\nCheck your connection and try again.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.hind(
                    fontSize: 15,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Retry',
                  onPressed: () => vm.fetchProfileIfNeeded(context),
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

    final bool isReadOnly = state.hasProfile && !state.isEditMode;

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
    final state = ref.watch(riderVehicleProfileViewmodelProvider);
    final vm = ref.read(riderVehicleProfileViewmodelProvider.notifier);

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
              else if (state.hasProfile)
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
                _buildVehicleInfoSection(context, ref, isReadOnly),
                const SizedBox(height: 30),
                _buildDocumentVerificationSection(context, ref, isReadOnly),
                const SizedBox(height: 30),
                _buildWorkingDaysSection(context, ref, isReadOnly),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),

        if (!isReadOnly) ...[
          if (state.hasProfile)
            CustomButton(
              text: 'Update',
              onPressed: () async {
                final ok = await runWithOverlay(
                  context,
                  () async {
                    await vm.updateProfile(ref);
                  },
                  spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen),
                );
                if (!context.mounted) return;
                if (ok) {
                  showSuccessBanner('Profile updated successfully', context);
                } else {
                  final freshState = ref.read(
                    riderVehicleProfileViewmodelProvider,
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
            )
          else
            CustomButton(
              text: 'Save',
              onPressed: () async {
                final ok = await runWithOverlay(
                  context,
                  () async {
                    return await vm.submit(ref);
                  },
                  spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen),
                );
                if (!context.mounted) return;
                if (ok) {
                  showSuccessBanner(
                    'Vehicle information saved successfully',
                    context,
                  );
                } else {
                  final freshState = ref.read(
                    riderVehicleProfileViewmodelProvider,
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
                child: _buildVehicleInfoSection(context, ref, isReadOnly),
              ),
            ),

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDocumentVerificationSection(context, ref, isReadOnly),
                    const SizedBox(height: 28),
                    _buildWorkingDaysSection(context, ref, isReadOnly),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleInfoSection(
    BuildContext context,
    WidgetRef ref,
    bool isReadOnly,
  ) {
    final isWeb = context.isWeb;
    final vm = ref.read(riderVehicleProfileViewmodelProvider.notifier);
    final state = ref.watch(riderVehicleProfileViewmodelProvider);

    final bool isBasicMode = [
      'feet',
      'bicycle',
    ].contains(state.type.toLowerCase());

    final bool hasVehicleFieldError =
        !isBasicMode &&
        (state.hasSubmitted && state.plateNumber.isEmpty ||
            state.hasSubmitted && state.make.isEmpty ||
            state.hasSubmitted && state.model.isEmpty ||
            state.hasSubmitted && state.color.isEmpty ||
            state.hasSubmitted && state.year.isEmpty);

    final bool hasError =
        (state.hasSubmitted && state.type.isEmpty) || hasVehicleFieldError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Vehicle Information",
                style: GoogleFonts.hind(
                  fontSize: isWeb ? 24 : 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlackGrey,
                ),
              ),
              if (isWeb) ...[
                const SizedBox(height: 20),
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
                      if (state.hasProfile) ...[
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
                      ],
                      CustomButton(
                        text: state.hasProfile ? 'Update' : 'Save',
                        onPressed: state.isLoading
                            ? null
                            : () async {
                                final ok = await runWithOverlay(
                                  context,
                                  () async {
                                    return state.hasProfile
                                        ? await vm.updateProfile(ref)
                                        : await vm.submit(ref);
                                  },
                                  spinner: SpinKitDualRing(
                                    color: AppColors.primaryDarkGreen,
                                  ),
                                );
                                if (!context.mounted) return;
                                if (ok) {
                                  showSuccessBanner(
                                    "Vehicle information updated successfully",
                                    context,
                                  );
                                } else {
                                  final freshState = ref.read(
                                    riderVehicleProfileViewmodelProvider,
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

        GridView.builder(
          padding: const EdgeInsets.only(top: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: isBasicMode ? 1 : 6,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? 2 : 1,
            crossAxisSpacing: isWeb ? 13 : 0,
            mainAxisSpacing: 5,
            mainAxisExtent: hasError ? 93 : 85,
          ),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return CustomDropdownField(
                  label: 'Means of Transportation',
                  items: const ['Feet', 'Bicycle', 'Car', 'Motor Bike', 'Bus'],
                  hintText: 'Car',
                  prefixIcon: AppAssets.icons.car.svg(),
                  labelTextColor: AppColors.textBlack,
                  hintTextColor: AppColors.textBodyText,
                  value: vm.selectedTransportMode,
                  onChanged: isReadOnly ? null : vm.updateTransportMode,
                  hasError:
                      !isReadOnly && state.hasSubmitted && state.type.isEmpty,
                  errorMessage:
                      !isReadOnly && state.hasSubmitted && state.type.isEmpty
                      ? "This field is required"
                      : null,
                );

              case 1:
                return CustomTextField(
                  controller: vm.plateNumberController,
                  enabled: !isReadOnly,
                  hintText: 'MRT12345',
                  label: 'Licence Plate Number',
                  prefixIcon: AppAssets.icons.mail.path,
                  onChanged: vm.updatePlateNumber,
                  hasError:
                      !isReadOnly &&
                      state.hasSubmitted &&
                      state.plateNumber.isEmpty,
                  errorMessage:
                      !isReadOnly &&
                          state.hasSubmitted &&
                          state.plateNumber.isEmpty
                      ? "This field is required"
                      : null,
                );

              case 2:
                return CustomTextField(
                  controller: vm.makeController,
                  enabled: !isReadOnly,
                  hintText: 'Toyota',
                  label: 'Make',
                  prefixIcon: AppAssets.icons.menu.path,
                  iconHeight: 18,
                  iconWidth: 18,
                  onChanged: vm.updateMake,
                  hasError:
                      !isReadOnly && state.hasSubmitted && state.make.isEmpty,
                  errorMessage:
                      !isReadOnly && state.hasSubmitted && state.make.isEmpty
                      ? "This field is required"
                      : null,
                );

              case 3:
                return CustomTextField(
                  controller: vm.modelController,
                  enabled: !isReadOnly,
                  hintText: 'Corolla LE',
                  label: 'Model',
                  prefixIcon: AppAssets.icons.menu.path,
                  iconHeight: 18,
                  iconWidth: 18,
                  onChanged: vm.updateModel,
                  hasError:
                      !isReadOnly && state.hasSubmitted && state.model.isEmpty,
                  errorMessage:
                      !isReadOnly && state.hasSubmitted && state.model.isEmpty
                      ? "This field is required"
                      : null,
                );

              case 4:
                return CustomTextField(
                  controller: vm.colorController,
                  enabled: !isReadOnly,
                  hintText: 'Red',
                  label: 'Color',
                  prefixIcon: AppAssets.icons.menu.path,
                  onChanged: vm.updateColor,
                  iconHeight: 18,
                  iconWidth: 18,
                  hasError:
                      !isReadOnly && state.hasSubmitted && state.color.isEmpty,
                  errorMessage:
                      !isReadOnly && state.hasSubmitted && state.color.isEmpty
                      ? "This field is required"
                      : null,
                );

              case 5:
                return CustomTextField(
                  controller: vm.yearController,
                  enabled: !isReadOnly,
                  hintText: '2003',
                  label: 'Year',
                  prefixIcon: AppAssets.icons.calender.path,
                  onChanged: vm.updateYear,
                  hasError:
                      !isReadOnly && state.hasSubmitted && state.year.isEmpty,
                  errorMessage:
                      !isReadOnly && state.hasSubmitted && state.year.isEmpty
                      ? "This field is required"
                      : null,
                );

              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Widget _buildDocumentVerificationSection(
    BuildContext context,
    WidgetRef ref,
    bool isReadOnly,
  ) {
    final isWeb = context.isWeb;
    final state = ref.watch(riderVehicleProfileViewmodelProvider);

    final bool isBasicMode = [
      'feet',
      'bicycle',
    ].contains(state.type.toLowerCase());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Documents Verification",
          style: GoogleFonts.hind(
            fontSize: isWeb ? 24 : 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlackGrey,
          ),
        ),
        SizedBox(height: isWeb ? 0 : 10),

        if (!isReadOnly) ...[
          Text(
            "(JPEG, PNG, and PDF, up to 5MB)",
            style: GoogleFonts.hind(
              fontSize: isWeb ? 14 : 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textBlackGrey,
            ),
          ),
          SizedBox(height: isWeb ? 0 : 10),
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Text(
              "Note*  Ensure document is clearly visible and readable, "
              "All corners of the document should be visible, "
              "Avoid glare, shadows, or blurry images, "
              "Document should be current and not expired",
              style: GoogleFonts.hind(
                fontSize: isWeb ? 14 : 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textRed,
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),

        if (isBasicMode)
          if (isWeb)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildNINBlock(context, ref, isReadOnly)),
                const SizedBox(width: 13),
                const Expanded(child: SizedBox()),
              ],
            )
          else
            _buildNINBlock(context, ref, isReadOnly)
        else if (isWeb)
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildVehicleRegBlock(context, ref, isReadOnly),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: _buildDriverLicenseBlock(context, ref, isReadOnly),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildNINBlock(context, ref, isReadOnly)),
                  const SizedBox(width: 13),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          )
        else
          Column(
            children: [
              _buildVehicleRegBlock(context, ref, isReadOnly),
              const SizedBox(height: 30),
              _buildDriverLicenseBlock(context, ref, isReadOnly),
              const SizedBox(height: 30),
              _buildNINBlock(context, ref, isReadOnly),
            ],
          ),
      ],
    );
  }

  Widget _buildVehicleRegBlock(
    BuildContext context,
    WidgetRef ref,
    bool isReadOnly,
  ) {
    final vm = ref.read(riderVehicleProfileViewmodelProvider.notifier);
    final state = ref.watch(riderVehicleProfileViewmodelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: vm.vehicleRegNumberController,
          enabled: !isReadOnly,
          hintText: 'e.g. VRN123456',
          label: 'Vehicle Reg. Number',
          prefixIcon: AppAssets.icons.vehicleDoc.path,
          blendMode: BlendMode.color,
          prefixIconColor: AppColors.textIconGrey,
          iconHeight: 20,
          iconWidth: 20,
          onChanged: vm.updateVehicleRegNumber,
          hasError:
              !isReadOnly &&
              state.hasSubmitted &&
              state.vehicleRegNumber.isEmpty,
          errorMessage:
              !isReadOnly &&
                  state.hasSubmitted &&
                  state.vehicleRegNumber.isEmpty
              ? "This field is required"
              : null,
        ),
        const SizedBox(height: 8),

        _buildDatePickerField(
          context: context,
          label: 'Reg. Expiry Date',
          controller: vm.vehicleRegExpiryController,
          isReadOnly: isReadOnly,
          onDateSelected: (dateStr) {
            vm.updateVehicleRegExpiry(dateStr);
          },
          hasError:
              !isReadOnly &&
              state.hasSubmitted &&
              state.vehicleRegExpiry.isEmpty,
          errorMessage:
              !isReadOnly &&
                  state.hasSubmitted &&
                  state.vehicleRegExpiry.isEmpty
              ? 'This field is required'
              : null,
        ),
        const SizedBox(height: 8),

        if (isReadOnly)
          _buildDocumentStatusTile(
            label: 'Vehicle Registration',
            number: state.vehicleRegNumber,
            expiry: state.vehicleRegExpiry,
          )
        else
          UploadBox(
            hintText: 'Upload',
            label: 'Vehicle Registration Document',
            onFileSelected: (file) => ref
                .read(riderVehicleProfileViewmodelProvider.notifier)
                .uploadVehicleReg(file),
            isUploading: state.isUploadingDriverRegistration,
            progress: state.driverRegProgress,
            onCancel: vm.cancelVehicleRegUpload,
            onRetry: vm.retryVehicleRegUpload,
            uploadFailed: state.driverRegUploadFailed,
            hasError: state.hasSubmitted && state.vehicleReg.isEmpty,
            errorMessage: state.hasSubmitted && state.vehicleReg.isEmpty
                ? "This field is required"
                : null,
          ),
      ],
    );
  }

  Widget _buildDriverLicenseBlock(
    BuildContext context,
    WidgetRef ref,
    bool isReadOnly,
  ) {
    final vm = ref.read(riderVehicleProfileViewmodelProvider.notifier);
    final state = ref.watch(riderVehicleProfileViewmodelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: vm.driverLicenseNumberController,
          hintText: 'e.g. LIC123456',
          label: "Driver's Licence Number",
          enabled: !isReadOnly,
          prefixIcon: AppAssets.icons.user2.path,
          iconHeight: 18,
          iconWidth: 18,
          onChanged: vm.updateDriverLicenseNumber,
          hasError:
              !isReadOnly &&
              state.hasSubmitted &&
              state.driverLicenseNumber.isEmpty,
          errorMessage:
              !isReadOnly &&
                  state.hasSubmitted &&
                  state.driverLicenseNumber.isEmpty
              ? "This field is required"
              : null,
        ),
        const SizedBox(height: 8),
        _buildDatePickerField(
          context: context,
          label: 'Licence Expiry Date',
          controller: vm.driverLicenseExpiryController,
          isReadOnly: isReadOnly,
          onDateSelected: (dateStr) {
            vm.updateDriverLicenseExpiry(dateStr);
          },
          hasError:
              !isReadOnly &&
              state.hasSubmitted &&
              state.driverLicenseExpiry.isEmpty,
          errorMessage:
              !isReadOnly &&
                  state.hasSubmitted &&
                  state.driverLicenseExpiry.isEmpty
              ? 'This field is required'
              : null,
        ),

        const SizedBox(height: 8),

        if (isReadOnly)
          _buildDocumentStatusTile(
            label: "Driver's Licence",
            number: state.driverLicenseNumber,
            expiry: state.driverLicenseExpiry,
          )
        else
          UploadBox(
            hintText: "Upload",
            label: "Driver's Licence Document",
            onFileSelected: (file) {
              ref
                  .read(riderVehicleProfileViewmodelProvider.notifier)
                  .uploadDriverLicense(file);
            },
            isUploading: state.isUploadingDriverLicense,
            progress: state.licenseProgress,
            onCancel: vm.cancelLicenseUpload,
            onRetry: vm.retryLicenseUpload,
            uploadFailed: state.driverLicenseUploadFailed,
            hasError: state.hasSubmitted && state.license.isEmpty,
            errorMessage: state.hasSubmitted && state.license.isEmpty
                ? "This field is required"
                : null,
          ),
      ],
    );
  }

  Widget _buildNINBlock(BuildContext context, WidgetRef ref, bool isReadOnly) {
    final vm = ref.read(riderVehicleProfileViewmodelProvider.notifier);
    final state = ref.watch(riderVehicleProfileViewmodelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: vm.ninNumberController,
          hintText: 'e.g. 12345678901',
          label: 'NIN Number',
          enabled: !isReadOnly,
          prefixIcon: AppAssets.icons.fileValidation.path,
          iconHeight: 18,
          iconWidth: 18,
          onChanged: vm.updateNinNumber,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          hasError:
              !isReadOnly &&
              state.hasSubmitted &&
              state.ninNumber.isEmpty &&
              state.ninNumber.length != 11,
          errorMessage:
              !isReadOnly && state.hasSubmitted && state.ninNumber.isEmpty
              ? "This field is required"
              : state.hasSubmitted && state.ninNumber.length != 11
              ? "Incorrect NIN number"
              : null,
        ),
        const SizedBox(height: 8),
        if (isReadOnly)
          _buildDocumentStatusTile(
            label: 'NIN',
            number: state.ninNumber,
            expiry: '',
          )
        else
          UploadBox(
            hintText: "Upload",
            label: 'NIN Document for Verification',
            onFileSelected: (file) => ref
                .read(riderVehicleProfileViewmodelProvider.notifier)
                .uploadNin(file),

            isUploading: state.isUploadingNin,
            progress: state.ninProgress,
            onCancel: vm.cancelNinUpload,
            onRetry: vm.retryNinUpload,
            uploadFailed: state.ninUploadFailed,
            hasError: state.hasSubmitted && state.ownerNIN.isEmpty,
            errorMessage: state.hasSubmitted && state.ownerNIN.isEmpty
                ? "This field is required"
                : null,
          ),
      ],
    );
  }

  Widget _buildWorkingDaysSection(
    BuildContext context,
    WidgetRef ref,
    bool isReadOnly,
  ) {
    final state = ref.watch(riderVehicleProfileViewmodelProvider);
    final vm = ref.read(riderVehicleProfileViewmodelProvider.notifier);
    final isWeb = context.isWeb;

    const List<Map<String, String>> days = [
      {'key': 'monday', 'label': 'Mon'},
      {'key': 'tuesday', 'label': 'Tue'},
      {'key': 'wednesday', 'label': 'Wed'},
      {'key': 'thursday', 'label': 'Thu'},
      {'key': 'friday', 'label': 'Fri'},
      {'key': 'saturday', 'label': 'Sat'},
      {'key': 'sunday', 'label': 'Sun'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'What are your working days?',
          style: GoogleFonts.hind(
            fontSize: isWeb ? 24 : 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 12),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 0,
          childAspectRatio: 2,
          padding: EdgeInsets.only(right: 40),
          children: days.map((day) {
            final isSelected = state.workingDays.contains(day['key']);
            return GestureDetector(
              onTap: isReadOnly ? null : () => vm.toggleWorkingDay(day['key']!),
              child: AnimatedContainer(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryDarkGreen
                      : AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryDarkGreen
                        : AppColors.borderColor,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    day['label']!,
                    style: GoogleFonts.hind(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.textWhite
                          : AppColors.textBlackGrey,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        if (state.hasSubmitted && state.workingDays.isEmpty && !isReadOnly) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.error,
                      color: AppColors.accentRed,
                      size: context.isWeb ? 18 : 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Please select at least one working day',
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w400,
                        fontSize: context.isWeb ? 14 : 12,
                        color: AppColors.accentRed,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDatePickerField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required bool isReadOnly,
    required Function(String dateStr) onDateSelected,
    bool hasError = false,
    String? errorMessage,
  }) {
    return GestureDetector(
      onTap: isReadOnly
          ? null
          : () async {
              final initialDate = DateHelpers.fromApiDateString(
                controller.text,
              );
              final picked = await showSingleDatePickerModal(
                context,
                initialDate: initialDate,
              );
              if (picked != null) {
                final formatted = DateHelpers.toApiDateString(picked);
                controller.text = formatted;
                onDateSelected(formatted);
              }
            },
      child: AbsorbPointer(
        child: CustomTextField(
          controller: controller,
          enabled: !isReadOnly,
          hintText: 'YYYY-MM-DD',
          label: label,
          prefixIcon: AppAssets.icons.calender.path,
          hintTextColor: AppColors.textBlackGrey,
          hasError: hasError,
          errorMessage: errorMessage,
        ),
      ),
    );
  }

  Widget _buildDocumentStatusTile({
    required String label,
    required String number,
    required String expiry,
  }) {
    final hasExpiry = expiry.isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_rounded,
            color: AppColors.primaryDarkGreen,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.hind(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                Text(
                  'No. ${number.isNotEmpty ? number : "—"}'
                  '${hasExpiry ? "  •  Expires: $expiry" : ""}',
                  style: GoogleFonts.hind(
                    fontSize: 11,
                    color: AppColors.textBodyText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton({
    bool isEdit = true,
    required VoidCallback onPressed,
  }) {
    return CustomButton(
      text: isEdit ? "Edit Profile" : "Cancel Edit",
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 41.31,
      width: 130,
      prefixIcon: isEdit
          ? AppAssets.icons.pencilEdit.svg()
          : Icon(Icons.close_rounded, color: AppColors.accentRed),
      onPressed: onPressed,
      borderRadius: 4,
    );
  }
}
