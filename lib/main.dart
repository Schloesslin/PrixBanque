import 'package:flutter/material.dart';
import 'package:prixbanqueapp/account_page.dart';
import 'package:prixbanqueapp/component/transaction_details.dart';
import 'package:prixbanqueapp/home_page.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AccountPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        ExtractArgumentsScreen.routeName: (context) => ExtractArgumentsScreen(),
      },
    );
  }
}
