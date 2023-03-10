import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:seller_e_commerce/vendors/controllers/vendor_regist_controller.dart';
import 'package:image_picker/image_picker.dart';

class VendorRegisterScreen extends StatefulWidget {
  @override
  State<VendorRegisterScreen> createState() => _VendorRegisterScreenState();
}

class _VendorRegisterScreenState extends State<VendorRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final VendorController _vendorController = VendorController();
  late String bussinessName;
  late String email;
  late String phoneNumber;
  late String countryValue;
  late String stateValue;
  late String cityValue;
  String? _taxStatus;
  String? taxNumber;
  List<String> _taxOption = ['Yes', 'No'];
  Uint8List? _image;

  selectGalleryImage() async {
    Uint8List? im = await _vendorController.pickStoreImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  selectCameraImage() async {
    Uint8List? im = await _vendorController.pickStoreImage(ImageSource.camera);
    setState(() {
      _image = im;
    });
  }

  _saveVendorDetail() {
    EasyLoading.show(status: 'Please Wait');
    if (_formKey.currentState!.validate()) {
      print('Good');
      _vendorController
          .registerVendor(bussinessName, email, phoneNumber, countryValue,
              stateValue, cityValue, _taxStatus!, taxNumber ?? '', _image)
          .whenComplete(() {
        EasyLoading.dismiss();
        setState(() {
          _formKey.currentState!.reset();

          _image = null;
        });
      });
    }
    print('Bad');
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 200,
            flexibleSpace: LayoutBuilder(
              builder: (context, Constraints) {
                return FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellow.shade900,
                          Colors.yellow,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(
                                      _image!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : IconButton(
                                    icon: Icon(
                                      Icons.person,
                                      size: 80,
                                      color: Colors.grey[300],
                                    ),
                                    onPressed: () {
                                      selectGalleryImage();
                                    },
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          bussinessName = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Name must not be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email must not be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                      ),
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          phoneNumber = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Phone number must not be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    Text("Address"),
                    SizedBox(height: 10),
                    SelectState(
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value;
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value;
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value;
                        });
                      },
                    ),
                    Row(
                      children: [
                        Text("Tax Registered"),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          child: Container(
                            width: 100,
                            child: DropdownButtonFormField(
                                hint: Text('Select'),
                                items: _taxOption.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                      value: value, child: Text(value));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _taxStatus = value;
                                  });
                                }),
                          ),
                        )
                      ],
                    ),
                    if (_taxStatus == 'Yes')
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            taxNumber = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Tax Number must not be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Tax Number',
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _saveVendorDetail();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 40,
                        child: Center(
                            child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 3),
                        )),
                        decoration: BoxDecoration(
                            color: Colors.yellow.shade900,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
