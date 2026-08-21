import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/features/rider/viewmodels/edit_bank_account_viewmodel.dart';
import 'package:wigo_flutter/shared/widgets/contact_text_field.dart';
import 'package:wigo_flutter/shared/widgets/custom_banner.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/custom_checkbox_widget.dart';
import 'package:wigo_flutter/shared/widgets/custom_text_field.dart';

import '../../../core/utils/context_extensions.dart';
import '../../../core/utils/validation_utils.dart';
import '../../../gen/assets.gen.dart';
import '../../models/bank_model.dart';
import '../../widgets/bank_widgets/bank_search_modal.dart';
import '../../widgets/custom_dropdown_field2.dart';
import '../../widgets/custom_loading_overlay.dart';
import '../../../features/rider/models/bank_details.dart';
import '../../../features/rider/models/wallet_state.dart';

class EditBankAccountScreen extends HookConsumerWidget {
  const EditBankAccountScreen({
    super.key,
    required this.bankDetails,
    this.openedViaNavigator = false,
  });

  final BankDetails bankDetails;
  final bool openedViaNavigator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editBankAccountProvider);
    final notifier = ref.read(editBankAccountProvider.notifier);

    useEffect(() {
      Future.microtask(() {
        notifier.startEditBankAccount(bankDetails);
      });
      return null;
    }, const []);

    useEffect(() {
      Future.microtask(() {
        if (state.fetchWalletLoading && context.mounted) {
          LoadingOverlay.show(context);
        } else {
          LoadingOverlay.hide();
        }
      });
      return null;
    }, const []);

    void saveChanges() async {
      FocusManager.instance.primaryFocus?.unfocus();

      final accountHasError =
          FormValidators.validateAccountNo(
            state.selectedBankDetails?.accountNumber,
          ) !=
          null;

      if (accountHasError) {
        showErrorBanner('Please enter the right account number', context);
        return;
      }

      await runWithOverlay(context, () async {
        final success = await notifier.saveBankDetails(context);
        if (success && context.mounted) {
          showSuccessBanner("Bank Account successfully updated", context);
          if (openedViaNavigator) {
            Navigator.of(context).pop(true);
          }
        }
      }, spinner: SpinKitDualRing(color: AppColors.primaryDarkGreen));
    }

    return openedViaNavigator
        ? Scaffold(body: _buildBody(context, ref, saveChanges))
        : Expanded(child: _buildBody(context, ref, saveChanges));
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, VoidCallback onSave) {
    void navigateBackToList() {
      if (openedViaNavigator) {
        Navigator.of(context).pop();
      } else {
        ref.read(editBankAccountProvider.notifier).cancelEditBankAccount();
      }
    }

    final state = ref.watch(editBankAccountProvider);
    final vm = ref.read(editBankAccountProvider.notifier);
    final items = state.isLoading ? <Bank>[] : [...state.banks]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    bool hasError =
        state.hasSubmitted &&
            (state.selectedBankDetails?.accountNumber.isEmpty ?? true) ||
        (state.selectedBankDetails?.accountHolderName.isEmpty ?? true) ||
        (state.selectedBankDetails?.phoneNumber.isEmpty ?? true) ||
        (state.selectedBankDetails?.selectedBank?.name.isEmpty ?? true) ||
        FormValidators.validateAccountNo(
              state.selectedBankDetails?.accountNumber,
            ) !=
            null;

    useEffect(() {
      Future.microtask(() {
        if (!context.mounted) return;
        vm.fetchBanks(context);
      });
      return null;
    }, const []);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.isWeb ? 40 : 15.0,
        context.isWeb ? 20 : 0,
        context.isWeb ? 300 : 15.0,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!context.isWeb && openedViaNavigator) const SizedBox(height: 20),
          if (context.isWeb || openedViaNavigator)
            Row(
              children: [
                InkWell(
                  onTap: openedViaNavigator
                      ? () => Navigator.of(context).pop()
                      : navigateBackToList,
                  child: AppAssets.icons.arrowLeft.svg(),
                ),
                const SizedBox(width: 5),
                Text(
                  'Back',
                  style: GoogleFonts.hind(
                    fontWeight: context.isWeb
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontSize: context.isWeb ? 24 : 18,
                    color: AppColors.textBlackGrey,
                  ),
                ),
              ],
            ),
          if (!context.isWeb && openedViaNavigator)
            Divider(color: AppColors.dividerColor.withValues(alpha: 0.2)),
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                elevation: 0,
                margin: EdgeInsets.only(top: 20),
                color: AppColors.backgroundWhite,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'We need your bank details to send you earnings from completed deliveries.',
                        style: GoogleFonts.hind(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlackGrey,
                          fontSize: context.isWeb ? 20 : 16,
                        ),
                      ),
                      SizedBox(height: context.isWeb ? 20 : 10),
                      Text(
                        'Payment Details',
                        style: GoogleFonts.hind(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlackGrey,
                          fontSize: context.isWeb ? 20 : 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'This is the Account you would receive payments',
                        style: GoogleFonts.hind(
                          fontWeight: FontWeight.w400,
                          color: AppColors.textBlackGrey,
                          fontSize: context.isWeb ? 15 : 12,
                        ),
                      ),
                      GridView.builder(
                        padding: EdgeInsets.only(top: context.isWeb ? 20 : 15),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: context.isWeb ? 2 : 1,
                          crossAxisSpacing: context.isWeb ? 13 : 0,
                          mainAxisSpacing: context.isWeb ? 30 : 0,
                          mainAxisExtent: context.isWeb
                              ? 85
                              : hasError
                              ? 82
                              : 75,
                        ),
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return CustomDropdownField2<Bank>(
                                label: 'Bank Name',
                                dropdownFieldHeight: 40,
                                labelFontSize: context.isWeb ? 20 : 14,
                                hintFontSize: context.isWeb ? 18 : 12,
                                labelFontWeight: FontWeight.w600,
                                enabledBorderColor: AppColors.borderColor,
                                items: items,
                                itemLabelBuilder: (bank) => bank.name,
                                prefixIcon: AppAssets.icons.bank.svg(),
                                hintText: state.isLoading
                                    ? 'Please wait'
                                    : 'Select your bank',
                                hintTextColor: AppColors.textBodyText,
                                value: vm.selectedBankName,
                                onChanged: (bank) {
                                  if (bank != null) {
                                    vm.updateSelectedBank(bank, context);
                                  }
                                },
                                onTap: () async {
                                  if (state.banks.isEmpty) {
                                    vm.fetchBanks(context);
                                  }
                                  final selected = await showBankSearchModal(
                                    context,
                                    state.banks,
                                  );

                                  if (selected != null && context.mounted) {
                                    vm.updateSelectedBank(selected, context);
                                  }
                                },
                                hasError:
                                    state.hasSubmitted &&
                                    (state
                                            .selectedBankDetails
                                            ?.selectedBank
                                            ?.name
                                            .isEmpty ??
                                        true),
                                errorMessage:
                                    state.hasSubmitted &&
                                        (state
                                                .selectedBankDetails
                                                ?.selectedBank
                                                ?.name
                                                .isEmpty ??
                                            true)
                                    ? "This field is required"
                                    : null,
                              );
                            case 1:
                              return CustomTextField(
                                label: 'Account Number',
                                prefixIcon: AppAssets.icons.group.path,
                                fontSize: context.isWeb ? 18 : 12,
                                labelFontSize: context.isWeb ? 20 : 14,
                                hintFontSize: context.isWeb ? 18 : 12,
                                labelFontWeight: FontWeight.w600,
                                hintText: 'Enter 10-digit account number',
                                controller: vm.accountNumberController,
                                hasError:
                                    state.hasSubmitted &&
                                    FormValidators.validateAccountNo(
                                          state
                                              .selectedBankDetails
                                              ?.accountNumber,
                                        ) !=
                                        null,
                                errorMessage: state.hasSubmitted
                                    ? FormValidators.validateAccountNo(
                                        state
                                            .selectedBankDetails
                                            ?.accountNumber,
                                      )
                                    : null,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                onChanged: (val) =>
                                    vm.updateAccountNumber(val, context),
                                height: context.isWeb ? 52 : 40,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                focusedBorderColor: AppColors.borderColor,
                                enabledBorderColor: AppColors.borderColor,
                              );
                            case 2:
                              return CustomTextField(
                                label: 'Account Name',
                                hintText: 'Account Name',
                                fontSize: context.isWeb ? 18 : 12,
                                labelFontSize: context.isWeb ? 20 : 14,
                                hintFontSize: context.isWeb ? 18 : 12,
                                labelFontWeight: FontWeight.w600,
                                controller: vm.accountNameController,
                                readOnly: true,
                                onChanged: vm.updateAccountName,
                                height: context.isWeb ? 52 : 40,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                hasError:
                                    state.hasSubmitted &&
                                    (state
                                            .selectedBankDetails
                                            ?.accountHolderName
                                            .isEmpty ??
                                        true),
                                errorMessage:
                                    state.hasSubmitted &&
                                        (state
                                                .selectedBankDetails
                                                ?.accountHolderName
                                                .isEmpty ??
                                            true)
                                    ? "This field is required"
                                    : null,
                                focusedBorderColor: AppColors.borderColor,
                                enabledBorderColor: AppColors.borderColor,
                              );
                            case 3:
                              return CustomPhoneNumberField(
                                padding: EdgeInsets.only(left: 17, top: 1),
                                label: 'Phone Number',
                                labelFontSize: context.isWeb ? 20 : 14,
                                labelFontWeight: FontWeight.w600,
                                controller: vm.phoneNumberController,
                                hintText: '',
                                onChanged: vm.updatePhoneNumber,
                                height: context.isWeb ? 52 : 40,
                                borderColor: AppColors.borderColor,
                                inputFontSize: context.isWeb ? 18 : 12,
                                hintTextFontSize: context.isWeb ? 18 : 12,
                                dialCodeFontSize: context.isWeb ? 18 : 12,
                                inputColor: AppColors.textBlack,
                                contentPadding: EdgeInsets.only(
                                  bottom: context.isWeb ? 4.5 : 0,
                                  top: 10.2,
                                ),
                                hasError:
                                    state.hasSubmitted &&
                                    (state
                                            .selectedBankDetails
                                            ?.phoneNumber
                                            .isEmpty ??
                                        true),
                                errorMessage:
                                    state.hasSubmitted &&
                                        (state
                                                .selectedBankDetails
                                                ?.phoneNumber
                                                .isEmpty ??
                                            true)
                                    ? "This field is required"
                                    : null,
                              );
                            default:
                              return const SizedBox.shrink();
                          }
                        },
                      ),
                      SizedBox(height: context.isWeb ? 15 : 5),
                      Row(
                        children: [
                          CustomCheckBox(
                            sizedBoxHeight: context.isWeb ? 20 : 11,
                            value: state.isDefault,
                            onChanged: vm.toggleDefault,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Make Default Payment Method',
                            style: GoogleFonts.hind(
                              fontSize: context.isWeb ? 14 : 12,
                              color: AppColors.textVidaLocaGreen,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: context.isWeb
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: context.isWeb ? 0 : 1,
                            child: CustomButton(
                              onPressed: openedViaNavigator
                                  ? () => Navigator.of(context).pop()
                                  : navigateBackToList,
                              text: 'Cancel',
                              fontSize: context.isWeb ? 18 : 16,
                              fontWeight: FontWeight.w500,
                              textColor: AppColors.textDarkDarkerGreen,
                              buttonColor: AppColors.buttonLighterGreen,
                              height: context.isWeb ? 48 : 45,
                              width: context.isWeb ? 300 : 150.0,
                            ),
                          ),
                          SizedBox(width: context.isWeb ? 50 : 20),
                          Expanded(
                            flex: context.isWeb ? 0 : 1,
                            child: CustomButton(
                              onPressed: onSave,
                              text: 'Save',
                              fontSize: context.isWeb ? 18 : 16,
                              fontWeight: FontWeight.w500,
                              height: context.isWeb ? 48 : 45,
                              width: context.isWeb ? 300 : 150.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
