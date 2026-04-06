import 'package:wigo_flutter/features/seller/models/upload_file_model.dart';

class UploadState {
  final List<UploadFile?> files;

  UploadState({required this.files});

  UploadState copyWith({List<UploadFile?>? files}) {
    return UploadState(files: files ?? this.files);
  }
}
