import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prix_banque/main.dart';

class TransfertImmediatPage extends StatefulWidget {
  static const tag = "transfert_immediat";
  static FirebaseUser user;
  @override
  _TransfertImmediatPageState createState() => _TransfertImmediatPageState();
}

class _TransfertImmediatPageState extends State<TransfertImmediatPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerValue = TextEditingController();
  TextEditingController controllerQuestion = TextEditingController();
  TextEditingController controllerResponse = TextEditingController();
  String result = "";
  final databaseReference = Firestore.instance;
  Widget _createAppBar() {
    return AppBar(
      title: Text(
        "Virement immédiat",
        style: TextStyle(fontSize: 30),
      ),
      centerTitle: true,
      toolbarHeight: 100,
      leading: Container(
        margin: EdgeInsets.only(left: 15),
        child: GestureDetector(
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
          controller: controllerValue,
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
    } else if (_type == "question") {
      return Container(
        margin: EdgeInsets.only(bottom: 5),
        child: TextFormField(
          controller: controllerQuestion,
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
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: TextFormField(
        controller: controllerResponse,
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
            this.result = "Demande de virement envoyée";
          });
          _sendTransfert();
        },
        child: Text(
          _text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }

  Future<void> _sendTransfert() async {
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
        .where('mail', isEqualTo: MyApp.user.email)
        .snapshots();
    messagesSnapshot = await messagesStream.first;
    String authName = messagesSnapshot.documents.first['First Name'] +
        " " +
        messagesSnapshot.documents.first['Last Name'];
    int id = Random().nextInt(99999999);
    await databaseReference
        .collection("Factures")
        .document(MyApp.user.email)
        .collection("send")
        .document(id.toString())
        .setData(
      {
        'dest': controllerEmail.text,
        'dest name': destName,
        'question': controllerQuestion.text,
        'response': controllerResponse.text,
        'value': controllerValue.text,
        'type': "Immédiat"
      },
    );

    await databaseReference
        .collection("Factures")
        .document(controllerEmail.text)
        .collection("receive")
        .document(id.toString())
        .setData(
      {
        'auth': MyApp.user.email,
        'auth name': authName,
        'question': controllerQuestion.text,
        'response': controllerResponse.text,
        'value': controllerValue.text,
        'type': "Immédiat"
      },
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
              _createInputFormField("Question de sécurité", "question"),
              _createInputFormField("Réponse", "reponse"),
              _createButton("Envoyer"),
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
