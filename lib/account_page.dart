import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:google_fonts/google_fonts.dart';

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
  CollectionReference userTransactions =
      Firestore.instance.collection('/Trades/test-user/trades');
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
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: TransactionList()
            // ListView.builder(
            //     itemCount: 2,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         contentPadding: EdgeInsets.symmetric(horizontal: 16),
            //         leading: Icon(Icons.access_alarm),
            //         title: Text(transactions[index]["name"]),
            //         trailing:
            //             Text(transactions[index]["value"].toString() + " \$"),
            //         onTap: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => MyListView()));
            //         },
            //       );
            //     })
            ));
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

class TransactionList extends StatefulWidget {
  TransactionList({Key key}) : super(key: key);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  //   final Stream<int> _bids = (() async* {
  //     Firestore.instance.collection("/Trades/")
  // })();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("/Trades/test-user/trades/")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Widget> children;
          if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Stack trace: ${snapshot.stackTrace}'),
              ),
            ];
            // } else if (!snapshot.hasData) {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                children = const <Widget>[
                  Icon(
                    Icons.info,
                    color: Colors.blue,
                    size: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('First switch case'),
                  )
                ];
                break;
              case ConnectionState.waiting:
                children = const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Loading'),
                  )
                ];
                break;
              case ConnectionState.active:
                children = <Widget>[
                  Expanded(
                    child: ListView(
                      children: snapshot.data.documents.map((document) {
                        var _value = document["value"].toString();
                        print("Value: $_value");
                        return ListTile(
                          title: Text(document["uid_receiver"]),
                          trailing: Text("$_value \$"),
                        );
                        // return Center(
                        //   child: Container(
                        //     child: Text("value: $_value"),
                        //   ),
                        // );
                      }).toList(),
                    ),
                  )
                ];
                break;
              case ConnectionState.done:
                children = const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Done case'),
                  )
                ];
                break;
            }
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          );
        },
      ),
    );
  }
}
