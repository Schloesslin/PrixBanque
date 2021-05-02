import 'dart:math';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prix_banque/main.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';

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

  Future<HttpsCallableResult> _checkTransactionData(data) async {
    HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: "DataCheckServices-check_data_transfert");
      final HttpsCallableResult result =  await callable.call(data);
      return result;
  }

  Future<HttpsCallableResult> _checkMailPresence(data) async {
    HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: "DataCheckServices-check_mail_presence");
    final HttpsCallableResult result =  await callable.call(data);
    return result;
  }

  Future<HttpsCallableResult> writeTransaction(data) async {
    HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: "transfertServices-getUsersAndTransaction");
    final HttpsCallableResult result =  await callable.call(data);
    return result;
  }


  Future<void> _sendTransfert() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    // Create the arguments to the callable function.
    var data = {'emitter': user.uid, 'value': controllerValue.text,'receiver_email':controllerEmail.text.trim()};
    var enough_in_balance = await _checkTransactionData(data).then((value) {
        print(value.data);
        return value.data;
    });

    if(enough_in_balance) {
      //Vérification de la présence email destinataire
      var mail = await _checkMailPresence(data).then((value) {
        print(value.data);
        return value.data;
      });
      if(mail) {
        await writeTransaction(data).then((value) {
          print("write done");
        });
        print("procede transaction");
      } else {
        showAlertDialog(this.context, "Viremant annulé", "Le destinataire n'est pas un utilisateur de PrixBanque.");
        return;
      }
    }
    else {
      //
      showAlertDialog(this.context, "Virement refusé", "Le solde de votre compte ne vous permet pas de réaliser ce virement.");
      return;
    }
  }

  showAlertDialog(BuildContext context, String title, String content) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop(); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
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
