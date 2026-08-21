import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../core/service/user_api_service.dart';
import '../models/upload_file_model.dart';

typedef UploadState = List<UploadFile?>;

final uploadProvider =
    StateNotifierProvider.family<UploadNotifier, UploadState, String>(
      (ref, id) => UploadNotifier(ref.read(userApiServiceProvider)),
    );

class UploadNotifier extends StateNotifier<UploadState> {
  final UserApiService api;

  UploadNotifier(this.api) : super([]);

  void init(int count) {
    if (state.isEmpty) state = List.filled(count, null);
  }

  bool _isValidImageType(String? ext) {
    if (ext == null) return false;
    final e = ext.toLowerCase();
    return e == 'jpg' || e == 'jpeg' || e == 'png';
  }

  bool _isValidVideoType(String? ext) => ext?.toLowerCase() == 'mp4';

  Future<void> pickImage(int index) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );
    if (result == null) return;

    final picked = result.files.first;
    final sizeMB = picked.size / (1024 * 1024);
    final newList = List<UploadFile?>.from(state);

    if (!_isValidImageType(picked.extension)) {
      newList[index] = UploadFile(
        file: picked,
        error: "File type not supported. Please upload JPG or PNG",
      );
      state = newList;
      return;
    }
    if (sizeMB > 5) {
      newList[index] = UploadFile(
        file: picked,
        error: "Image exceeds 5MB. Try compressing or a smaller file.",
      );
      state = newList;
      return;
    }

    newList[index] = UploadFile(
      file: picked,
      preview: kIsWeb && picked.bytes != null
          ? Uint8List.fromList(picked.bytes!)
          : null,
    );
    state = newList;

    if (!kIsWeb && picked.path != null) {
      try {
        final bytes = await File(picked.path!).readAsBytes();
        if (mounted) _updateAt(index, (f) => f.copyWith(preview: bytes));
      } catch (_) {}
    }

    await _uploadToCloudinary(index, picked);
  }

  Future<void> pickVideo(int index) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      withData: kIsWeb,
    );
    if (result == null) return;

    final picked = result.files.first;
    final sizeMB = picked.size / (1024 * 1024);
    final newList = List<UploadFile?>.from(state);

    if (sizeMB > 20) {
      newList[index] = UploadFile(
        file: picked,
        error: "Video exceeds 20MB limit.",
      );
      state = newList;
      return;
    }
    if (!_isValidVideoType(picked.extension)) {
      newList[index] = UploadFile(
        file: picked,
        error: "File type not supported. Please upload MP4 videos.",
      );
      state = newList;
      return;
    }

    try {
      late VideoPlayerController controller;
      if (kIsWeb) {
        controller = VideoPlayerController.networkUrl(
          Uri.parse(Uri.dataFromBytes(picked.bytes!).toString()),
        );
      } else {
        controller = VideoPlayerController.file(File(picked.path!));
      }
      await controller.initialize();
      final duration = controller.value.duration.inSeconds;
      await controller.dispose();

      if (duration > 60) {
        newList[index] = UploadFile(
          file: picked,
          error: "Video must be under 60 seconds (current: ${duration}s)",
        );
        state = newList;
        return;
      }

      Uint8List? thumbnail;
      if (!kIsWeb) {
        thumbnail = await VideoThumbnail.thumbnailData(
          video: picked.path!,
          imageFormat: ImageFormat.JPEG,
          quality: 75,
        );
      }

      newList[index] = UploadFile(file: picked, preview: thumbnail);
      state = newList;

      await _uploadToCloudinary(index, picked);
    } catch (e) {
      debugPrint("Video processing error: $e");
      newList[index] = UploadFile(
        file: picked,
        error: "Could not process video. Try a different format.",
      );
      state = newList;
    }
  }

  Future<void> _uploadToCloudinary(int index, PlatformFile file) async {
    if (!mounted) return;
    final cancelToken = CancelToken();

    _updateAt(
      index,
      (f) => f.copyWith(
        isUploading: true,
        uploadProgress: 0.0,
        uploadFailed: false,
        cancelToken: cancelToken,
      ),
    );

    try {
      final signatureRes = await api.getUploadSignature("products");
      if (!signatureRes.isSuccess) {
        throw Exception("Failed to get upload signature");
      }

      final data = signatureRes.data!;
      final cloudName = data['cloudName'];
      final uploadUrl =
          "https://api.cloudinary.com/v1_1/$cloudName/auto/upload";

      final MultipartFile fileMultipart = kIsWeb
          ? MultipartFile.fromBytes(file.bytes!, filename: file.name)
          : await MultipartFile.fromFile(file.path!, filename: file.name);

      final formData = FormData.fromMap({
        "file": fileMultipart,
        "api_key": data['apiKey'],
        "timestamp": data['timestamp'],
        "signature": data['signature'],
        "folder": data['folder'] ?? 'products',
      });

      final response = await Dio().post(
        uploadUrl,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: (sent, total) {
          if (total != -1 && mounted) {
            _updateAt(index, (f) => f.copyWith(uploadProgress: sent / total));
          }
        },
      );

      if (!mounted) return;
      _updateAt(
        index,
        (f) => f.copyWith(
          cloudinaryUrl: response.data['secure_url'] as String,
          uploadProgress: 1.0,
          isUploading: false,
          uploadFailed: false,
        ),
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return;
      debugPrint("Product upload DioException: $e");
      if (!mounted) return;
      _updateAt(
        index,
        (f) => f.copyWith(
          isUploading: false,
          uploadFailed: true,
          uploadProgress: 0.0,
        ),
      );
    } catch (e) {
      debugPrint("Product upload error: $e");
      if (!mounted) return;
      _updateAt(
        index,
        (f) => f.copyWith(
          isUploading: false,
          uploadFailed: true,
          uploadProgress: 0.0,
        ),
      );
    }
  }

  void cancelUpload(int index) {
    state[index]?.cancelToken?.cancel("Upload cancelled");
    if (!mounted) return;
    _updateAt(
      index,
      (f) => f.copyWith(isUploading: false, uploadProgress: 0.0),
    );
  }

  void retryUpload(int index) {
    final file = state[index]?.file;
    if (file != null) _uploadToCloudinary(index, file);
  }

  void removeFile(int index) {
    state[index]?.cancelToken?.cancel();
    final newList = List<UploadFile?>.from(state);
    newList[index] = null;
    state = newList;
  }

  void _updateAt(int index, UploadFile Function(UploadFile) updater) {
    if (index < 0 || index >= state.length) return;
    final current = state[index];
    if (current == null) return;
    final newList = List<UploadFile?>.from(state);
    newList[index] = updater(current);
    state = newList;
  }
}
