class ProductData {
  late String _productId;
  late String _productOwnerId;
  late int _productListingTime;
  late String _productName;
  late String _productDescription;
  late String _productImage;
  late double _productPrice;

  ProductData(
      {required String productId,
      required String productOwnerId,
      required String productName,
      required String productDescription,
      required String productImage,
      required double productPrice,
      required int productListingTime}) {
    _productId = productId;
    _productOwnerId = productOwnerId;
    _productName = productName;
    _productDescription = productDescription;
    _productImage = productImage;
    _productPrice = productPrice;
    _productListingTime = productListingTime;
  }

  factory ProductData.fromMap(Map data) {
    return ProductData(
        productId: data['productId'],
        productOwnerId: data['productOwnerId'],
        productName: data['productName'],
        productDescription: data['productDescription'],
        productImage: data['productImageUrl'],
        productPrice: data['productPrice'],
        productListingTime: data['productListingTime']);
  }

  String get productId {
    return _productId;
  }

  String get productOwnerId {
    return _productOwnerId;
  }

  String get productName {
    return _productName;
  }

  String get productDescription {
    return _productDescription;
  }

  String get productImage {
    return _productImage;
  }

  double get productPrice {
    return _productPrice;
  }

  int get productListingTime {
    return _productListingTime;
  }
}
