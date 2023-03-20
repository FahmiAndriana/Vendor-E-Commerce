import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:seller_e_commerce/vendors/views/screen/vendor_inner_screen/withdraw_screen.dart';

class EarnScreen extends StatefulWidget {
  const EarnScreen({super.key});

  @override
  State<EarnScreen> createState() => _EarnScreenState();
}

class _EarnScreenState extends State<EarnScreen> {
  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');
  final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
      .collection('orders')
      .where('accepted', isEqualTo: true)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: vendors.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(data['storeImage']),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '\Hi, ' + data['bussinessName'],
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: _ordersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                double totalOrders = 0.0;
                for (var orderitem in snapshot.data!.docs) {
                  totalOrders += orderitem['productPrice'];
                }
                dynamic totalItems = 0;
                for (var orderitem in snapshot.data!.docs) {
                  totalItems += orderitem['quantity'];
                }

                final formatCurrency = NumberFormat("#,##0.00", "id_ID");
                final formattedTotalOrders = formatCurrency.format(totalOrders);

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width - 60,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Text(
                                  'Total Earning',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Text('\Rp ' + formattedTotalOrders.toString(),
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width - 60,
                          decoration: BoxDecoration(
                              color: Colors.yellow[900],
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Text(
                                  'Total Orders',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Text(snapshot.data!.docs.length.toString(),
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width - 60,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Text(
                                  'Total Items Sold',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Text(totalItems.toString(),
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            bottomSheet: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return WithdrawScreen();
                  },
                ));
              },
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(
                    child: Text(
                  'Withdraw',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
              ),
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
