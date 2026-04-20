import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/context_extensions.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../shared/widgets/custom_text_field.dart';
import '../../../widgets/text_column.dart';

final isPaymentDetailsEditModeProvider = StateProvider<bool>((ref) => false);

class SellerPaymentDetailsScreen extends ConsumerWidget {
  const SellerPaymentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(isPaymentDetailsEditModeProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!context.isWeb) ...[
            Align(
              alignment: AlignmentGeometry.centerEnd,
              child: _buildCustomButton(ref: ref, isEditMode: isEditMode),
            ),
            const SizedBox(height: 15),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTextColumn(
                title: "Payment Details",
                titleFontSize: 20,
                subtitle1:
                    "Update your Payment details, and keep it up to date",
                isMainSubTitle: true,
                subtitleFontWeight: FontWeight.w500,
                subtitleFontSize: context.isWeb ? 16 : 14,
              ),
              if (context.isWeb) ...[
                _buildCustomButton(ref: ref, isEditMode: isEditMode),
              ],
            ],
          ),
          const Divider(),
          const SizedBox(height: 15),
          GridView.builder(
            padding: EdgeInsets.only(top: 10),
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
                  return CustomDropdownField(
                    label: 'Bank Name',
                    labelTextColor: AppColors.textBlackGrey,
                    items: [],
                    prefixIcon: AppAssets.icons.bank.svg(),
                    hintText: 'Select your bank',
                  );
                case 1:
                  return CustomTextField(
                    label: 'Account Number',
                    labelTextColor: AppColors.textBlackGrey,
                    prefixIcon: AppAssets.icons.group.path,
                    hintText: 'Enter 10 digit account Number',
                    enabled: isEditMode,
                    border: InputBorder.none,
                    clipRectBorderRadius: 8,
                  );
                case 2:
                  return CustomTextField(
                    enabled: isEditMode,
                    label: 'Account Name',
                    labelTextColor: AppColors.textBlackGrey,
                    prefixIcon: AppAssets.icons.user.path,
                    hintText: 'Enter account name',
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
    required bool isEditMode,
    required WidgetRef ref,
  }) {
    return CustomButton(
      text: !isEditMode ? "Edit Profile" : "Update New",
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 41.31,
      width: 130,
      prefixIcon: !isEditMode ? AppAssets.icons.pencilEdit.svg() : null,
      onPressed: !isEditMode
          ? () => ref.read(isPaymentDetailsEditModeProvider.notifier).state =
                !isEditMode
          : () {
              ref.read(isPaymentDetailsEditModeProvider.notifier).state = false;
            },
      borderRadius: 4,
    );
  }
}
