import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:seller_e_commerce/vendors/views/screen/earn_screen.dart';
import 'package:seller_e_commerce/vendors/views/screen/edit_screen.dart';
import 'package:seller_e_commerce/vendors/views/screen/logout_screen.dart';
import 'package:seller_e_commerce/vendors/views/screen/order_screen.dart';
import 'package:seller_e_commerce/vendors/views/screen/upload_screen.dart';

class MainVendorScreen extends StatefulWidget {
  MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

int _pageIndex = 0;

class _MainVendorScreenState extends State<MainVendorScreen> {
  List<Widget> _pages = [
    EarnScreen(),
    UploadScreen(),
    EditScreen(),
    OrderScreen(),
    LogOutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.attach_money_outlined), label: 'Earnings'),
            BottomNavigationBarItem(
                icon: Icon(Icons.file_upload_outlined), label: 'Upload'),
            BottomNavigationBarItem(
                icon: Icon(Icons.edit_document), label: 'Edit'),
            BottomNavigationBarItem(
                icon: Icon(Icons.delivery_dining_sharp), label: 'Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
          ]),
      body: _pages[_pageIndex],
    );
  }
}
