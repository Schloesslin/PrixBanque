import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:prix_banque/button_type.dart';
import 'package:prix_banque/controller.dart';
import 'package:prix_banque/forgot_pass.dart';
import 'package:prix_banque/input_type.dart';

import 'package:prix_banque/tag_page.dart';
import 'package:provider/provider.dart';
import 'package:prix_banque/component/logger.dart';

class HomePage extends StatefulWidget {
  int index;
  HomePage({@required this.index});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth firebaseAuth;
  final log = getLogger('_HomePageState');

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();

  Widget createInput(
      String hint, Input_type type, TextEditingController controller) {
    log.i('createInput | name: ${hint} ${type.toString()} ${controller.text}');
    switch (type) {
      case Input_type.EMAIL:
        log.i('createInput | type email');
        return Container(
          margin: EdgeInsets.only(bottom: 5),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.mail_outline),
              labelText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        );
        break;
      case Input_type.PASSWORD:
        log.i('createInput | type password');
        return Container(
          margin: EdgeInsets.only(bottom: 5),
          child: TextFormField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.vpn_key_outlined),
              labelText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        );
        break;
      default:
        log.i('createInput | type default');
        return Container(
          margin: EdgeInsets.only(bottom: 5),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        );
    }
  }

  Widget createAppBar(Tag_page tag, int index) {
    log.i('createAppBar | name ${tag.toString()} ${index}');
    switch (tag) {
      case Tag_page.HOME_PAGE:
        return AppBar(
          title: Text(
            (index == 0) ? "Inscription" : "Connexion",
            style: TextStyle(fontSize: 40),
          ),
          centerTitle: true,
          toolbarHeight: 100,
        );
        break;
      default:
        return null;
    }
  }

  Widget createBody(Tag_page tag) {
    log.i('createBody | name ${tag.toString()}');
    switch (tag) {
      case Tag_page.HOME_PAGE:
        if (widget.index == 0) {
          return SingleChildScrollView(
            child: Container(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 50),
                width: 250,
                child: new Column(
                  children: [
                    this.createInput(
                        "Nom", Input_type.FIRST_NAME, controllerName),
                    this.createInput(
                        "Prénom", Input_type.LAST_NAME, controllerLastName),
                    this.createInput(
                        "E-mail", Input_type.EMAIL, controllerEmail),
                    this.createInput("Mot de passe", Input_type.PASSWORD,
                        controllerPassword),
                    this.createButton(
                      "Créer un compte",
                      Button_type.CREATE_ACCOUNT,
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 50),
              width: 250,
              child: new Column(
                children: [
                  this.createInput("E-mail", Input_type.EMAIL, controllerEmail),
                  this.createInput(
                      "Mot de passe", Input_type.PASSWORD, controllerPassword),
                  this.createButton(
                    "Se connecter",
                    Button_type.LOGIN,
                  ),
                  this.createButton(
                    "Mot de passe oublié ?",
                    Button_type.FORGOT_PASS,
                  )
                ],
              ),
            ),
          ),
        );
        break;
      default:
        return null;
    }
  }

  Widget _createBottomNavigationBar() {
    log.i('_createBottomNavigationBar');

    return BottomNavigationBar(
      onTap: (_index) {
        setState(() {
          widget.index = _index;
        });
      },
      currentIndex: widget.index,
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

  Widget createButton(String text, Button_type type) {
    log.i('createButton | name ${text} ${type.toString()}');
    final controller = Provider.of<Controller>(context);
    switch (type) {
      case Button_type.LOGIN:
        return MaterialButton(
          minWidth: 250,
          color: Colors.blue,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(23.0),
          ),
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            controller.signIn(controllerEmail.text, controllerPassword.text);
          },
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
        );
        break;
      case Button_type.CREATE_ACCOUNT:
        return MaterialButton(
          minWidth: 250,
          color: Colors.blue,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(23.0),
          ),
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            controller.createUser(controllerEmail.text, controllerPassword.text,
                controllerName.text, controllerLastName.text);
          },
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
        );
        break;
      case Button_type.FORGOT_PASS:
        return MaterialButton(
          minWidth: 250,
          textColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(23.0),
          ),
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            forgotPass();
          },
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
        );
        break;
      default:
        return null;
    }
  }

  void forgotPass() {
    log.i('forgotPass');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotPass(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    log.i('build');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: createAppBar(Tag_page.HOME_PAGE, widget.index),
        bottomNavigationBar: _createBottomNavigationBar(),
        body: createBody(
          Tag_page.HOME_PAGE,
        ),
      ),
    );
  }
}
