import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../gen/assets.gen.dart';
import '../../models/bank_details.dart';
import '../../models/wallet_state.dart';

class BankDetailsTile extends StatelessWidget {
  const BankDetailsTile({
    super.key,
    required this.bank,
    required this.isWeb,
    required this.showDelete,
    required this.onEdit,
    this.onClear,
  });

  final BankDetails bank;
  final bool isWeb;
  final bool showDelete;
  final VoidCallback onEdit;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final config =
        bankTileConfig[bank.id] ??
        (color: AppColors.backgroundLight, icon: Icon(Icons.help_outline));

    String maskedAccountNumber(String number) {
      if (number.isEmpty) return number;

      // Show first 3 digits, mask middle, show last 4
      if (number.length <= 7) return number; // not enough digits to mask safely

      final start = number.substring(0, 3); // first 3
      final end = number.substring(number.length - 4); // last 4
      final mask = '*' * (number.length - (start.length + end.length));

      return '$start$mask$end';
    }

    final titleText =
        bank.isEmpty
            ? bank
                .bankName // "Click to Add Bank Account"
            : bank.bankName;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 0,
              color: config.color,
              child: ListTile(
                leading: config.icon,
                title: Row(
                  children: [
                    Text(
                      titleText,
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: isWeb ? 22 : 16,
                        color:
                            bank.isEmpty
                                ? AppColors.textBodyText
                                : AppColors.textBlackGrey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (bank.isDefault)
                      AppAssets.icons.defaultContainer.svg(
                        height: isWeb ? 23 : 17,
                        width: isWeb ? 82 : 54,
                      ),
                  ],
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: isWeb ? 0 : 5.0),
                  child: Text(
                    'Account Number: ${maskedAccountNumber(bank.accountNumber)}',
                    style: GoogleFonts.hind(
                      color:
                          bank.isEmpty
                              ? AppColors.textBodyText
                              : AppColors.textBlackGrey,
                      fontSize: isWeb ? 14 : 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                trailing: InkWell(
                  onTap: onEdit,
                  child: AppAssets.icons.edit.svg(
                    colorFilter: ColorFilter.mode(
                      AppColors.darkPurple,
                      BlendMode.srcIn,
                    ),
                    height: isWeb ? 24 : 18,
                    width: isWeb ? 24 : 18,
                  ),
                ),
              ),
            ),
          ),
          if (showDelete) const SizedBox(width: 20),
          if (showDelete)
            InkWell(
              onTap: onClear,
              child: AppAssets.icons.recycle.svg(
                height: !isWeb ? 30 : 48,
                width: !isWeb ? 30 : 48,
              ),
            ),
        ],
      ),
    );
  }
}
