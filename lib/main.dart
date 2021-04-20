import 'package:flutter/material.dart';
import 'package:prixbanqueapp/forgot_pass.dart';
import 'package:prixbanqueapp/home_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:prixbanqueapp/transfert_immediat_page.dart';
import 'package:prixbanqueapp/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseUser user;

  onRefresh(userCred) {
    setState(() {
      user = userCred;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return MaterialApp(
        home: HomePage(
          onSignIn: (userCred) => onRefresh(userCred),
        ),
        debugShowCheckedModeBanner: false,
      );
    }
    return MaterialApp(
      home: WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
