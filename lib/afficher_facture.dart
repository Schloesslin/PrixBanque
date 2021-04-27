import 'package:flutter/material.dart';
// import 'package:date_field/date_field.dart';

class AffichageFacturePage extends StatefulWidget {
  @override
  _AffichageFacturePageState createState() => _AffichageFacturePageState();
}

class _AffichageFacturePageState extends State<AffichageFacturePage> {
  int index = 0;

  Widget _createAppBar() {
    return AppBar(
      title: Text(
        "Mes Facture",
        style: TextStyle(fontSize: 30),
      ),
      centerTitle: true,
      toolbarHeight: 100,
      leading: Container(
        margin: EdgeInsets.only(left: 15),
        child: GestureDetector(
          key: Key("back"),
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _createAppBar(),
        bottomNavigationBar: _createBottomNavigationBar(),
      ),
    );
  }
}
