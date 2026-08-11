import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/validation_utils.dart';
import 'package:wigo_flutter/features/rider/models/bank_details.dart';
import 'package:wigo_flutter/shared/widgets/custom_text_field.dart';

import '../../../../core/auth/auth_state.dart';
import '../../../../core/auth/auth_state_notifier.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/context_extensions.dart';
import '../../../../core/utils/helper_methods_classes.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../viewmodels/wallet_withdrawal_viewmodel.dart';

class CustomAlertDialog extends StatelessWidget {
  final Widget content;
  final Widget? title;
  final List<Widget>? actions;
  final void Function()? closeIconPress;

  const CustomAlertDialog({
    super.key,
    required this.content,
    this.title,
    this.actions,
    required this.closeIconPress,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 20),
            child: GestureDetector(
              onTap: closeIconPress,
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.fromLTRB(25, 5, 25, 20),
      content: SingleChildScrollView(child: content),
      actions: actions,
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: AppColors.backgroundWhite,
      titlePadding: EdgeInsets.zero,
    );
  }
}

class SuccessFailureDialog extends StatelessWidget {
  const SuccessFailureDialog({
    super.key,
    this.body,
    this.onPressed1,
    this.onPressed2,
    required this.buttonText2,
    required this.buttonText1,
    this.isWalletWithdrawal = true,
    required this.description,
    required this.title,
    required this.icon,
  });

  final String title, description;
  final VoidCallback? onPressed1;
  final VoidCallback? onPressed2;
  final bool isWalletWithdrawal;
  final Widget? body;
  final String buttonText1, buttonText2;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.isWeb ? 45.0 : 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: context.isWeb ? 20 : 14,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              description,
              style: GoogleFonts.hind(
                fontSize: context.isWeb ? 16 : 12,
                color: AppColors.textBodyText,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (body != null) ...[const SizedBox(height: 10), body!],
          const SizedBox(height: 20),
          CustomButton(
            text: buttonText1,
            onPressed: onPressed1,
            fontSize: context.isWeb ? 18 : 12,
            height: context.isWeb ? 48 : 45,
            fontWeight: FontWeight.w500,
            width: double.infinity,
          ),

          if (isWalletWithdrawal) SizedBox(height: 10),
          if (isWalletWithdrawal)
            CustomButton(
              text: buttonText2,
              onPressed: onPressed2,
              fontSize: context.isWeb ? 18 : 12,
              height: context.isWeb ? 48 : 45,
              fontWeight: FontWeight.w500,
              width: double.infinity,
              buttonColor: Colors.transparent,
              borderColor: AppColors.primaryDarkGreen,
              textColor: AppColors.textVidaLocaGreen,
            ),
        ],
      ),
    );
  }
}

class InputPinDialog extends ConsumerWidget {
  const InputPinDialog({
    super.key,
    required this.body,
    required this.onPinSubmitted,
    this.buttonText,
    this.title,
    required this.details,
    this.labelOnTap,
  });

