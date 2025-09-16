import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

class CustomAvatar extends StatelessWidget {
  final double? radius;
  final double padding;
  final TextStyle? profileNameStyle, profileEmailStyle;
  final bool showEmail, showBottomText, showLeftTexts;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const CustomAvatar({
    super.key,
    this.radius,
    this.profileNameStyle,
    this.profileEmailStyle,
    this.padding = 0.0,
    this.showEmail = true,
    this.showBottomText = false,
    this.showLeftTexts = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {},
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: radius ?? 20.0,
                backgroundImage: NetworkImage(
                  'https://github.com/user-attachments/assets/93e38020-8447-4f79-a623-cfea02d6bd4b',
                ),
              ),
              const SizedBox(width: 10.0),
              if (showLeftTexts) ...[
                Column(
                  mainAxisAlignment: mainAxisAlignment,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${"Rider Name"} ${""}",
                      style:
                          profileNameStyle ??
                          GoogleFonts.hind(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 16.94 / 14,
                            color: AppColors.textBlackGrey,
                          ),
                    ),
                    if (showEmail) ...[
                      const SizedBox(height: 3.0),
                      Text(
                        "Rider",
                        style:
                            profileEmailStyle ??
                            GoogleFonts.hind(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 14.52 / 12,
                              color: AppColors.textBlackGrey,
                            ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
          if (showBottomText) ...[
            const SizedBox(height: 3.0),
            Text(
              "Upload Photo",
              style: GoogleFonts.hind(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 14.52 / 12,
                color: AppColors.primaryDarkGreen,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // String initials([UserModel? user]) {
  //   try {
  //     var initials = 'AN';
  //     if (user == null) return initials;
  //     if (user.fullname.isEmpty) return initials;
  //
  //     final u = user.fullname.split(' ');
  //     if (u.length == 1) return u.first;
  //     return '${u[0][0]}${u[1][0]}';
  //   } catch (e) {
  //     return 'AN';
  //   }
  // }
}
