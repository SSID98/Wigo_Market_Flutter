import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wigo_flutter/features/rider/presentation/views/rider_wallet_screens/wallet_edit_bank_account_screen.dart';
import 'package:wigo_flutter/features/rider/viewmodels/edit_bank_account_viewmodel.dart';
import 'package:wigo_flutter/features/rider/viewmodels/wallet_withdrawal_viewmodel.dart';
import 'package:wigo_flutter/shared/models/bank_model.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/context_extensions.dart';
import '../../../../../core/utils/validation_utils.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_banner.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../models/bank_details.dart';
import '../../widgets/bank_details_tile.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/withdraw_confirmation_card.dart';

enum WithdrawalStatus { success, failure }

class WalletWithdrawalScreen extends ConsumerWidget {
  const WalletWithdrawalScreen({super.key, required this.isSeller});

  final bool isSeller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(withdrawalViewModelProvider.notifier);
    ref.read(editBankAccountProvider.notifier).ensureWalletFetched();
    final state = ref.watch(withdrawalViewModelProvider);
    final amount = state.amount ?? '';
    final bankState = ref.watch(editBankAccountProvider);
    final defaultBank = bankState.bankDetailsList
        .cast<BankDetails?>()
        .firstWhere(
          (bank) => bank != null && bank.isDefault,
          orElse: () => null,
        );
    final continueButtonColor = AppColors.primaryDarkGreen;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: context.isWeb
            ? Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 300, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildBody(
                        defaultBank,
                        continueButtonColor,
                        amount,
                        context,
                        ref,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: state.showConfirmationCard
                          ? WithdrawalConfirmationCard(
                              onConfirm: () {
                                _showPinDialog(
                                  context,
                                  defaultBank ??
                                      BankDetails.empty('1').copyWith(
                                        selectedBank: Bank(
                                          name: 'No Default Account Set',
                                          id: 0,
                                          code: '',
                                        ),
                                        accountNumber: '**** ****',
                                      ),
                                  amount,
                                  ref,
                                );
                              },
                              amount: amount,
                              details:
                                  defaultBank ??
                                  BankDetails.empty('1').copyWith(
                                    selectedBank: Bank(
                                      name: 'No Default Account Set',
                                      id: 0,
                                      code: '',
                                    ),
                                    accountNumber: '**** ****',
                                  ),
                              onCancel: () {
                                vm.toggleConfirmationCard(false);
                              },
                              isWeb: true,
                              body: _buildBodyCard(
                                context,
                                defaultBank ??
                                    BankDetails.empty('1').copyWith(
                                      selectedBank: Bank(
                                        name: 'No Default Account Set',
                                        id: 0,
                                        code: '',
                                      ),
                                      accountNumber: '**** ****',
                                    ),
                                amount,
                              ),
                            )
                          : const SizedBox(),
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
                    context,
                    ref,
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
    BuildContext context,
    WidgetRef ref,
  ) {
    final vm = ref.read(withdrawalViewModelProvider.notifier);
    final state = ref.watch(withdrawalViewModelProvider);
    final bankState = ref.watch(editBankAccountProvider);
    final defaultBankIndex = bankState.bankDetailsList.indexWhere(
      (b) => b.isDefault,
    );
    final defaultBank = defaultBankIndex != -1
        ? bankState.bankDetailsList[defaultBankIndex]
        : null;

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
                fontWeight: context.isWeb ? FontWeight.w500 : FontWeight.w400,
                fontSize: 18,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        if (!context.isWeb)
          Divider(color: AppColors.dividerColor.withValues(alpha: 0.2)),
        if (!context.isWeb) const SizedBox(height: 8),
        Text(
          "Withdrawal",
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w600,
            fontSize: context.isWeb ? 24 : 16,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Manage your earnings, request withdrawals, and track payout history seamlessly.",
          style: GoogleFonts.hind(
            fontSize: context.isWeb ? 18 : 12,
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
                  iconWidth: context.isWeb ? 19 : 11,
                  fontSize: context.isWeb ? 18 : 15,
                  labelFontSize: context.isWeb ? 20 : 15,
                  hintFontSize: context.isWeb ? 18 : 15,
                  labelFontWeight: FontWeight.w600,
                  hintText: 'Enter Amount',
                  controller: vm.amountController,
                  keyboardType: TextInputType.number,
                  hasError:
                      state.hasSubmitted &&
                      FormValidators.validateAmount(state.amount) != null,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: vm.updateAmount,
                  spacing: 15,
                  errorMessage: state.hasSubmitted
                      ? FormValidators.validateAmount(state.amount)
                      : null,
                  height: context.isWeb ? 52 : 40,
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
                    fontSize: context.isWeb ? 14 : 12,
                    color: AppColors.textBodyText,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 25),

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
                                fontSize: context.isWeb ? 16 : 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textBodyText,
                              ),
                            ),
                            TextSpan(
                              text: ' 24-48 hours ',
                              style: GoogleFonts.hind(
                                fontSize: context.isWeb ? 16 : 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBodyText,
                              ),
                            ),
                            TextSpan(
                              text: 'after order completion.',
                              style: GoogleFonts.hind(
                                fontSize: context.isWeb ? 16 : 12,
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
                    fontSize: context.isWeb ? 18 : 14,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                defaultBank != null
                    ? BankDetailsTile(
                        bank: defaultBank,
                        isWeb: context.isWeb,
                        showDelete: false,
                        position: defaultBankIndex + 1,
                        onEdit: () {
                          final s = ref.read(editBankAccountProvider);
                          final canEditDirectly =
                              s.hasWallet && s.hasWithdrawalPin;

                          if (!canEditDirectly) {
                            isSeller
                                ? ref
                                      .read(editBankAccountProvider.notifier)
                                      .navigateToSellerPaymentSetup(context)
                                : ref
                                      .read(editBankAccountProvider.notifier)
                                      .navigateToPaymentSetup(context);
                            ;
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                            return;
                          }

                          Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBankAccountScreen(
                                bankDetails: defaultBank,
                                openedViaNavigator: true,
                              ),
                            ),
                          );
                        },
                      )
                    : BankDetailsTile(
                        bank: BankDetails.empty('1').copyWith(
                          selectedBank: Bank(
                            name: 'No Default Account Set',
                            id: 0,
                            code: '',
                          ),
                          accountNumber: '**** ****',
                        ),
                        isWeb: context.isWeb,
                        showDelete: false,
                        position: defaultBankIndex + 1,
                        onEdit: () {
                          final s = ref.read(editBankAccountProvider);
                          final canEditDirectly =
                              s.hasWallet &&
                              s.hasWithdrawalPin &&
                              defaultBank != null;

                          if (s.hasWithdrawalPin == false) {
                            showErrorBanner(
                              "Please set a withdrawal pin first",
                              context,
                            );
                            return;
                          }

                          if (!canEditDirectly) {
                            isSeller
                                ? ref
                                      .read(editBankAccountProvider.notifier)
                                      .navigateToSellerPaymentSetup(context)
                                : ref
                                      .read(editBankAccountProvider.notifier)
                                      .navigateToPaymentSetup(context);
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                            return;
                          }

                          Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBankAccountScreen(
                                bankDetails: defaultBank,
                                openedViaNavigator: true,
                              ),
                            ),
                          );
                        },
                      ),
                const SizedBox(height: 20),
                CustomButton(
                  fontSize: context.isWeb ? 18 : 12,
                  fontWeight: FontWeight.w500,
                  text: 'Continue',
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (defaultBank == null) {
                      showErrorBanner(
                        "Please set a default bank account before withdrawing.",
                        context,
                      );
                      isSeller
                          ? ref
                                .read(editBankAccountProvider.notifier)
                                .navigateToSellerPaymentSetup(context)
                          : ref
                                .read(editBankAccountProvider.notifier)
                                .navigateToPaymentSetup(context);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      return;
                    } else if (bankState.hasWithdrawalPin != true) {
                      showErrorBanner(
                        "Please set a withdrawal pin first",
                        context,
                      );
                      isSeller
                          ? ref
                                .read(editBankAccountProvider.notifier)
                                .navigateToSellerPaymentSetup(context)
                          : ref
                                .read(editBankAccountProvider.notifier)
                                .navigateToPaymentSetup(context);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      return;
                    }
                    vm.setLoading(true);
                    await Future.delayed(const Duration(milliseconds: 500));
                    if (context.mounted && !context.isWeb) {
                      vm.amountController.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => Scaffold(
                            body: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 20,
                              ),
                              child: Column(
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
                                          fontWeight: context.isWeb
                                              ? FontWeight.w500
                                              : FontWeight.w400,
                                          fontSize: 18,
                                          color: AppColors.textBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  if (!context.isWeb)
                                    Divider(
                                      color: AppColors.dividerColor.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                  if (!context.isWeb) const SizedBox(height: 8),
                                  WithdrawalConfirmationCard(
                                    onConfirm: () async {
                                      _showPinDialog(
                                        context,
                                        defaultBank,
                                        amount,
                                        ref,
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
                    } else if (context.mounted && context.isWeb) {
                      vm.toggleConfirmationCard(true);
                    }
                    vm.setLoading(false);
                  },
                  width: double.infinity,
                  height: context.isWeb ? 60 : 45,
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
          _buildDetailRow(
            context,
            'Bank Name',
            details.selectedBank?.name ?? '',
          ),
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
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: GoogleFonts.hind(
          fontWeight: FontWeight.w400,
          color: isAmount
              ? AppColors.textOrange
              : isDialogAmount
              ? AppColors.primaryDarkGreen
              : AppColors.textBlackGrey,
          fontSize: context.isWeb ? 16 : 12,
        ),
      ),
      Text(
        value,
        style: GoogleFonts.hind(
          fontWeight: FontWeight.w600,
          color: isAmount
              ? AppColors.textOrange
              : isDialogAmount
              ? AppColors.primaryDarkGreen
              : AppColors.textBlackGrey,
          fontSize: context.isWeb ? 16 : 12,
        ),
      ),
    ],
  );
}

void _showPinDialog(
  BuildContext context,
  BankDetails details,
  String amount,
  WidgetRef ref,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      final vm = ref.read(withdrawalViewModelProvider.notifier);
      return CustomAlertDialog(
        content: InputPinDialog(
          body: _buildBodyCard(
            context,
            details,
            amount,
            isDialogAmount: true,
            isNotDialog: false,
          ),
          labelOnTap: () async {
            final success = await vm.requestPinOtp(dialogContext);
            if (success) {
              if (!context.mounted) return;
              Navigator.pop(dialogContext);
              _resetPinDialog(context, vm, ref);
            }
          },
          details: details,
          onPinSubmitted: () async {
            Navigator.pop(dialogContext);
            final result = await vm.makeWithdrawal(context: dialogContext);
            if (result && context.mounted) {
              showWithdrawalResult(context, details, true, amount, ref);
            } else {
              if (!context.mounted) return;
              showWithdrawalResult(context, details, false, amount, ref);
            }
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

void _resetPinDialog(
  BuildContext context,
  WithdrawalViewmodel vm,
  WidgetRef ref,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return CustomAlertDialog(
        content: ResetPinDialog(
          onPressed: () async {
            await vm.verifyOtp(context: dialogContext);
            if (ref.read(withdrawalViewModelProvider).isVerified) {
              vm.otpController.clear();
              if (!context.mounted) return;
              Navigator.pop(dialogContext);
              _createNewPinDialog(context, vm, ref);
            }
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

void _createNewPinDialog(
  BuildContext context,
  WithdrawalViewmodel vm,
  WidgetRef ref,
) {
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
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            final result = await vm.resetUserPin(context: dialogContext);
            if (result) {
              if (!context.mounted) return;
              showSuccessBanner(
                "Pin successfully reset, You can now withdraw",
                context,
              );
              Navigator.pop(dialogContext);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            }
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

void showWithdrawalResult(
  BuildContext context,
  BankDetails details,
  bool isSuccess,
  String amount,
  WidgetRef ref,
) {
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
          _showPinDialog(context, details, amount, ref);
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
    final String title = isSuccess
        ? "Withdrawal Successful"
        : "Withdrawal Failed";
    final String buttonText1 = isSuccess ? "Back" : "Try-again";
    final String buttonText2 = isSuccess
        ? "View Transaction History"
        : "Cancel";
    final String message = isSuccess
        ? "Your withdrawal request has been submitted successfully. You'll receive a notification once it's processed."
        : "Your withdrawal request failed. Kindly check if your details again or if you have sufficient funds in your wallet";

    return CustomAlertDialog(
      content: SuccessFailureDialog(
        buttonText2: buttonText2,
        buttonText1: buttonText1,
        description: message,
        title: title,
        icon: isSuccess
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
