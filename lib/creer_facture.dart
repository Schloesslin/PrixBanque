import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/services.dart';
import 'package:prix_banque/controller.dart';
import 'package:provider/provider.dart';

class CreationFacturePage extends StatefulWidget {
  @override
  _CreationFacturePageState createState() => _CreationFacturePageState();
}

class _CreationFacturePageState extends State<CreationFacturePage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  DateTime selectedDate = DateTime.now();

  String result = "";

  Widget _createAppBar() {
    return AppBar(
      title: Text(
        "Creation Facture",
        style: TextStyle(fontSize: 30),
      ),
      centerTitle: true,
      toolbarHeight: 100,
      leading: Container(
        margin: EdgeInsets.only(left: 15),
        child: GestureDetector(
          key: Key("test"),
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
    );
  }

  Widget _createInputFormField(String _hint, String _type) {
    if (_type == "price") {
      return Container(
        margin: EdgeInsets.only(bottom: 5),
        child: TextFormField(
          controller: controllerPrice,
          inputFormatters: <TextInputFormatter>[],
          keyboardType: TextInputType.number,
          validator: (dynamic value) {
            if (value <= 0) this.result = "Error";
            return result;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.monetization_on_outlined),
            labelText: _hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      );
    } else if (_type == "email") {
      return Container(
        margin: EdgeInsets.only(bottom: 5),
        child: TextFormField(
          controller: controllerEmail,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail_outline),
            labelText: _hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: _hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  Widget _createDateInput() {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: DateTimeField(
        onDateSelected: (DateTime value) {
          setState(() {
            selectedDate = value;
          });
        },
        selectedDate: selectedDate,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.date_range_outlined),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  Widget _createButton(String _text) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: MaterialButton(
        minWidth: 300,
        color: Colors.blue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(23.0),
        ),
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          setState(() {
            this.result = "Facture Créer";
          });
          _CreateBill();
        },
        child: Text(
          _text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }

  Widget _refreshBody() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        child: Container(
          width: 250,
          margin: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              _createInputFormField("Email destinataire", "email"),
              _createInputFormField('Montant', "price"),
              _createDateInput(),
              _createButton("Valider"),
              Text(
                this.result,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _CreateBill() async {
    final databaseReference = Firestore.instance;
    int id = Random().nextInt(99999999);
    Stream<QuerySnapshot> messagesStream = databaseReference
        .collection("Users")
        .where('mail', isEqualTo: controllerEmail.text)
        .snapshots();

    QuerySnapshot messagesSnapshot = await messagesStream.first;
    String destName = messagesSnapshot.documents.first['First Name'] +
        " " +
        messagesSnapshot.documents.first['Last Name'];

    messagesStream = databaseReference
        .collection("Users")
        .where('mail',
            isEqualTo:
                Provider.of<Controller>(context, listen: false).user.email)
        .snapshots();
    messagesSnapshot = await messagesStream.first;
    String authName = messagesSnapshot.documents.first['First Name'] +
        " " +
        messagesSnapshot.documents.first['Last Name'];
    try {
      await databaseReference
          .collection("Bills")
          .document(controllerEmail.text.trim())
          .collection("receive")
          .document(id.toString())
          .setData(
        {
          'auth': Provider.of<Controller>(context, listen: false).user.email,
          'auth name': authName,
          'value': controllerPrice.text,
        },
      );
    } catch (e) {}
    try {
      await databaseReference
          .collection("Bills")
          .document(Provider.of<Controller>(context, listen: false).user.email)
          .collection("send")
          .document(id.toString())
          .setData(
        {
          'auth': controllerEmail.text.trim(),
          'auth name': destName,
          'value': controllerPrice.text,
        },
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _createAppBar(),
        body: _refreshBody(),
      ),
    );
  }
}
