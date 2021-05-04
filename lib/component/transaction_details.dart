import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDetails extends StatefulWidget {
  final String receiver;
  final String transmitter;
  final int value;
  final String date;
  TransactionDetails(
      {Key key, this.receiver, this.transmitter, this.value, this.date})
      : super(key: key);

  @override
  _TransactionDetailsState createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  @override
  Widget build(BuildContext context) {
    var date2 = DateFormat('dd/MM/yyyy').format(
        DateTime.fromMicrosecondsSinceEpoch(int.parse(widget.date) * 1000));
    //Display a dialog with all the informationw about the clicked transaction
    return AlertDialog(
      content: Container(
        height: 220,
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
                "Compte émetteur: ${widget.transmitter}",
                textAlign: TextAlign.center,
              ),
            ),
            Text("Compte receveur: ${widget.receiver}"),
            Text("Le ${date2}"),
            Text(
              "${widget.value.toString()} \$",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
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
