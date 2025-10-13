import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_wallet_screens/wallet_edit_bank_account_screen.dart';
import 'package:wigo_flutter/features/rider/viewmodels/edit_bank_account_viewmodel.dart';
import 'package:wigo_flutter/features/rider/viewmodels/wallet_withdrawal_viewmodel.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/validation_utils.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_dialog.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../models/bank_details.dart';
import '../../widgets/bank_details_tile.dart';
import '../../widgets/withdraw_confirmation_card.dart';

enum WithdrawalStatus { success, failure }

class WalletWithdrawalScreen extends ConsumerStatefulWidget {
  const WalletWithdrawalScreen({super.key});

  @override
  ConsumerState<WalletWithdrawalScreen> createState() =>
      _WalletWithdrawalScreenState();
}

class _WalletWithdrawalScreenState
    extends ConsumerState<WalletWithdrawalScreen> {
  String? _currentAmountError;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(withdrawalViewModelProvider.notifier);
    final isWeb = MediaQuery.of(context).size.width > 600;
    String amount = vm.amountController.text;
    final defaultBank =
        ref.watch(editBankAccountProvider.notifier).getDefaultBankAccount();
    final continueButtonColor = AppColors.primaryDarkGreen;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body:
            isWeb
                ? Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 300, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildBody(
                          defaultBank,
                          continueButtonColor,
                          amount,
                          vm,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: WithdrawalConfirmationCard(
                          onConfirm: () {
                            _showPinDialog(
                              context,
                              defaultBank ??
                                  BankDetails.empty('1').copyWith(
                                    bankName: 'No Default Account Set',
                                    accountNumber: '**** ****',
                                  ),
                              amount,
                              vm,
                            );
                          },
                          amount: amount,
                          details:
                              defaultBank ??
                              BankDetails.empty('1').copyWith(
                                bankName: 'No Default Account Set',
                                accountNumber: '**** ****',
                              ),
                          // onCancel: _handleCancel,
                          // onConfirm: _handleConfirmWithdrawal,
                          isWeb: true,
                          body: _buildBodyCard(
                            context,
                            defaultBank ??
                                BankDetails.empty('1').copyWith(
                                  bankName: 'No Default Account Set',
                                  accountNumber: '**** ****',
                                ),
                            amount,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 20, 15.0, 0),
                    child: _buildBody(
                      defaultBank,
                      continueButtonColor,
                      amount,
                      vm,
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildBody(
    BankDetails? defaultBank,
    Color buttonColor,
    String amount,
    WithdrawalViewmodel vm,
  ) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: AppAssets.icons.arrowLeft.svg(),
            ),
            const SizedBox(width: 5),
            Text(
              'Back',
              style: GoogleFonts.hind(
                fontWeight: isWeb ? FontWeight.w500 : FontWeight.w400,
                fontSize: 18,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        if (!isWeb)
          Divider(color: AppColors.dividerColor.withValues(alpha: 0.2)),
        if (!isWeb) const SizedBox(height: 8),
        Text(
          "Withdrawal",
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w600,
            fontSize: isWeb ? 24 : 16,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Manage your earnings, request withdrawals, and track payout history seamlessly.",
          style: GoogleFonts.hind(
            fontSize: isWeb ? 18 : 12,
            color: AppColors.textBlackGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Card(
          elevation: 0,
          margin: EdgeInsets.only(top: 20),
          color: AppColors.backgroundWhite,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                CustomTextField(
                  label: 'Amount Withdraw',
                  prefixIcon: AppAssets.icons.naira.path,
                  labelTextColor: AppColors.textNeutral950,
                  iconWidth: isWeb ? 19 : 11,
                  fontSize: isWeb ? 18 : 15,
                  labelFontSize: isWeb ? 20 : 15,
                  hintFontSize: isWeb ? 18 : 15,
                  autoValidateMode: _autoValidateMode,
                  labelFontWeight: FontWeight.w600,
                  hintText: 'Enter Amount',
                  controller: vm.amountController,
                  keyboardType: TextInputType.number,
                  hasError: _currentAmountError != null,
                  errorIcon: false,
                  validator: (value) => null,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (v) {},
                  spacing: 15,
                  errorMessage: _currentAmountError,
                  height: isWeb ? 52 : 40,
                  prefixPadding: EdgeInsets.only(
                    left: 17.0,
                    right: 3.0,
                    bottom: 4,
                  ),
                  contentPadding: EdgeInsets.only(left: 10),
                ),
                const SizedBox(height: 5),
                Text(
                  "Min. #500.00",
                  style: GoogleFonts.notoSans(
                    fontSize: isWeb ? 14 : 12,
                    color: AppColors.textBodyText,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 25),
                // Payout Info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppAssets.icons.recentDeliveries.svg(
                      height: 39.04,
                      width: 38.33,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "Payouts are made automatically to your bank account every",
                              style: GoogleFonts.hind(
                                fontSize: isWeb ? 16 : 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textBodyText,
                              ),
                            ),
                            TextSpan(
                              text: ' 24-48 hours ',
                              style: GoogleFonts.hind(
                                fontSize: isWeb ? 16 : 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBodyText,
                              ),
                            ),
                            TextSpan(
                              text: 'after order completion.',
                              style: GoogleFonts.hind(
                                fontSize: isWeb ? 16 : 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textBodyText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Bank Details",
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: isWeb ? 18 : 14,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                defaultBank != null
                    ? BankDetailsTile(
                      bank: defaultBank,
                      isWeb: isWeb,
                      showDelete: false,
                      onEdit: () async {
                        final didUpdate = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditBankAccountScreen(
                                  bankDetails: defaultBank,
                                  openedViaNavigator: true,
                                ),
                          ),
                        );
                        if (didUpdate == true) {
                          setState(() {});
                        }
                      },
                    )
                    : BankDetailsTile(
                      bank: BankDetails.empty('1').copyWith(
                        bankName: 'No Default Account Set',
                        accountNumber: '**** ****',
                      ),
                      isWeb: isWeb,
                      showDelete: false,
                      onEdit: () async {
                        final newBank = BankDetails.empty('1');

                        final didUpdate = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditBankAccountScreen(
                                  bankDetails: newBank,
                                  openedViaNavigator: true,
                                ),
                          ),
                        );
                        if (didUpdate == true) {
                          setState(() {});
                        }
                      },
                    ),
                const SizedBox(height: 20),
                CustomButton(
                  fontSize: isWeb ? 18 : 12,
                  fontWeight: FontWeight.w500,
                  text: 'Continue',
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    final validationResult = FormValidators.validateAmount(
                      vm.amountController.text,
                    );
                    setState(() {
                      _currentAmountError = validationResult;

                      _autoValidateMode = AutovalidateMode.always;
                    });
                    if (defaultBank == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please set a default bank account before withdrawing.",
                          ),
                        ),
                      );
                      return;
                    }

                    if (validationResult == null) {
                      vm.setLoading(true);
                      await Future.delayed(const Duration(milliseconds: 500));
                      vm.amountController.clear();
                      if (!isWeb) {
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (c) => Scaffold(
                                  body: SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child:
                                                  AppAssets.icons.arrowLeft
                                                      .svg(),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Back',
                                              style: GoogleFonts.hind(
                                                fontWeight:
                                                    isWeb
                                                        ? FontWeight.w500
                                                        : FontWeight.w400,
                                                fontSize: 18,
                                                color: AppColors.textBlack,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 8),
                                        if (!isWeb)
                                          Divider(
                                            color: AppColors.dividerColor
                                                .withValues(alpha: 0.2),
                                          ),
                                        if (!isWeb) const SizedBox(height: 8),
                                        WithdrawalConfirmationCard(
                                          onConfirm: () async {
                                            _showPinDialog(
                                              context,
                                              defaultBank,
                                              amount,
                                              vm,
                                            );
                                          },
                                          amount: amount,
                                          details: defaultBank,
                                          isWeb: false,
                                          body: _buildBodyCard(
                                            context,
                                            defaultBank,
                                            amount,
                                            isAmount: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          ),
                        );
                      }
                      vm.setLoading(false);
                    }
                  },
                  width: double.infinity,
                  height: isWeb ? 60 : 45,
                  buttonColor: buttonColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildBodyCard(
  BuildContext context,
  BankDetails details,
  String amount, {
  bool isAmount = false,
  bool isDialogAmount = false,
  bool isNotDialog = true,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.borderColor, width: 1),
    ),
    elevation: 0,
    margin: EdgeInsets.zero,
    color: AppColors.backgroundWhite,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildDetailRow(
            context,
            'Amount',
            "#$amount",
            isAmount: isAmount,
            isDialogAmount: isDialogAmount,
          ),
          const SizedBox(height: 10),
          _buildDetailRow(context, 'Bank Name', details.bankName),
          const SizedBox(height: 10),
          _buildDetailRow(context, 'Account Number', details.accountNumber),
          if (isNotDialog) const SizedBox(height: 10),
          if (isNotDialog)
            _buildDetailRow(context, 'Processing Time', '24 - 48 Hours'),
        ],
      ),
    ),
  );
}

