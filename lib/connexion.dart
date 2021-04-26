import 'package:flutter/material.dart';
import 'package:prix_banque/controller.dart';
import 'package:prix_banque/home_page.dart';
import 'package:prix_banque/welcome_page.dart';
import 'package:provider/provider.dart';

class AuthHomePage extends StatelessWidget {
  int index;
  AuthHomePage({@required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, Controller user, _) {
        switch (user.status) {
          case Status.Authenticated:
            return WelcomePage(
              index: index,
            );
          default:
            return HomePage(index: index);
        }
      },
    );
  }
}
