import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/context_extensions.dart';
import '../../gen/assets.gen.dart';

class CustomDropdownField2<T> extends ConsumerStatefulWidget {
  final String label;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final void Function(T?)? onChanged;
  final ValueListenable<T?>? value;
  final VoidCallback? onTap;
  final double? iconHeight,
      iconWidth,
      sizeBoxHeight,
      hintFontSize,
      radius,
      itemsFontSize,
      labelFontSize;
  final String? hintText, validatorText;
  final Widget? prefixIcon;
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
  final double? dropdownFieldHeight;

  const CustomDropdownField2({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabelBuilder,
    this.onChanged,
    this.value,
    this.onTap,
    this.hintText,
    this.iconWidth,
    this.iconHeight,
    this.prefixIcon,
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
    this.dropdownFieldHeight,
  });

  @override
  ConsumerState<CustomDropdownField2<T>> createState() =>
      _CustomDropdownFieldState2<T>();
}

class _CustomDropdownFieldState2<T>
    extends ConsumerState<CustomDropdownField2<T>> {
  T? selectedItem;
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
            height: widget.dropdownFieldHeight,
            child: DropdownButtonFormField2<T>(
              isExpanded: true,
              valueListenable: widget.value,
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
                    (e) => DropdownItem<T>(
                      value: e,
                      child: Padding(
                        padding:
                            widget.padding ?? const EdgeInsets.only(top: 4.0),
                        child: Text(
                          widget.itemLabelBuilder(e),
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.hind(
                            fontWeight: FontWeight.w400,
                            color: widget.itemTextColor ?? AppColors.textBlack,
                            fontSize: widget.itemsFontSize ?? 14,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                final castVal = val;
                setState(() => selectedItem = castVal);
                widget.onChanged?.call(castVal);
              },
              validator: (val) {
                if (val == null) return 'Please select a value';
                if (val is String && val.isEmpty)
                  return 'Please select a value';
                return null;
              },
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
                      fontSize: context.isWeb ? 14 : 10,
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
