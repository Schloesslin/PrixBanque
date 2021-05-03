import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prix_banque/controller.dart';
import 'package:provider/provider.dart';
// import 'package:date_field/date_field.dart';

class AffichageFacturePage extends StatefulWidget {
  @override
  _AffichageFacturePageState createState() => _AffichageFacturePageState();
}

class _AffichageFacturePageState extends State<AffichageFacturePage> {
  int index = 0;

  Widget _createAppBar() {
    return AppBar(
      title: Text(
        "Mes Factures",
        style: TextStyle(fontSize: 30),
      ),
      centerTitle: true,
      toolbarHeight: 100,
      leading: Container(
        margin: EdgeInsets.only(left: 15),
        child: GestureDetector(
          key: Key("back"),
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
    );
  }

  final databaseReference = Firestore.instance;
  Widget _refreshBody() {
    if (index == 1) {
      Stream<QuerySnapshot> messagesSnapshot = databaseReference
          .collection("Bills/" +
              Provider.of<Controller>(context, listen: false).user.email +
              "/send")
          .snapshots();
      StreamBuilder<QuerySnapshot> streamBuilder = StreamBuilder<QuerySnapshot>(
        stream: messagesSnapshot,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
          if (querySnapshot.hasError)
            return new Text('Error: ${querySnapshot.error}');
          switch (querySnapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text("Loading...");
            default:
              return new ListView(
                  children:
                      querySnapshot.data.documents.map((DocumentSnapshot doc) {
                return new ListTile(
                  title: Container(
                    child: GestureDetector(
                      onTap: () {
                        print("lol");
                      },
                      child: Text(
                        "Destinataire : " + doc['auth name'],
                      ),
                    ),
                  ),
                  subtitle: Text(
                    "Montant : " + doc['value'],
                  ),
                );
              }).toList());
          }
        },
      );
      return streamBuilder;
    }
    Stream<QuerySnapshot> messagesSnapshot = databaseReference
        .collection("Bills/" +
            Provider.of<Controller>(context, listen: false).user.email +
            "/receive")
        .snapshots();
    StreamBuilder<QuerySnapshot> streamBuilder = StreamBuilder<QuerySnapshot>(
      stream: messagesSnapshot,
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
        if (querySnapshot.hasError)
          return new Text('Error: ${querySnapshot.error}');
        switch (querySnapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text("Loading...");
          default:
            return new ListView(
                children:
                    querySnapshot.data.documents.map((DocumentSnapshot doc) {
              return new ListTile(
                title: Container(
                  child: GestureDetector(
                    onTap: () {
                      print("lol2");
                    },
                    child: Text(
                      "Payeur : " + doc['auth name'],
                    ),
                  ),
                ),
                subtitle: Text(
                  "Montant : " + doc['value'],
                ),
              );
            }).toList());
        }
      },
    );
    return streamBuilder;
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
          icon: Icon(Icons.add_shopping_cart),
          label: "A Payé",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: "Emise",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: "Payer",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _createAppBar(),
        body: _refreshBody(),
        bottomNavigationBar: _createBottomNavigationBar(),
      ),
    );
  }
}
