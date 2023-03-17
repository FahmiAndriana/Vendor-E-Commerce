import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller_e_commerce/vendors/models/vendor_user_models.dart';
import 'package:seller_e_commerce/vendors/views/auth/vendor_register_auth.dart';

import 'package:seller_e_commerce/vendors/views/screen/landing_screen.dart';
import 'package:seller_e_commerce/vendors/views/screen/main_vender_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

bool logout = false;

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
            if (!snapshot.data!.exists) {
              return VendorRegisterScreen();
            }

            final data = snapshot.data?.data();
            if (data == null) {
              return Placeholder();
            }

            VendorUserModel vendorUserModel = VendorUserModel.fromJson(
              data as Map<String, dynamic>,
            );

            if (vendorUserModel.approved == true) {
              return MainVendorScreen();
            } else {
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
                    Text(
                      vendorUserModel.bussinessName.toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                          "Your Application has been send to admin, Admin will get back to you soon"),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _auth.signOut();
                        print("logout");
                      },
                      child: Text('LogOut'),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
