import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../models/upload_file_model.dart';
import '../../viewmodels/upload_file_viewmodel.dart';

enum UploadType { image, video }

class UploadBox2 extends ConsumerWidget {
  final UploadFile? file;
  final VoidCallback onPick;
  final VoidCallback? onRemove;
  final UploadType type;
  final double? height, width;
  final bool isMainProduct;
  final double? iconHeight, iconWidth, fontSize;
  final String? uploadId;
  final int? uploadIndex;

  const UploadBox2({
    super.key,
    required this.file,
    required this.onPick,
    this.onRemove,
    this.width,
    this.height,
    this.iconHeight,
    this.iconWidth,
    this.fontSize,
    required this.type,
    this.isMainProduct = false,
    this.uploadId,
    this.uploadIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    final hasError = file?.error != null;
    final uploadFailed = file?.uploadFailed == true && !hasError;
    final isComplete = file?.isUploadComplete == true;

    final Color borderColor = hasError || uploadFailed
        ? AppColors.accentRed
        : isComplete
        ? AppColors.primaryDarkGreen
        : AppColors.textIconGrey;

    return Column(
      children: [
        GestureDetector(
          onTap: file?.isUploading == true ? null : onPick,
          child: DottedBorder(
            color: borderColor,
            borderType: BorderType.RRect,
            radius: const Radius.circular(4),
            dashPattern: [8, 8],
            child: SizedBox(
              height: height ?? 120,
              width: width ?? 120,
              child: file == null || hasError
                  ? _buildEmpty(isWeb)
                  : _buildPreview(isWeb, ref),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          _buildErrorRow(file!.error!, isWeb),
        ],
      ],
    );
  }

  Widget _buildErrorRow(String message, bool isWeb) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(Icons.error, color: AppColors.accentRed, size: isWeb ? 16 : 14),
      const SizedBox(width: 4),
      Flexible(
        child: Text(
          message,
          style: GoogleFonts.hind(
            color: AppColors.textRed,
            fontSize: isWeb ? 14 : 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );

  Widget _buildEmpty(bool isWeb) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        type == UploadType.image
            ? AppAssets.icons.uploadProductImage.svg(
                height: iconHeight,
                width: iconWidth,
              )
            : AppAssets.icons.uploadProductVideo.svg(
                height: iconHeight,
                width: iconWidth,
              ),
        const SizedBox(height: 10),
        isWeb
            ? RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Click to upload",
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize ?? 18,
                        color: AppColors.textVidaLocaGreen,
                      ),
                    ),
                    TextSpan(
                      text: " or Drag and Drop",
                      style: GoogleFonts.hind(
                        fontWeight: FontWeight.w500,
                        fontSize: fontSize ?? 18,
                        color: AppColors.textBodyText,
                      ),
                    ),
                  ],
                ),
              )
            : Text(
                "Click to upload",
                style: GoogleFonts.hind(
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize ?? 18,
                  color: AppColors.textVidaLocaGreen,
                ),
              ),
        if (isMainProduct) ...[
          const SizedBox(height: 10),
          Text(
            "(main product image)",
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.w600,
              fontSize: fontSize ?? 16,
              color: AppColors.textIconGrey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    ),
  );

  Widget _buildPreview(bool isWeb, WidgetRef ref) {
    final hasError = file?.error != null;
    final uploadFailed = file?.uploadFailed == true && !hasError;
    final isUploading = file?.isUploading == true;
    final progress = file?.uploadProgress ?? 0.0;
    final isComplete = file?.isUploadComplete == true;
    final hasPreview = file?.preview != null;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (hasPreview && !uploadFailed)
          Image.memory(file!.preview!, fit: BoxFit.cover)
        else
          Container(
            color: AppColors.backgroundLight,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    uploadFailed
                        ? 'Upload Failed, Please retry'
                        : file?.file.name ?? '',
                    style: GoogleFonts.hind(
                      fontSize: 14,
                      color: uploadFailed
                          ? AppColors.textRed
                          : AppColors.textBodyText,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  if (uploadFailed) ...[
                    const SizedBox(height: 6),
                    CustomButton(
                      text: "Tap to retry",
                      fontSize: 12,
                      buttonColor: Colors.transparent,
                      borderColor: AppColors.accentRed,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.textRed,
                      borderRadius: 6,
                      borderWidth: 1.5,
                      height: 20,
                      onPressed: onPick,
                    ),
                  ],
                ],
              ),
            ),
          ),

        if (isUploading)
          Container(
            color: hasPreview
                ? Colors.black.withValues(alpha: 0.45)
                : Colors.black.withValues(alpha: 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitDualRing(
                  color: AppColors.primaryDarkGreen,
                  size: 34,
                  lineWidth: 3,
                ),
                const SizedBox(height: 8),
                Text(
                  "${(progress * 100).toStringAsFixed(0)}%",
                  style: GoogleFonts.hind(
                    color: hasPreview ? Colors.white : AppColors.textBlackGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (uploadId != null && uploadIndex != null) ...[
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => ref
                        .read(uploadProvider(uploadId!).notifier)
                        .cancelUpload(uploadIndex!),
                    child: Icon(
                      Icons.cancel_rounded,
                      color: hasPreview
                          ? Colors.white70
                          : AppColors.textIconGrey,
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          ),
        if (isComplete && !isUploading)
          isWeb
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        text: 'Replace',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        onPressed: onPick,
                        height: 48,
                        prefixIcon: AppAssets.icons.reuploadImage.svg(),
                      ),
                      CustomButton(
                        text: 'Delete',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        onPressed: onRemove,
                        height: 48,
                        buttonColor: AppColors.accentRed,
                        prefixIcon: AppAssets.icons.delete.svg(),
                      ),
                    ],
                  ),
                )
              : Positioned(
                  top: 16,
                  right: 10,
                  child: Container(
                    width: 96,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.tableHeader,
                      border: Border.all(color: AppColors.primaryDarkGreen),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: onPick,
                            child: AppAssets.icons.reuploadImage.svg(),
                          ),
                          GestureDetector(
                            onTap: onRemove,
                            child: AppAssets.icons.delete.svg(height: 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      ],
    );
  }
}
