import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prix_banque/component/transactions_list.dart';

class TransactionPage extends StatefulWidget {
  final CollectionReference transactionList;
  TransactionPage({Key key, @required this.transactionList}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: TransactionList(
          isResume: false, listOfTransactions: widget.transactionList),
    );
  }
}
