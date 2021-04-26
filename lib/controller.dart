import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:prix_banque/forgot_pass.dart';
import 'package:prix_banque/main.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class Controller with ChangeNotifier {
  final FirebaseAuth auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  Status get status => _status;
  FirebaseUser get user => _user;

  final databaseReference = Firestore.instance;
  Controller.instance({this.auth}) {
    auth.onAuthStateChanged.listen(onAuthStateChanged);
  }

  Future<void> onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<String> createAccount({String email, String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return "Success";
    } catch (e) {
      return e.message;
    }
  }

  Future<String> createUserFirestore(
      String uid, String email, String firstName, String lastName) async {
    await databaseReference.collection("Users").document().setData(
      {
        'uid': uid,
        'First Name': firstName,
        'Last Name': lastName,
        'mail': email
      },
    );
    return "Succes";
  }

  //final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  Future<String> createUser(
      String email, String pass, String firstName, String lastName) async {
    String error;

    createAccount(email: email, password: pass);
    createUserFirestore(user.uid, user.email, firstName, lastName);
    DatabaseReference _ref =
        FirebaseDatabase.instance.reference().child("Customers");
    int _usernumber = await getCount(_ref);
    if (_usernumber <= 10000) {
      _ref.child(user.uid).child("Main account").push().set({
        'Account number': Random().nextInt(99999999),
        'Balance': 1000,
        'First Name': firstName,
        'Last Name': lastName
      });
    } else {
      _ref.child(user.uid).child("Main account").push().set({
        'Account number': Random().nextInt(99999999),
        'Balance': 0,
        'First Name': firstName,
        'Last Name': lastName
      });
    }

    return "Succes";
  }

  Future<int> getCount(DatabaseReference db) async {
    int result = (await db.child("_count").once()).value;
    return result + 1;
  }
}
