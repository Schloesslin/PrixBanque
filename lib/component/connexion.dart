import 'package:flutter/material.dart';
import 'package:prix_banque/controller/controller.dart';
import 'package:prix_banque/views/home_page.dart';
import 'package:prix_banque/views/welcome_page.dart';
import 'package:provider/provider.dart';

class AuthHomePage extends StatelessWidget {
  int indexWelcome;
  int indexHome;
  AuthHomePage({@required this.indexWelcome, @required this.indexHome});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, Controller user, _) {
        switch (user.status) {
          case Status.Authenticated:
            return WelcomePage(
              index: indexWelcome,
            );
          default:
            //index = 1;
            return HomePage(index: indexHome);
        }
      },
    );
  }
}
