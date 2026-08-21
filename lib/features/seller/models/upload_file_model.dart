import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class UploadFile {
  final PlatformFile file;
  final Uint8List? preview;
  final String? error;
  final String? cloudinaryUrl;
  final double uploadProgress;
  final bool isUploading;
  final bool uploadFailed;
  final CancelToken? cancelToken;

  const UploadFile({
    required this.file,
    this.preview,
    this.error,
    this.cloudinaryUrl,
    this.uploadProgress = 0.0,
    this.isUploading = false,
    this.uploadFailed = false,
    this.cancelToken,
  });

  bool get isUploadComplete =>
      cloudinaryUrl != null &&
      uploadProgress >= 1.0 &&
      !uploadFailed &&
      error == null;

  UploadFile copyWith({
    PlatformFile? file,
    Uint8List? preview,
    Object? error = _sentinel,
    Object? cloudinaryUrl = _sentinel,
    double? uploadProgress,
    bool? isUploading,
    bool? uploadFailed,
    Object? cancelToken = _sentinel,
  }) => UploadFile(
    file: file ?? this.file,
    preview: preview ?? this.preview,
    error: identical(error, _sentinel) ? this.error : error as String?,
    cloudinaryUrl: identical(cloudinaryUrl, _sentinel)
        ? this.cloudinaryUrl
        : cloudinaryUrl as String?,
    uploadProgress: uploadProgress ?? this.uploadProgress,
    isUploading: isUploading ?? this.isUploading,
    uploadFailed: uploadFailed ?? this.uploadFailed,
    cancelToken: identical(cancelToken, _sentinel)
        ? this.cancelToken
        : cancelToken as CancelToken?,
  );
}

const _sentinel = Object();
