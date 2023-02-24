import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

enum ImagePickerState {
  standby,
  prompt,
  picked,
  error,
  cropped,
  uploading,
  uploaded
}

class ImageUploadState {
  XFile? sourceFile;
  CroppedFile? croppedFile;
  ImagePickerState state;
  Error? error;

  ImageUploadState(
      {required this.state, this.sourceFile, this.croppedFile, this.error});
}

/// Options for [ImageUploadNotifier]
///
/// [context] is required to show the dialog. Just pass `context` from
/// the build method.
/// [storagePath] is the path to the Firebase Storage location.
/// This is to handle the lifecycle of the image picker internally.
/// [aspectRatioPresets] is the list of aspect ratios to show in the cropper.
/// If not provided, then the cropper will only show the square option.
class ImageUploadOptions {
  final BuildContext context;
  final String? storagePath;
  final List<CropAspectRatioPreset>? aspectRatioPresets;

  ImageUploadOptions(
      {required this.context, this.storagePath, this.aspectRatioPresets});
}

final imageUploadProvider = StateNotifierProvider.family<
    ImageUploadNotifier,
    ImageUploadState,
    ImageUploadOptions>((ref, options) => ImageUploadNotifier(options));

class ImageUploadNotifier extends StateNotifier<ImageUploadState> {
  final ImageUploadOptions options;

  ImageUploadNotifier(this.options)
      : super(ImageUploadState(state: ImagePickerState.standby));

  Future<ImageUploadState> handleImagePickFlow() async {
    final context = options.context;
    state = ImageUploadState(state: ImagePickerState.prompt);
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Pick an image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.state == ImagePickerState.cropped)
                Image.file(
                  File(state.croppedFile!.path),
                ),
              TextButton(
                onPressed: () async {
                  final imageUploadState = await _pickImage();
                  if (imageUploadState.state == ImagePickerState.cropped) {
                    setState(() {});
                  }
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
        );
      }),
    );
    return state;
  }

  Future<ImageUploadState> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      state = ImageUploadState(
          sourceFile: pickedFile, state: ImagePickerState.picked);
      await _cropImage();
    } else {
      state = ImageUploadState(state: ImagePickerState.error);
    }
    return state;
  }

  Future<ImageUploadState> _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: state.sourceFile!.path,
        aspectRatioPresets:
            options.aspectRatioPresets ?? [CropAspectRatioPreset.square],
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop the image',
            toolbarColor:
                Theme.of(options.context).colorScheme.primaryContainer,
            toolbarWidgetColor:
                Theme.of(options.context).colorScheme.onPrimaryContainer,
            initAspectRatio: CropAspectRatioPreset.square,
          ),
          IOSUiSettings(
            title: 'Crop the image',
          )
        ]);
    if (croppedFile != null) {
      state = ImageUploadState(
          sourceFile: state.sourceFile,
          croppedFile: croppedFile,
          state: ImagePickerState.cropped);
      if (options.storagePath != null) {
        await _finalize();
      }
    } else {
      state = ImageUploadState(
          sourceFile: state.sourceFile, state: ImagePickerState.prompt);
    }
    return state;
  }

  Future<void> _takePhoto() async {}

  Future<ImageUploadState> _finalize() async {
    if (state.croppedFile != null) {
      state = ImageUploadState(
          sourceFile: state.sourceFile,
          croppedFile: state.croppedFile,
          state: ImagePickerState.uploading);

      await FirebaseStorage.instance.ref(options.storagePath).putFile(
          File(state.croppedFile!.path),
          SettableMetadata(contentType: 'image/jpeg'));
      state = ImageUploadState(
          sourceFile: state.sourceFile,
          croppedFile: state.croppedFile,
          state: ImagePickerState.uploaded);
    } else {
      state = ImageUploadState(
          sourceFile: state.sourceFile,
          croppedFile: state.croppedFile,
          state: ImagePickerState.standby);
    }
    return state;
  }
}
