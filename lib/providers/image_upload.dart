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
  final ImageUploadOptions? options;

  ImageUploader(this.ref, {this.options});

  Future<ImageUpload> handleImageUpload() async {
    final imageUploadNotifier = ref.read(imageUploadProvider(this).notifier);
    return await imageUploadNotifier._controlCenter();
  }
}

class ImageUploadOptions {
  final List<CropAspectRatioPreset>? aspectRatioPresets;

  /// Options for [ImageUploadNotifier] \
  /// \
  /// [aspectRatioPresets] is the list of aspect ratios to show in the cropper.
  /// If not provided, then the cropper will only show the square option.
  ImageUploadOptions({this.aspectRatioPresets});
}

final imageUploadProvider = StateNotifierProvider.family<
    ImageUploadNotifier,
    ImageUpload,
    ImageUploader>((ref, uploader) => ImageUploadNotifier(uploader));

class ImageUploadNotifier extends StateNotifier<ImageUpload> {
  final ImageUploader uploader;

  ImageUploadNotifier(this.uploader) : super(const ImageUpload.prompt());

  final imageDialogKey = GlobalKey<State<StatefulWidget>>();

  Future<ImageUpload> _controlCenter() async {
    await state.whenOrNull<Future<void>>(
      prompt: _prompt,
      picked: (pickedFile) async {
        logger.i('Picked file: ${pickedFile.path}');
        await _cropImage();
      },
      cropped: (croppedFile) async {
        logger.i('Cropped file: ${croppedFile.path}');
        // I know what I am doing.
        // ignore: invalid_use_of_protected_member
        imageDialogKey.currentState?.setState(() {});
      },
      error: (error) {
        if (error != ImagePickerError.userCancelled) {
          Navigator.of(uploader.ref.context).pop();
        }
      },
    );
    return state;
  }

  Future<void> _prompt() async {
    final context = uploader.ref.context;
    state = const ImageUpload.prompt();
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          key: imageDialogKey,
          builder: (context, setState) {
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
                          cropped: (croppedFile) =>
                              Image.file(File(croppedFile.path)),
                        ) ??
                        const SizedBox.shrink(),
                    TextButton(
                      onPressed: () async {
                        await _pickImage();
                      },
                      child: const Text('Pick from gallery'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _takePhoto();
                      },
                      child: const Text('Take a photo'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      state = const ImageUpload.error(
                          ImagePickerError.userCancelled);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          }),
    );
    _controlCenter();
  }

  Future<void> _pickImage() async {
    await state.whenOrNull(
      prompt: () async {
        final pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          state = ImageUpload.picked(pickedFile);
          await _cropImage();
        } else {
          state = const ImageUpload.error(ImagePickerError.pickerError);
        }
      },
    );
    _controlCenter();
  }

  Future<void> _cropImage() async {
    final options = uploader.options;
    final context = uploader.ref.context;
    await state.whenOrNull(
      picked: (sourceFile) async {
        final croppedFile = await ImageCropper().cropImage(
            sourcePath: sourceFile.path,
            aspectRatioPresets: options?.aspectRatioPresets ??
                const [
                  CropAspectRatioPreset.square,
                ],
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Crop Image',
                toolbarColor: Theme.of(context).colorScheme.primaryContainer,
                toolbarWidgetColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false,
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
}
