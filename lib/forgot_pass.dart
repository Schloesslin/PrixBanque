import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class ForgotPass extends StatefulWidget {
  static const tag = "forgot_page";

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController controllerEmail = TextEditingController();

  Widget _createAppBar() {
    return AppBar(
      title: Text("Forgot password"),
      centerTitle: true,
      toolbarHeight: 100,
      leading: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute<void>(builder: (BuildContext context) {
            return MyApp();
          }));
          return MyApp();
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
      minWidth: 250,
      color: Colors.blue,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(23.0),
      ),
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      onPressed: () {
        _resetPass();
      },
      child: Text(
        _text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Future<void> _resetPass() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: controllerEmail.text.trim());
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Mail sent'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "An email with reset password instructions has been send",
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error send password'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(e.message),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
