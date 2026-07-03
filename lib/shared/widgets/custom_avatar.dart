import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/context_extensions.dart';

class CustomAvatar extends StatefulWidget {
  final double? radius;
  final EdgeInsetsGeometry avatarPadding;
  final Widget? bottomText;
  final TextStyle? profileNameStyle, profileEmailStyle;
  final bool showEmail, showBottomText, showLeftTexts, showCircleAvatar;
  final MainAxisAlignment mainAxisAlignment, avatarAlign;
  final CrossAxisAlignment crossAxisAlignment;
  final void Function()? onTap;
  final ImageProvider<Object>? backgroundImage;
  final Color borderColor;
  final String? profileName, profileEmail;
  final bool isEditMode;
  final Function(PlatformFile file)? onImageSelected;
  final bool isUploadingPhoto;
  final bool photoUploadFailed;
  final String? imageErrorMessage;

  const CustomAvatar({
    super.key,
    this.radius,
    this.borderColor = Colors.transparent,
    this.bottomText,
    this.profileNameStyle,
    this.profileEmailStyle,
    this.avatarPadding = EdgeInsetsGeometry.zero,
    this.showEmail = true,
    this.showBottomText = false,
    this.showLeftTexts = true,
    this.showCircleAvatar = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.avatarAlign = MainAxisAlignment.start,
    this.onTap,
    this.backgroundImage,
    this.profileEmail,
    this.profileName,
    this.isEditMode = false,
    this.onImageSelected,
    this.isUploadingPhoto = false,
    this.photoUploadFailed = false,
    this.imageErrorMessage,
  });

  @override
  State<CustomAvatar> createState() => _CustomAvatarState();
}

class _CustomAvatarState extends State<CustomAvatar> {
  String? _localErrorText;

  Future<void> _pickImage() async {
    if (!widget.isEditMode) {
      widget.onTap?.call();
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      withData: context.isWeb,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;
    const maxSizeBytes = 5 * 1024 * 1024;

    if (file.size > maxSizeBytes) {
      setState(() => _localErrorText = 'Image must be less than 5 MB');
      return;
    }

    setState(() => _localErrorText = null);
    widget.onImageSelected?.call(file);
  }

  @override
  Widget build(BuildContext context) {
    final double effectiveRadius = widget.radius ?? 20.0;

    final String? activeErrorText = _localErrorText ?? widget.imageErrorMessage;

    final bool hasAnyError =
        activeErrorText != null || widget.photoUploadFailed;

    final Color effectiveBorderColor = hasAnyError
        ? AppColors.textRed
        : widget.borderColor;

    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: widget.avatarAlign,
          children: [
            if (widget.showCircleAvatar)
              Padding(
                padding: widget.avatarPadding,
                child: GestureDetector(
                  onTap: widget.isEditMode ? _pickImage : widget.onTap,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: effectiveBorderColor,
                            width: hasAnyError ? 2.0 : 1.0,
                          ),
                        ),
                        child: widget.isUploadingPhoto
                            ? CircleAvatar(
                                radius: effectiveRadius,
                                backgroundColor: AppColors.backgroundLight,
                                child: SizedBox(
                                  width: effectiveRadius * 0.65,
                                  height: effectiveRadius * 0.65,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.primaryDarkGreen,
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: effectiveRadius,
                                backgroundImage:
                                    widget.backgroundImage ??
                                    const NetworkImage(
                                      'https://github.com/user-attachments/assets/93e38020-8447-4f79-a623-cfea02d6bd4b',
                                    ),
                              ),
                      ),

                      if (widget.isEditMode)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: hasAnyError
                                    ? AppColors.accentRed
                                    : AppColors.primaryDarkGreen,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.backgroundWhite,
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt_rounded,
                                size: effectiveRadius * 0.4,
                                color: AppColors.textWhite,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            const SizedBox(width: 10.0),

            if (widget.showLeftTexts) ...[
              Column(
                mainAxisAlignment: widget.mainAxisAlignment,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.profileName ?? 'Guest',
                    style:
                        widget.profileNameStyle ??
                        GoogleFonts.hind(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 16.94 / 14,
                          color: AppColors.textBlackGrey,
                        ),
                  ),
                  if (widget.showEmail) ...[
                    const SizedBox(height: 3.0),
                    Text(
                      widget.profileEmail ?? 'Profile Email',
                      style:
                          widget.profileEmailStyle ??
                          GoogleFonts.hind(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 14.52 / 12,
                            color: AppColors.textBlackGrey,
                          ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),

        if (widget.isEditMode) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickImage,
            child: Text(
              widget.isUploadingPhoto
                  ? 'Uploading...'
                  : widget.photoUploadFailed
                  ? 'Tap to retry'
                  : 'Tap to change photo',
              style: GoogleFonts.hind(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: widget.photoUploadFailed
                    ? AppColors.textRed
                    : AppColors.primaryDarkGreen,
                decoration: widget.isUploadingPhoto
                    ? TextDecoration.none
                    : TextDecoration.underline,
              ),
            ),
          ),
        ] else if (widget.showBottomText) ...[
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child:
                widget.bottomText ??
                Text(
                  'Upload Photo',
                  style: GoogleFonts.hind(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 14.52 / 12,
                    color: AppColors.primaryDarkGreen,
                  ),
                ),
          ),
        ],

        if (activeErrorText != null) ...[
          const SizedBox(height: 5),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error,
                color: AppColors.accentRed,
                size: context.isWeb ? 16 : 13,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  activeErrorText,
                  style: GoogleFonts.hind(
                    color: AppColors.textRed,
                    fontSize: context.isWeb ? 13 : 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
