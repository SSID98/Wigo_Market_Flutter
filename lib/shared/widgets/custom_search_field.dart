import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController? searchController;
  final String? hintText;
  final Widget? leading;
  final Iterable<Widget>? trailing;
  final Color? borderColor;

  const CustomSearchField({
    super.key,
    this.searchController,
    this.hintText,
    this.leading,
    this.trailing,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: SearchBar(
        controller: searchController,
        leading: leading,
        trailing: trailing,
        hintText: hintText,
        // padding: WidgetStatePropertyAll(EdgeInsets.only(left: 20)),
        backgroundColor: const WidgetStatePropertyAll(AppColors.textFieldColor),
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
