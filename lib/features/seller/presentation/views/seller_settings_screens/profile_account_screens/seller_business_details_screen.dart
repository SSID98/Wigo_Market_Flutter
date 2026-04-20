import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/context_extensions.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../shared/models/location_data.dart';
import '../../../../../../shared/widgets/custom_text_field.dart';
import '../../../../../rider/presentation/widgets/switch.dart';
import '../../../../viewmodels/business_info_viewmodel.dart';
import '../../../widgets/text_column.dart';

final isBusinessProfileEditModeProvider = StateProvider<bool>((ref) => false);

class SellerBusinessDetailsScreen extends ConsumerWidget {
  const SellerBusinessDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(isBusinessProfileEditModeProvider);
    final state = ref.watch(businessInfoViewmodelProvider);
    final notifier = ref.read(businessInfoViewmodelProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!context.isWeb) ...[
            Align(
              alignment: AlignmentGeometry.centerEnd,
              child: _buildCustomButton(isEditMode: isEditMode, ref: ref),
            ),
            const SizedBox(height: 25),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTextColumn(
                title: "Business/Shop Details",
                titleFontSize: 20,
                subtitle1: "Update your Profile, and keep it up to date",
                isMainSubTitle: true,
                subtitleFontWeight: FontWeight.w500,
                subtitleFontSize: context.isWeb ? 16 : 14,
              ),
              if (context.isWeb) ...[
                _buildCustomButton(isEditMode: isEditMode, ref: ref),
              ],
            ],
          ),
          const Divider(),
          GridView.builder(
            padding: EdgeInsets.only(top: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.isWeb ? 2 : 1,
              crossAxisSpacing: context.isWeb ? 13 : 0,
              mainAxisSpacing: 13,
              mainAxisExtent: 85,
            ),
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return CustomTextField(
                    enabled: isEditMode,
                    hintText: 'eg., Dmobile Tech',
                    label: 'Shop/Business Name',
                    prefixIcon: AppAssets.icons.store.path,
                    hintTextColor: AppColors.textBodyText,
                    onChanged: notifier.updateBusinessName,
                    border: InputBorder.none,
                    clipRectBorderRadius: 8,
                  );

                case 1:
                  return CustomDropdownField(
                    label: 'Type of Business',
                    hintText: 'Select Type of Business',
                    items: isEditMode ? ['Retail', 'Wholesale'] : [],
                    iconWidth: 22,
                    iconHeight: 22,
                    onChanged: notifier.updateBusinessType,
                    value: state.businessType,
                    prefixIcon: AppAssets.icons.store.svg(),
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
          const SizedBox(height: 15),
          CustomTextField(
            enabled: isEditMode,
            hintText: 'Enter your Business address',
            label: 'Business address',
            prefixIcon: AppAssets.icons.home.path,
            hintTextColor: AppColors.textIconGrey,
            onChanged: notifier.updateBusinessAddress,
            border: InputBorder.none,
            clipRectBorderRadius: 8,
          ),
          GridView.builder(
            padding: EdgeInsets.only(top: 10),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.isWeb ? 2 : 1,
              crossAxisSpacing: context.isWeb ? 13 : 0,
              mainAxisSpacing: 13,
              mainAxisExtent: 85,
            ),
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return CustomDropdownField(
                    label: 'State',
                    items: isEditMode
                        ? nigeriaStatesAndCities.keys.toList()
                        : [],
                    hintText: 'Select State',
                    value: state.businessState.isEmpty
                        ? null
                        : state.businessState,
                    onChanged: (val) {
                      notifier.updateBusinessState(val);
                    },
                  );

                case 1:
                  return CustomDropdownField(
                    label: 'City/ Town',
                    items: isEditMode ? state.filteredCities : [],
                    hintText: 'Select City',
                    value: state.businessCity.isEmpty
                        ? null
                        : state.businessCity,
                    onChanged: notifier.updateBusinessCity,
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
          const SizedBox(height: 15),
          CustomTextField(
            enabled: isEditMode,
            label: 'Business Description',
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
            border: InputBorder.none,
            clipRectBorderRadius: 8,
          ),
          const SizedBox(height: 30),
          _buildShopPrefCard(context),
        ],
      ),
    );
  }

  Widget _buildCustomButton({
    required bool isEditMode,
    required WidgetRef ref,
  }) {
    return CustomButton(
      text: !isEditMode ? "Edit Profile" : "Update New",
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 41.31,
      width: 130,
      borderRadius: 4,
      prefixIcon: !isEditMode ? AppAssets.icons.pencilEdit.svg() : null,
      onPressed: !isEditMode
          ? () => ref.read(isBusinessProfileEditModeProvider.notifier).state =
                !isEditMode
          : () {
              ref.read(isBusinessProfileEditModeProvider.notifier).state =
                  false;
            },
    );
  }

  Widget _buildShopPrefCard(BuildContext context) {
    final bool isActive = true;
    return Card(
      elevation: 0,
      color: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: AppColors.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTextColumn(
              title: "Shop Preference",
              titleFontSize: 18,
              subtitle1:
                  "Manage your shop’s availability, order options, and visibility to buyers.",
            ),
            const Divider(),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: buildTextColumn(
                    title: "Shop visibility",
                    titleFontSize: 16,
                    subtitle1:
                        "Disable this to hide your shop from buyers when you’re not available.",
                  ),
                ),
                CustomSwitch(
                  value: isActive,
                  onChanged: (isActive) {},
                  thumbColour: AppColors.accentWhite,
                  activeColor: AppColors.switchGreen,
                  inactiveColor: AppColors.accentGrey,
                  height: 26,
                  width: 49,
                  thumbDiameter: 20,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTextColumn(
                  title: "Shop Open Hours",
                  titleFontSize: 16,
                  subtitle1: "Monday: Friday: 9:00 AM – 6:00 PM",
                  subtitle2: "Saturday: 10:00 AM – 4:00 PM",
                  hasBullet: true,
                ),
                CustomButton(
                  text: "Edit",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 32,
                  width: 65,
                  prefixIcon: AppAssets.icons.pencilEdit.svg(height: 16),
                  onPressed: () {},
                  borderRadius: 4,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTextColumn(
                  title: "Order Preference",
                  titleFontSize: 16,
                  subtitle1: "Delivery and Pick up",
                ),
                CustomButton(
                  text: "Edit",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 32,
                  width: 65,
                  prefixIcon: AppAssets.icons.pencilEdit.svg(height: 16),
                  onPressed: () {},
                  borderRadius: 4,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
