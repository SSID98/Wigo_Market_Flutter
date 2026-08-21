import 'package:flutter/material.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import '../../models/bank_model.dart';
import 'bank_search_sheet.dart';

Future<Bank?> showBankSearchModal(BuildContext context, List<Bank> banks) {
  return showModalBottomSheet<Bank>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.backgroundWhite,
    builder: (_) {
      return BankSearchSheet(banks: banks);
    },
  );
}
