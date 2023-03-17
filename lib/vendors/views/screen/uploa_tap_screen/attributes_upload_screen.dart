import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:seller_e_commerce/vendors/provider/product_provider.dart';

class AttributesUploadScreen extends StatefulWidget {
  const AttributesUploadScreen({super.key});

  @override
  State<AttributesUploadScreen> createState() => _AttributesUploadScreenState();
}

class _AttributesUploadScreenState extends State<AttributesUploadScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _sizeController = TextEditingController();

  bool _entered = false;
  List<String> _sizeList = [];
  bool _isSave = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please fields Must not be empty';
              }
              return null;
            },
            onChanged: (value) {
              _productProvider.getFormData(brandname: value);
            },
            decoration: InputDecoration(labelText: 'Brand'),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  width: 100,
                  child: TextFormField(
                    controller: _sizeController,
                    onChanged: (value) {
                      setState(() {
                        _entered = true;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Size',
                    ),
                  ),
                ),
              ),
              _entered == true
                  ? ElevatedButton(
                      onPressed: () {
                        _sizeList.add(_sizeController.text);
                        _sizeController.clear();
                      },
                      child: Text('Add'))
                  : Text(""),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          if (_sizeList.isNotEmpty)
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _sizeList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _sizeList.removeAt(index);
                        _productProvider.getFormData(sizeList: _sizeList);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text(_sizeList[index])),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  );
                },
              ),
            ),
          if (_sizeList.isNotEmpty)
            ElevatedButton(
                onPressed: () {
                  _productProvider.getFormData(sizeList: _sizeList);
                  setState(() {
                    _isSave = true;
                  });
                },
                child: Text(
                  _isSave ? "Saved" : "Save",
                  style: TextStyle(fontSize: 20, letterSpacing: 2),
                ))
        ],
      ),
    );
  }
}
