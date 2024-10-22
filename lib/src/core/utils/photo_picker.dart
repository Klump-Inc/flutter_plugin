import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PhotoPicker {
  static Future<File?> fromCamera() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);
    return photo != null ? File(photo.path) : null;
  }

  static Future<File?> fromLibrary() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery);
    return photo != null ? File(photo.path) : null;
  }
}