Widget _buildDetailRow(
  BuildContext context,
  String label,
  String value, {
  bool isAmount = false,
  bool isDialogAmount = false,
}) {
  final isWeb = MediaQuery.of(context).size.width > 600;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: GoogleFonts.hind(
          fontWeight: FontWeight.w400,
          color:
              isAmount
                  ? AppColors.textOrange
                  : isDialogAmount
                  ? AppColors.primaryDarkGreen
                  : AppColors.textBlackGrey,
          fontSize: isWeb ? 16 : 12,
        ),
      ),
      Text(
        value,
        style: GoogleFonts.hind(
          fontWeight: FontWeight.w600,
          color:
              isAmount
                  ? AppColors.textOrange
                  : isDialogAmount
                  ? AppColors.primaryDarkGreen
                  : AppColors.textBlackGrey,
          fontSize: isWeb ? 16 : 12,
        ),
      ),
    ],
  );
}

void _showPinDialog(
  BuildContext context,
  BankDetails details,
  String amount,
  WithdrawalViewmodel vm,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return CustomAlertDialog(
        content: InputPinDialog(
          body: _buildBodyCard(
            context,
            details,
            amount,
            isDialogAmount: true,
            isNotDialog: false,
          ),
          labelOnTap: () {
            Navigator.pop(dialogContext);
            _resetPinDialog(context, vm);
          },
          details: details,
          onPinSubmitted: (pin) {
            Navigator.pop(dialogContext);
            _mockWithdrawal(
              context,
              details,
              vm,
              pin,
              amount,
            ); // Proceed to mock withdrawal
          },
        ),
        closeIconPress: () {
          Navigator.pop(dialogContext);
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      );
    },
  );
}

