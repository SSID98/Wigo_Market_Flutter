import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wigo_flutter/features/rider/viewmodels/edit_bank_account_viewmodel.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/custom_text_field.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/local/local_storage_service.dart';
import '../../../../../core/utils/validation_utils.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../models/wallet_state.dart';
import '../../../viewmodels/wallet_withdrawal_viewmodel.dart';

class PaymentMethodScreen extends ConsumerStatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  ConsumerState<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  String? _pinHasError;
  String? _confirmPinHasError;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(editBankAccountProvider.notifier);
    final isWeb = MediaQuery.of(context).size.width > 800;
    final vm = ref.watch(withdrawalViewModelProvider.notifier);

    return Expanded(
      child: SingleChildScrollView(
        child: Card(
          elevation: 0,
          color: AppColors.backgroundWhite,
          margin: EdgeInsets.only(
            top: 20,
            right: isWeb ? 740 : 15,
            left: isWeb ? 40 : 15,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0),
                    width: double.infinity,
                    height: isWeb ? 54 : 34,
                    color: AppColors.buttonLighterGreen,
                    child: Center(
                      child: Text(
                        "Setting Up withdrawal Pin",
                        style: GoogleFonts.hind(
                          fontWeight: FontWeight.w600,
                          fontSize: isWeb ? 16 : 14,
                          color: AppColors.textBlackGrey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Secure your earnings with a 4-digit PIN. You can reset your PIN anytime in Settings. Make sure to choose a PIN you'll remember.",
                  style: GoogleFonts.hind(
                    fontSize: isWeb ? 14 : 12,
                    color: AppColors.textBlackGrey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 35),
                CustomTextField(
                  label: 'Create Pin',
                  labelFontWeight: FontWeight.w600,
                  hintText: 'Enter PIN',
                  prefixIcon: AppAssets.icons.lock.path,
                  hintTextColor: AppColors.textBlackGrey,
                  suffixIcon: Icon(Icons.visibility_off_outlined),
                  hintFontSize: isWeb ? 16 : 14,
                  controller: vm.pinController,
                  hasError: _pinHasError != null,
                  validator: (value) => null,
                  keyboardType: TextInputType.number,
                  autoValidateMode: _autovalidateMode,
                  errorMessage: _pinHasError,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  isPassword: true,
                  height: isWeb ? 48 : 35,
                  contentPadding: EdgeInsets.only(top: isWeb ? 0 : 10),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Confirm Pin',
                  labelFontWeight: FontWeight.w600,
                  hintText: 'Confirm PIN',
                  prefixIcon: AppAssets.icons.lock.path,
                  hintTextColor: AppColors.textBlackGrey,
                  suffixIcon: Icon(Icons.visibility_off_outlined),
                  hintFontSize: isWeb ? 16 : 14,
                  controller: vm.confirmPinController,
                  hasError: _confirmPinHasError != null,
                  validator: (value) => null,
                  autoValidateMode: _autovalidateMode,
                  errorMessage: _confirmPinHasError,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  isPassword: true,
                  height: isWeb ? 48 : 35,
                  contentPadding: EdgeInsets.only(top: isWeb ? 0 : 10),
                ),
                const SizedBox(height: 35),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Cancel',
                        onPressed: () {},
                        fontSize: isWeb ? 18 : 16,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.textDarkDarkerGreen,
                        height: isWeb ? 48 : 40,
                        buttonColor: AppColors.buttonLighterGreen,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: CustomButton(
                        text: 'Continue',
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final pinLengthError = FormValidators.validatePin(
                            vm.pinController.text,
                          );
                          final confirmPinLengthError =
                              FormValidators.validatePin(
                                vm.confirmPinController.text,
                              );
                          String? mismatchError;
                          if (pinLengthError == null &&
                              confirmPinLengthError == null) {
                            if (vm.pinController.text !=
                                vm.confirmPinController.text) {
                              mismatchError =
                                  'Pins do not match. Please re-enter.';
                            }
                          }

                          setState(() {
                            _pinHasError = pinLengthError ?? mismatchError;
                            _confirmPinHasError =
                                confirmPinLengthError ?? mismatchError;

                            _autovalidateMode = AutovalidateMode.always;
                          });

                          final hasAnyError =
                              _pinHasError != null ||
                              _confirmPinHasError != null;
                          if (!hasAnyError) {
                            vm.setLoading(true);
                            vm.pinController.clear();
                            vm.confirmPinController.clear();
                            if (!context.mounted) return;
                            _showSuccessDialog(context, notifier);
                          }
                          await Future.delayed(
                            const Duration(milliseconds: 500),
                          );
                          vm.setLoading(false);
                        },
                        fontSize: isWeb ? 18 : 16,
                        fontWeight: FontWeight.w500,
                        height: isWeb ? 48 : 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showSuccessDialog(
    BuildContext context,
    EditBankAccountViewModel notifier,
  ) async {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.backgroundWhite,
          titlePadding: EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10),
              IconButton(
                padding: EdgeInsets.only(right: isWeb ? 0 : 25),
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  notifier.setWalletScreenState(
                    WalletScreenState.addBankAccount,
                  );
                },
              ),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? 45.0 : 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppAssets.icons.doubleTickSuccessful.svg(),
                const SizedBox(height: 12),
                Text(
                  "New Pin Successfully Created",
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: isWeb ? 20 : 14,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "This is the Pin will protect your funds and ensures only you can request a payout.",
                  style: GoogleFonts.hind(
                    fontSize: isWeb ? 16 : 12,
                    color: AppColors.textBodyText,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Continue',
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final storage = LocalStorageService(prefs);

                    await storage.setPinSetupCompleted();
                    if (!dialogContext.mounted) return;
                    Navigator.of(dialogContext).pop();
                    notifier.setWalletScreenState(
                      WalletScreenState.addBankAccount,
                    );
                  },
                  fontSize: isWeb ? 18 : 12,
                  height: isWeb ? 48 : 45,
                  fontWeight: FontWeight.w500,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
