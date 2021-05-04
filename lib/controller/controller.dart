import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:prix_banque/views/forgot_pass_page.dart';
import 'package:prix_banque/main.dart';
import 'package:prix_banque/component/logger.dart';
import 'package:cloud_functions/cloud_functions.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class Controller with ChangeNotifier {
  final log = getLogger('Controller');
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
    log.i('onAuthStateChanged | name: ${firebaseUser.toString()}');
    if (firebaseUser == null) {
      log.w('onAuthStateChanged | Firebase user was null');
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    log.i('signIn | name: ${email} ${password}');
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return true;
    } catch (e) {
      log.e("signIn | Error while signing in user ${e}");
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    log.i('signOut');
    auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<String> createAccount({String email, String password}) async {
    log.i('createAccount | name: ${email} ${password}');

    try {
      await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return "Success";
    } catch (e) {
      log.e("createAccount | Error while creating an account ${e}");
      return e.message;
    }
  }

  Future<String> createUserFirestore(
      String uid, String email, String firstName, String lastName) async {
    log.i(
        'createUserFirestore | name: ${uid} ${email} ${firstName} ${lastName}');
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
    log.i('createUser | name: ${email} ${pass} ${firstName} ${lastName}');
    String error;
    await createAccount(email: email, password: pass);
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DatabaseReference _ref =
        FirebaseDatabase.instance.reference().child("Customers");
    int _usernumber = await getCount(_ref);
    if (_usernumber <= 10000) {
      log.i("createUser | User can use the promotional offer");
      _ref.child(user.uid).child("Main account").set({
        'Account number': Random().nextInt(99999999),
        'Balance': 1000,
        'First Name': firstName,
        'Last Name': lastName
      });
    } else {
      log.i("createUser | User cannot use promotional offer");
      _ref.child(user.uid).child("Main account").set({
        'Account number': Random().nextInt(99999999),
        'Balance': 0,
        'First Name': firstName,
        'Last Name': lastName
      });
    }
    await createUserFirestore(user.uid, user.email, firstName, lastName);
    return "Succes";
  }

  Future<int> getCount(DatabaseReference db) async {
    log.i('getCount | name: ${db.toString()} ');
    int result = (await db.child("_count").once()).value;
    return result + 1;
  }

  Future<HttpsCallableResult> writeTransaction(data) async {
    log.i('writeTransaction | name : '+data.toString());
    HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: "transfertServices-getUsersAndTransaction");
    final HttpsCallableResult result =  await callable.call(data);
    return result;
  }

}
