import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seller_e_commerce/vendors/provider/product_provider.dart';
import 'package:uuid/uuid.dart';

class ImagesUploadScreen extends StatefulWidget {
  const ImagesUploadScreen({super.key});

  @override
  State<ImagesUploadScreen> createState() => _ImagesUploadScreenState();
}

class _ImagesUploadScreenState extends State<ImagesUploadScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final ImagePicker imagePicker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<File> _image = [];
  List<String> _imageUrlList = [];
  choiseImage() async {
    final _pickerFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (_pickerFile == null) {
      print('No Image Picker');
    } else {
      setState(() {
        _image.add(File(_pickerFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          itemCount: _image.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 8, childAspectRatio: 3 / 3),
          itemBuilder: (context, index) {
            return index != 0
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(
                            _image[index - 1],
                          ),
                          fit: BoxFit.cover),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          choiseImage();
                        },
                      ),
                    ),
                  );
          },
        ),
        SizedBox(
          height: 20,
        ),
        TextButton(
            onPressed: () async {
              for (var img in _image) {
                EasyLoading.show(status: "Upload Image");
                Reference ref =
                    _storage.ref().child('productImage').child(Uuid().v4());
                await ref.putFile(img).whenComplete(() async {
                  await ref.getDownloadURL().then((value) {
                    setState(() {
                      _imageUrlList.add(value);
                      _productProvider.getFormData(imageUrlList: _imageUrlList);

                      setState(() {
                        _productProvider.getFormData(
                            imageUrlList: _imageUrlList);
                        EasyLoading.dismiss();
                      });
                    });
                  });
                }).whenComplete(
                  () {
                    SnackBar(
                      content: Text('Image has been Uploaded'),
                      duration: Duration(seconds: 3),
                      action: SnackBarAction(
                        label: 'Close',
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    );
                  },
                );
              }
              setState(() {
                _image.clear();
              });
            },
            child: _image.isNotEmpty ? Text("Upload") : Text(""))
      ],
    );
  }
}
