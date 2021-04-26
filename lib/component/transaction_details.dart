import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';

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
    var _date = DateFormat('dd/MM/yyyy').format(args.date.toDate());
    //Display a dialog with all the informationw about the clicked transaction
    return AlertDialog(
      elevation: 0,
      content: Container(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_balance,
              size: 40,
              color: Colors.blue,
            ),
            Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text(
                "Compte émetteur: $_transmitter",
                textAlign: TextAlign.center,
              ),
            ),
            Text("Compte émetteur: $_receiver"),
            Text("Le $_date"),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                "$_value \$",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
      // Text(
      //     "Compte émetteur: $_transmitter\nCompte receveur: $_receiver\nLe: $_date\n $_value \$"),
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
