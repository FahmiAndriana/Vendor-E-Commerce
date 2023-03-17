import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:seller_e_commerce/vendors/views/screen/edit_product_tabs/published_tab.dart';
import 'package:seller_e_commerce/vendors/views/screen/edit_product_tabs/unpublished_tab.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Manage Product'),
            bottom: TabBar(tabs: [
              Tab(
                child: Text('Published'),
              ),
              Tab(
                child: Text('Unpublished'),
              )
            ]),
          ),
          body: TabBarView(children: [PublishedScreen(), UnpublishedScreen()]),
        ));
  }
}
