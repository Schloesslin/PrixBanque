import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prix_banque/controller/controller.dart';
import 'package:prix_banque/main.dart';
import 'package:prix_banque/views/transfert_immediat_page.dart';
import 'package:provider/provider.dart';

class TransfertAttentePage extends StatefulWidget {
  int index;
  String email;
  TransfertAttentePage({@required this.index, @required this.email});
  @override
  _TransfertAttentePageState createState() => _TransfertAttentePageState();
}

class _TransfertAttentePageState extends State<TransfertAttentePage> {
  final databaseReference = Firestore.instance;

  Widget _refreshBody() {
    if (widget.index == 1) {
      Stream<QuerySnapshot> messagesSnapshot = databaseReference
          .collection("Factures/" + widget.email + "/send")
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
                  trailing: Text(doc['type']),
                  title: Container(
                    child: GestureDetector(
                      onTap: () {
                        print("lol");
                      },
                      child: Text(
                        "Destinataire : " + doc['dest name'],
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
        .collection("Factures/" + widget.email + "/receive")
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
                trailing: Text(doc['type']),
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

  Widget _createAppBar() {
    return AppBar(
      title: Text(
        "Virements en attente",
        style: TextStyle(fontSize: 30),
      ),
      centerTitle: true,
      toolbarHeight: 100,
      leading: Container(
        margin: EdgeInsets.only(left: 15),
        child: GestureDetector(
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
          icon: Icon(Icons.receipt),
          label: "Reçu",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.send),
          label: "Envoyé",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
