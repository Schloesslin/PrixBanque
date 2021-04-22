import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// You can pass any object to the arguments parameter.
// In this example, create a class that contains both
// a customizable title and message.
class ScreenArguments {
  final String receiver;
  final String transmitter;
  final int value;
  final Timestamp date;

  ScreenArguments(this.receiver, this.transmitter, this.value, this.date);
}

// A Widget that extracts the necessary arguments from
// the ModalRoute.
class ExtractArgumentsScreen extends StatelessWidget {
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute
    // settings and cast them as ScreenArguments.
    final ScreenArguments args =
        ModalRoute.of(context).settings.arguments as ScreenArguments;
    var _receiver = args.receiver;
    var _transmitter = args.transmitter;
    var _value = args.value.toString();
    var _date = args.date.toString();
    return AlertDialog(
      elevation: 0,
      content: Text(
          "Compte émetteur: $_transmitter\nCompte receveur: $_receiver\nLe: $_date\n $_value"),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Fermer'))
      ],
    );
  }
}

class TransactionDetails extends StatefulWidget {
  TransactionDetails({Key key}) : super(key: key);

  @override
  _TransactionDetails createState() => _TransactionDetails();
}

class _TransactionDetails extends State<TransactionDetails> {
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
