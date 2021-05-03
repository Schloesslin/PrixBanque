import 'dart:math';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/rendering.dart';
import 'package:prix_banque/controller.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'controller.dart';


class AffichageFacturePage extends StatefulWidget{

  @override
  _AffichageFacturePageState createState() => _AffichageFacturePageState ();

}

class _AffichageFacturePageState extends State<AffichageFacturePage>{
  Controller controller;
  final databaseReference = Firestore.instance;

  int index = 0;
  String situation = "F";
  var data = {};

  Widget _createAppBar(BuildContext context, String titre) {
    this.controller =  Provider.of<Controller>(context, listen: false);
    return AppBar(
      title: Text(
        titre,
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

  Widget _refrechBody(){
    if( index == 0 )
      return _BillToBuy();
    else if( index == 1)
      return _BillSend();
    else if (index ==2) {
      return _BillReceive();
    }
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

  void getTransactionData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    data['emitter'] = user.uid;
}

  Widget _BillToBuy() {

    print(this.situation);
    Stream<QuerySnapshot> messagesSnapshot = databaseReference
        .collection("Bills/" + controller.user.email + "/receive")
        .where("situation", isEqualTo: this.situation)
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
                          data['value']=doc['value'];
                          data['receiver_email']=doc['email auth'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Container(
                                child: Scaffold(
                                  appBar: _createAppBar(context,"Emetteur"),
                                  body: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical : 50,horizontal: 20),
                                      child: Text(
                                        "Nom          : " + doc['auth name'] + "\n" +
                                            "Email        : " + doc['email auth'] + "\n" +
                                            "Date          : " + doc['date reg'] + "\n" +
                                            "Montant   : " + doc['value'] + " \$",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  floatingActionButton: FloatingActionButton(
                                    onPressed: () => setState(() {
                                      _BuytoBill(doc['id'],doc['email auth']);
                                      //TODO : call write transaction microservices --> récupérer toutes les données nécessaires
                                      writeTransaction(data).then((value) {
                                        print("Transaction done");
                                      });
                                      Navigator.pop(context);
                                    }),
                                    child: const Icon(Icons.add_shopping_cart_sharp),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            child: Text(
                              "Nom          : " + doc['auth name'] + "\n" +
                                  "Montant   : " + doc['value'] + " \$",

                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList());
        }
      },
    );
    return streamBuilder;
  }

  Future<HttpsCallableResult> writeTransaction(data) async {
    //log.i('writeTransaction | name : '+data.toString());
    HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: "transfertServices-getUsersAndTransaction");
    final HttpsCallableResult result =  await callable.call(data);
    return result;
  }


  Widget _BillSend(){

    Stream<QuerySnapshot> messagesSnapshot = databaseReference
        .collection("Bills/" + controller.user.email + "/send")
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Container(
                                child: Scaffold(
                                    appBar: _createAppBar(context,"Destinateur"),
                                    body: Card(
                                      elevation: 8,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 20),
                                        child: Text(
                                          "Nom          : " + doc['dest name'] + "\n" +
                                              "Email         : " + doc['email dest'] + "\n" +
                                              "Date          : " + doc['date reg'] + "\n" +
                                              "Montant   : " + doc['value'] + " \$" + "\n"
                                              "Situation  : " + _situationView(doc['situation']),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    floatingActionButton: FloatingActionButton(
                                      onPressed: () => setState(() {
                                        _deleteBill(doc['id'],controller.user.email,doc['dest name']);
                                        Navigator.pop(context);
                                      }),
                                      child: const Icon(Icons.delete),
                                    )
                                ),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            child: Text(
                              "Nom          : " + doc['dest name'] + "\n" +
                                  "Montant   : " + doc['value'] + " \$",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList());
        }
      },
    );
    return streamBuilder;
  }

  Widget _BillReceive(){

    Stream<QuerySnapshot> messagesSnapshot = databaseReference
        .collection("Bills/" + controller.user.email + "/receive")
        .where("situation", isEqualTo: "O")
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
                  //if (doc['situation'] != this.situation){
                  return new ListTile(
                    //trailing: Text(doc['type']),
                    title: Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Container(
                                child: Scaffold(
                                  appBar: _createAppBar(context,"Details"),
                                  body: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 8),
                                      child: Text(
                                        "Nom          : " + doc['auth name'] + "\n" +
                                            "Email        : " + doc['email auth'] + "\n" +
                                            "Date          : " + doc['date reg'] + "\n" +
                                            "Montant   : " + doc['value'] + " \$",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  floatingActionButton: FloatingActionButton(
                                    onPressed: () => setState(() {
                                      _deleteBill(doc['id'],doc['email auth'],controller.user.email);
                                      Navigator.pop(context);
                                    }),
                                    child: const Icon(Icons.delete),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            child: Text(
                              "Nom          : " + doc['auth name'] + "\n" +
                                  "Montant   : " + doc['value'] + " \$",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                  //}
                }).toList());
        }
      },
    );
    return streamBuilder;

  }

  Future<void> _BuytoBill(String idBill, String emailAuth) async{

    String val = "O";

    await databaseReference
        .collection("Bills")
        .document(emailAuth)
        .collection("send")
        .document(idBill)
        .updateData(
      {
        'situation': val
      },
    );
    await databaseReference
        .collection("Bills")
        .document(controller.user.email)
        .collection("receive")
        .document(idBill)
        .updateData(
      {
        'situation': val
      },
    );
  }

  Future<void> _deleteBill(String idBill,String emailAuth,emailDest) async{

    await databaseReference
        .collection("Bills")
        .document(emailAuth )
        .collection("send")
        .document(idBill)
        .delete();

    await databaseReference
        .collection("Bills")
        .document(emailDest)
        .collection("receive")
        .document(idBill)
        .delete();
  }

  String _situationView(String val){
    return (val.compareTo(this.situation) == 0) ? "Non Regler" : "Regler";
  }


  @override
  Widget build(BuildContext context) {
    //final controller = Provider.of<Controller>(context);
    // TODO: implement build
    getTransactionData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _createAppBar(context, "Mes Facutres"),
        body: _refrechBody(),
        bottomNavigationBar: _createBottomNavigationBar(),
      ),
    );
  }
}