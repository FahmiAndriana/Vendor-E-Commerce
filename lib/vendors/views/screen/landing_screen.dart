import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:seller_e_commerce/vendors/models/vendor_user_models.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final CollectionReference _vendorStream =
        FirebaseFirestore.instance.collection('vendors');
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
      stream: _vendorStream.doc(_auth.currentUser!.uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        VendorUserModel vendorUserModel = VendorUserModel.fromJson(
            snapshot.data!.data()! as Map<String, dynamic>);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  vendorUserModel.storeImage.toString(),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(vendorUserModel.bussinessName.toString()),
              SizedBox(
                height: 15,
              ),
              Text(
                  "Your Application has been send to admin, Admin will get back to you soon"),
              TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  child: Text("Sign Out"))
            ],
          ),
        );
      },
    ));
  }
}
