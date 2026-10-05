import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import 'app_section_card.dart';

class BuyerNoteCard extends StatelessWidget {
  const BuyerNoteCard({super.key, required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final hasNote = note.trim().isNotEmpty;
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
            hasNote ? "● $note" : 'No note from the buyer.',
            style: GoogleFonts.openSans(
              color: AppColors.textBodyText,
              fontWeight: FontWeight.w400,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          if (hasNote) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () => _showFullNoteDialog(context, note),
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
        ],
      ),
    );
  }

  void _showFullNoteDialog(BuildContext context, String note) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.backgroundWhite,
          title: Text(
            'Buyer Note',
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColors.textVidaGreen800,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              note,
              style: GoogleFonts.openSans(
                color: AppColors.textBodyText,
                fontWeight: FontWeight.w400,
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Close',
                style: GoogleFonts.hind(color: AppColors.textBodyText),
              ),
            ),
          ],
        );
      },
    );
  }
}
