import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

import 'package:prix_banque/forgot_pass.dart';

class HomePage extends StatefulWidget {
  final Function(FirebaseUser) onSignIn;
  HomePage({@required this.onSignIn});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 1;
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();
  String error = "";
  final databaseReference = Firestore.instance;

  Widget _refreshTitle(int _index) {
    if (_index == 0) {
      return Text(
        "Sign up",
        style: TextStyle(fontSize: 40),
      );
    }
    return Text(
      "Sign in",
      style: TextStyle(fontSize: 40),
    );
  }

  Widget _refreshBody(int _index) {
    if (_index == 0) {
      return SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 50),
            width: 250,
            child: new Column(
              children: [
                _createInputFormField("First name", "classic"),
                _createInputFormField("Last name", "classic"),
                _createInputFormField("E-mail", "email"),
                _createInputFormField("Password", "password"),
                _createButton("Create account"),
              ],
            ),
          ),
        ),
      );
    }
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 50),
        width: 250,
        child: new Column(
          children: [
            _createInputFormField("E-mail", "email"),
            _createInputFormField("Password", "password"),
            _createButton("Login"),
            MaterialButton(
              minWidth: 250,
              textColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(23.0),
              ),
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: () {
                _forgotPass();
              },
              child: Text(
                "Forgot your password ?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createAppBar() {
    return AppBar(
      title: _refreshTitle(index),
      centerTitle: true,
      toolbarHeight: 100,
    );
  }

  Widget _createBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (_index) {
        setState(() {
          index = _index;
        });
      },
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: "Sign up",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: "Sign in",
        ),
      ],
    );
  }

  Widget _createInputFormField(String _hint, String _type) {
    if (_type == "password") {
      return Container(
        margin: EdgeInsets.only(bottom: 5),
        child: TextFormField(
          controller: controllerPassword,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key_outlined),
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
        controller: _hint == "First name" ? controllerName : controllerLastName,
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
    if (_text == "Login") {
      return MaterialButton(
        minWidth: 250,
        color: Colors.blue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(23.0),
        ),
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          _signIn();
        },
        child: Text(
          _text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25),
        ),
      );
    }
    return MaterialButton(
      minWidth: 250,
      color: Colors.blue,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(23.0),
      ),
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      onPressed: () {
        _createUser();
      },
      child: Text(
        _text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25),
      ),
    );
  }

  Future<void> _createUser() async {
    try {
      // ignore: unused_local_variable
      AuthResult userResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: controllerEmail.text.trim(),
              password: controllerPassword.text);
    } catch (e) {
      setState(() {
        error = e.message;
      });
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error connection'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(error),
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
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DatabaseReference _ref =
        FirebaseDatabase.instance.reference().child("Customers");
    //Offre de lancement
    //TODO : recuperation de l'attribut count et incrémentation en fonction
    int _usernumber = await getCount(_ref);
    if (_usernumber <= 10000) {
      _ref.child(user.uid).child("Main account").set({
        'Account number': Random().nextInt(99999999),
        'Balance': 1000,
        'First Name': controllerName.text,
        'Last Name': controllerLastName.text
      });
    } else {
      _ref.child(user.uid).child("Main account").set({
        'Account number': Random().nextInt(99999999),
        'Balance': 0,
        'First Name': controllerName.text,
        'Last Name': controllerLastName.text
      });
    }

    await databaseReference.collection("Users").document().setData(
      {
        'uid': user.uid,
        'First Name': controllerName.text,
        'Last Name': controllerLastName.text,
        'mail': user.email
      },
    );
  }

  Future<void> _signIn() async {
    try {
      AuthResult userResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: controllerEmail.text.trim(),
              password: controllerPassword.text);
      widget.onSignIn(userResult.user);
    } catch (e) {
      setState(() {
        error = e.message;
      });
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error connection'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(error),
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

  void _forgotPass() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotPass(),
      ),
    );
  }

  Future<int> getCount(DatabaseReference db) async {
    int result = (await db.child("_count").once()).value;
    return result + 1;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _createAppBar(),
        bottomNavigationBar: _createBottomNavigationBar(),
        body: _refreshBody(index),
      ),
    );
  }
}
