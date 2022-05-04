import 'package:image_picker/image_picker.dart';
import 'dart:io';

abstract class ServiceForSingleImage {
  final ImagePicker picker = ImagePicker();
  dynamic pickImageError;
  File? imgCamFile;
  Future<File?> singleImage();
}

class ImageFromCamera extends ServiceForSingleImage {
  @override
  Future<File?> singleImage() async {
    try {
      final photo = await picker.pickImage(source: ImageSource.camera);
      imgCamFile = File(photo!.path);
    } catch (e) {
      pickImageError = e;
    }
    return imgCamFile;
  }
}

Future<File?> singleImage(ServiceForSingleImage image) => image.singleImage();

class ImageFromGallery extends ServiceForSingleImage {
  @override
  Future<File?> singleImage() async {
    try {
      final photo = await picker.pickImage(source: ImageSource.gallery);
      imgCamFile = File(photo!.path);
    } catch (e) {
      pickImageError = e;
    }
    return imgCamFile;
  }
}
