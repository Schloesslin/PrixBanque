import 'package:flutter/material.dart';
import 'package:prix_banque/controller.dart';
import 'package:prix_banque/home_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:prix_banque/connexion.dart';
import 'package:prix_banque/welcome_page.dart';
import 'package:provider/provider.dart';

import 'component/transaction_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(
    indexHome: 1,
    indexWelcome: 0,
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  static FirebaseUser user;
  static String userEmail;
  int indexHome;
  int indexWelcome;
  MyApp({@required this.indexWelcome, @required this.indexHome});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  onRefresh(userCred) {
    setState(() {
      MyApp.user = userCred;
      MyApp.userEmail = MyApp.user.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Controller.instance(auth: FirebaseAuth.instance),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthHomePage(
          indexWelcome: widget.indexWelcome,
          indexHome: widget.indexHome,
        ),
      ),
    );
  }
}
