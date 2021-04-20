import 'package:flutter/material.dart';
import 'package:prixbanqueapp/main.dart';
import 'package:prixbanqueapp/transfert_attente_page.dart';
import 'package:prixbanqueapp/transfert_immediat_page.dart';
import 'package:prixbanqueapp/transfert_programme_page.dart';

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
      actions: [
        Container(
          margin: EdgeInsets.only(right: 15),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return MyApp();
                  },
                ),
              );
              return MyApp();
            },
            child: Icon(
              Icons.logout,
            ),
          ),
        ),
      ],
    );
  }

  Widget _createButton(String _text) {
    if (_text == "Immediat") {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransfertImmediatPage(),
              ),
            );
          },
          child: Text(
            "Virement immédiat",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
        ),
      );
    }
    if (_text == "Programme") {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransfertProgrammePage(),
              ),
            );
          },
          child: Text(
            "Virement programmé",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
        ),
      );
    }
    return MaterialButton(
      minWidth: 300,
      color: Colors.blue,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(23.0),
      ),
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransfertAttentePage(),
          ),
        );
      },
      child: Text(
        "Virements en attente",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25),
      ),
    );
  }

  Widget _refreshBody(int _index) {
    if (_index == 0) {
      return Container();
    } else if (_index == 1) {
      return Container();
    }
    return _createVirementBody();
  }

  Widget _createVirementBody() {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _createButton("Immediat"),
          _createButton("Programme"),
          _createButton("Attente"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _createAppBar(),
        body: _refreshBody(index),
        bottomNavigationBar: _createBottomNavigationBar(),
      ),
    );
  }
}
