import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../gen/assets.gen.dart';

class CustomPhoneNumberField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final String label;
  final double? height;
  final double? labelFontSize,
      inputFontSize,
      hintTextFontSize,
      dialCodeFontSize;
  final Color borderColor;
  final FontWeight? labelFontWeight, inputFontWeight;
  final EdgeInsetsGeometry? padding, contentPadding;
  final Color? inputColor, fillColor;
  final void Function(String)? onChanged;
  final bool isOtherDesign;
  final Color? hintTextColor;

  const CustomPhoneNumberField({
    super.key,
    this.controller,
    this.height,
    this.hintText = '8080982606',
    required this.label,
    this.labelFontWeight,
    this.labelFontSize,
    this.padding,
    this.contentPadding,
    this.inputColor,
    this.inputFontSize,
    this.inputFontWeight,
    this.borderColor = Colors.transparent,
    this.hintTextFontSize,
    this.dialCodeFontSize,
    this.fillColor,
    this.onChanged,
    this.isOtherDesign = false,
    this.hintTextColor,
  });

  @override
  State<CustomPhoneNumberField> createState() => _CustomPhoneNumberFieldState();
}

class _CustomPhoneNumberFieldState extends State<CustomPhoneNumberField> {
  CountryCode _selectedCountryCode = CountryCode(
    code: 'NG',
    dialCode: '+234',
    flagUri: 'assets/icons/nigeria.svg',
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.hind(
            fontWeight: widget.labelFontWeight ?? FontWeight.w500,
            fontSize: widget.labelFontSize ?? 16.0,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: 4),
        !widget.isOtherDesign
            ? Container(
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.fillColor ?? AppColors.textFieldColor,
                borderRadius: BorderRadius.circular(10),
                border: BoxBorder.fromBorderSide(
                  BorderSide(color: widget.borderColor),
                ),
              ),
              padding:
                  widget.padding ??
                  EdgeInsets.symmetric(horizontal: 17, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _countryCodePicker1(),
                  Expanded(child: _buildInputField()),
                ],
              ),
            )
            : Row(
              children: [
                Container(
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: widget.fillColor ?? AppColors.textFieldColor,
                    borderRadius: BorderRadius.circular(4),
                    border: BoxBorder.fromBorderSide(
                      BorderSide(color: widget.borderColor),
                    ),
                  ),
                  padding:
                      widget.padding ?? EdgeInsets.symmetric(horizontal: 12),
                  child: _countryCodePicker2(),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: widget.fillColor ?? AppColors.textFieldColor,
                      borderRadius: BorderRadius.circular(4),
                      border: BoxBorder.fromBorderSide(
                        BorderSide(color: widget.borderColor),
                      ),
                    ),
                    padding:
                        widget.padding ??
                        EdgeInsets.symmetric(horizontal: 17, vertical: 12),
                    child: _buildInputField(),
                  ),
                ),
              ],
            ),
      ],
    );
  }

  Widget _countryCodePicker1() {
    return CountryCodePicker(
      onChanged: (country) {
        setState(() {
          _selectedCountryCode = country;
        });
      },
      initialSelection: _selectedCountryCode.code,
      favorite: ['+234', 'NG'],
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
      builder: (country) {
        return Row(
          children: [
            SizedBox(
              width: 29,
              height: 22,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  country!.flagUri!,
                  package: 'country_code_picker',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(width: 5),
            AppAssets.icons.arrowDown.svg(height: 22, width: 22),
            const SizedBox(width: 6),
            Text(
              country.dialCode!,
              style: GoogleFonts.hind(
                fontSize: widget.dialCodeFontSize ?? 15.12,
                fontWeight: FontWeight.w400,
                color: AppColors.textBlackGrey,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _countryCodePicker2() {
    return CountryCodePicker(
      onChanged: (country) {
        setState(() {
          _selectedCountryCode = country;
        });
      },
      initialSelection: _selectedCountryCode.code,
      favorite: ['+234', 'NG'],
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
      builder: (country) {
        final dialCode = country!.dialCode!;
        final code = dialCode.substring(1);
        return Row(
          children: [
            const SizedBox(width: 8),
            Icon(CupertinoIcons.plus, size: 22, color: AppColors.textIconGrey),
            Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 11),
              child: Text(
                code,
                style: GoogleFonts.hind(
                  fontSize: widget.dialCodeFontSize ?? 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textIconGrey,
                ),
              ),
            ),
            const SizedBox(width: 6),
            AppAssets.icons.arrowDown.svg(
              height: 22,
              width: 22,
              colorFilter: ColorFilter.mode(
                AppColors.textIconGrey,
                BlendMode.srcIn,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputField() {
    return TextFormField(
      style: GoogleFonts.hind(
        fontSize: widget.inputFontSize ?? 15.11,
        fontWeight: widget.inputFontWeight ?? FontWeight.w400,
        color: widget.inputColor ?? AppColors.textBlackGrey,
      ),
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType: TextInputType.phone,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        isDense: true,
        constraints: BoxConstraints(),
        contentPadding: widget.contentPadding ?? EdgeInsets.zero,
        hintText: widget.hintText,
        hintStyle: GoogleFonts.hind(
          fontSize: widget.hintTextFontSize ?? 15.11,
          fontWeight: FontWeight.w400,
          color: widget.hintTextColor ?? AppColors.textBodyText,
        ),
        border: InputBorder.none,
      ),
    );
  }
}
