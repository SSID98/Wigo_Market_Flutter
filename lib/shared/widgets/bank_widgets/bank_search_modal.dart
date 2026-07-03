import 'package:flutter/material.dart';

import '../../models/bank_model.dart';
import 'bank_search_sheet.dart';

Future<Bank?> showBankSearchModal(BuildContext context, List<Bank> banks) {
  return showModalBottomSheet<Bank>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) {
      return BankSearchSheet(banks: banks);
    },
  );
}
