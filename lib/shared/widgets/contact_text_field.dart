import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';

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
  final Color? inputColor;

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
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.textFieldColor,
            borderRadius: BorderRadius.circular(10),
            border: BoxBorder.fromBorderSide(
              BorderSide(color: widget.borderColor),
            ),
          ),
          padding:
              widget.padding ??
              EdgeInsets.symmetric(horizontal: 17, vertical: 12),
          child: Row(
            children: [
              CountryCodePicker(
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
                      const Icon(Icons.keyboard_arrow_down, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        country.dialCode!,
                        style: GoogleFonts.hind(
                          fontSize: widget.dialCodeFontSize ?? 15.12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textBodyText,
                        ),
                      ),
                    ],
                  );
                },
              ),
              Expanded(
                child: TextFormField(
                  style: GoogleFonts.hind(
                    fontSize: widget.inputFontSize ?? 15.11,
                    fontWeight: widget.inputFontWeight ?? FontWeight.w400,
                    color: widget.inputColor ?? AppColors.textBodyText,
                  ),
                  controller: widget.controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    contentPadding:
                        widget.contentPadding ?? EdgeInsets.only(bottom: 0),
                    isCollapsed: true,
                    hintText: widget.hintText,
                    hintStyle: GoogleFonts.hind(
                      fontSize: widget.hintTextFontSize ?? 15.11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textBodyText,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
