import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prix_banque/button_type.dart';
import 'package:prix_banque/controller.dart';
import 'package:prix_banque/input_type.dart';
import 'package:prix_banque/tag_page.dart';

class WidgetFactory {
  Controller controller = Controller();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();

  Widget createButton(String text, Button_type type, List<Object> params) {
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
            controller.signIn(params);
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
            controller.createUser(params);
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
            controller.forgotPass(params);
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

  Widget createInput(
      String hint, Input_type type, TextEditingController controller) {
    switch (type) {
      case Input_type.EMAIL:
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

  Widget createBody(Tag_page tag, int index, List<Object> params) {
    switch (tag) {
      case Tag_page.HOME_PAGE:
        if (index == 0) {
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
                      [
                        controllerEmail,
                        controllerPassword,
                        controllerName,
                        controllerLastName,
                        params[0] as BuildContext,
                      ],
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
                    [
                      controllerEmail,
                      controllerPassword,
                      params[1] as Function(FirebaseUser),
                      params[0] as BuildContext
                    ],
                  ),
                  this.createButton("Mot de passe oublié ?",
                      Button_type.FORGOT_PASS, [params[0] as BuildContext])
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
}
