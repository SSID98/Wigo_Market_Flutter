import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/shared/widgets/contact_text_field.dart';
import 'package:wigo_flutter/shared/widgets/custom_button.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/widgets/custom_text_field.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    final contactSupportSection = _ContactSupportSection();
    final submitFormSection = const _SubmitFormSection();

    return Scaffold(
      backgroundColor:
          isWeb ? AppColors.backgroundLight : AppColors.backgroundWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child:
            isWeb
                ? Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          margin: EdgeInsets.only(bottom: 20, top: 20),
                          shadowColor: Colors.white70.withValues(alpha: 0.06),
                          color: AppColors.backgroundWhite,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: contactSupportSection,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Card(
                          margin: EdgeInsets.only(bottom: 150, top: 20),
                          shadowColor: Colors.white70.withValues(alpha: 0.06),
                          color: AppColors.backgroundWhite,
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: submitFormSection,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 75),
                      child: Row(
                        children: [
                          GestureDetector(
                            child: AppAssets.icons.arrowLeft.svg(),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "Back",
                            style: GoogleFonts.hind(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textBlackGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            contactSupportSection,
                            const SizedBox(height: 35),
                            submitFormSection,
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class _ContactSupportSection extends StatelessWidget {
  const _ContactSupportSection();

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact Support",
          style: GoogleFonts.hind(
            fontSize: isWeb ? 28 : 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Need Help? Contact Wigo market Support",
          style: GoogleFonts.hind(
            fontSize: isWeb ? 18 : 14,
            fontWeight: isWeb ? FontWeight.w500 : FontWeight.w400,
            color: AppColors.textBlackGrey,
          ),
        ),
        SizedBox(height: isWeb ? 20 : 30),
        Text(
          "Get in Touch",
          style: GoogleFonts.hind(
            fontSize: isWeb ? 28 : 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlackGrey,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Have questions or need assistance? We're here to help. Drop us a message or reach out through any of the channels below.",
          style: GoogleFonts.hind(
            fontSize: isWeb ? 18 : 14,
            fontWeight: isWeb ? FontWeight.w500 : FontWeight.w400,
            color: AppColors.textBlackGrey,
          ),
        ),
        GridView.builder(
          padding: EdgeInsets.only(top: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWeb ? 2 : 1,
            crossAxisSpacing: isWeb ? 13 : 0,
            mainAxisSpacing: 8,
            mainAxisExtent: 85,
          ),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return _buildListTile(
                  leading: AppAssets.icons.phoneContainer.svg(
                    height: isWeb ? 56 : 42,
                    width: isWeb ? 56 : 42,
                  ),
                  "Phone",
                  isWeb,
                  5,
                  subtitle: '(234)906342567',
                );
              case 1:
                return _buildListTile(
                  leading: AppAssets.icons.mailContainer.svg(
                    height: isWeb ? 56 : 42,
                    width: isWeb ? 56 : 42,
                  ),
                  "Email",
                  isWeb,
                  5,
                  subtitle: 'wigomarket@gmail.com',
                );
              case 2:
                return _buildListTile(
                  leading: AppAssets.icons.locationContainer.svg(
                    height: isWeb ? 56 : 42,
                    width: isWeb ? 56 : 42,
                  ),
                  "Location",
                  isWeb,
                  5,
                  subtitle: 'Benin Edo State',
                );
              case 3:
                return _buildListTile(
                  "Connect With Us",
                  isWeb,
                  0,
                  isConnect: true,
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}

Widget _buildListTile(
  String title,
  bool isWeb,
  double bottomPadding, {
  bool isConnect = false,
  Widget? leading,
  String? subtitle,
}) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 0),
    elevation: 0,
    color: AppColors.backgroundLight,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.69)),
    child: Center(
      child: ListTile(
        leading: leading,
        title: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Text(
            title,
            style: GoogleFonts.hind(
              fontSize: isWeb ? 20 : 16,
              fontWeight: isConnect ? FontWeight.w700 : FontWeight.w600,
              color:
                  isConnect
                      ? AppColors.textBlackGrey
                      : AppColors.textDarkerGreen,
            ),
          ),
        ),
        subtitle:
            subtitle != null
                ? Text(
                  subtitle,
                  style: GoogleFonts.hind(
                    fontSize: isWeb ? 16 : 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlackGrey,
                  ),
                )
                : isConnect
                ? Padding(
                  padding: EdgeInsets.only(right: 60.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppAssets.icons.greenFacebook.svg(
                        height: isWeb ? 50 : 34,
                        width: isWeb ? 50 : 34,
                      ),
                      AppAssets.icons.x.svg(
                        height: isWeb ? 50 : 34,
                        width: isWeb ? 50 : 34,
                      ),
                      AppAssets.icons.instagram.svg(
                        height: isWeb ? 50 : 34,
                        width: isWeb ? 50 : 34,
                      ),
                      AppAssets.icons.linkedin.svg(
                        height: isWeb ? 50 : 34,
                        width: isWeb ? 50 : 34,
                      ),
                      AppAssets.icons.youtube.svg(
                        height: isWeb ? 50 : 34,
                        width: isWeb ? 50 : 34,
                      ),
                    ],
                  ),
                )
                : null,
      ),
    ),
  );
}

class _SubmitFormSection extends StatelessWidget {
  const _SubmitFormSection();

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColors.backgroundLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Submit a support request via email and receive a response within 24 hours.",
              style: GoogleFonts.hind(
                fontSize: isWeb ? 20 : 16,
                fontWeight: isWeb ? FontWeight.w600 : FontWeight.w500,
                color: AppColors.textBlackGrey,
              ),
            ),
            SizedBox(height: 10),
            GridView.builder(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWeb ? 2 : 1,
                crossAxisSpacing: isWeb ? 13 : 0,
                mainAxisSpacing: 15,
                mainAxisExtent: isWeb ? 95 : 85,
              ),
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return CustomTextField(
                      fillColor: AppColors.backgroundWhite,
                      label: 'Email address',
                      hintText: 'Enter Email Address',
                      prefixIcon: AppAssets.icons.mail.path,
                      focusedBorderColor: AppColors.borderColor,
                      enabledBorderColor: AppColors.borderColor,
                    );
                  case 1:
                    return CustomPhoneNumberField(
                      label: 'Phone Number',
                      fillColor: AppColors.backgroundWhite,
                      borderColor: AppColors.borderColor,
                      contentPadding: EdgeInsets.only(bottom: isWeb ? 3.5 : 0),
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
            CustomTextField(
              label: 'Message',
              hintText: 'Type your Message',
              fillColor: AppColors.backgroundWhite,
              focusedBorderColor: AppColors.borderColor,
              enabledBorderColor: AppColors.borderColor,
              contentPadding: EdgeInsets.all(16),
              minLines: 6,
              maxLines: 8,
            ),
            const SizedBox(height: 50),
            CustomButton(
              text: 'Save',
              onPressed: () {},
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 45,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
