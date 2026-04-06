import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class UploadFile {
  final PlatformFile file;
  final Uint8List? preview;
  final String? error;

  UploadFile({required this.file, this.preview, this.error});

  UploadFile copyWith({PlatformFile? file, Uint8List? preview, String? error}) {
    return UploadFile(
      file: file ?? this.file,
      preview: preview ?? this.preview,
      error: error,
    );
  }
}

UploadFile? getFile(List<UploadFile?> files, int index) {
  if (index >= files.length) return null;
  return files[index];
}
