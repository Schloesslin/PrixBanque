import 'package:flutter/material.dart';
import 'package:prix_banque/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:prix_banque/transfert_attente_page.dart';
import 'package:prix_banque/transfert_immediat_page.dart';
import 'package:prix_banque/transfert_programme_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int index = 0;
  String _account = "";
  String _name = "";
  String _lastname = "";
  String _balance = "";
  DateTime today = new DateTime.now().toLocal();

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

  Widget _refreshBody(int _index) {
    if (_index == 0) {
      //Pour éviter de faire trop d'appels inutiles
      if (_name == "") {
        print("laaaa");
        _getUserData();
      }
      return Container(
        alignment: Alignment.topCenter,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.account_balance_sharp),
                    title: Text('Bonjour, ' + _name + ' ' + _lastname + ' !'),
                    subtitle: Text("Nous sommes le " +
                        today.day.toString() +
                        "/" +
                        today.month.toString() +
                        "/" +
                        today.year.toString() +
                        "et il est " +
                        today.hour.toString() +
                        "h" +
                        today.minute.toString()),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 8),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet_rounded),
                    title: Text(
                      'Compte principal',
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                    subtitle: Text("N° de compte : " + _account,
                        style: TextStyle(
                          height: 5,
                          fontSize: 10.0,
                        )),
                    trailing: Text(_balance + " \$",
                        style: TextStyle(
                          fontSize: 22,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    } else if (index == 2) {
      return _createVirementBody();
    }
    return Container();
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

  Future<void> _getUserData() async {
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      DatabaseReference _ref = FirebaseDatabase.instance
          .reference()
          .child("Customers")
          .child(user.uid)
          .child("Main account");
      await _ref.once().then((DataSnapshot data) {
        Map<dynamic, dynamic> map = data.value;
        _account = map.values.toList()[0]["Account number"].toString();
        _name = map.values.toList()[0]["First Name"];
        _lastname = map.values.toList()[0]["Last Name"];
        _balance = map.values.toList()[0]["Balance"].toString();
      });
    } catch (e) {
      print("error : " + (e.toString()));
    }
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
