import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_mvp/models/product.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';

class ProductDataService {
  late CollectionReference products;
  late final userId;
  ProductDataService(String userId) {
    products = FirebaseFirestore.instance.collection('ProductData');
    this.userId = userId;
  }

  Future<String> generateNewProduct() async {
    return products.doc().id;
  }

  Future<String> addProduct({
    required String id,
    required String ownerId,
    required String name,
    required String description,
    required String imageUrl,
    required double price,
  }) async {
    return await products.doc(id).set({
      "productId": id,
      "productName": name,
      "productDescription": description,
      "productImageUrl": imageUrl,
      "productPrice": price,
      "productOwnerId": ownerId,
      "productListingTime": DateTime.now().millisecondsSinceEpoch
    }).then((value) {
      print("New item added ${id}");
      return "Item is added successfully";
    }).catchError((error) {
      print(error.message);
      return error.message.toString();
    });
  }

  Future<List<ProductData>> get productBasket async {
    List<ProductData> productBasket = [];
    await products
        .where('productOwnerId', isEqualTo: userId)
        .orderBy('productListingTime')
        .limit(10)
        .get()
        .then((snap) async {
      snap.docs.forEach((productSnap) =>
          productBasket.add(ProductData.fromMap(productSnap.data() as Map<dynamic, dynamic>)));
    });
    return productBasket;
  }

  Future<List<ProductData>> getNextProductsBasket(int lastProductTime) async {
    print("But  I was called In service \n\n\n\n\n\n");
    List<ProductData> productBasket = [];
    await products
        .where('productOwnerId', isEqualTo: userId)
        .orderBy('productListingTime')
        .startAfter([lastProductTime])
        .limit(10)
        .get()
        .then((snap) async {
          snap.docs.forEach((productSnap) =>
              productBasket.add(ProductData.fromMap(productSnap.data() as Map<dynamic, dynamic>)));
        });
    return productBasket;
  }

  Stream<ProductData> productData(String id) {
    return products.doc(id).snapshots().map((snap) {
      return ProductData.fromMap(snap.data() as Map<dynamic, dynamic>);
    });
  }
}
