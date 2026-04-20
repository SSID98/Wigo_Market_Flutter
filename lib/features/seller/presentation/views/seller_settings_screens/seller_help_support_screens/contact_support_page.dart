import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import '../../../../../../core/utils/context_extensions.dart';
import '../../../../../../shared/screens/support_screen.dart';

class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Contact Support",
            style: GoogleFonts.hind(
              fontSize: context.isWeb ? 28 : 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Need Help? Contact Wigo market Support",
            style: GoogleFonts.hind(
              fontSize: context.isWeb ? 18 : 14,
              fontWeight: context.isWeb ? FontWeight.w500 : FontWeight.w400,
              color: AppColors.textBlackGrey,
            ),
          ),
          const SizedBox(height: 15),
          Card(
            color: AppColors.backgroundWhite,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: BorderSide(color: AppColors.borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ContactSupportSection(connectPadding: 10),
                  const SizedBox(height: 15),
                  Divider(),
                  const SizedBox(height: 15),
                  SubmitFormSection(),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
