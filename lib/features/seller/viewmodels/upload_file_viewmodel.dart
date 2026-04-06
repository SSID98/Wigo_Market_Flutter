import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/upload_file_model.dart';

typedef UploadState = List<UploadFile?>;

// Use .family to keep different upload sections separate
final uploadProvider =
    StateNotifierProvider.family<UploadNotifier, UploadState, String>((
      ref,
      id,
    ) {
      return UploadNotifier();
    });

class UploadNotifier extends StateNotifier<UploadState> {
  // UploadNotifier() : super(UploadState(files: []));
  //
  // /// Initialize dynamically
  // void init(int count) {
  //   state = UploadState(files: List.filled(count, null));
  // }
  UploadNotifier() : super([]);

  void init(int count) {
    if (state.isEmpty) {
      state = List.filled(count, null);
    }
  }

  bool isValidImageType(String? ext) {
    if (ext == null) return false;
    final e = ext.toLowerCase();
    return e == 'jpg' || e == 'jpeg' || e == 'png';
  }

  bool isValidVideoType(String? ext) {
    if (ext == null) return false;
    return ext.toLowerCase() == 'mp4';
  }

  Future<void> pickImage(int index) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null) return;

    final picked = result.files.first;
    final sizeMB = picked.size / (1024 * 1024);
    final ext = picked.extension;
    // final files = [...state.files];

    final newList = List<UploadFile?>.from(state);

    if (!isValidImageType(ext)) {
      newList[index] = UploadFile(
        file: picked,
        error: "File type not supported. Please upload JPG or PNG",
      );
      state = newList;
      // state = state.copyWith(files: files);
      return;
    }

    if (sizeMB > 5) {
      newList[index] = UploadFile(
        file: picked,
        error:
            "Image exceeds max size (5MB). Try compressing or uploading a smaller file.",
      );
      state = newList;
      // state = state.copyWith(files: files);
      return;
    }

    newList[index] = UploadFile(
      file: picked,
      preview: picked.bytes != null ? Uint8List.fromList(picked.bytes!) : null,
    );

    state = newList;
    // state = state.copyWith(files: files);
  }

  Future<void> pickVideo(int index) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      withData: kIsWeb, // Only need data in memory for Web
    );

    if (result == null) return;

    final picked = result.files.first;
    final sizeMB = picked.size / (1024 * 1024);
    final newList = List<UploadFile?>.from(state);
    final ext = picked.extension;

    // 1. Check Size immediately
    if (sizeMB > 20) {
      newList[index] = UploadFile(
        file: picked,
        error: "Video exceeds 20MB limit.",
      );
      state = newList;
      return;
    }

    if (!isValidVideoType(ext)) {
      newList[index] = UploadFile(
        file: picked,
        error: "File type not supported. Please upload MP4 videos.",
      );
      state = newList;
      // state = state.copyWith(files: files);
      return;
    }

    try {
      // 2. Determine Video Source based on Platform
      late VideoPlayerController controller;
      if (kIsWeb) {
        // On Web, we create a blob URL from the bytes
        final blobUrl = Uri.dataFromBytes(picked.bytes!).toString();
        controller = VideoPlayerController.networkUrl(Uri.parse(blobUrl));
      } else {
        // On Mobile, use the file path
        controller = VideoPlayerController.file(File(picked.path!));
      }

      // 3. Initialize to check duration
      await controller.initialize();
      final duration = controller.value.duration.inSeconds;
      await controller.dispose();

      if (duration > 60) {
        newList[index] = UploadFile(
          file: picked,
          error: "Video must be under 60 seconds (Current: ${duration}s)",
        );
        state = newList;
        return;
      }

      // 4. Generate Thumbnail
      Uint8List? thumbnail;
      if (kIsWeb) {
        // Note: VideoThumbnail package doesn't support Web well.
        // For now, we use a placeholder or leave it null.
        thumbnail = null;
      } else {
        thumbnail = await VideoThumbnail.thumbnailData(
          video: picked.path!,
          imageFormat: ImageFormat.JPEG,
          quality: 75,
        );
      }

      // 5. Success!
      newList[index] = UploadFile(file: picked, preview: thumbnail);
      state = newList;
    } catch (e) {
      // Catch-all for any initialization or thumbnail errors
      debugPrint("Video Processing Error: $e");
      newList[index] = UploadFile(
        file: picked,
        error: "Could not process video. Try a different format.",
      );
      state = newList;
    }
  }

  void removeFile(int index) {
    final newList = List<UploadFile?>.from(state);
    newList[index] = null;
    state = newList;
  }

  // void removeFile(int index) {
  //   if (index < 0 || index >= state.files.length) return;
  //
  //   final files = [...state.files];
  //   files[index] = null;
  //
  //   state = state.copyWith(files: files);
  // }

  // void updateFile(int index, UploadFile? file) {
  //   final files = [...state.files];
  //   files[index] = file;
  //   state = state.copyWith(files: files);
  // }
}

// final uploadProvider = StateNotifierProvider<UploadNotifier, UploadState>(
//   (ref) => UploadNotifier(),
// );
