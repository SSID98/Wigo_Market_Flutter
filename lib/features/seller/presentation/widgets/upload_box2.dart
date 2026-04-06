import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wigo_flutter/core/constants/app_colors.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../models/upload_file_model.dart';

enum UploadType { image, video }

class UploadBox2 extends ConsumerWidget {
  final UploadFile? file;
  final VoidCallback onPick;
  final VoidCallback? onRemove;
  final UploadType type;
  final double? height, width;
  final bool isMainProduct;
  final double? iconHeight, iconWidth, fontSize;

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
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWeb = MediaQuery.of(context).size.width > 800;
    return Column(
      children: [
        GestureDetector(
          onTap: onPick,
          child: DottedBorder(
            color:
                file?.error != null
                    ? AppColors.accentRed
                    : file != null
                    ? AppColors.primaryDarkGreen
                    : AppColors.textIconGrey,
            borderType: BorderType.RRect,
            radius: const Radius.circular(4),
            dashPattern: [8, 8],
            child: SizedBox(
              height: height ?? 120,
              width: width ?? 120,
              child:
                  file == null || file?.error != null
                      ? _empty(isWeb)
                      : _preview(isWeb),
            ),
          ),
        ),
        if (file?.error != null) ...[
          const SizedBox(height: 10),
          Flexible(
            child: Text(
              file!.error!,
              style: GoogleFonts.hind(
                color: AppColors.textRed,
                fontSize: isWeb ? 16 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _empty(bool isWeb) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
        if (isWeb)
          RichText(
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
        else
          Text(
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
              fontSize: fontSize ?? 18,
              color: AppColors.textIconGrey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    ),
  );

  Widget _preview(bool isWeb) {
    return Stack(
      children: [
        Positioned.fill(
          child:
              file?.preview != null
                  ? Image.memory(file!.preview!, fit: BoxFit.cover)
                  : const SizedBox(),
        ),
        isWeb
            ? Center(
              child: Column(
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
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
