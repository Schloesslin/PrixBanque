import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  final Function(FirebaseUser) onSignIn;
  HomePage({@required this.onSignIn});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();
  String error = "";

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
                Text(error),
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
        controller: _hint=="First name" ? controllerName : controllerLastName,
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
    // ignore: unused_local_variable
    try {
      AuthResult userResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: controllerEmail.text, password: controllerPassword.text);
    }
    catch(error) {
      return;
    }
    // onCreate(userResult.user);
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DatabaseReference _ref = FirebaseDatabase.instance.reference().child(user.uid).child("Main account");
    _ref.push().set({'Account number': Random().nextInt(99999999),'Balance' : 0,'First Name' : controllerName.text, 'Last Name' : controllerLastName.text});
  }

  Future<void> _signIn() async {
    AuthResult userResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: controllerEmail.text, password: controllerPassword.text);
    widget.onSignIn(userResult.user);
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
