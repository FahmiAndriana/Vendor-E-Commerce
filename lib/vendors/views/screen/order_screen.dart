import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('orders')
      .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  String formatDate(date) {
    final outPutDateFormat = DateFormat('dd/MM/yyyy');
    final outPutDate = outPutDateFormat.format(date);
    return outPutDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              final formatCurrency = NumberFormat("#,##0.00", "id_ID");
              final formattedProductPrice =
                  formatCurrency.format(document['productPrice']);
              return Column(
                children: [
                  Slidable(
                    child: Card(
                      child: ExpansionTile(
                        title: Row(
                          children: [
                            document['accepted'] == true
                                ? Icon(
                                    Icons.check_box_outlined,
                                    color: Colors.blue,
                                  )
                                : Icon(Icons.check_box_outline_blank_outlined,
                                    color: Colors.red),
                            SizedBox(
                              width: 30,
                            ),
                            document['accepted'] == true
                                ? Text('Accepted',
                                    style: TextStyle(color: Colors.blue))
                                : Text('On Progress',
                                    style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Product :'),
                                Text(
                                  document['productName'],
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Order Date :'),
                                Text(
                                  formatDate(document['orderDate'].toDate()),
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Price :'),
                                Text(
                                  '\Rp ' + formattedProductPrice,
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5),
                              child: Text(
                                'Buyers Detail',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Name :'),
                                Text(
                                  document['fullName'],
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Phone :'),
                                Text(
                                  document['phone'],
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Address :'),
                                Text(
                                  document['address'] ?? '',
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
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
                                  content: Text(
                                      'Are you sure want delet this product?'),
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
                                            .doc(document['orderId'])
                                            .update({
                                          'approved': false,
                                        });
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
                          icon: Icons.block,
                          label: 'Reject',
                        ),
                        SlidableAction(
                          flex: 2,
                          onPressed: (context) async {
                            await _firestore
                                .collection('products')
                                .doc(document['orderId'])
                                .update({
                              'approved': true,
                            });
                          },
                          backgroundColor: Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.check_circle,
                          label: 'Delivered',
                        ),
                      ],
                    ),
                  )
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
