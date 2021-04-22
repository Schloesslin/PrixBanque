import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prixbanqueapp/component/transaction_details.dart';

class TransactionList extends StatefulWidget {
  final bool isResume;
  final CollectionReference listOfTransactions;
  TransactionList(
      {Key key, @required this.isResume, @required this.listOfTransactions})
      : super(key: key);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        //We're getting the transactions from Firstore and order them by they're date
        stream: widget.listOfTransactions
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //We're initialising a list of widget to return
          List<Widget> children;
          //If there is an error with the stream
          if (snapshot.hasError) {
            children = <Widget>[
              Center(
                child: const Icon(
                  Icons.error_outline_outlined,
                  color: Colors.red,
                  size: 60,
                ),
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
          }
          //If we didn't have any data yet, display a progress circle
          else if (!snapshot.hasData) {
            children = <Widget>[
              const Icon(
                Icons.error_outline_outlined,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: '),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Stack trace: '),
              ),
            ];
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
                if (snapshot.data.documents.isEmpty) {
                  children = <Widget>[
                    Center(
                      child: SizedBox(
                        child: Icon(
                          Icons.sentiment_dissatisfied_rounded,
                          size: 50,
                        ),
                      ),
                    ),
                    Text("Vous n'avez aucune transaction"),
                  ];
                } else {
                  var documentList = widget.isResume
                      ? snapshot.data.documents.take(5)
                      : snapshot.data.documents;
                  children = <Widget>[
                    Expanded(
                      child: ListView(
                        children: documentList.map((document) {
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
                }
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
          // if (children.isEmpty) {
          //   children = <Widget>[
          //     Text("vous n'avez pas de transactions enregistrées.")
          //   ];
          // }
          if (widget.isResume) {
            children.take(4).toList();
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
