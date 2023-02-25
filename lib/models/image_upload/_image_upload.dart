import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

part '_image_upload.freezed.dart';

enum ImagePickerState { prompt, picked, error, cropped }

enum ImagePickerError { stepError, pickerError, cropperError, userCancelled }

extension ImagePickerErrorMessage on ImagePickerError {
  String get message {
    switch (this) {
      case ImagePickerError.pickerError:
        return 'Image picker error';
      case ImagePickerError.cropperError:
        return 'Image cropper error';
      case ImagePickerError.stepError:
        return 'Image picker flow went wrong';
      case ImagePickerError.userCancelled:
        return 'User cancelled image picker';
    }
  }
}

@Freezed(unionKey: 'state', fromJson: false, toJson: false)
class ImageUpload with _$ImageUpload {
  const factory ImageUpload.prompt() = ImageUploadPrompt;
  const factory ImageUpload.picked(XFile sourceFile) = ImageUploadPicked;
  const factory ImageUpload.error(ImagePickerError error) = ImageUploadError;
  const factory ImageUpload.cropped(CroppedFile croppedFile) =
      ImageUploadCropped;
}
