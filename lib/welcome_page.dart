import 'package:flutter/material.dart';
import 'package:prixbanqueapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int index = 0;
  String _account;
  String _name;
  String _lastname;
  String _balance;
  DateTime today = new DateTime.now().toLocal();


  Widget _refreshTitle(int _index) {
    if (_index == 0) {
      return Text(
        "Compte",
        style: TextStyle(fontSize: 40),
      );
    } else if (_index == 1) {
      return Text(
        "Factures",
        style: TextStyle(fontSize: 40),
      );
    }
    return Text(
      "Transferts",
      style: TextStyle(fontSize: 40),
    );
  }

  Widget _refreshBody(int _index) {
    if(_index == 0) {
      //Pour éviter de faire trop d'appels inutiles
      if(_name == "") {
        _getUserData();
      }
      return Container(
        alignment: Alignment.topCenter,
        child : Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.account_balance_sharp),
                      title: Text('Bonjour, '+_name+' '+_lastname+' !'),
                      subtitle: Text("Nous sommes le "+today.day.toString()+"/"+today.month.toString()+"/"+today.year.toString()+"et il est "+ today.hour.toString() +"h"+today.minute.toString()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery. of(context). size. height/8),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                         //leading: Icon(Icons.account_balance_wallet_rounded),
                          title: Text(
                              'Compte principal',
                            style: TextStyle(
                              fontSize : 25.0,
                            ),
                          ),
                          subtitle: Text(
                              "N° de compte : "+_account,
                            style : TextStyle(
                              height: 5,
                              fontSize : 10.0,
                            )

                          ),
                          trailing: Text(_balance+" \$",
                          style : TextStyle(
                            fontSize: 22,
                          )),
                        ),
                      ],
                    ),
                  )
            ],
           ),
        );
    }
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
          icon: Icon(Icons.add_circle_outline),
          label: "Compte",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: "Factures",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: "Transferts",
        ),
      ],
    );
  }

  Widget _createAppBar() {
    return AppBar(
      title: _refreshTitle(index),
      centerTitle: true,
      toolbarHeight: 100,
      leading: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute<void>(builder: (BuildContext context) {
            return MyApp();
          }));
          return MyApp();
        },
        child: Icon(
          Icons.logout,
        ),
      ),
    );
  }

  Future<void> _getUserData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DatabaseReference _ref = FirebaseDatabase.instance.reference().child("Customers").child(user.uid).child("Main account");
    await _ref.once().then( (DataSnapshot data) {
      Map<dynamic, dynamic> map = data.value;
      _account = map.values.toList()[0]["Account number"].toString();
      _name = map.values.toList()[0]["First Name"];
      _lastname = map.values.toList()[0]["Last Name"];
      _balance = map.values.toList()[0]["Balance"].toString();
    return;
    }
    );

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _createAppBar(),
        bottomNavigationBar: _createBottomNavigationBar(),
        body: _refreshBody(index),
      ),
    );
  }
}
