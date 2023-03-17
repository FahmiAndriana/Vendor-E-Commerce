import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:seller_e_commerce/vendors/provider/product_provider.dart';

class ShippingUploadScreen extends StatefulWidget {
  @override
  State<ShippingUploadScreen> createState() => _ShippingUploadScreenState();
}

class _ShippingUploadScreenState extends State<ShippingUploadScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool? _chargeShipping = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);

    return Column(
      children: [
        CheckboxListTile(
            title: Text("Charge Shipping"),
            value: _chargeShipping,
            onChanged: (value) {
              setState(() {
                _chargeShipping = value;
                _productProvider.getFormData(chargeShipping: _chargeShipping);
              });
            }),
        if (_chargeShipping == true)
          Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please fields Must not be empty';
                }
                return null;
              },
              onChanged: (value) {
                _productProvider.getFormData(shippingCharge: int.parse(value));
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Shipping Charge'),
            ),
          )
      ],
    );
  }
}