  final String? title, buttonText;
  final void Function()? onPinSubmitted;
  final Widget body;
  final BankDetails details;
  final void Function()? labelOnTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(withdrawalViewModelProvider.notifier);
    final state = ref.watch(withdrawalViewModelProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.isWeb ? 45.0 : 0),
      child: SizedBox(
        width: 1000,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: context.isWeb
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              title ?? 'Enter PIN to make Withdrawal',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: context.isWeb ? 20 : 16,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 16),
            body,
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Forgot Pin?',
              labelFontSize: context.isWeb ? 16 : 12,
              hintText: 'Enter PIN',
              labelOnTap: labelOnTap,
              isPassword: true,
              suffixIconPadding: 10,
              prefixIcon: AppAssets.icons.lock.path,
              labelTextColor: AppColors.textVidaLocaGreen,
              hintFontSize: context.isWeb ? 16 : 14,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              suffixIcon: Icon(Icons.visibility_off_outlined),
              controller: vm.pinController,
              hasError:
                  state.hasSubmitted &&
                  FormValidators.validatePin(state.pin) != null,
              errorMessage: state.hasSubmitted
                  ? FormValidators.validatePin(state.pin)
                  : null,
              height: context.isWeb ? 52 : 40,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: buttonText ?? 'Make Withdrawal',
              onPressed: onPinSubmitted,
              fontSize: context.isWeb ? 18 : 12,
              height: context.isWeb ? 48 : 45,
              fontWeight: FontWeight.w500,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPinDialog extends ConsumerWidget {
  const ResetPinDialog({
    super.key,
    this.buttonText,
    this.title,
    this.description,
    this.isCreatePin = false,
    this.isResetPin = true,
    this.onPressed,
    this.onClose,
    this.dialogContext,
    this.context,
  });

  final String? title, buttonText, description;
  final bool isCreatePin, isResetPin;
  final void Function()? onPressed;
  final void Function()? onClose;
  final BuildContext? dialogContext, context;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(withdrawalViewModelProvider.notifier);
    final state = ref.watch(withdrawalViewModelProvider);
    final authState = ref.watch(authStateProvider);
    final user = authState.status == AuthStatus.loggedIn
        ? authState.user
        : null;
    final userEmail = user?.email ?? 'chu******osy@gmail.com';
    final String maskedUserEmail = MaskedEmail.maskEmail(userEmail);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.isWeb ? 45.0 : 0),
      child: SizedBox(
        width: 1000,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: context.isWeb
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              title ?? 'Reset Withdrawal PIN',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w700,
                fontSize: context.isWeb ? 20 : 16,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description ??
                  'An OTP has been sent to your registered email $maskedUserEmail',
              style: GoogleFonts.hind(
                fontSize: context.isWeb ? 16 : 12,
                color: AppColors.textBlackGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 15),
            if (isResetPin)
              CustomTextField(
                label: 'Enter OTP',
                labelFontSize: context.isWeb ? 16 : 14,
                suffixIconPadding: 10,
                prefixIcon: AppAssets.icons.mail.path,
                hintFontSize: context.isWeb ? 16 : 14,
                keyboardType: TextInputType.number,
                isPassword: false,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: vm.otpController,
                onChanged: vm.updateCode,
                height: context.isWeb ? 52 : 40,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
              ),
            if (isCreatePin) ...[
              CustomTextField(
                labelFontSize: context.isWeb ? 16 : 14,
                label: 'Create Pin',
                hintText: 'Enter PIN',
                suffixIconPadding: 10,
                prefixIcon: AppAssets.icons.lock.path,
                hintFontSize: context.isWeb ? 16 : 14,
                keyboardType: TextInputType.number,
                isPassword: true,
                onChanged: vm.updatePin,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                suffixIcon: Icon(Icons.visibility_off_outlined),
                controller: vm.pinController,
                hasError:
                    state.hasSubmitted &&
                    (FormValidators.validatePin(state.pin) != null ||
                        state.pin != state.confirmPin),
                height: context.isWeb ? 52 : 40,
                errorMessage: state.hasSubmitted
                    ? (FormValidators.validatePin(state.pin) ??
                          FormValidators.validatePinMatch(
                            state.pin,
                            state.confirmPin,
                          ))
                    : null,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
              ),
              const SizedBox(height: 15),
              CustomTextField(
                label: 'Confirm Pin',
                labelFontSize: context.isWeb ? 16 : 14,
                hintText: 'Confirm PIN',
                suffixIconPadding: 10,
                prefixIcon: AppAssets.icons.lock.path,
                hintFontSize: context.isWeb ? 16 : 14,
                keyboardType: TextInputType.number,
                isPassword: true,
                onChanged: vm.updateConfirmPin,
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
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                suffixIcon: Icon(Icons.visibility_off_outlined),
                controller: vm.confirmPinController,
                height: context.isWeb ? 52 : 40,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
              ),
            ],
            const SizedBox(height: 10),
            CustomButton(
              text: buttonText ?? 'Continue',
              onPressed:
                  onPressed ??
                  () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (!context.mounted) return;
                    if (dialogContext != null) {
                      Navigator.pop(dialogContext!);
                      Navigator.pop(context);
                    }
                    await Future.delayed(const Duration(milliseconds: 500));
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
  }
}
