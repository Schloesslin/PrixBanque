import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prixbanqueapp/component/transactions_list.dart';
// import 'package:google_fonts/google_fonts.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  CollectionReference userTransactions =
      Firestore.instance.collection('/Trades/test-user/trades');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu_rounded),
            padding: EdgeInsets.only(left: 8),
            onPressed: () {},
          ),
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: TransactionList(
              isResume: true,
              listOfTransactions: userTransactions,
            )));
  }
}
