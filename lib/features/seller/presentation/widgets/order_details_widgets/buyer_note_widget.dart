import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import 'app_section_card.dart';

class BuyerNoteCard extends StatelessWidget {
  const BuyerNoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Buyer Note",
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColors.textVidaGreen800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "● Please deliver before my 1 PM class",
            style: GoogleFonts.openSans(
              color: AppColors.textBodyText,
              fontWeight: FontWeight.w400,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                // showDialog(
                //   context: context,
                //   builder: (_) => const _BuyerNoteDialog(),
                // );
              },
              child: Text(
                "View all",
                style: GoogleFonts.hind(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.backgroundPeach,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.backgroundPeach,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
