import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/rider/presentation/widgets/bank_details_tile.dart';
import 'package:wigo_flutter/features/rider/viewmodels/edit_bank_account_viewmodel.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../models/bank_details.dart';

class AddBankAccountScreen extends ConsumerWidget {
  const AddBankAccountScreen({super.key, required this.isWeb});

  final bool isWeb;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bankList = ref.watch(editBankAccountProvider).bankDetailsList;
    return isWeb
        ? Padding(
          padding: EdgeInsets.only(left: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 601,
                child: _buildBankAccountsCard(ref, bankList, isWeb, context),
              ),
              const SizedBox(width: 20),
              SizedBox(width: 400, child: _buildInfoCard()),
            ],
          ),
        )
        : Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildBankAccountsCard(ref, bankList, isWeb, context),
                const SizedBox(height: 20),
                _buildInfoCard(),
              ],
            ),
          ),
        );
  }

  Widget _buildBankAccountsCard(
    WidgetRef ref,
    List<BankDetails> bankList,
    bool isWeb,
    BuildContext context,
  ) {
    final notifier = ref.read(editBankAccountProvider.notifier);

    return Card(
      elevation: 0,
      color: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      margin: EdgeInsets.only(top: 20),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          isWeb ? 60 : 16.0,
          isWeb ? 40 : 16.0,
          isWeb ? 60 : 16.0,
          isWeb ? 80 : 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "We need your bank details to send you earnings from completed deliveries. You can Add up to 3 Bank Accounts.",
              style: GoogleFonts.hind(
                fontSize: isWeb ? 18 : 12,
                color: AppColors.textBlackGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 25),
            ...bankList.map(
              (bank) => BankDetailsTile(
                bank: bank,
                isWeb: isWeb,
                showDelete: true,
                onEdit: () => notifier.startEditBankAccount(bank),
                onClear:
                    () => _showClearConfirmationDialog(
                      context,
                      notifier,
                      bank.id,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: AppColors.backgroundWhite,
      elevation: 0,
      margin: EdgeInsets.only(bottom: 20, top: isWeb ? 20 : 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: double.infinity,
              height: isWeb ? 54 : 34,
              color: AppColors.buttonLighterGreen,
              child: Center(
                child: Text(
                  "How Pay-outs are made",
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.textBlackGrey,
                  ),
                ),
              ),
            ),
            _buildCard(
              "Withdraw Your Funds",
              "You can request a withdrawal once your available balance meets the minimum withdrawal amount of",
              isWithdraw: true,
              isWeb,
              withdraw: ' ₦1,000.',
            ),
            const SizedBox(height: 20),
            _buildCard(
              "How Pay-outs are made",
              "Pay-outs are made automatically to your bank account every",
              isWeb,
              isPayouts: true,
              payout1: ' 24–48 hours ',
              payout2: 'after order completion.',
            ),
            SizedBox(height: isWeb ? 100 : 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    String title,
    String body,
    bool isWeb, {
    bool isWithdraw = false,
    bool isPayouts = false,
    String? payout1,
    String? payout2,
    String? withdraw,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.borderColor, width: 1),
          ),
          elevation: 0,
          margin: EdgeInsets.zero,
          color: AppColors.backgroundWhite,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 16, 80, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.hind(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.textBlackGrey,
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: body,
                        style: GoogleFonts.hind(
                          fontSize: isWeb ? 14 : 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textBlackGrey,
                        ),
                      ),
                      if (isPayouts)
                        TextSpan(
                          text: payout1,
                          style: GoogleFonts.hind(
                            fontSize: isWeb ? 14 : 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlackGrey,
                          ),
                        ),
                      TextSpan(
                        text: payout2,
                        style: GoogleFonts.hind(
                          fontSize: isWeb ? 14 : 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textBlackGrey,
                        ),
                      ),
                      if (isWithdraw)
                        TextSpan(
                          text: withdraw,
                          style: GoogleFonts.notoSans(
                            fontSize: isWeb ? 14 : 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlackGrey,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showClearConfirmationDialog(
    BuildContext context,
    EditBankAccountViewModel notifier,
    String bankId,
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
                padding: EdgeInsets.only(right: isWeb ? 0 : 25),
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Are you sure you want to clear your details? This action cannot be undone.",
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w600,
                  fontSize: isWeb ? 20 : 14,
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    fontSize: isWeb ? 18 : 12,
                    height: isWeb ? 48 : 45,
                    fontWeight: FontWeight.w500,
                    buttonColor: AppColors.buttonLighterGreen,
                    textColor: AppColors.textBlackGrey,
                  ),
                  CustomButton(
                    text: 'Continue',
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      notifier.clearBankDetails(bankId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Bank details cleared.")),
                      );
                    },
                    fontSize: isWeb ? 18 : 12,
                    height: isWeb ? 48 : 45,
                    fontWeight: FontWeight.w500,
                    buttonColor: AppColors.accentRed,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
