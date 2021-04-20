import 'package:flutter/material.dart';

class TransfertAttentePage extends StatefulWidget {
  @override
  _TransfertAttentePageState createState() => _TransfertAttentePageState();
}

class _TransfertAttentePageState extends State<TransfertAttentePage> {
  int index = 0;

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
          index = _index;
        });
      },
      currentIndex: index,
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
        bottomNavigationBar: _createBottomNavigationBar(),
      ),
    );
  }
}
