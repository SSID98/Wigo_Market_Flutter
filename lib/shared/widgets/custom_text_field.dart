import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';

class CustomTextField extends ConsumerStatefulWidget {
  final GlobalKey<FormFieldState<String>>? fieldKey;
  final String label;
  final String? hintText, prefixIcon, optionalPrefixIcon;
  final Widget? suffixIcon;
  final String? helperText;
  final bool isPassword;
  final double? iconHeight, iconWidth;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final Function()? onTap;
  final TextEditingController? controller;
  final Color? hintTextColor, labelTextColor;
  final double? hintFontSize, fontSize, labelFontSize;
  final String? Function(String?)? validator;
  final double? suffixIconPadding, prefixIconPadding;
  final Color? prefixIconColor, fillColor;
  final void Function(String)? onChanged;
  final void Function(bool)? onFocusChange;
  final bool hasError;
  final AutovalidateMode? autoValidateMode;
  final EdgeInsetsGeometry? contentPadding, prefixPadding;
  final FontWeight? labelFontWeight;
  final double? height, spacing;
  final int? maxLength;
  final Color? enabledBorderColor, focusedBorderColor;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? labelOnTap;
  final bool errorIcon;
  final int? maxLines, minLines;
  final String? errorMessage;
  final bool? enabled;
  final double? borderRadius;
  final Widget? labelRichText;
  final bool isRichText;
  final FontStyle? hintFontStyle;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.fieldKey,
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
    this.validator,
    this.suffixIconPadding,
    this.prefixIconColor,
    this.fillColor,
    this.onChanged,
    this.onFocusChange,
    this.prefixIconPadding,
    this.contentPadding,
    this.labelFontWeight,
    this.hasError = false,
    this.height,
    this.maxLength,
    this.labelFontSize,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.inputFormatters,
    this.prefixPadding,
    this.spacing,
    this.labelOnTap,
    this.errorIcon = true,
    this.errorMessage,
    this.autoValidateMode,
    this.maxLines,
    this.minLines,
    this.enabled,
    this.borderRadius,
    this.labelRichText,
    this.isRichText = false,
    this.hintFontStyle,
  });

  @override
  ConsumerState<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends ConsumerState<CustomTextField> {
  late bool _obscureText;

  ColorFilter? _resolvePrefixIconColor() {
    if (widget.hasError) {
      return const ColorFilter.mode(AppColors.accentRed, BlendMode.srcIn);
    }
    if (widget.prefixIconColor != null) {
      return ColorFilter.mode(widget.prefixIconColor!, BlendMode.srcIn);
    }
    return null; //
  }

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.labelOnTap,
          child:
              widget.isRichText
                  ? widget.labelRichText
                  : Text(
                    widget.label,
                    style: GoogleFonts.hind(
                      fontWeight: widget.labelFontWeight ?? FontWeight.w500,
                      fontSize: widget.labelFontSize ?? 16.0,
                      color: widget.labelTextColor ?? AppColors.textBlack,
                    ),
                  ),
        ),
        SizedBox(height: widget.spacing ?? 4),
        SizedBox(
          height: widget.height,
          child: Focus(
            onFocusChange: widget.onFocusChange,
            child: TextFormField(
              enabled: widget.enabled,
              validator: widget.validator,
              style: GoogleFonts.hind(
                fontWeight: FontWeight.w400,
                fontSize: widget.fontSize ?? 14.0,
                color: AppColors.textBlack,
              ),
              maxLines: widget.maxLines ?? 1,
              minLines: widget.minLines,
              cursorColor: AppColors.textBlackGrey,
              inputFormatters: widget.inputFormatters,
              key: widget.fieldKey,
              controller: widget.controller,
              onChanged: widget.onChanged,
              readOnly: widget.readOnly ?? false,
              onTap: widget.onTap,
              keyboardType: widget.keyboardType,
              autovalidateMode: widget.autoValidateMode,
              obscureText: _obscureText,
              obscuringCharacter: '•',
              maxLength: widget.maxLength,
              decoration: InputDecoration(
                contentPadding:
                    widget.contentPadding ?? EdgeInsets.symmetric(vertical: 15),
                prefixIconConstraints: BoxConstraints(),
                filled: true,
                constraints: BoxConstraints(),
                fillColor:
                    widget.hasError
                        ? AppColors.accentLightRed
                        : (widget.fillColor ?? AppColors.textFieldColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        widget.errorMessage != null
                            ? AppColors.accentRed
                            : (widget.enabledBorderColor ?? Colors.transparent),
                  ),
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 8.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        widget.errorMessage != null
                            ? AppColors.accentRed
                            : (widget.focusedBorderColor ?? Colors.transparent),
                  ),
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 8.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.accentRed,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? 8.0,
                  ),
                ),
                prefixIcon:
                    (widget.prefixIcon != null ||
                            widget.optionalPrefixIcon != null)
                        ? Padding(
                          padding:
                              widget.prefixPadding ??
                              EdgeInsets.only(
                                left: widget.prefixIconPadding ?? 17.0,
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
                                  colorFilter:
                                      widget.errorIcon
                                          ? _resolvePrefixIconColor()
                                          : null,
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
                  color: widget.hintTextColor ?? AppColors.textBodyText,
                  fontStyle: widget.hintFontStyle,
                ),
                helperText: widget.helperText,
                helperMaxLines: 2,
                helperStyle: GoogleFonts.hind(
                  fontWeight: FontWeight.w400,
                  fontSize: 15.12,
                  color: AppColors.textBlackGrey,
                ),
                suffixIcon:
                    widget.suffixIcon != null
                        ? Padding(
                          padding: EdgeInsets.only(
                            right: widget.suffixIconPadding ?? 25.0,
                          ),
                          child:
                              widget.isPassword
                                  ? IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppColors.textIconGrey,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  )
                                  : widget.suffixIcon,
                        )
                        : null,
              ),
            ),
          ),
        ),
        if (widget.hasError && widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Your custom error icon
                Icon(
                  Icons.error,
                  color: AppColors.accentRed,
                  size: isWeb ? 18 : 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.errorMessage!,
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w400,
                      fontSize: isWeb ? 14 : 10,
                      color: AppColors.accentRed,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class CustomDropdownField extends ConsumerStatefulWidget {
  final String label;
  final List<String> items;
  final double? iconHeight,
      iconWidth,
      sizeBoxHeight,
      hintFontSize,
      radius,
      itemsFontSize,
      labelFontSize;
  final String? hintText, validatorText;
  final Widget? prefixIcon;
  final void Function(String?)? onChanged;
  final String? value;
  final Color? hintTextColor,
      labelTextColor,
      fillColor,
      enabledBorderColor,
      focusedBorderColor,
      itemTextColor;
  final ColorFilter? iconColorFilter;
  final FontWeight? labelFontWeight, hintFontWeight;
  final EdgeInsetsGeometry? padding, menuItemPadding;
  final double? dropMenuWidth;

  const CustomDropdownField({
    super.key,
    this.label = '',
    required this.items,
    this.hintText,
    this.iconWidth,
    this.iconHeight,
    this.prefixIcon,
    this.onChanged,
    this.value,
    this.hintTextColor,
    this.labelTextColor,
    this.sizeBoxHeight,
    this.hintFontSize,
    this.fillColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.radius,
    this.itemsFontSize,
    this.itemTextColor,
    this.iconColorFilter,
    this.validatorText,
    this.labelFontSize,
    this.labelFontWeight,
    this.padding,
    this.dropMenuWidth,
    this.menuItemPadding,
    this.hintFontWeight,
  });

  @override
  ConsumerState<CustomDropdownField> createState() =>
      _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends ConsumerState<CustomDropdownField> {
  String? selectedItem;
  Widget? currentPrefixIcon;

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
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: GoogleFonts.hind(
              fontWeight: widget.labelFontWeight ?? FontWeight.w500,
              fontSize: widget.labelFontSize ?? 16.0,
              color: widget.labelTextColor ?? AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 4),
        ],
        SizedBox(
          height: widget.sizeBoxHeight,
          child: DropdownButtonFormField2<String>(
            isExpanded: true,
            value: widget.value,
            menuItemStyleData: MenuItemStyleData(
              padding:
                  widget.menuItemPadding ?? EdgeInsets.only(left: 13, right: 5),
            ),
            dropdownStyleData: DropdownStyleData(
              width: widget.dropMenuWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius ?? 8),
                color: AppColors.backgroundWhite,
              ),
              offset: const Offset(0, 0),
            ),
            buttonStyleData: ButtonStyleData(height: widget.sizeBoxHeight),
            iconStyleData: IconStyleData(
              icon: AppAssets.icons.arrowDown.svg(
                height: widget.iconHeight ?? 20,
                width: widget.iconWidth ?? 20,
                colorFilter: widget.iconColorFilter,
              ),
              iconSize: 0,
              openMenuIcon: AppAssets.icons.arrowDown.svg(
                height: widget.iconHeight ?? 20,
                width: widget.iconWidth ?? 20,
                colorFilter: widget.iconColorFilter,
              ),
            ),
            hint: Text(
              widget.hintText ?? '',
              style: GoogleFonts.hind(
                fontWeight: widget.hintFontWeight ?? FontWeight.w400,
                color: widget.hintTextColor ?? AppColors.textIconGrey,
                fontSize: widget.hintFontSize ?? 14,
              ),
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(right: 10),
              prefixIconConstraints: const BoxConstraints(),
              prefixIcon:
                  currentPrefixIcon != null
                      ? Padding(
                        padding: const EdgeInsets.only(left: 17.0),
                        child: currentPrefixIcon!,
                      )
                      : null,
              fillColor: widget.fillColor ?? AppColors.textFieldColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.enabledBorderColor ?? Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(widget.radius ?? 8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.focusedBorderColor ?? Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(widget.radius ?? 8.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.accentRed),
                borderRadius: BorderRadius.circular(widget.radius ?? 8.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.accentRed),
                borderRadius: BorderRadius.circular(widget.radius ?? 8.0),
              ),
            ),
            items:
                widget.items
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Padding(
                          padding:
                              widget.padding ?? const EdgeInsets.only(top: 4.0),
                          child: Text(
                            e,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.hind(
                              fontWeight: FontWeight.w400,
                              color:
                                  widget.itemTextColor ?? AppColors.textBlack,
                              fontSize: widget.itemsFontSize ?? 14,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
            onChanged: (val) {
              setState(() {
                selectedItem = val;
                if (val == 'Bike') {
                  currentPrefixIcon = AppAssets.icons.motorbike.svg();
                } else if (val == 'Car') {
                  currentPrefixIcon = AppAssets.icons.car.svg();
                } else if (val == 'Feet') {
                  currentPrefixIcon = AppAssets.icons.foot.svg();
                } else if (val == 'Bus') {
                  currentPrefixIcon = AppAssets.icons.bus.svg();
                } else if (val == 'Bicycle') {
                  currentPrefixIcon = AppAssets.icons.bicycle.svg();
                } else {
                  currentPrefixIcon = widget.prefixIcon;
                }
              });
              widget.onChanged?.call(val);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return widget.validatorText;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
