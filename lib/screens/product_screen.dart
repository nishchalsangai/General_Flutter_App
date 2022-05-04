import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_mvp/globals/size_config.dart';
import 'package:mini_mvp/globals/widgets/app_bar.dart';
import 'package:mini_mvp/managers/product_manager.dart';

import 'package:provider/provider.dart';
import '../globals/mixins/validate_productform.dart';
import '../globals/theme/app_theme.dart';

class AddProductScreen extends StatelessWidget with ValidateProductFormMixin {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<ProductManager>(builder: (context, productManager, child) {
      return Scaffold(
        key: productManager.scaffold,
        appBar: CustomAppBar.customAppBar(
            leadingIcon: true,
            title: "Add Product",
            context: context,
            color: AppTheme.subHeadingColor.withOpacity(0.08),
            action: []),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: productManager.productFormKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  productManager.pickProductImageFromCamera();
                                  Navigator.pop(context);
                                },
                                child: bottomSheetElements(
                                  leadingIcon: Icons.camera,
                                  title: 'Camera',
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  productManager.pickProductImageFromGallery();
                                  Navigator.pop(context);
                                },
                                child: bottomSheetElements(
                                  leadingIcon: Icons.add_photo_alternate,
                                  title: 'Pick From Files',
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: productManager.originalImage == null
                      ? const Image(
                          image: AssetImage("assets/images/addImage.png"),
                          fit: BoxFit.contain,
                          height: 150,
                          width: 150,
                        )
                      : ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                          child: Image.file(
                            File(productManager.originalImage!.path),
                            fit: BoxFit.contain,
                            height: 120,
                            width: 120,
                          ),
                        ),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 1,
                ),
                Text(
                  productManager.originalImage == null ? "Add Image" : "Tap on image to change",
                  style: GoogleFonts.openSans(
                      fontSize: 14, color: AppTheme.subHeadingColor, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 2,
                ),
                ProductFormField(
                  controller: productManager.name,
                  hint: 'Product Name',
                  fun: productName,
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 2,
                ),
                ProductFormField(
                  controller: productManager.description,
                  hint: 'Product Description',
                  fun: productDescription,
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 2,
                ),
                ProductFormField(
                  controller: productManager.price,
                  hint: 'Product Price',
                  fun: productPrice,
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical! * 5,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                          colors: [AppTheme.primaryColor, AppTheme.accentColor])),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        primary: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0),
                    onPressed: productManager.disableButton
                        ? null
                        : () {
                            productManager.compressedImageInKB != 0
                                ? showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          bottomSheetElements(
                                            title: 'Original Image Size',
                                            trailing: productManager.originalImageInKB.toString(),
                                          ),
                                          bottomSheetElements(
                                            title: 'Image Size After Compression',
                                            trailing: productManager.compressedImageInKB.toString(),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(horizontal: 5),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16),
                                                gradient: const LinearGradient(colors: [
                                                  AppTheme.primaryColor,
                                                  AppTheme.accentColor
                                                ])),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets.all(0),
                                                  primary: Colors.transparent,
                                                  shadowColor: Colors.transparent,
                                                  elevation: 0),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                productManager.uploadProduct(context);
                                              },
                                              child: Text("ADD PRODUCT"),
                                            ),
                                          ),
                                          SizedBox(
                                            height: SizeConfig.safeBlockVertical! * 2,
                                          )
                                        ],
                                      );
                                    })
                                : productManager.uploadProduct(context);
                          },
                    child: productManager.disableButton
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text("Check Image Size"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class bottomSheetElements extends StatelessWidget {
  bottomSheetElements({
    Key? key,
    this.leadingIcon,
    required this.title,
    this.trailing,
  }) : super(key: key);
  IconData? leadingIcon;
  final String title;
  String? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingIcon == null
          ? null
          : Icon(
              leadingIcon,
              color: AppTheme.primaryColor,
            ),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 16,
            letterSpacing: .22,
            fontWeight: FontWeight.w400,
            color: AppTheme.headingColor),
      ),
      trailing: trailing == null ? null : Text("$trailing kb"),
    );
  }
}

class ProductFormField extends StatelessWidget {
  const ProductFormField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.fun,
  }) : super(key: key);
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? fun;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 20,
            spreadRadius: 10,
          ),
        ],
      ),
      child: TextFormField(
        keyboardType: hint == 'Product Price' ? TextInputType.number : TextInputType.text,
        controller: controller,
        validator: fun,
        style: GoogleFonts.openSans(
            fontSize: 14, color: AppTheme.headingColor, fontWeight: FontWeight.w600),
        maxLines: null,
        minLines: hint == 'Product Description' ? 6 : 1,
        decoration: InputDecoration(
          filled: true,
          hintText: hint,
          // labelText: hint,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.primaryColor)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          hintStyle: GoogleFonts.openSans(
              fontSize: 14, color: AppTheme.subHeadingColor, fontWeight: FontWeight.w600),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintMaxLines: 1,
          prefixText: hint == 'Product Price' ? "₹" : null,
          prefixStyle: GoogleFonts.openSans(
              fontSize: 14, color: AppTheme.headingColor, fontWeight: FontWeight.w600),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          errorStyle: const TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }
}
