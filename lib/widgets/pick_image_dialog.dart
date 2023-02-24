import 'dart:io';

import 'package:flutter/material.dart';

enum ImagePickerState { standby, picked, cropped, uploading, uploaded }

/// A dialog to pick an image from the gallery \
///
///
/// [imagePickerState] is the pass-down state of the image picker. This is not
/// required but is recommended in order to update the UI. (Unstable) \
/// [fileSink] is the pass-down state of the image file. This is nullable but
/// is required by the widget. (Unstable) \
/// [storagePath] is the path to the Storage bucket. (Optional if you don't want
/// to upload the image to the Storage bucket)

class PickImageDialog extends StatefulWidget {
  final ImagePickerState? imagePickerState;
  final File? fileSink;
  final String? storagePath;

  const PickImageDialog(
      {super.key,
      required this.fileSink,
      this.storagePath,
      this.imagePickerState});

  @override
  State<PickImageDialog> createState() => _PickImageDialogState();
}

class _PickImageDialogState extends State<PickImageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick an image'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {},
            child: const Text('Pick from gallery'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Take a photo'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Save'),
        ),
      ],
    );
  }
}
