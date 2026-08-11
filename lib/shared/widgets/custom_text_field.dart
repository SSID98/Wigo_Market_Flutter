import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';
import 'package:wigo_flutter/gen/assets.gen.dart';

import '../../core/utils/context_extensions.dart';

class CustomTextField extends ConsumerStatefulWidget {
  final GlobalKey<FormFieldState<String>>? fieldKey;
  final String label;
  final String? hintText, prefixIcon, optionalPrefixIcon;
  final Widget? suffixIcon, prefixIcon2;
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
  final bool isRichText, autoFocus;
  final FontStyle? hintFontStyle;
  final InputBorder? border;
  final double clipRectBorderRadius;
  final BlendMode? blendMode;

  const CustomTextField({
    super.key,
    this.label = '',
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
    this.clipRectBorderRadius = 0,
    this.border,
    this.prefixIcon2,
    this.autoFocus = false,
    this.blendMode,
  });

  @override
  ConsumerState<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends ConsumerState<CustomTextField> {
  late bool _obscureText;

  ColorFilter? _resolvePrefixIconColor() {
    if (widget.hasError) {
      return ColorFilter.mode(
        AppColors.accentRed,
        widget.blendMode ?? BlendMode.srcIn,
      );
    }
    if (widget.prefixIconColor != null) {
      return ColorFilter.mode(
        widget.prefixIconColor!,
        widget.blendMode ?? BlendMode.srcIn,
      );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.labelOnTap,
          child: widget.isRichText && widget.label.isEmpty
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
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(
                widget.clipRectBorderRadius,
              ),
              child: TextFormField(
                autofocus: widget.autoFocus,
                enabled: widget.enabled,
                validator: widget.validator,
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w400,
                  fontSize: widget.fontSize ?? 14.0,
                  color: AppColors.textBlack,
                ),
                maxLines: widget.maxLines ?? 1,
                minLines: widget.minLines,
                // cursorColor: AppColors.textBlackGrey,
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
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? 8.0,
                    ),
                  ),
                  border: widget.border,
                  contentPadding:
                      widget.contentPadding ??
                      EdgeInsets.symmetric(vertical: 15),
                  prefixIconConstraints: BoxConstraints(),
                  filled: true,
                  constraints: BoxConstraints(),
                  fillColor: widget.hasError
                      ? AppColors.accentLightRed
                      : (widget.fillColor ?? AppColors.textFieldColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.errorMessage != null
                          ? AppColors.accentRed
                          : (widget.enabledBorderColor ?? Colors.transparent),
                    ),
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? 8.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.errorMessage != null
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
                          widget.optionalPrefixIcon != null ||
                          widget.prefixIcon2 != null)
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
                                  colorFilter: widget.errorIcon
                                      ? _resolvePrefixIconColor()
                                      : null,
                                ),
                              if (widget.optionalPrefixIcon != null)
                                SvgPicture.asset(
                                  widget.optionalPrefixIcon!,
                                  height: widget.iconHeight,
                                  width: widget.iconWidth,
                                ),
                              if (widget.prefixIcon2 != null)
                                widget.prefixIcon2!,
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
                  suffixIcon: widget.suffixIcon != null
                      ? Padding(
                          padding: EdgeInsets.only(
                            right: widget.suffixIconPadding ?? 25.0,
                          ),
                          child: widget.isPassword
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
        ),
        if (widget.hasError && widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error,
                  color: AppColors.accentRed,
                  size: context.isWeb ? 18 : 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.errorMessage!,
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w400,
                      fontSize: context.isWeb ? 14 : 11,
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
  final ValueListenable<String?>? value;
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
  final Widget? labelRichText;
  final bool isRichText;
  final bool hasError;
  final Color? prefixIconColor;
  final String? errorMessage;
  final ValueListenable<Iterable<String>>? multiValue;
  final VoidCallback? onTap;

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
    this.isRichText = false,
    this.labelRichText,
    this.hasError = false,
    this.prefixIconColor,
    this.errorMessage,
    this.onTap,
    this.multiValue,
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
    currentPrefixIcon = _resolveIconForValue(widget.value?.value);
    widget.value?.addListener(_onExternalValueChanged);
  }

  @override
  void didUpdateWidget(CustomDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      oldWidget.value?.removeListener(_onExternalValueChanged);
      widget.value?.addListener(_onExternalValueChanged);
      setState(() {
        currentPrefixIcon = _resolveIconForValue(widget.value?.value);
      });
    }
  }

  @override
  void dispose() {
    widget.value?.removeListener(_onExternalValueChanged);
    super.dispose();
  }

  void _onExternalValueChanged() {
    if (!mounted) return;
    setState(() {
      currentPrefixIcon = _resolveIconForValue(widget.value?.value);
    });
  }

  Widget? _resolveIconForValue(String? val) {
    if (val == null || val.isEmpty) return widget.prefixIcon;
    switch (val) {
      case 'Motor Bike':
      case 'Bike':
        return AppAssets.icons.motorbike.svg();
      case 'Car':
        return AppAssets.icons.car.svg();
      case 'Feet':
        return AppAssets.icons.foot.svg();
      case 'Bus':
        return AppAssets.icons.bus.svg();
      case 'Bicycle':
        return AppAssets.icons.bicycle.svg();
      default:
        return widget.prefixIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty || widget.labelRichText != null) ...[
          widget.isRichText
              ? widget.labelRichText!
              : Text(
                  widget.label,
                  style: GoogleFonts.hind(
                    fontWeight: widget.labelFontWeight ?? FontWeight.w500,
                    fontSize: widget.labelFontSize ?? 16.0,
                    color: widget.labelTextColor ?? AppColors.textBlack,
                  ),
                ),
          const SizedBox(height: 4),
        ],
        TapRegion(
          onTapInside: (v) {
            if (widget.onTap != null) {
              widget.onTap!();
            }
          },
          child: SizedBox(
            height: widget.sizeBoxHeight,
            child: IgnorePointer(
              ignoring: widget.onChanged == null,
              child: DropdownButtonFormField2<String>(
                isExpanded: true,
                valueListenable: widget.value,
                multiValueListenable: widget.multiValue,
                menuItemStyleData: MenuItemStyleData(
                  padding:
                      widget.menuItemPadding ??
                      EdgeInsets.only(left: 13, right: 5),
                ),
                dropdownStyleData: DropdownStyleData(
                  width: widget.dropMenuWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.radius ?? 8),
                    color: AppColors.backgroundWhite,
                  ),
                  offset: const Offset(0, 0),
                ),
                buttonStyleData: FormFieldButtonStyleData(
                  height: widget.sizeBoxHeight,
                ),
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
                  prefixIcon: currentPrefixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 17.0),
                          child: currentPrefixIcon!,
                        )
                      : null,
                  fillColor: widget.hasError
                      ? AppColors.accentLightRed
                      : (widget.fillColor ?? AppColors.textFieldColor),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.errorMessage != null
                          ? AppColors.accentRed
                          : (widget.enabledBorderColor ?? Colors.transparent),
                    ),
                    borderRadius: BorderRadius.circular(widget.radius ?? 8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.errorMessage != null
                          ? AppColors.accentRed
                          : (widget.focusedBorderColor ?? Colors.transparent),
                    ),
                    borderRadius: BorderRadius.circular(widget.radius ?? 8.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.accentRed,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(widget.radius ?? 8.0),
                  ),
                ),
                items: widget.items
                    .map(
                      (e) => DropdownItem<String>(
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
                    currentPrefixIcon = _resolveIconForValue(val);
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
          ),
        ),
        if (widget.hasError && widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error,
                  color: AppColors.accentRed,
                  size: context.isWeb ? 18 : 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.errorMessage!,
                    style: GoogleFonts.hind(
                      fontWeight: FontWeight.w400,
                      fontSize: context.isWeb ? 14 : 11,
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
