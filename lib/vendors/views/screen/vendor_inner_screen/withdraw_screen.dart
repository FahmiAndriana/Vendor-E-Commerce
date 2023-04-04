import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:seller_e_commerce/vendors/views/screen/earn_screen.dart';
import 'package:uuid/uuid.dart';

class WithdrawScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formLey = GlobalKey<FormState>();
  final TextEditingController amountC = TextEditingController();
  late String amount;
  late String name;
  late String mobile;
  late String bankName;
  late String bankNameAccount;
  late String bankNumberAccount;
  late String branch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formLey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please amount Must not be empty';
                    }
                    return null;
                  },
                  controller: amountC,
                  onChanged: (value) {
                    amount = value;
                  },
                  decoration: InputDecoration(labelText: 'Amount'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Name Must not be empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Mobile Must not be empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    mobile = value;
                  },
                  decoration: InputDecoration(labelText: 'Mobile'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Name Bank Must not be empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    bankName = value;
                  },
                  decoration: InputDecoration(labelText: 'Name Bank'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Branch Must not be empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    branch = value;
                  },
                  decoration: InputDecoration(labelText: 'Branch'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Account Name Must not be empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    bankNameAccount = value;
                  },
                  decoration: InputDecoration(labelText: 'Account Name '),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Account Number Must not be empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    bankNumberAccount = value;
                  },
                  decoration: InputDecoration(labelText: 'Account Number'),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () async {
                    if (_formLey.currentState!.validate()) {
                      await _firestore
                          .collection('withdraw')
                          .doc(Uuid().v4())
                          .set({
                        'amount': amount,
                        'name': name,
                        'mobile': mobile,
                        'bankName': bankName,
                        'branch': branch,
                        'bankNameAccoubt': bankNameAccount,
                        'bankNumberAccount': bankNumberAccount,
                        'vendorId': FirebaseAuth.instance.currentUser!.uid,
                        'approved': false,
                      }).whenComplete(() {
                        Navigator.pop(context);
                        _formLey.currentState!.reset();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Withdraw succesfully submitted!'),
                        ));
                      });
                    } else {}
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
