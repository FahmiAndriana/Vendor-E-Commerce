import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic> productData = {};
  getFormData(
      {String? productName,
      double? productPrice,
      int? quantity,
      String? categories,
      String? description,
      DateTime? dateTimeNow,
      List<String>? imageUrlList,
      bool? chargeShipping,
      int? shippingCharge,
      String? brandname,
      List<String>? sizeList}) {
    if (productName != null) {
      productData['productName'] = productName;
    }

    if (productPrice != null) {
      productData['productPrice'] = productPrice;
    }

    if (quantity != null) {
      productData['quantity'] = quantity;
    }

    if (categories != null) {
      productData['categories'] = categories;
    }

    if (description != null) {
      productData['description'] = description;
    }

    if (dateTimeNow != null) {
      productData['dateTimeNow'] = dateTimeNow;
    }

    if (imageUrlList != null) {
      productData['imageUrlList'] = imageUrlList;
    }

    if (chargeShipping != null) {
      productData['chargeShipping'] = chargeShipping;
    }
    if (shippingCharge != null) {
      productData['shippingCharge'] = shippingCharge;
    }

    if (brandname != null) {
      productData['brandname'] = brandname;
    }

    if (sizeList != null) {
      productData['sizeList'] = sizeList;
    }
    notifyListeners();
  }

  clearData() {
    productData.cast();
    notifyListeners();
  }
}
