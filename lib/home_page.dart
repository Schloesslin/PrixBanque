import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:prix_banque/tag_page.dart';
import 'package:prix_banque/widget_factory.dart';

class HomePage extends StatefulWidget {
  final Function(FirebaseUser) onSignIn;
  HomePage({@required this.onSignIn});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WidgetFactory widgetFactory = WidgetFactory();
  int index = 1;

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
          label: "Sign up",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: "Sign in",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: widgetFactory.createAppBar(Tag_page.HOME_PAGE, index),
        bottomNavigationBar: _createBottomNavigationBar(),
        body: widgetFactory.createBody(
          Tag_page.HOME_PAGE,
          index,
          [
            context,
            widget.onSignIn,
          ],
        ),
      ),
    );
  }
}
