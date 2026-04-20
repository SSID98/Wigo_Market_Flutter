import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/shared/widgets/contact_text_field.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/context_extensions.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../shared/widgets/custom_avatar.dart';
import '../../../../../../shared/widgets/custom_text_field.dart';
import '../../../widgets/text_column.dart';

final isPersonalProfileEditModeProvider = StateProvider<bool>((ref) => false);

class SellerPersonalDetailsScreen extends ConsumerWidget {
  const SellerPersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(isPersonalProfileEditModeProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!context.isWeb && !isEditMode)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: _buildCustomButton(
                onPressed: () =>
                    ref.read(isPersonalProfileEditModeProvider.notifier).state =
                        !isEditMode,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTextColumn(
                title: "Personal Details",
                titleFontSize: context.isWeb ? 20 : 18,
                subtitle1: "Update your Profile, and keep it up to date",
                isMainSubTitle: true,
                subtitleFontWeight: FontWeight.w500,
                subtitleFontSize: context.isWeb ? 16 : 14,
              ),
              if (context.isWeb && !isEditMode) ...[
                _buildCustomButton(
                  onPressed: () =>
                      ref
                              .read(isPersonalProfileEditModeProvider.notifier)
                              .state =
                          !isEditMode,
                ),
              ],
            ],
          ),
          const Divider(),
          const SizedBox(height: 15),
          Row(
            children: [
              CustomAvatar(
                crossAxisAlignment: CrossAxisAlignment.center,
                avatarAlign: context.isWeb
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                radius: 50,
                showLeftTexts: context.isWeb ? true : false,
                showBottomText: isEditMode ? true : false,
              ),
              if (isEditMode) ...[
                const SizedBox(width: 25),
                _buildCustomButton(
                  isEdit: false,
                  onPressed: () {
                    // 1. Call API (later)
                    ref.read(isPersonalProfileEditModeProvider.notifier).state =
                        false;
                  },
                ),
              ],
            ],
          ),
          GridView.builder(
            padding: EdgeInsets.only(top: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
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
                    hintText: 'e.g John Doe',
                    label: 'Full Name',
                    prefixIcon: AppAssets.icons.user.path,
                    hintTextColor: AppColors.textBlack,
                    enabled: isEditMode,
                    border: InputBorder.none,
                    clipRectBorderRadius: 8,
                  );

                case 1:
                  return CustomPhoneNumberField(
                    label: 'Phone Number',
                    enabled: isEditMode,
                    contentPadding: EdgeInsets.only(
                      bottom: context.isWeb ? 3.5 : 0,
                    ),
                  );
                case 2:
                  return CustomDropdownField(
                    label: 'Gender',
                    hintText: 'Select your Gender',
                    items: isEditMode ? ['Male', 'Female'] : [],
                    iconWidth: 22,
                    iconHeight: 22,
                    prefixIcon: AppAssets.icons.user.svg(),
                    labelTextColor: AppColors.textBlack,
                  );
                case 3:
                  return CustomTextField(
                    hintText: 'Enter residential address',
                    label: 'Residential Address',
                    prefixIcon: AppAssets.icons.home.path,
                    hintTextColor: AppColors.textBlackGrey,
                    enabled: isEditMode,
                    border: InputBorder.none,
                    clipRectBorderRadius: 8,
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
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
      text: isEdit ? "Edit Profile" : "Update New",
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 41.31,
      width: 130,
      prefixIcon: isEdit ? AppAssets.icons.pencilEdit.svg() : null,
      onPressed: onPressed,
      borderRadius: 4,
    );
  }
}
