import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_mvp/globals/extensions.dart';
import 'package:mini_mvp/globals/repo/image_repo.dart';
import 'package:provider/provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../globals/widgets/alert_dialogue.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import '../services/storage_service.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ProductManager extends ChangeNotifier {
  final GlobalKey<FormState> productFormKey = GlobalKey<FormState>();
  GlobalKey scaffold = GlobalKey();
  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController price = TextEditingController();
  late ProductDataService _productService;
  late String id;
  File? compressedImage;
  File? originalImage;
  late StorageService _storageService;
  bool disableButton = false;
  double originalImageInKB = 0;
  double compressedImageInKB = 0;
  late String userId;
  ProductManager(this.userId) {
    _productService = ProductDataService(userId);
    _storageService = StorageService(FirebaseStorage.instance);
  }

  compressImage(File imageFile) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = dir.absolute.path + "/temp.jpg";
    compressedImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      targetPath,
      quality: 5,
    );
    print(imageFile.lengthSync());
    print(compressedImage?.lengthSync());
    addImagesToList();
  }

  addImagesToList() {
    originalImageInKB = getSizeofImage(originalImage!);
    compressedImageInKB = getSizeofImage(compressedImage!);
    notifyListeners();
  }

  double getSizeofImage(File image) {
    final byteImage = image.readAsBytesSync().lengthInBytes;
    final imageInKB = (byteImage / 1024).toPrecision(2);
    print(imageInKB);
    return imageInKB;
  }

  pickProductImageFromCamera() async {
    ImageFromCamera image = ImageFromCamera();
    final photo = await singleImage(image);
    final imageFile = File(photo!.path);
    originalImage = imageFile;
    compressImage(imageFile);
  }

  pickProductImageFromGallery() async {
    ImageFromGallery image = ImageFromGallery();
    final photo = await singleImage(image);
    final imageFile = File(photo!.path);
    originalImage = imageFile;
    compressImage(imageFile);
  }

  uploadProduct(BuildContext context) async {
    try {
      switchButton();
      final isValid = productFormKey.currentState!.validate();
      String? ownerId = Provider.of<AuthenticationService>(context, listen: false).userIdGetter;
      if (isValid && (originalImage != null)) {
        _productService.generateNewProduct().then((value) async {
          id = value;
          final imgUrl = await _storageService.getItemImgURL(compressedImage, id, 0);
          _productService
              .addProduct(
                  id: id,
                  ownerId: ownerId!,
                  name: name.text,
                  description: description.text,
                  imageUrl: imgUrl!,
                  price: double.parse(price.text))
              .then((value) {
            if (value == "Item is added successfully") {
              switchButton();
              onProcessCompletion(scaffold.currentContext!, "", value, true);
              name.clear();
              description.clear();
              price.clear();
              compressedImage = null;
              originalImage = null;
            }
          });
        });
      } else if (originalImage == null) {
        switchButton();
        showInSnackBar(context, "Please upload a image");
      } else {
        switchButton();
      }
    } catch (ex) {
      showInSnackBar(context, ex.toString());
    }
  }

  void showInSnackBar(BuildContext context, String val) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        val,
        style: GoogleFonts.openSans(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    ));
  }

  void switchButton() {
    disableButton = !disableButton;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    name.clear();
    description.clear();
    price.clear();
    compressedImage = null;
    originalImage = null;
    super.dispose();
  }
}
