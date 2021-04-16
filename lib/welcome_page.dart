import 'package:flutter/material.dart';
import 'package:prixbanqueapp/main.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int index = 0;

  Widget _refreshTitle(int _index) {
    if (_index == 0) {
      return Text(
        "Compte",
        style: TextStyle(fontSize: 40),
      );
    } else if (_index == 1) {
      return Text(
        "Factures",
        style: TextStyle(fontSize: 40),
      );
    }
    return Text(
      "Transferts",
      style: TextStyle(fontSize: 40),
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
          label: "Compte",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: "Factures",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: "Transferts",
        ),
      ],
    );
  }

  Widget _createAppBar() {
    return AppBar(
      title: _refreshTitle(index),
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
          Icons.logout,
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
        bottomNavigationBar: _createBottomNavigationBar(),
      ),
    );
  }
}
