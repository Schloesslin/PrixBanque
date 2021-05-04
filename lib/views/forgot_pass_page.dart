import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prix_banque/controller/controller.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class ForgotPass extends StatefulWidget {
  static const tag = "forgot_page";

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController controllerEmail = TextEditingController();
  String response = "";

  Widget _createAppBar() {
    //final controller = Provider.of<Controller>(context);
    return AppBar(
      title: Text("Forgot password"),
      centerTitle: true,
      toolbarHeight: 100,
      leading: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute<void>(builder: (BuildContext context) {
            return MyApp(
              indexHome: 1,
              indexWelcome: 0,
            );
          }));
          return MyApp(
            indexHome: 1,
            indexWelcome: 0,
          );
        },
        child: Icon(
          Icons.arrow_back,
        ),
      ),
    );
  }

  Widget _refreshBody() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(top: 50),
          width: 250,
          child: new Column(
            children: [
              _createInputFormField("E-mail", "email"),
              _createButton("Forgot your password"),
              Text(response),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createInputFormField(String _hint, String _type) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: TextFormField(
        key: Key("email"),
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

  Widget _createButton(String _text) {
    return MaterialButton(
      key: Key("sendpass"),
      minWidth: 250,
      color: Colors.blue,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(23.0),
      ),
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      onPressed: () async {
        sendPass(controllerEmail.text.trim());
        setState(() {
          response = "Un email a été envoyé";
        });
      },
      child: Text(
        _text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Future<bool> sendPass(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
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
