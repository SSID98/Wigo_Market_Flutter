import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../../../shared/widgets/upload_box.dart';

class VehicleAndDocumentsScreen extends StatelessWidget {
  const VehicleAndDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    final vehicleInfoSection = _VehicleInfoSection(showSaveInside: isWeb);
    final documentVerificationSection = const _DocumentVerificationSection();

    return Scaffold(
      backgroundColor:
          isWeb ? AppColors.backgroundLight : AppColors.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
        child:
            isWeb
                ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 332,
                        child: Card(
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
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        height: 510,
                        child: Card(
                          margin: EdgeInsets.only(bottom: 150, top: 20),
                          shadowColor: Colors.white70.withValues(alpha: 0.06),
                          color: AppColors.backgroundWhite,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: documentVerificationSection,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 50),
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
                    const Divider(),
                    const SizedBox(height: 5),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            vehicleInfoSection,
                            const SizedBox(height: 60),
                            documentVerificationSection,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomButton(
                      text: 'Save',
                      onPressed: () {},
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 45,
                      width: double.infinity,
                    ),
                  ],
                ),
      ),
    );
  }
}

// VEHICLE INFO SECTION
class _VehicleInfoSection extends StatelessWidget {
  final bool showSaveInside;

  const _VehicleInfoSection({required this.showSaveInside});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
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
              if (showSaveInside) ...[
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Save',
                  onPressed: () {},
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 41,
                  width: 153,
                ),
              ],
            ],
          ),
        ),
        GridView.builder(
          padding: EdgeInsets.only(top: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
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
                  label: 'Means of Transportation',
                  items: const ['Car', 'Motor Bike'],
                  hintText: 'Car',
                  prefixIcon: AppAssets.icons.car.svg(),
                  labelTextColor: AppColors.textBlack,
                  hintTextColor: AppColors.textBlackGrey,
                );
              case 1:
                return CustomTextField(
                  hintText: 'MRT12345',
                  label: 'Licence Plate Number',
                  prefixIcon: AppAssets.icons.mail.path,
                  hintTextColor: AppColors.textBlackGrey,
                );
              case 2:
                return CustomTextField(
                  hintText: 'Toyota Corolla LE',
                  label: 'Make & Model',
                  prefixIcon: AppAssets.icons.menu.path,
                  hintTextColor: AppColors.textBlackGrey,
                  iconHeight: 18,
                  iconWidth: 18,
                );
              case 3:
                return CustomTextField(
                  hintText: '2003',
                  label: 'Year',
                  prefixIcon: AppAssets.icons.calender.path,
                  hintTextColor: AppColors.textBlackGrey,
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}

// DOCUMENTS SECTION
class _DocumentVerificationSection extends StatelessWidget {
  const _DocumentVerificationSection();

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
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
            "Note*  Ensure document is clearly visible and readable, All corners of the document should be visible, Avoid glare, shadows, or blurry images, Document should be current and not expired",
            style: GoogleFonts.hind(
              fontSize: isWeb ? 14 : 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textRed,
            ),
          ),
        ),
        GridView.builder(
          padding: EdgeInsets.only(top: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? 2 : 1,
            crossAxisSpacing: isWeb ? 13 : 0,
            mainAxisSpacing: 5,
            mainAxisExtent: isWeb ? 95 : 85,
          ),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return UploadBox(
                  fileName: 'Upload',
                  label: 'Vehicle Registration',
                );
              case 1:
                return UploadBox(fileName: "Upload", label: 'Drivers License');
              case 2:
                return UploadBox(
                  fileName: "Upload",
                  label: 'Upload your NIN document for Verification',
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
