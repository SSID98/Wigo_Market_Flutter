import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../core/utils/context_extensions.dart';
import '../../gen/assets.gen.dart';
import 'custom_button.dart';

class UploadBox extends StatefulWidget {
  final String? fileName;
  final String hintText;
  final String label;
  final Color? labelTextColor;
  final FontWeight? labelFontWeight;
  final double? height, labelFontSize;
  final Widget? prefixIcon1;
  final Widget? prefixIcon2;
  final bool isNin;
  final Widget? richText;
  final bool isRichText;
  final Color? hintTextColor;
  final Function(PlatformFile file)? onFileSelected;
  final double progress;
  final bool isUploading;
  final void Function()? onCancel;
  final void Function()? onRetry;
  final bool uploadFailed;
  final bool hasError;
  final String? errorMessage;
  final Widget? prefixIconError;

  const UploadBox({
    super.key,
    this.fileName,
    required this.label,
    this.labelTextColor,
    this.labelFontWeight,
    this.labelFontSize,
    this.height,
    this.hintText = '',
    this.hintTextColor,
    this.prefixIcon1,
    this.prefixIcon2,
    this.prefixIconError,
    this.isNin = false,
    this.richText,
    this.isRichText = false,
    this.onFileSelected,
    required this.progress,
    this.isUploading = false,
    this.onCancel,
    this.onRetry,
    this.uploadFailed = false,
    this.hasError = false,
    this.errorMessage,
  });

  @override
  State<UploadBox> createState() => _UploadBoxState();
}

class _UploadBoxState extends State<UploadBox> {
  String? fileName;
  String? errorText;

  @override
  void initState() {
    super.initState();
    fileName = widget.fileName;
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: context.isWeb,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;

      final maxSize = 5 * 1024 * 1024;

      if (file.size > maxSize) {
        setState(() {
          errorText = "File must be less than 5MB";
          fileName = null;
        });
        return;
      }

      setState(() {
        errorText = null;
        fileName = file.name;
      });

      widget.onFileSelected?.call(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isUploadSuccess =
        fileName != null &&
        errorText == null &&
        (widget.errorMessage == null || widget.hasError == false) &&
        !widget.hasError &&
        widget.progress >= 1.0 &&
        !widget.uploadFailed;

    final bool showErrorBorder =
        errorText != null ||
        (widget.hasError && fileName == null) ||
        widget.uploadFailed ||
        widget.errorMessage != null;

    final Color borderColor = isUploadSuccess
        ? AppColors.primaryDarkGreen
        : showErrorBorder
        ? AppColors.textRed
        : AppColors.textIconGrey;

    final Widget activeIcon;
    if (isUploadSuccess) {
      activeIcon = widget.prefixIcon2 ?? AppAssets.icons.uploaded.svg();
    } else if (widget.errorMessage != null ||
        widget.uploadFailed ||
        errorText != null ||
        widget.hasError) {
      activeIcon =
          widget.prefixIconError ??
          widget.prefixIcon1 ??
          AppAssets.icons.upload.svg(
            colorFilter: ColorFilter.mode(AppColors.accentRed, BlendMode.srcIn),
          );
    } else {
      activeIcon = widget.prefixIcon1 ?? AppAssets.icons.upload.svg();
    }

    return GestureDetector(
      onTap: _pickFile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isRichText && widget.richText != null
              ? widget.richText!
              : Text(
                  widget.label,
                  style: GoogleFonts.hind(
                    fontWeight: widget.labelFontWeight ?? FontWeight.w500,
                    fontSize: widget.labelFontSize ?? 16.0,
                    color: widget.labelTextColor ?? AppColors.textBlack,
                  ),
                ),
          const SizedBox(height: 5),
          DottedBorder(
            color: borderColor,
            strokeWidth: 1.5,
            borderType: BorderType.RRect,
            radius: Radius.circular(8.0),
            dashPattern: [6, 6],
            child: SizedBox(
              height: widget.height ?? 45,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: activeIcon,
                  ),
                  const SizedBox(width: 8),
                  if (fileName == null)
                    Text(
                      widget.hintText,
                      style: GoogleFonts.hind(
                        fontSize: context.isWeb ? 14 : 12,
                        fontWeight: FontWeight.w500,
                        color: widget.hintTextColor ?? AppColors.textBlackGrey,
                      ),
                    )
                  else
                    Flexible(
                      child: Text(
                        fileName!,
                        style: GoogleFonts.hind(
                          fontSize: context.isWeb ? 14 : 12,
                          fontWeight: FontWeight.w500,
                          color: widget.uploadFailed
                              ? AppColors.textRed
                              : AppColors.textBlackGrey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  if (context.isWeb && widget.isNin)
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: CustomButton(
                        text: 'Upload',
                        onPressed: _pickFile,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        prefixIcon: AppAssets.icons.cloud.svg(),
                        height: 30.0,
                        width: 84.0,
                        padding: EdgeInsets.zero,
                        borderRadius: 4,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (widget.isUploading) ...[
            Row(
              children: [
                const SizedBox(width: 6),
                Expanded(
                  // width: 20,
                  child: LinearProgressIndicator(
                    value: widget.progress,
                    color: AppColors.primaryDarkGreen,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "${(widget.progress * 100).toStringAsFixed(0)}%",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 6),
                IconButton(icon: Icon(Icons.close), onPressed: widget.onCancel),
              ],
            ),
          ],
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(Icons.error, color: AppColors.accentRed, size: 12),
                  SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.5),
                    child: Text(
                      errorText!,
                      style: GoogleFonts.hind(
                        color: AppColors.textRed,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.hasError &&
              widget.errorMessage != null &&
              errorText == null &&
              fileName == null)
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
          if (widget.uploadFailed) ...[
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Text(
                    "Upload failed. ",
                    style: GoogleFonts.hind(
                      color: AppColors.textRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onRetry,
                    child: Text(
                      "Tap to retry",
                      style: GoogleFonts.hind(
                        color: AppColors.textRed,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
