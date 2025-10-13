import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/utils/validation_utils.dart';
import 'package:wigo_flutter/features/rider/models/bank_details.dart';
import 'package:wigo_flutter/shared/widgets/custom_text_field.dart';

import '../../core/constants/app_colors.dart';
import '../../features/rider/viewmodels/wallet_withdrawal_viewmodel.dart';
import '../../gen/assets.gen.dart';
import 'custom_button.dart';

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
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 45.0 : 0),
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
              fontSize: isWeb ? 20 : 14,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              description,
              style: GoogleFonts.hind(
                fontSize: isWeb ? 16 : 12,
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
            fontSize: isWeb ? 18 : 12,
            height: isWeb ? 48 : 45,
            fontWeight: FontWeight.w500,
            width: double.infinity,
          ),

          if (isWalletWithdrawal) SizedBox(height: 10),
          if (isWalletWithdrawal)
            CustomButton(
              text: buttonText2,
              onPressed: onPressed2,
              fontSize: isWeb ? 18 : 12,
              height: isWeb ? 48 : 45,
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

class InputPinDialog extends ConsumerStatefulWidget {
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
  final void Function(String pin) onPinSubmitted;
  final Widget body;
  final BankDetails details;
  final void Function()? labelOnTap;

  @override
  ConsumerState<InputPinDialog> createState() => _InputPinDialogState();
}

class _InputPinDialogState extends ConsumerState<InputPinDialog> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _submitPin() {
    final pin = _pinController.text.trim();
    // if (pin.isEmpty) {
    //   setState(() {
    //     _pinError = "PIN cannot be empty.";
    //   });
    //   return;
    // }
    // if (pin.length != 4) {
    //   setState(() {
    //     _pinError = "PIN must be 4 digits.";
    //   });
    //   return;
    // }

    widget.onPinSubmitted(pin);
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 45.0 : 0),
      child: SizedBox(
        width: 1000,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              isWeb ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              widget.title ?? 'Enter PIN to make Withdrawal',
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w600,
                fontSize: isWeb ? 20 : 16,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 16),
            widget.body,
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Forgot Pin?',
              labelFontSize: isWeb ? 16 : 12,
              hintText: 'Enter PIN',
              labelOnTap: widget.labelOnTap,
              isPassword: true,
              suffixIconPadding: 10,
              prefixIcon: AppAssets.icons.lock.path,
              labelTextColor: AppColors.textVidaLocaGreen,
              hintFontSize: isWeb ? 16 : 14,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              suffixIcon: Icon(Icons.visibility_off_outlined),
              controller: _pinController,
              height: isWeb ? 52 : 40,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: widget.buttonText ?? 'Make Withdrawal',
              onPressed: _submitPin,
              fontSize: isWeb ? 18 : 12,
              height: isWeb ? 48 : 45,
              fontWeight: FontWeight.w500,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPinDialog extends ConsumerStatefulWidget {
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
  ConsumerState<ResetPinDialog> createState() => _ResetPinDialogState();
}

class _ResetPinDialogState extends ConsumerState<ResetPinDialog> {
  String? _pinHasError;
  String? _confirmPinHasError;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final pinKey = GlobalKey<FormFieldState<String>>();
  final confirmPinKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    final vm = ref.watch(withdrawalViewModelProvider.notifier);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWeb ? 45.0 : 0),
      child: SizedBox(
        width: 1000,
        child: Form(
          key: vm.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isWeb ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Text(
                widget.title ?? 'Reset Withdrawal PIN',
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w700,
                  fontSize: isWeb ? 20 : 16,
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.description ??
                    'An OTP has been sent to your registered Email abcd**joh@gmail.com',
                style: GoogleFonts.hind(
                  fontSize: isWeb ? 16 : 12,
                  color: AppColors.textBlackGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Divider(thickness: 1.5),
              const SizedBox(height: 15),
              if (widget.isResetPin)
                CustomTextField(
                  label: 'Enter OTP',
                  labelFontSize: isWeb ? 16 : 14,
                  suffixIconPadding: 10,
                  prefixIcon: AppAssets.icons.mail.path,
                  hintFontSize: isWeb ? 16 : 14,
                  keyboardType: TextInputType.number,
                  isPassword: false,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: vm.otpController,
                  height: isWeb ? 52 : 40,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                ),
              if (widget.isCreatePin)
                CustomTextField(
                  labelFontSize: isWeb ? 16 : 14,
                  label: 'Create Pin',
                  hintText: 'Enter PIN',
                  suffixIconPadding: 10,
                  prefixIcon: AppAssets.icons.lock.path,
                  hintFontSize: isWeb ? 16 : 14,
                  keyboardType: TextInputType.number,
                  isPassword: true,
                  key: pinKey,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  suffixIcon: Icon(Icons.visibility_off_outlined),
                  controller: vm.pinController,
                  hasError: _pinHasError != null,
                  validator: (value) => null,
                  height: isWeb ? 52 : 40,
                  autoValidateMode: _autovalidateMode,
                  errorMessage: _pinHasError,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                ),
              if (widget.isCreatePin) const SizedBox(height: 15),
              if (widget.isCreatePin)
                CustomTextField(
                  label: 'Confirm Pin',
                  labelFontSize: isWeb ? 16 : 14,
                  hintText: 'Confirm PIN',
                  suffixIconPadding: 10,
                  key: confirmPinKey,
                  prefixIcon: AppAssets.icons.lock.path,
                  hintFontSize: isWeb ? 16 : 14,
                  keyboardType: TextInputType.number,
                  isPassword: true,
                  hasError: _confirmPinHasError != null,
                  autoValidateMode: _autovalidateMode,
                  validator: (value) => null,
                  errorMessage: _confirmPinHasError,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  suffixIcon: Icon(Icons.visibility_off_outlined),
                  controller: vm.confirmPinController,
                  height: isWeb ? 52 : 40,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                ),
              const SizedBox(height: 10),
              CustomButton(
                text: widget.buttonText ?? 'Continue',
                onPressed:
                    widget.onPressed ??
                    () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final pinLengthError = FormValidators.validatePin(
                        vm.pinController.text,
                      );
                      final confirmPinLengthError = FormValidators.validatePin(
                        vm.confirmPinController.text,
                      );
                      String? mismatchError;
                      if (pinLengthError == null &&
                          confirmPinLengthError == null) {
                        if (vm.pinController.text !=
                            vm.confirmPinController.text) {
                          mismatchError = 'Pins do not match. Please re-enter.';
                        }
                      }

                      setState(() {
                        _pinHasError = pinLengthError ?? mismatchError;
                        _confirmPinHasError =
                            confirmPinLengthError ?? mismatchError;

                        // 2. Enable styling
                        _autovalidateMode = AutovalidateMode.always;
                      });

                      final hasAnyError =
                          _pinHasError != null || _confirmPinHasError != null;
                      if (!hasAnyError) {
                        vm.setLoading(true);
                        vm.pinController.clear();
                        vm.confirmPinController.clear();
                        if (!context.mounted) return;
                        if (widget.dialogContext != null) {
                          Navigator.pop(
                            widget.dialogContext!,
                          ); // Safely use the non-null assertion operator (!)
                        }
                        if (widget.context != null) {
                          Navigator.pop(
                            widget.context!,
                          ); // Safely use the non-null assertion operator (!)
                        }
                        await Future.delayed(const Duration(milliseconds: 500));
                        vm.setLoading(false);
                      }
                    },
                fontSize: isWeb ? 18 : 12,
                height: isWeb ? 48 : 45,
                fontWeight: FontWeight.w500,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
