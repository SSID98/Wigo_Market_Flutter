// cart_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/url.dart';
import '../../../../../core/utils/helper_methods.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_checkbox_2.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../viewmodels/delivery_details_viewmodel.dart';
import 'order_summary_card.dart';

class BuyerDeliveryDetailsScreen extends ConsumerWidget {
  const BuyerDeliveryDetailsScreen({super.key});

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
                    Expanded(flex: 3, child: DeliveryDetailsSection()),
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
                    DeliveryDetailsSection(),
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

class DeliveryDetailsSection extends ConsumerWidget {
  const DeliveryDetailsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    final dPS = ref.watch(deliveryPaymentProvider);
    final dPN = ref.read(deliveryPaymentProvider.notifier);
    final themeData = Theme.of(context).copyWith(
      listTileTheme: ListTileThemeData(
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.zero,
        titleTextStyle: GoogleFonts.hind(
          fontSize: isWeb ? 18 : 15,
          color: AppColors.textBlackGrey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: _iconTextRow(isWeb, onTap: () async {
            showLoadingDialog(context);
            await Future.delayed(const Duration(seconds: 1));
            if (!context.mounted) return;
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context).pop();
          }, text: "Back"),
        ),
        const SizedBox(height: 20),
        _iconTextRow(isWeb, isDelivery: true, text: "Delivery Details"),
        const SizedBox(height: 10),
        RadioGroup<String>(
          groupValue: dPS.deliveryOption,
          onChanged: (value) {
            if (value != null) {
              dPN.setSelectedOption(value);
            }
          },
          child: Column(
            children: [
              SizedBox(
                height: 47,
                child: Theme(
                  data: themeData,
                  child: RadioListTile<String>(
                    title: const Text(
                      'Self Delivery (Pick Up Products yourself)',
                    ),
                    value: 'Option1',
                  ),
                ),
              ),
              Divider(height: 0),
              Theme(
                data: themeData,
                child: RadioListTile<String>(
                  title: const Text('WiGo Rider'),
                  value: 'Option2',
                ),
              ),
            ],
          ),
        ),
        if (dPS.deliveryOption == 'Option2')
          CustomTextField(
            label: 'Pick-Up location',
            hintText: 'Enter your Pick-Up location',
            fillColor: AppColors.backgroundWhite,
            focusedBorderColor: AppColors.borderColor,
            enabledBorderColor: AppColors.borderColor,
            borderRadius: 4,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
          ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delivery Fee',
              style: GoogleFonts.hind(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.textOrange,
              ),
            ),
            Text(
              '#1,000',
              style: GoogleFonts.hind(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _iconTextRow(isWeb, isDelivery: true, text: 'Payment Type'),
        const SizedBox(height: 20),
        RadioGroup<String>(
          groupValue: dPS.paymentOption,
          onChanged: (value) {
            if (value != null) {
              dPN.setSelectedOption(value);
            }
          },
          child: Column(
            children: [
              SizedBox(
                height: 47,
                child: Theme(
                  data: themeData,
                  child: RadioListTile<String>(
                    title: Row(
                      mainAxisAlignment:
                          isWeb
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Paystack'),
                        Image.network(
                          '$networkImageUrl/visa.png',
                          height: isWeb ? 23.14 : 15,
                          width: isWeb ? 245 : 172,
                          errorBuilder: (
                            BuildContext context,
                            Object exception,
                            StackTrace? stackTrace,
                          ) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: AppColors.textIconGrey,
                                size: 50.0,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    value: 'Option1',
                  ),
                ),
              ),
              Divider(height: 0),
              Theme(
                data: themeData,
                child: RadioListTile<String>(
                  title: const Text('Cash on Delivery'),
                  value: 'Option2',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomCheckbox2(
                  value: dPS.agreeToTerms,
                  onChanged: dPN.toggleAgreeToTerms,
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
                  context.push('/buyer/orderConfirmation');
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
                context.push('/buyer/orderConfirmation');
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
    bool isDelivery = false,
    void Function()? onTap,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          isDelivery
              ? AppAssets.icons.checkmarkCircle.svg()
              : Icon(
                Icons.keyboard_arrow_left_rounded,
                size: isWeb ? 24 : 18,
                color: AppColors.primaryDarkGreen,
              ),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.hind(
              fontSize: isWeb ? 24 : 18,
              fontWeight: isDelivery ? FontWeight.w600 : FontWeight.w400,
              color:
                  isDelivery
                      ? AppColors.textBlack
                      : AppColors.textVidaLocaGreen,
            ),
          ),
        ],
      ),
    );
  }
}
