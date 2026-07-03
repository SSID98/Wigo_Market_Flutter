import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/local/secure_storage.dart';
import 'package:wigo_flutter/features/rider/viewmodels/edit_bank_account_viewmodel.dart';
import 'package:wigo_flutter/shared/widgets/custom_banner.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';
import 'package:wigo_flutter/shared/widgets/custom_text_field.dart';

import '../../../../../core/auth/auth_state.dart';
import '../../../../../core/auth/auth_state_notifier.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/context_extensions.dart';
import '../../../../../core/utils/helper_methods_classes.dart';
import '../../../../../core/utils/validation_utils.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../models/wallet_state.dart';
import '../../../viewmodels/wallet_withdrawal_viewmodel.dart';

class PaymentMethodScreen extends ConsumerWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(editBankAccountProvider.notifier);
    final vm = ref.watch(withdrawalViewModelProvider.notifier);
    final state = ref.watch(withdrawalViewModelProvider);

    return Expanded(
      child: SingleChildScrollView(
        child: Card(
          elevation: 0,
          color: AppColors.backgroundWhite,
          margin: EdgeInsets.only(
            top: 20,
            right: context.isWeb ? 740 : 15,
            left: context.isWeb ? 40 : 15,
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
                    height: context.isWeb ? 54 : 34,
                    color: AppColors.buttonLighterGreen,
                    child: Center(
                      child: Text(
                        "Setting Up withdrawal Pin",
                        style: GoogleFonts.hind(
                          fontWeight: FontWeight.w600,
                          fontSize: context.isWeb ? 16 : 14,
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
                    fontSize: context.isWeb ? 14 : 12,
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
                  hintFontSize: context.isWeb ? 16 : 14,
                  controller: vm.pinController,
                  hasError:
                      state.hasSubmitted &&
                      (FormValidators.validatePin(state.pin) != null ||
                          state.pin != state.confirmPin),
                  keyboardType: TextInputType.number,
                  errorMessage: state.hasSubmitted
                      ? (FormValidators.validatePin(state.pin) ??
                            FormValidators.validatePinMatch(
                              state.pin,
                              state.confirmPin,
                            ))
                      : null,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  isPassword: true,
                  height: context.isWeb ? 48 : 35,
                  contentPadding: EdgeInsets.only(top: context.isWeb ? 0 : 10),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'Confirm Pin',
                  labelFontWeight: FontWeight.w600,
                  hintText: 'Confirm PIN',
                  prefixIcon: AppAssets.icons.lock.path,
                  hintTextColor: AppColors.textBlackGrey,
                  suffixIcon: Icon(Icons.visibility_off_outlined),
                  hintFontSize: context.isWeb ? 16 : 14,
                  controller: vm.confirmPinController,
                  hasError:
                      state.hasSubmitted &&
                      (FormValidators.validatePin(state.confirmPin) != null ||
                          state.pin != state.confirmPin),
                  errorMessage: state.hasSubmitted
                      ? (FormValidators.validatePin(state.confirmPin) ??
                            FormValidators.validatePinMatch(
                              state.pin,
                              state.confirmPin,
                            ))
                      : null,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  isPassword: true,
                  height: context.isWeb ? 48 : 35,
                  contentPadding: EdgeInsets.only(top: context.isWeb ? 0 : 10),
                ),
                const SizedBox(height: 35),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Cancel',
                        onPressed: () {},
                        fontSize: context.isWeb ? 18 : 16,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.textDarkDarkerGreen,
                        height: context.isWeb ? 48 : 40,
                        buttonColor: AppColors.buttonLighterGreen,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: CustomButton(
                        text: 'Continue',
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final result = await vm.setUserPin(context: context);
                          if (result) {
                            if (!context.mounted) return;
                            _showSuccessDialog(context, notifier, ref);
                          } else {
                            final freshState = ref.read(
                              withdrawalViewModelProvider,
                            );
                            if (!context.mounted) return;
                            showErrorBanner(freshState.errorMessage!, context);
                          }
                        },
                        fontSize: context.isWeb ? 18 : 16,
                        fontWeight: FontWeight.w500,
                        height: context.isWeb ? 48 : 40,
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
    WidgetRef ref,
  ) async {
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
                padding: EdgeInsets.only(right: context.isWeb ? 0 : 25),
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
            padding: EdgeInsets.symmetric(horizontal: context.isWeb ? 45.0 : 0),
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
                    fontSize: context.isWeb ? 20 : 14,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "This is the Pin will protect your funds and ensures only you can request a payout.",
                  style: GoogleFonts.hind(
                    fontSize: context.isWeb ? 16 : 12,
                    color: AppColors.textBodyText,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Continue',
                  onPressed: () async {
                    final storage = SecureStorage();
                    // final prefs = await SharedPreferences.getInstance();
                    // final storage = LocalStorageService(prefs);

                    final authState = ref.watch(authStateProvider);
                    if (authState.status == AuthStatus.loggedIn &&
                        authState.user != null) {
                      final user = authState.user!;
                      final userId = user.id;
                      await storage.storeData(
                        key: userKey('pinSetUpCompleted', userId),
                        data: 'true',
                      );
                    }
                    if (!dialogContext.mounted) return;
                    Navigator.of(dialogContext).pop();
                    notifier.setWalletScreenState(
                      WalletScreenState.addBankAccount,
                    );
                  },
                  fontSize: context.isWeb ? 18 : 12,
                  height: context.isWeb ? 48 : 45,
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
