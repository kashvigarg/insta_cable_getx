import 'dart:io';

import 'package:image_picker/image_picker.dart';

class VideoPickerHelper {
  static final _videoPicker = ImagePicker();

  static Future<File?> pickVideo() {
    return _videoPicker.pickVideo(source: ImageSource.gallery).toFile();
  }
}

extension ToFile on Future<XFile?> {
  Future<File?> toFile() => then((xFile) => xFile?.path)
      .then((filePath) => filePath != null ? File(filePath) : null);
}
