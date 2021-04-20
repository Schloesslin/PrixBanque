import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class TransfertProgrammePage extends StatefulWidget {
  @override
  _TransfertProgrammePageState createState() => _TransfertProgrammePageState();
}

class _TransfertProgrammePageState extends State<TransfertProgrammePage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerValue = TextEditingController();
  String result = "";
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