void _resetPinDialog(BuildContext context, WithdrawalViewmodel vm) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return CustomAlertDialog(
        content: ResetPinDialog(
          onPressed: () {
            vm.otpController.clear();
            Navigator.pop(dialogContext);
            _createPinDialog(context, vm);
          },
        ),
        closeIconPress: () {
          Navigator.pop(dialogContext);
          if (Navigator.canPop(context)) {
            Navigator.pop(context); //
          }
        },
      );
    },
  );
}

void _createPinDialog(BuildContext context, WithdrawalViewmodel vm) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return CustomAlertDialog(
        content: ResetPinDialog(
          title: 'Create New PIN',
          description:
              "Secure your earnings with a 4-digit PIN. Make sure to choose a PIN you'll remember.",
          isCreatePin: true,
          isResetPin: false,
          dialogContext: dialogContext,
          context: context,
        ),
        closeIconPress: () {
          Navigator.pop(dialogContext);
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      );
    },
  );
}

// Mock the withdrawal process and show the result dialog
void _mockWithdrawal(
  BuildContext context,
  BankDetails details,
  WithdrawalViewmodel vm,
  String pin,
  String amount,
) {
  // Simulate network delay and backend validation
  // Mock logic: PIN "1234" succeeds, any other PIN fails
  final bool isSuccess = pin == "1234";

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return WithdrawalResultDialog(
        details: details,
        amount: amount,
        status: isSuccess ? WithdrawalStatus.success : WithdrawalStatus.failure,
        onSuccessBack: () {
          Navigator.pop(dialogContext);
          Navigator.pop(context);
        },
        onTryAgain: () {
          Navigator.pop(dialogContext);
          _showPinDialog(context, details, amount, vm);
        },
        onCancel: () {
          Navigator.pop(dialogContext);
          Navigator.pop(context);
        },
      );
    },
  );
}

class WithdrawalResultDialog extends StatelessWidget {
  final BankDetails details;
  final WithdrawalStatus status;
  final VoidCallback onSuccessBack;
  final VoidCallback onTryAgain;
  final VoidCallback onCancel;
  final String amount;

  const WithdrawalResultDialog({
    super.key,
    required this.details,
    required this.status,
    required this.onSuccessBack,
    required this.onTryAgain,
    required this.onCancel,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = status == WithdrawalStatus.success;
    final String title =
        isSuccess ? "Withdrawal Successful" : "Withdrawal Failed";
    final String buttonText1 = isSuccess ? "Back" : "Try-again";
    final String buttonText2 =
        isSuccess ? "View Transaction History" : "Cancel";
    final String message =
        isSuccess
            ? "Your withdrawal request has been submitted successfully. You'll receive a notification once it's processed."
            : "Your withdrawal request failed. Kindly check if your details again or if you have sufficient funds in your wallet";

    return CustomAlertDialog(
      content: SuccessFailureDialog(
        buttonText2: buttonText2,
        buttonText1: buttonText1,
        description: message,
        title: title,
        icon:
            isSuccess
                ? AppAssets.icons.doubleTickSuccessful.svg()
                : AppAssets.icons.actionFailed.svg(),
        body: _buildBodyCard(
          context,
          details,
          amount,
          isNotDialog: false,
          isDialogAmount: true,
        ),
        onPressed1: isSuccess ? onSuccessBack : onTryAgain,
        onPressed2: onCancel,
      ),
      closeIconPress: onCancel,
    );
  }
}
