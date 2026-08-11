import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';
import 'package:wigo_flutter/shared/widgets/custom_dropdown_field2.dart';
import 'package:wigo_flutter/shared/widgets/custom_loading_overlay.dart';

import '../../core/constants/app_colors.dart';
import '../../core/local/local_user_controller.dart';
import '../models/bank_model.dart';
import '../viewmodels/bank_viewmodel.dart';
import '../widgets/bank_widgets/bank_search_modal.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class PaymentMethodSetupScreen extends HookConsumerWidget {
  const PaymentMethodSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isWeb = MediaQuery.of(context).size.width > 600;
    return isWeb
        ? _buildWebLayout(screenSize, context, ref)
        : _buildMobileLayout(screenSize, context, ref);
  }

  Widget _buildMobileLayout(
    Size screenSize,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Image.asset(
                AppAssets.images.onboardingRiderMobile.path,
                fit: BoxFit.cover,
                color: AppColors.backGroundOverlay,
                colorBlendMode: BlendMode.overlay,
                errorBuilder:
                    (
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
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: screenSize.width * 0.95,
                    constraints: BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundWhite,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 24.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(
                            titleFontSize: 20.0,
                            descriptionFontSize: 14.0,
                            descriptionPadding: 50.0,
                          ),
                          _buildBody(
                            screenSize: screenSize.height * 0.56,
                            fontSize1: 12.0,
                            fontSize2: 12.0,
                            ref: ref,
                            context: context,
                          ),
                          _buildFooter(context: context, ref: ref),
                          const SizedBox(height: 15.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebLayout(Size screenSize, BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              AppAssets.images.onboardingRiderWeb.path,
              fit: BoxFit.cover,
              color: AppColors.backGroundOverlay,
              colorBlendMode: BlendMode.overlay,
              errorBuilder:
                  (
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
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: screenSize.width * 0.95,
                  constraints: BoxConstraints(maxWidth: 1005),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 210,
                      vertical: 35,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(
                          titleFontSize: 36.0,
                          descriptionFontSize: 18.0,
                          descriptionPadding: 0.0,
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: _buildBody(
                            screenSize: screenSize.height * 0.50,
                            fontSize1: 16.72,
                            fontSize2: 16.0,
                            ref: ref,
                            context: context,

                            web: true,
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: _buildFooter(
                            web: true,
                            context: context,
                            ref: ref,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({
    required double descriptionPadding,
    required double titleFontSize,
    required double descriptionFontSize,
  }) {
    return Column(
      children: [
        Text(
          'Setup Payment Method',
          textAlign: TextAlign.center,
          style: GoogleFonts.hind(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textDarkGreen,
          ),
        ),
        const SizedBox(height: 15.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: descriptionPadding),
          child: Text(
            'Let’s get your profile ready to start delivering on wiGO MARKET.',
            textAlign: TextAlign.center,
            style: GoogleFonts.hind(
              fontSize: descriptionFontSize,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlackGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody({
    required double screenSize,
    required double fontSize1,
    required double fontSize2,
    bool web = false,
    required WidgetRef ref,
    required BuildContext context,
  }) {
    final bankState = ref.watch(bankProvider);
    final vm = ref.read(bankProvider.notifier);
    final items = bankState.isLoading ? <Bank>[] : [...bankState.banks]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    useEffect(() {
      Future.microtask(() {
        if (!context.mounted) return;
        ref.read(bankProvider.notifier).fetchBanks(context);
      });
      return null;
    }, const []);

    return SizedBox(
      height: screenSize,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Payment Method',
            style: GoogleFonts.hind(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'We use this information to pay you quickly and securely after each completed Delivery.',
            style: GoogleFonts.hind(
              fontSize: fontSize1,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlackGrey,
            ),
          ),
          const Divider(thickness: 1),
          const SizedBox(height: 8),

          CustomDropdownField2<Bank>(
            label: 'Bank Name',
            labelTextColor: AppColors.textBlackGrey,
            items: items,
            itemLabelBuilder: (bank) => bank.name,
            prefixIcon: AppAssets.icons.bank.svg(),
            hintText: bankState.isLoading ? 'Please wait' : 'Select your bank',
            hintTextColor: AppColors.textBodyText,
            value: vm.selectedBankName,
            onChanged: (bank) {
              if (bank != null) {
                vm.updateSelectedBank(bank, context);
              }
            },
            onTap: () async {
              if (bankState.banks.isEmpty) {
                vm.fetchBanks(context);
              }
              final selected = await showBankSearchModal(
                context,
                bankState.banks,
              );

              if (selected != null && context.mounted) {
                vm.updateSelectedBank(selected, context);
              }
            },
            hasError:
                bankState.hasSubmitted &&
                (bankState.selectedBank?.name.isEmpty ?? true),
            errorMessage:
                bankState.hasSubmitted &&
                    (bankState.selectedBank?.name.isEmpty ?? true)
                ? "This field is required"
                : null,
          ),
          const SizedBox(height: 25.0),
          CustomTextField(
            label: 'Account Number',
            labelTextColor: AppColors.textBlackGrey,
            prefixIcon: AppAssets.icons.group.path,
            hintText: 'Enter 10 digit account Number',
            hintTextColor: AppColors.textBodyText,
            onChanged: (val) => vm.updateAccountNumber(val, context),
            keyboardType: TextInputType.number,
            inputFormatters: [LengthLimitingTextInputFormatter(10)],
            hasError: bankState.hasSubmitted && bankState.accountNumber.isEmpty,
            errorMessage:
                bankState.hasSubmitted && bankState.accountNumber.isEmpty
                ? "This field is required"
                : null,
          ),
          const SizedBox(height: 25),
          CustomTextField(
            label: 'Account Name',
            labelTextColor: AppColors.textBlackGrey,
            prefixIcon: AppAssets.icons.user.path,
            hintText: 'Account name',
            hintTextColor: AppColors.textBodyText,
            onChanged: vm.updateAccountName,
            readOnly: true,
            controller: vm.accountNameController,
            hasError: bankState.hasSubmitted && bankState.accountName.isEmpty,
            errorMessage:
                bankState.hasSubmitted && bankState.accountName.isEmpty
                ? "This field is required"
                : null,
          ),
          const SizedBox(height: 20),
          Text(
            'Your bank details are encrypted and protected. We’ll never share them with anyone.',
            style: GoogleFonts.hind(
              fontSize: fontSize2,
              fontWeight: FontWeight.w500,
              color: AppColors.textBodyText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter({
    bool web = false,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final vm = ref.read(bankProvider.notifier);
    return Column(
      children: [
        CustomButton(
          text: 'Continue',
          onPressed: () async {
            final success = await vm.submit(context);
            if (success) {
              ref
                  .read(localUserControllerProvider.notifier)
                  .saveStage(OnboardingStage.success);
            }
          },
          fontSize: 18,
          fontWeight: FontWeight.w500,
          borderRadius: 6.0,
          height: 50,
          textColor: AppColors.textWhite,
          buttonColor: AppColors.primaryDarkGreen,
          width: double.infinity,
        ),
        CustomButton(
          text: 'Skip',
          onPressed: () async {
            await runWithOverlay(context, () async {
              await Future.delayed(const Duration(seconds: 1), () {
                ref
                    .read(localUserControllerProvider.notifier)
                    .saveStage(OnboardingStage.success);
              });
            }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
          },
          suffixIcon: AppAssets.icons.arrowRight2.svg(),
          fontSize: 18,
          fontWeight: FontWeight.w500,
          borderRadius: 6.0,
          height: 70,
          textColor: AppColors.textDarkerGreen,
          buttonColor: Colors.transparent,
        ),
      ],
    );
  }
}
