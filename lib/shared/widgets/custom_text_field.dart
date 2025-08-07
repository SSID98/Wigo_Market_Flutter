import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

class CustomTextField extends ConsumerStatefulWidget {
  final String label;
  final String? hintText;
  final String? prefixIcon;
  final String? optionalPrefixIcon;
  final Widget? suffixIcon;
  final String? helperText;
  final bool isPassword;
  final double? iconHeight, iconWidth;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final Function()? onTap;
  final TextEditingController? controller;
  final Color? hintTextColor, labelTextColor;
  final double? hintFontSize;
  final double? fontSize;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.isPassword = false,
    this.helperText,
    this.iconHeight,
    this.iconWidth,
    this.prefixIcon,
    this.optionalPrefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.readOnly,
    this.onTap,
    this.controller,
    this.hintTextColor,
    this.hintFontSize,
    this.fontSize,
    this.labelTextColor,
  });

  @override
  ConsumerState<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends ConsumerState<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: widget.labelTextColor ?? AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w400,
            fontSize: widget.fontSize ?? 14.0,
            color: AppColors.textBlack,
          ),
          cursorColor: AppColors.textBlackLight,
          controller: widget.controller,
          readOnly: widget.readOnly ?? false,
          onTap: widget.onTap,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          obscuringCharacter: '•',
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            prefixIconConstraints: BoxConstraints(),
            filled: true,
            fillColor: AppColors.textFieldColor,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.accentOrange, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            prefixIcon:
                (widget.prefixIcon != null || widget.optionalPrefixIcon != null)
                    ? Padding(
                      padding: const EdgeInsets.only(
                        left: 17.0,
                        right: 3.0,
                        bottom: 1.9,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.prefixIcon != null)
                            SvgPicture.asset(
                              widget.prefixIcon!,
                              height: widget.iconHeight,
                              width: widget.iconWidth,
                            ),
                          if (widget.optionalPrefixIcon != null)
                            SvgPicture.asset(
                              widget.optionalPrefixIcon!,
                              height: widget.iconHeight,
                              width: widget.iconWidth,
                            ),
                        ],
                      ),
                    )
                    : null,
            hintText: widget.hintText,
            hintStyle: GoogleFonts.hind(
              fontWeight: FontWeight.w400,
              fontSize: widget.hintFontSize ?? 14.0,
              color: widget.hintTextColor ?? AppColors.textBlackLight,
            ),
            helperText: widget.helperText,
            helperMaxLines: 2,
            helperStyle: GoogleFonts.hind(
              fontWeight: FontWeight.w400,
              fontSize: 15.12,
              color: AppColors.textBlackLight,
            ),
            suffixIcon:
                widget.suffixIcon != null
                    ? Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      // Check if it's a password field to decide which icon to show
                      child:
                          widget.isPassword
                              ? IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.textIconGrey,
                                  size: 22,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              )
                              : widget
                                  .suffixIcon, // Show the user-provided icon
                    )
                    : null, // If suffixIcon is null, show nothing
          ),
        ),
      ],
    );
  }
}

class CustomDropdownField extends ConsumerStatefulWidget {
  final String label;
  final List<String> items;
  final double iconSize;
  final String? hintText;
  final String? prefixIcon;
  final double? iconHeight, iconWidth;
  final void Function(String?)? onChanged;
  final String? value;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.hintText,
    required this.iconSize,
    this.prefixIcon,
    this.iconHeight,
    this.iconWidth,
    this.onChanged,
    this.value,
  });

  @override
  ConsumerState<CustomDropdownField> createState() =>
      _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends ConsumerState<CustomDropdownField> {
  String? selectedItem;
  String? currentPrefixIcon;

  @override
  void initState() {
    super.initState();
    currentPrefixIcon = widget.prefixIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.hind(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: AppColors.textBlackLight,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: widget.value,
          icon: Icon(Icons.keyboard_arrow_down_rounded, size: widget.iconSize),
          hint: Text(
            widget.hintText ?? '',
            style: GoogleFonts.hind(
              fontWeight: FontWeight.w400,
              color: AppColors.textIconGrey,
              fontSize: 14,
            ),
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 17),
            prefixIconConstraints: BoxConstraints(),
            prefixIcon:
                currentPrefixIcon != null
                    ? Padding(
                      padding: const EdgeInsets.only(left: 17.0, right: 3.0),
                      child: SvgPicture.asset(
                        currentPrefixIcon!,
                        height: widget.iconHeight,
                        width: widget.iconWidth,
                      ),
                    )
                    : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            fillColor: AppColors.textFieldColor,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0),
              // Green border when enabled
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              // Blue border when focused
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          items:
              widget.items
                  .map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          e,
                          style: GoogleFonts.hind(
                            fontWeight: FontWeight.w400,
                            color: AppColors.textBlack,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (val) {
            setState(() {
              selectedItem = val;
              if (val == 'Motor Bike') {
                currentPrefixIcon = 'assets/icons/motorbike.svg';
              } else if (val == 'Four Wheel') {
                currentPrefixIcon = 'assets/icons/car.svg';
              }
            });
            widget.onChanged?.call(val);
          },
        ),
      ],
    );
  }
}
