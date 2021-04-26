import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:prix_banque/forgot_pass.dart';

class Controller {
  Future<void> signIn(List<Object> params) async {
    String error;
    try {
      AuthResult userResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: (params[0] as TextEditingController).text.trim(),
              password: (params[1] as TextEditingController).text);
      (params[2] as Function(FirebaseUser))(userResult.user);
    } catch (e) {
      error = e.message;
      return showDialog<void>(
        context: params[3] as BuildContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error connection'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(error),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> createUser(List<Object> params) async {
    String error;
    final databaseReference = Firestore.instance;

    try {
      // ignore: unused_local_variable
      AuthResult userResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: (params[0] as TextEditingController).text.trim(),
              password: (params[1] as TextEditingController).text);
    } catch (e) {
      error = e.message;
      return showDialog<void>(
        context: params[4] as BuildContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error connection'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(error),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DatabaseReference _ref =
        FirebaseDatabase.instance.reference().child("Customers");
    int _usernumber = await getCount(_ref);
    if (_usernumber <= 10000) {
      _ref.child(user.uid).child("Main account").push().set({
        'Account number': Random().nextInt(99999999),
        'Balance': 1000,
        'First Name': (params[2] as TextEditingController).text,
        'Last Name': (params[3] as TextEditingController).text
      });
    } else {
      _ref.child(user.uid).child("Main account").push().set({
        'Account number': Random().nextInt(99999999),
        'Balance': 0,
        'First Name': (params[2] as TextEditingController).text,
        'Last Name': (params[3] as TextEditingController).text
      });
    }

    await databaseReference.collection("Users").document().setData(
      {
        'uid': user.uid,
        'First Name': (params[2] as TextEditingController).text,
        'Last Name': (params[3] as TextEditingController).text,
        'mail': user.email
      },
    );
  }

  Future<int> getCount(DatabaseReference db) async {
    int result = (await db.child("_count").once()).value;
    return result + 1;
  }

  void forgotPass(List<Object> params) {
    Navigator.push(
      params[0] as BuildContext,
      MaterialPageRoute(
        builder: (context) => ForgotPass(),
      ),
    );
  }
}
