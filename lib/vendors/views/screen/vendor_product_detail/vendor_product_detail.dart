import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VendorProductDetail extends StatefulWidget {
  final dynamic productData;

  const VendorProductDetail({super.key, required this.productData});

  @override
  State<VendorProductDetail> createState() => _VendorProductDetailState();
}

class _VendorProductDetailState extends State<VendorProductDetail> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _productNameC = TextEditingController();
  final TextEditingController _brandNameC = TextEditingController();
  final TextEditingController _quantityC = TextEditingController();
  final TextEditingController _priceC = TextEditingController();
  final TextEditingController _descriptionC = TextEditingController();
  final TextEditingController _categoryC = TextEditingController();
  double? productPrice;
  int? quantity;
  @override
  void initState() {
    setState(() {
      _productNameC.text = widget.productData['productName'];
      _brandNameC.text = widget.productData['brandName'];
      _quantityC.text = widget.productData['quantity'].toString();
      _priceC.text = widget.productData['productPrice'].toString();
      _descriptionC.text = widget.productData['description'];
      _categoryC.text = widget.productData['category'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Center(
              child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null) {
                    return 'Name must not be empty';
                  }
                },
                controller: _productNameC,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              SizedBox(height: 14),
              TextFormField(
                validator: (value) {
                  if (value == null) {
                    return 'Name must not be empty';
                  }
                },
                controller: _brandNameC,
                decoration: InputDecoration(labelText: 'Brand Name'),
              ),
              SizedBox(height: 14),
              TextFormField(
                validator: (value) {
                  if (value == null) {
                    return 'Price must not be empty';
                  }
                },
                onChanged: (value) {
                  productPrice = double.parse(value);
                },
                controller: _priceC,
                decoration: InputDecoration(labelText: 'Product Price'),
              ),
              SizedBox(height: 14),
              TextFormField(
                validator: (value) {
                  if (value == null) {
                    return 'Quantity must not be empty';
                  }
                },
                onChanged: (value) {
                  quantity = int.parse(value);
                },
                controller: _quantityC,
                decoration: InputDecoration(labelText: 'Product Quantity'),
              ),
              SizedBox(height: 14),
              TextFormField(
                validator: (value) {
                  if (value == null) {
                    return 'Desc must not be empty';
                  }
                },
                maxLength: 700,
                maxLines: 5,
                controller: _descriptionC,
                decoration: InputDecoration(labelText: 'Product Description'),
              ),
              SizedBox(height: 14),
              TextFormField(
                enabled: false,
                controller: _categoryC,
                decoration: InputDecoration(labelText: 'Product Category'),
              ),
              SizedBox(height: 40),
              InkWell(
                onTap: () async {
                  // if (productPrice != null) {
                  await _firestore
                      .collection('products')
                      .doc(widget.productData['productId'])
                      .update({
                    'productName': _productNameC.text,
                    'brandName': _brandNameC.text,
                    'quantity': quantity ?? widget.productData['quantity'],
                    'productPrice':
                        productPrice ?? widget.productData['productPrice'],
                    'description': _descriptionC.text
                  }).whenComplete(() {
                    Navigator.of(context).pop();
                  });
                  // } else {
                }
                // }
                ,
                child: Container(
                  height: 65,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Center(
                      child: Text(
                    'Update Product',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
