import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prix_banque/afficher_facture.dart';
import 'package:prix_banque/component/transactions_list.dart';
import 'package:prix_banque/controller.dart';
import 'package:prix_banque/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:prix_banque/transaction_page.dart';
import 'package:prix_banque/transfert_attente_page.dart';
import 'package:prix_banque/transfert_immediat_page.dart';
import 'package:prix_banque/transfert_programme_page.dart';
import 'package:prix_banque/creer_facture.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  int index;
  WelcomePage({@required this.index});
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _account = "";
  String _name = "";
  String _lastname = "";
  String _balance = "";
  DateTime today = new DateTime.now().toLocal();
  CollectionReference _transactionlist;

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
      //In case of immediate transactions
      _getUserData();
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
            SizedBox(height: 100),
            GestureDetector(
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
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
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransactionPage(
                            transactionList: _transactionlist)));
              },
            ),
            Text(
              "Vos dernières transactions",
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: TransactionList(
                  isResume: true, listOfTransactions: _transactionlist),
            )
          ],
        ),
      );
    } else if (widget.index == 2) {
      return _createVirementBody();
    } else if (widget.index == 1) {
      return _CreateFactureBody();
    }
    return Container();
  }

  Widget _createBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (_index) {
        setState(() {
          widget.index = _index;
        });
      },
      currentIndex: widget.index,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: "Compte",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
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
      title: _refreshTitle(widget.index),
      centerTitle: true,
      toolbarHeight: 100,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 15),
          child: GestureDetector(
            onTap: () =>
                Provider.of<Controller>(context, listen: false).signOut(),
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

//----------------------------Facture-------------------------------------
  Widget _createFactureBotton(String _text) {
    if (_text == "Create") {
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
                builder: (context) => CreationFacturePage(),
              ),
            );
          },
          child: Text(
            "Créer",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
        ),
      );
    } else {
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
                builder: (context) => AffichageFacturePage(),
              ),
            );
          },
          child: Text(
            "Consulter",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
        ),
      );
    }
  }

  Widget _CreateFactureBody() {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _createFactureBotton("Create"),
          _createFactureBotton("View"),
        ],
      ),
    );
  }

//---------------------------------Facture fin--------------------------------------
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
      _transactionlist =
          Firestore.instance.collection('/Trades/${user.uid}/trades');
    } catch (e) {
      print("error : " + (e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    //Pour éviter de faire trop d'appels inutiles
    /*if (_name == "") {
      print("data");
      _getUserData();
    }*/
    _getUserData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _createAppBar(),
        body: _refreshBody(widget.index),
        bottomNavigationBar: _createBottomNavigationBar(),
      ),
    );
  }
}
