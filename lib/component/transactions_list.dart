import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prixbanqueapp/component/transaction_details.dart';

class TransactionList extends StatefulWidget {
  TransactionList({Key key}) : super(key: key);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
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
                Icons.error_outline_outlined,
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
                          leading: Icon(Icons.account_balance_rounded),
                          title: Text(document["uid_receiver"]),
                          trailing: Text("$_value \$"),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ExtractArgumentsScreen.routeName,
                              arguments: ScreenArguments(
                                document['uid_receiver'],
                                document['uid_emitter'],
                                document['value'],
                                document['date'],
                              ),
                            );
                          },
                        );
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
