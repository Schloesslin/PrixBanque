import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:prix_banque/controller.dart';
import 'package:prix_banque/main.dart';
import 'package:provider/provider.dart';

class TransfertProgrammePage extends StatefulWidget {
  @override
  _TransfertProgrammePageState createState() => _TransfertProgrammePageState();
}

class _TransfertProgrammePageState extends State<TransfertProgrammePage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerValue = TextEditingController();
  TextEditingController controllerQuestion = TextEditingController();
  TextEditingController controllerResponse = TextEditingController();
  String result = "";
  final databaseReference = Firestore.instance;
  DateTime selectedDate = DateTime.now();

  Widget _createAppBar() {
    return AppBar(
      title: Text(
        "Virement programmé",
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
        key: Key("tt"),
        onPressed: () {
          _sendTransfert();
          setState(() {
            this.result = "Demande de virement envoyée";
          });
        },
        child: Text(
          _text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25),
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
              _createDateInput(),
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

  Future<void> _sendTransfert() async {
    String date = DateManage.getDateString(selectedDate);
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

    DatabasePusher.pushTransfert(
        controllerEmail.text,
        id,
        Provider.of<Controller>(context, listen: false).user.email,
        authName,
        destName,
        controllerQuestion.text,
        controllerResponse.text,
        controllerValue.text,
        date);
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

class DateManage {
  static String getDateString(DateTime dateTime) {
    return dateTime.day.toString() +
        "/" +
        dateTime.month.toString() +
        "/" +
        dateTime.year.toString() +
        " - " +
        dateTime.hour.toString() +
        "h" +
        dateTime.minute.toString();
  }
}

class DatabasePusher {
  static Future<String> pushTransfert(
      String email,
      int id,
      String authmail,
      String authName,
      String destName,
      String question,
      String response,
      String value,
      String date) async {
    final databaseReference = Firestore.instance;
    try {
      await databaseReference
          .collection("Factures")
          .document(email)
          .collection("receive")
          .document(id.toString())
          .setData(
        {
          'auth': authmail,
          'auth name': authName,
          'question': question,
          'response': response,
          'value': value,
          'type': date
        },
      );
    } catch (e) {}
    try {
      await databaseReference
          .collection("Factures")
          .document(authName)
          .collection("send")
          .document(id.toString())
          .setData(
        {
          'dest': email,
          'dest name': destName,
          'question': question,
          'response': response,
          'value': value,
          'type': date
        },
      );
    } catch (e) {}
    return "Success";
  }
}
