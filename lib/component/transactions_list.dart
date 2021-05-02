import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'transaction_details.dart';
import 'package:prix_banque/logger.dart';

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
  final log = getLogger('_TransactionListState');

  @override
  Widget build(BuildContext context) {
    if (widget.listOfTransactions == null) {
      log.i('build | Empty list of transactions');
      return Container(
        child: Column(
          children: <Widget>[
            Center(
              child: SizedBox(
                child: Icon(
                  Icons.sticky_note_2_outlined,
                  size: 50,
                ),
              ),
            ),
            Text("Vous n'avez aucune transaction."),
          ],
        ),
      );
    }
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
                    child: Text('La connexion a été interrompue.'),
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
                    child: Text('Chargement'),
                  )
                ];
                break;
              case ConnectionState.active:
                if (snapshot.data.documents.isEmpty) {
                  children = <Widget>[
                    Center(
                      child: SizedBox(
                        child: Icon(
                          Icons.sticky_note_2_outlined,
                          size: 50,
                        ),
                      ),
                    ),
                    Text("Vous n'avez aucune transaction."),
                  ];
                } else {
                  if (widget.isResume) {
                    var documentList = snapshot.data.documents.length > 5
                        ? snapshot.data.documents.take(5)
                        : snapshot.data.documents;
                    children = <Widget>[
                      SizedBox(
                        height: 280,
                        child: ListView(
                          shrinkWrap: true,
                          children: documentList.map((document) {
                            var _value = document["value"].toString();
                            log.i('build |  Value : $_value');
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
                      ),
                    ];
                  } else {
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
                      ),
                    ];
                  }
                }
                break;
              case ConnectionState.done:
                children = const <Widget>[
                  Icon(
                    Icons.info,
                    color: Colors.blue,
                    size: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('La connexion a été interrompu.'),
                  )
                ];
                break;
            }
          }
          // if (widget.isResume && (children.length > 4)) {
          //   children.take(4).toList();
          // }
          // children.toList();
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
