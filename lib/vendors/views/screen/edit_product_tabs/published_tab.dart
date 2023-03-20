import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:seller_e_commerce/vendors/views/screen/vendor_product_detail/vendor_product_detail.dart';
import 'package:intl/intl.dart';

class PublishedScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorProductStream = FirebaseFirestore
        .instance
        .collection('products')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('approved', isEqualTo: true)
        .snapshots();
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: _vendorProductStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Container(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final vendorProductData = snapshot.data!.docs[index];
              final formatCurrency = NumberFormat("#,##0.00", "id_ID");
              final formattedProductPrice =
                  formatCurrency.format(vendorProductData['productPrice']);
              return Slidable(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return VendorProductDetail(
                          productData: vendorProductData,
                        );
                      },
                    ));
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 88,
                        width: 88,
                        child: Image.network(vendorProductData['imageUrl'][0]),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vendorProductData['productName']),
                          Text(
                            '\Rp ' + formattedProductPrice,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                key: const ValueKey(0),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      flex: 2,
                      onPressed: (context) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delet Product'),
                              content:
                                  Text('Are you sure want delet this product?'),
                              actions: [
                                TextButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Yes'),
                                  onPressed: () async {
                                    await _firestore
                                        .collection('products')
                                        .doc(vendorProductData['productId'])
                                        .delete();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      flex: 2,
                      onPressed: (context) async {
                        await _firestore
                            .collection('products')
                            .doc(vendorProductData['productId'])
                            .update({
                          'approved': false,
                        });
                      },
                      backgroundColor: Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.mobile_off_outlined,
                      label: 'Unpublish',
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ));
    ;
  }
}
