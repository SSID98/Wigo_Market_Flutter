// cart_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/helper_methods.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/models/location_data.dart';
import '../../../../../shared/viewmodels/location_notifier.dart';
import '../../../../../shared/viewmodels/login_view_model.dart';
import '../../../../../shared/widgets/contact_text_field.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_checkbox_2.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import 'order_summary_card.dart';

class CustomerInfoScreen extends ConsumerWidget {
  const CustomerInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    bool isHandlingBack = false;
    return PopScope(
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child:
            isWeb
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: CustomerInfoSection()),
                    const SizedBox(width: 30),
                    Expanded(
                      flex: 2,
                      child: OrderSummaryCard(
                        isCheckoutScreens: true,
                        isCustomerInfo: true,
                      ),
                    ),
                  ],
                )
                : Column(
                  children: [
                    CustomerInfoSection(),
                    const SizedBox(height: 30),
                    OrderSummaryCard(
                      isCheckoutScreens: true,
                      isCustomerInfo: true,
                    ),
                  ],
                ),
      ),
    );
  }
}

class CustomerInfoSection extends ConsumerWidget {
  const CustomerInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    final location = ref.watch(locationProvider);
    final notifier = ref.read(locationProvider.notifier);
    final state = ref.watch(loginViewModelProvider);
    final testVm = ref.watch(loginViewModelProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconTextRow(isWeb, onTap: () async {
                showLoadingDialog(context);
                await Future.delayed(const Duration(seconds: 1));
                if (!context.mounted) return;
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context).pop();
              }),
              SizedBox(height: 20),
              _iconTextRow(isWeb, isCustomer: true),
            ],
          ),
        ),
        GridView.builder(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? 2 : 1,
            crossAxisSpacing: isWeb ? 13 : 0,
            mainAxisSpacing: 15,
            mainAxisExtent: isWeb ? 95 : 85,
          ),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return CustomTextField(
                  fillColor: AppColors.backgroundWhite,
                  label: 'First Name',
                  hintText: 'Enter First Name',
                  focusedBorderColor: AppColors.borderColor,
                  enabledBorderColor: AppColors.borderColor,
                  borderRadius: 4,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 4,
                  ),
                );
              case 1:
                return CustomTextField(
                  fillColor: AppColors.backgroundWhite,
                  label: 'Last Name',
                  hintText: 'Enter Last Name',
                  focusedBorderColor: AppColors.borderColor,
                  enabledBorderColor: AppColors.borderColor,
                  borderRadius: 4,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 4,
                  ),
                );
              case 2:
                return CustomPhoneNumberField(
                  label: 'Phone Number',
                  fillColor: AppColors.backgroundWhite,
                  borderColor: AppColors.borderColor,
                  contentPadding: EdgeInsets.only(bottom: isWeb ? 3.5 : 0),
                  isOtherDesign: true,
                  hintText: 'Enter phone number',
                  hintTextFontSize: 16,
                  hintTextColor: AppColors.textIconGrey,
                );
              case 3:
                return CustomPhoneNumberField(
                  label: 'Additional Phone Number',
                  fillColor: AppColors.backgroundWhite,
                  borderColor: AppColors.borderColor,
                  contentPadding: EdgeInsets.only(bottom: isWeb ? 3.5 : 0),
                  isOtherDesign: true,
                  hintText: 'Enter phone number',
                  hintTextFontSize: 16,
                  hintTextColor: AppColors.textIconGrey,
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
        CustomTextField(
          label: 'Delivery Address',
          hintText: 'Enter your address',
          fillColor: AppColors.backgroundWhite,
          focusedBorderColor: AppColors.borderColor,
          enabledBorderColor: AppColors.borderColor,
          borderRadius: 4,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? 2 : 1,
            crossAxisSpacing: isWeb ? 13 : 0,
            mainAxisSpacing: 15,
            mainAxisExtent: isWeb ? 95 : 85,
          ),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return CustomDropdownField(
                  fillColor: Colors.transparent,
                  focusedBorderColor: AppColors.borderColor,
                  enabledBorderColor: AppColors.borderColor,
                  label: 'State/Region',
                  items: nigeriaStatesAndCities.keys.toList(),
                  hintText: 'Select State',
                  radius: 4,
                  value:
                      location.selectedState.isEmpty
                          ? null
                          : location.selectedState,
                  onChanged: (val) {
                    notifier.setStateValue(val);
                  },
                );
              case 1:
                return CustomDropdownField(
                  fillColor: Colors.transparent,
                  focusedBorderColor: AppColors.borderColor,
                  enabledBorderColor: AppColors.borderColor,
                  label: 'City',
                  items: location.availableCities,
                  hintText: 'Select City',
                  radius: 4,
                  value:
                      location.selectedCity.isEmpty
                          ? null
                          : location.selectedCity,
                  onChanged: notifier.updateCity,
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomCheckbox2(
                  value: state.agreeToTerms,
                  onChanged: testVm.toggleAgreeToTerms,
                  size: 19,
                  checkSize: 12,
                ),
                const SizedBox(width: 8),
                Text(
                  "Save this information for next time",
                  style: GoogleFonts.hind(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textBlackGrey,
                  ),
                ),
              ],
            ),
            if (isWeb)
              CustomButton(
                text: 'Continue',
                onPressed: () async {
                  showLoadingDialog(context);
                  await Future.delayed(const Duration(seconds: 1));
                  if (!context.mounted) return;
                  Navigator.of(context, rootNavigator: true).pop();
                  context.push('/buyer/deliveryDetails');
                },
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 50,
                width: 139,
              ),
          ],
        ),
        if (!isWeb) ...[
          const SizedBox(height: 15),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: CustomButton(
              text: 'Continue',
              onPressed: () async {
                showLoadingDialog(context);
                await Future.delayed(const Duration(seconds: 1));
                if (!context.mounted) return;
                Navigator.of(context, rootNavigator: true).pop();
                context.push('/buyer/deliveryDetails');
              },
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 50,
              width: 139,
            ),
          ),
        ],
      ],
    );
  }

  Widget _iconTextRow(
    bool isWeb, {
    bool isCustomer = false,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          isCustomer
              ? AppAssets.icons.checkmarkCircle.svg()
              : Icon(
                Icons.keyboard_arrow_left_rounded,
                size: isWeb ? 24 : 18,
                color: AppColors.primaryDarkGreen,
              ),
          const SizedBox(width: 4),
          Text(
            isCustomer ? "Customer Information" : "Back",
            style: GoogleFonts.hind(
              fontSize: isWeb ? 24 : 18,
              fontWeight: isCustomer ? FontWeight.w600 : FontWeight.w400,
              color:
                  isCustomer
                      ? AppColors.textBlack
                      : AppColors.textVidaLocaGreen,
            ),
          ),
        ],
      ),
    );
  }
}
