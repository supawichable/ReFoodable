import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/models/image_upload/_image_upload.dart';
import 'package:gdsctokyo/util/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

/// A class that handles image upload.
///
/// Ironically, you have to handle the upload part yourself. \
/// This is for systemically picking, and cropping images. \
/// with an opinionated UI.
///
/// ## Usage
/// ### Creating [HookConsumerWidget]
/// This is necessary because our ImageUploader operates on \
/// a global [StateNotifierProvider] to ensure state reliability. \
/// (Probably, it says so)
///
/// ```dart
/// class MyWidget extends HookConsumerWidget {
///
///   const MyWidget({Key? key}) : super(key: key);
///
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     // ...
///   }
/// ```
///
/// ### A button that triggers the image upload
///
/// ```dart
/// ElevatedButton(
///  onPressed: () async {
///   final imageUpload = await ImageUploader(
///     ref, // This is the WidgetRef from build()
///     options: ImageUploadOptions(
///      // The default aspect ratio is square.
///      // So if you want to leave it blank, you can.
///      aspectRatioPresets: [
///         CropAspectRatioPreset.square,
///         CropAspectRatioPreset.ratio3x2,
///         CropAspectRatioPreset.original,
///      ],
///   ).handleImageUpload();
///   // Do something with the image upload
/// }
/// ```
/// ### Doing something with the image upload
/// [ImageUpload] is a union type of different states. \
/// You can use `when` to handle each state.
/// Or you can use `whenOrNull` to handle only the states \
/// that you want to handle. \
/// You can use `maybeWhen` to handle only the states \
/// that you want to handle, and return a default value \
///
/// [ImageUpload] will return error if something went wrong. \
///
/// ```dart
/// await imageUpload.whenOrNull(
///  cropped: (croppedFile) async {
///   // Upload to the Firestore or something
///  },
///  error: (error) {
///   // Show error snack bar
///   },
/// );
/// ```
class ImageUploader {
  final WidgetRef ref;
  final ImageUploadOptions options;

  ImageUploader(this.ref, {this.options = const ImageUploadOptions()});

  Future<ImageUpload> handleImageUpload() async {
    final imageUploadNotifier = ref.read(imageUploadProvider(this).notifier);
    return await imageUploadNotifier._handleImageUpload();
  }
}

class ImageUploadOptions {
  final List<CropAspectRatioPreset> aspectRatioPresets;
  final CropAspectRatio? aspectRatio;

  /// Options for [ImageUploadNotifier] \
  /// \
  /// [aspectRatioPresets] is the list of aspect ratios to show in the cropper.
  /// If not provided, then the cropper will only show the
  /// [CropAspectRatioPreset.original] option. \
  /// [aspectRatio] is the custom aspect ratio to show in the cropper. \
  ///
  /// If both [aspectRatioPresets] and [aspectRatio] are provided, then
  /// [aspectRatio] will be used as the default aspect ratio.
  /// (So don't?)
  const ImageUploadOptions({
    this.aspectRatio,
    this.aspectRatioPresets = const [CropAspectRatioPreset.original],
  });
}

final imageUploadProvider = StateNotifierProvider.family<
    ImageUploadNotifier,
    ImageUpload,
    ImageUploader>((ref, uploader) => ImageUploadNotifier(uploader));

class ImageUploadNotifier extends StateNotifier<ImageUpload> {
  final ImageUploader uploader;

  ImageUploadNotifier(this.uploader) : super(const ImageUpload.standBy());

  Future<void> _controlCenter() async {
    await state.whenOrNull<Future<void>>(
      standBy: _handleImageUpload,
      prompt: _prompt,
      picked: (_) async {
        _cropImage();
      },
      error: (error) {
        Navigator.of(uploader.ref.context).pop();
        switch (error) {
          case ImagePickerError.stepError:
            break;
          case ImagePickerError.pickerError:
            state = const ImageUpload.prompt();
            break;
          case ImagePickerError.cropperError:
            state = const ImageUpload.prompt();
            break;
          case ImagePickerError.userCancelled:
            break;
        }
        return null;
      },
    );
  }

  Future<ImageUpload> _handleImageUpload() async {
    final context = uploader.ref.context;
    state = const ImageUpload.prompt();

    await showDialog(
      context: context,
      builder: (context) => ImageUploadDialog(uploader: uploader),
    );

    return state;
  }

  Future<void> _prompt() async {
    logger.w('Something went wrong but rest assured, it is not your fault.');
  }

  Future<void> _cropImage() async {
    final options = uploader.options;
    final context = uploader.ref.context;
    await state.whenOrNull(
      picked: (sourceFile) async {
        final croppedFile = await ImageCropper().cropImage(
            sourcePath: sourceFile.path,
            aspectRatioPresets: options.aspectRatioPresets,
            aspectRatio: options.aspectRatio,
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Crop Image',
                toolbarColor: Theme.of(context).colorScheme.primaryContainer,
                toolbarWidgetColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              IOSUiSettings(
                title: 'Crop Image',
              ),
            ]);
        if (croppedFile != null) {
          state = ImageUpload.cropped(croppedFile);
        } else {
          state = const ImageUpload.error(ImagePickerError.cropperError);
        }
      },
    );
    // _controlCenter();
  }

  Future<void> _pickImage() async {
    await state.whenOrNull(
      prompt: () async {
        final pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          state = ImageUpload.picked(pickedFile);
        } else {
          state = const ImageUpload.error(ImagePickerError.pickerError);
        }
      },
    );
    _controlCenter();
  }

  Future<void> _takePhoto() async {
    await state.whenOrNull(prompt: () async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        state = ImageUpload.picked(pickedFile);
      } else {
        state = const ImageUpload.error(ImagePickerError.pickerError);
      }
      return state;
    });
    _controlCenter();
  }

  Future<void> _throwError(ImagePickerError error) async {
    state = ImageUpload.error(error);
    _controlCenter();
  }

  Future<void> _save() async {
    state.whenOrNull(cropped: (croppedFile) async {
      Navigator.of(uploader.ref.context).pop();
    });
  }
}

class ImageUploadDialog extends HookConsumerWidget {
  final ImageUploader uploader;
  const ImageUploadDialog({super.key, required this.uploader});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final ImageUploadNotifier _notifier =
        ref.read(imageUploadProvider(uploader).notifier);
    late final ImageUpload state = ref.watch(imageUploadProvider(uploader));

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        title: const Text('Pick an image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            state.whenOrNull(
                  error: (error) => Text(error.message),
                  cropped: (croppedFile) => Image.file(File(croppedFile.path)),
                ) ??
                const SizedBox.shrink(),
            TextButton(
              onPressed: () async {
                await _notifier._pickImage();
              },
              child: const Text('Pick from gallery'),
            ),
            TextButton(
              onPressed: () async {
                await _notifier._takePhoto();
              },
              child: const Text('Take a photo'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _notifier._throwError(ImagePickerError.userCancelled);
            },
            child: const Text('Cancel'),
          ),
          if (state is ImageUploadCropped)
            TextButton(
              onPressed: () async {
                await _notifier._save();
              },
              child: const Text('Save'),
            ),
        ],
      ),
    );
  }
}
