import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService(this._storage);

  Future<String?> getItemImgURL(File? file, String? id, int itemImgNo) async {
    print("mein yaha hoon");
    try {
      var destination = "Product/$id/${id}_$itemImgNo";
      await _storage.ref(destination).putFile(file!);

      final ref = _storage.ref().child("Product/$id/${id}_$itemImgNo");
      var url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }
}
