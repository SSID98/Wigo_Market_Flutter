import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/features/rider/viewmodels/edit_bank_account_viewmodel.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_text_field.dart';
import '../../../models/bank_details.dart';
import '../../../models/wallet_state.dart';
import '../../widgets/bank_details_tile.dart';

class WalletWithdrawalScreen extends ConsumerWidget {
  const WalletWithdrawalScreen({super.key, required this.isWeb});

  final bool isWeb;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(editBankAccountProvider.notifier);
    final defaultBank =
        ref.watch(editBankAccountProvider.notifier).getDefaultBankAccount();

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isWeb ? 40 : 15.0,
            isWeb ? 20 : 20,
            isWeb ? 300 : 15.0,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: notifier.navigateToOverview,
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
                        labelFontWeight: FontWeight.w600,
                        hintText: 'Enter Amount',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (v) {},
                        spacing: 15,
                        height: isWeb ? 52 : 40,
                        prefixPadding: EdgeInsets.only(
                          left: 17.0,
                          right: 3.0,
                          bottom: 4,
                        ),
                        contentPadding: EdgeInsets.only(left: 10),
                        focusedBorderColor: AppColors.borderColor,
                        enabledBorderColor: AppColors.borderColor,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Min. ₦500.00",
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
                            onEdit: () {
                              // Navigate to Edit screen for the default bank
                              notifier.startEditBankAccount(defaultBank);
                            },
                          )
                          : BankDetailsTile(
                            bank: BankDetails.empty('1').copyWith(
                              bankName: 'No Default Account Set',
                              accountNumber: '**** ****',
                            ),
                            isWeb: isWeb,
                            showDelete: false,
                            onEdit: () {
                              notifier.setWalletScreenState(
                                WalletScreenState.addBankAccount,
                              );
                            },
                          ),
                      const SizedBox(height: 20),
                      CustomButton(
                        fontSize: isWeb ? 18 : 12,
                        fontWeight: FontWeight.w500,
                        text: 'Continue',
                        onPressed: () {
                          // TODO: Handle continue logic (PIN confirmation, etc.
                        },
                        width: double.infinity,
                        height: isWeb ? 60 : 45,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
