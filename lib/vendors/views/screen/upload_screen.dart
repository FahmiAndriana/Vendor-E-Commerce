import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:seller_e_commerce/vendors/provider/product_provider.dart';
import 'package:seller_e_commerce/vendors/views/screen/main_vender_screen.dart';
import 'package:seller_e_commerce/vendors/views/screen/uploa_tap_screen/attributes_upload_screen.dart';
import 'package:seller_e_commerce/vendors/views/screen/uploa_tap_screen/general_upload_screen.dart';
import 'package:seller_e_commerce/vendors/views/screen/uploa_tap_screen/images_upload_screen.dart';
import 'package:seller_e_commerce/vendors/views/screen/uploa_tap_screen/shipping_upload_screen.dart';
import 'package:uuid/uuid.dart';

class UploadScreen extends StatefulWidget {
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

final _generalFormKey = GlobalKey<FormState>();
final _shippingFormKey = GlobalKey<FormState>();
final _attributesFormKey = GlobalKey<FormState>();
final _imagesFormKey = GlobalKey<FormState>();

class _UploadScreenState extends State<UploadScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: [
            Tab(
              child: Text("General"),
            ),
            Tab(
              child: Text("Shipping"),
            ),
            Tab(
              child: Text("Attributes"),
            ),
            Tab(
              child: Text("Images"),
            ),
          ]),
        ),
        body: TabBarView(children: [
          Form(
            key: _generalFormKey,
            child: GeneralUploadScreen(),
          ),
          Form(
            key: _shippingFormKey,
            child: ShippingUploadScreen(),
          ),
          Form(
            key: _attributesFormKey,
            child: AttributesUploadScreen(),
          ),
          Form(
            key: _imagesFormKey,
            child: ImagesUploadScreen(),
          ),
        ]),
        bottomSheet: Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 20),
          child: ElevatedButton(
            child: Text("Upload"),
            onPressed: () async {
              EasyLoading.show();

              if (_generalFormKey.currentState!.validate() &&
                  _shippingFormKey.currentState!.validate() &&
                  _attributesFormKey.currentState!.validate() &&
                  _imagesFormKey.currentState!.validate()) {
                final productId = Uuid().v4();
                await _firestore.collection('products').doc(productId).set({
                  'productId': productId,
                  'productName': _productProvider.productData['productName'],
                  'productPrice': _productProvider.productData['productPrice'],
                  'quantity': _productProvider.productData['quantity'],
                  'category': _productProvider.productData['categories'],
                  'description': _productProvider.productData['description'],
                  'imageUrl': _productProvider.productData['imageUrlList'],
                  'scheduleDate': _productProvider.productData['dateTimeNow'],
                  'chargeShipping':
                      _productProvider.productData['chargeShipping'],
                  'shippingCharge':
                      _productProvider.productData['shippingCharge'],
                  'brandName': _productProvider.productData['brandname'],
                  'sizeList': _productProvider.productData['sizeList'],
                  'vendorId': FirebaseAuth.instance.currentUser!.uid,
                  'approved': false,
                }).whenComplete(() {
                  _productProvider.clearData();
                  _generalFormKey.currentState!.reset();
                  _shippingFormKey.currentState!.reset();
                  _attributesFormKey.currentState!.reset();
                  _imagesFormKey.currentState!.reset();
                  EasyLoading.dismiss();
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return MainVendorScreen();
                    },
                  ));
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
