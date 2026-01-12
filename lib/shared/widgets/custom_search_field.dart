import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../gen/assets.gen.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController? searchController;
  final String? hintText;
  final Widget? leading;
  final Iterable<Widget>? trailing;
  final Color? borderColor;
  final WidgetStateProperty<TextStyle?>? hintStyle;
  final double? height, padding;
  final Color? backgroundColor;
  final void Function(String)? onSubmitted;

  const CustomSearchField({
    super.key,
    this.searchController,
    this.hintText,
    this.leading,
    this.trailing,
    this.borderColor,
    this.hintStyle,
    this.height,
    this.backgroundColor,
    this.padding,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    return SizedBox(
      height: height ?? 40,
      child: SearchBar(
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        controller: searchController,
        leading:
            leading ??
            Padding(
              padding: EdgeInsets.only(left: padding ?? 20.0),
              child: AppAssets.icons.search.svg(),
            ),
        trailing: trailing,
        hintText: hintText,
        hintStyle:
            hintStyle ??
            WidgetStateProperty.all(
              GoogleFonts.hind(
                fontSize: isWeb ? 14 : 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textBlackGrey,
              ),
            ),
        // padding: WidgetStatePropertyAll(EdgeInsets.only(left: 20)),
        backgroundColor: WidgetStatePropertyAll(
          backgroundColor ?? AppColors.textFieldColor,
        ),
        elevation: const WidgetStatePropertyAll(0),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: BorderSide(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
