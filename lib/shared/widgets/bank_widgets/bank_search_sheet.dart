import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/shared/widgets/custom_search_field.dart';

import '../../models/bank_model.dart';

class BankSearchSheet extends StatefulWidget {
  final List<Bank> banks;

  const BankSearchSheet({super.key, required this.banks});

  @override
  State<BankSearchSheet> createState() => BankSearchSheetState();
}

class BankSearchSheetState extends State<BankSearchSheet> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final filteredBanks =
        widget.banks
            .where((b) => b.name.toLowerCase().contains(query.toLowerCase()))
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomSearchField(
                hintText: 'Search bank...',
                height: 50,
                backgroundColor: Colors.transparent,
                borderColor: AppColors.borderColor1,
                hintStyle: WidgetStateProperty.all(
                  GoogleFonts.hind(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textBlackGrey,
                  ),
                ),

                onChanged: (val) {
                  setState(() => query = val);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredBanks.length,
                itemBuilder: (_, index) {
                  final bank = filteredBanks[index];

                  return ListTile(
                    title: Text(
                      bank.name,
                      style: GoogleFonts.hind(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context, bank);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
