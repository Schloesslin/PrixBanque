import 'package:flutter/material.dart';
import 'package:prix_banque/home_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:prix_banque/welcome_page.dart';

import 'component/transaction_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  static FirebaseUser user;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  onRefresh(userCred) {
    setState(() {
      MyApp.user = userCred;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MyApp.user == null) {
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
      routes: {
        ExtractArgumentsScreen.routeName: (context) => ExtractArgumentsScreen(),
      },
    );
  }
}
