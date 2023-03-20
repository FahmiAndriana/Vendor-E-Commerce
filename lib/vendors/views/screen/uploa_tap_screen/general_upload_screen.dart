import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:seller_e_commerce/vendors/provider/product_provider.dart';
import 'package:intl/intl.dart';

class GeneralUploadScreen extends StatefulWidget {
  const GeneralUploadScreen({super.key});

  @override
  State<GeneralUploadScreen> createState() => _GeneralUploadScreenState();
}

class _GeneralUploadScreenState extends State<GeneralUploadScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _categoryList = [];
  _getCategories() {
    return _firestore
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _categoryList.add(doc['categoryname']);
        });
      });
    });
  }

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  String formatDate(date) {
    final outputDateFormat = DateFormat('dd/MM/yyyy');

    final outputDate = outputDateFormat.format(date);
    return outputDate;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Name Must not be empty';
                  }
                  return null;
                },
                onChanged: (value) {
                  _productProvider.getFormData(productName: value);
                },
                decoration: InputDecoration(
                  labelText: 'Product Name',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Price Must not be empty';
                  }
                  return null;
                },
                onChanged: (value) {
                  _productProvider.getFormData(
                      productPrice: double.parse(value));
                },
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Quantity Must not be empty';
                  }
                  return null;
                },
                onChanged: (value) {
                  _productProvider.getFormData(quantity: int.parse(value));
                },
                decoration: InputDecoration(
                  labelText: 'Quantity',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Category Must not be empty';
                    }
                    return null;
                  },
                  hint: Text("Select Category"),
                  items: _categoryList.map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _productProvider.getFormData(categories: value);
                    });
                  }),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Desc Must not be empty';
                  }
                  return null;
                },
                onChanged: (value) {
                  _productProvider.getFormData(description: value);
                },
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(5000))
                            .then((value) {
                          _productProvider.getFormData(dateTimeNow: value);
                        });
                      },
                      child: Text("Schedule")),
                  SizedBox(
                    width: 20,
                  ),
                  _productProvider.productData['dateTimeNow'] != null
                      ? Text(formatDate(
                          _productProvider.productData['dateTimeNow']))
                      : Text("")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
