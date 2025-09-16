import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../gen/assets.gen.dart';

class UploadBox extends StatefulWidget {
  final String? fileName;
  final String hintText;
  final String label;
  final Color? labelTextColor;
  final FontWeight? labelFontWeight;
  final double? height, labelFontSize;

  const UploadBox({
    super.key,
    this.fileName,
    required this.label,
    this.labelTextColor,
    this.labelFontWeight,
    this.labelFontSize,
    this.height,
    this.hintText = '',
  });

  @override
  State<UploadBox> createState() => _UploadBoxState();
}

class _UploadBoxState extends State<UploadBox> {
  String? fileName;

  @override
  void initState() {
    super.initState();
    fileName = widget.fileName;
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() => fileName = result.files.single.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickFile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: GoogleFonts.hind(
              fontWeight: widget.labelFontWeight ?? FontWeight.w500,
              fontSize: 16.0,
              color: widget.labelTextColor ?? AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 5),
          DottedBorder(
            color: AppColors.textIconGrey,
            strokeWidth: 1.0,
            borderType: BorderType.RRect,
            radius: Radius.circular(8.0),
            dashPattern: [6, 6],
            child: SizedBox(
              height: widget.height ?? 45,
              child: Row(
                children: [
                  if (fileName == null) ...[
                    Padding(
                      padding: EdgeInsets.only(left: 18.0),
                      child: AppAssets.icons.upload.svg(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.hintText,
                      style: GoogleFonts.hind(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textBlackGrey,
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: EdgeInsets.only(left: 18.0),
                      child: AppAssets.icons.uploaded.svg(),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        fileName!,
                        style: GoogleFonts.hind(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBlackGrey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
