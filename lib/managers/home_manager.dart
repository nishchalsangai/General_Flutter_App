import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_mvp/models/product.dart';
import 'package:mini_mvp/services/product_service.dart';

class HomeManager extends ChangeNotifier {
  late bool _isLoading;

  late ProductDataService _productService;

  late StreamSubscription _productBasketStream;

  late List<ProductData> _productBasket;

  late ScrollController _prodControl;
  late StreamController _prodManager;
  late int lastTime;
  late bool productAvailable;
  late final userId;
  HomeManager(this.userId) {
    productAvailable = true;
    lastTime = 0;
    _productBasket = [];
    _productService = ProductDataService(userId);
    _prodControl = ScrollController();
    _prodControl.addListener(_scrollListener);
    startProductBasketSubscription();
  }

  void startProductBasketSubscription() {
    _isLoading = true;
    productAvailable = true;
    notifyListeners();
    print("Hello starting item subs \n\n\n\n\n");
    _productBasketStream = _productService.productBasket.asStream().listen((productBasket) {
      _productBasket = productBasket;
      print("${productBasket.length} is \n\n\n\n");
      if (productBasket.length < 10) {
        productAvailable = false;
      }
      if (productBasket.isNotEmpty) {
        lastTime = productBasket[productBasket.length - 1].productListingTime;
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  _scrollListener() async {
    if (_prodControl.offset >= _prodControl.position.maxScrollExtent &&
        !_prodControl.position.outOfRange &&
        productAvailable) {
      loadMoreProducts();
      toggleLoading();
    }
  }

  Future<void> loadMoreProducts() async {
    await _productService.getNextProductsBasket(lastTime).then((nextProductBasket) {
      _productBasket = [...productBasket, ...nextProductBasket];
      lastTime = nextProductBasket[nextProductBasket.length - 1].productListingTime;
      if (nextProductBasket.length < 10) {
        productAvailable = false;
      }
    });
    _isLoading = false;
    notifyListeners();
  }

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  /// getters
  List<ProductData> get productBasket {
    return _productBasket;
  }

  ScrollController get prodControl {
    return _prodControl;
  }

  bool get isLoading {
    return _isLoading;
  }
}
