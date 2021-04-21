import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // final latestTransaction = {
  //   "transaction x",
  //   "transaction c",
  //   "test",
  //   "test1",
  //   "test3"
  // };
  final transactions = [
    {
      "name": "transaction_name",
      "value": 3,
    },
    {
      "name": "transaction_name",
      "value": -30,
    },
    {
      "name": "oui bojour",
      "value": 303,
    },
    {
      "name": "test",
      "value": 30,
    },
    {
      "name": "transaction_name",
      "value": 30,
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu_rounded),
            padding: EdgeInsets.only(left: 8),
            onPressed: () {},
          ),
          // title: Text("Oui bonjour"),
        ),
        body: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                leading: Icon(Icons.access_alarm),
                title: Text(transactions[index]["name"]),
                trailing: Text(transactions[index]["value"].toString() + " \$"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SecondPage()));
                },
              );
            })
        //         ListView(physics: ClampingScrollPhysics(), children: <Widget>[
        //   Padding(
        //       padding: EdgeInsets.only(left: 24, top: 8, bottom: 16),
        //       child: Text(
        //         'Bonjour user',
        //         // style: GoogleFonts.poppins(
        //         //     fontSize: 20, fontWeight: FontWeight.w700)
        //       )),
        //   // Container(
        //   //   height: 175,
        //   //   margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        //   //   decoration: BoxDecoration(
        //   //     borderRadius: BorderRadius.circular(15),
        //   //     color: Colors.green,
        //   //   ),
        //   //   child: Card(
        //   //     color: Colors.transparent,
        //   //     elevation: 0,
        //   //     child: InkWell(
        //   //       onTap: () {
        //   //         Navigator.push(context,
        //   //             MaterialPageRoute(builder: (context) => SecondPage()));
        //   //       },
        //   //     ),
        //   //   ),
        //   // ),
        //   // Padding(
        //   //     padding: EdgeInsets.only(left: 24, top: 8, bottom: 16),
        //   //     child: Text(
        //   //       'Dernières transactions',
        //   //     )),
        //   Container(child: Text("Oui"))
        // ])
        );
  }
}

class SecondPage extends StatefulWidget {
  SecondPage({Key key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          padding: EdgeInsets.only(left: 8),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Text('Page avec toutes les transitions'),
    );
  }
}
