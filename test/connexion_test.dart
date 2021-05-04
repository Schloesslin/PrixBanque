import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prix_banque/views/afficher_facture_page.dart';
import 'package:prix_banque/controller/controller.dart';
import 'package:prix_banque/views/creer_facture_page.dart';
import 'package:prix_banque/views/forgot_pass_page.dart';
import 'package:mockito/mockito.dart';
import 'package:prix_banque/views/home_page.dart';
import 'package:prix_banque/main.dart';
import 'package:prix_banque/views/transfert_attente_page.dart';
import 'package:prix_banque/views/transfert_immediat_page.dart';
import 'package:prix_banque/views/transfert_programme_page.dart';
import 'package:prix_banque/views/welcome_page.dart';
import 'package:rxdart/rxdart.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

class MockAuthResult extends Mock implements AuthResult {}

void main() {
  testWidgets("ouverture myApp", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      indexHome: 1,
      indexWelcome: 0,
    ));
  });

  testWidgets("ouverture myApp", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      indexHome: 0,
      indexWelcome: 1,
    ));
  });
  testWidgets("ouverture myApp", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      indexHome: 1,
      indexWelcome: 1,
    ));
  });
  testWidgets("ouverture myApp", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(
      indexHome: 0,
      indexWelcome: 0,
    ));
  });

  testWidgets("ouverture transfert immediat", (WidgetTester tester) async {
    await tester.pumpWidget(TransfertImmediatPage());
  });

  testWidgets("ouverture transfert programme", (WidgetTester tester) async {
    await tester.pumpWidget(TransfertProgrammePage());
    expect(find.byKey(Key("tt")), findsWidgets);
    await tester.tap(find.byKey(Key("tt")));
    await tester.pump();
    expect(find.text("Demande de virement envoyée"), findsWidgets);
  });

  testWidgets("ouverture transfert attente", (WidgetTester tester) async {
    await tester.pumpWidget(TransfertAttentePage(
      index: 0,
      email: "schloesslin.lucas@gmail.com",
    ));
  });

  testWidgets("ouverture transfert attente", (WidgetTester tester) async {
    await tester.pumpWidget(TransfertAttentePage(
      index: 1,
      email: "schloesslin.lucas@gmail.com",
    ));
  });
  testWidgets("ouverture creation facture", (WidgetTester tester) async {
    await tester.pumpWidget(CreationFacturePage());
  });

  group('welcome page', () {
    testWidgets("ouverture welcome page index 0", (WidgetTester tester) async {
      await tester.pumpWidget(WelcomePage(index: 0));
      expect(find.text('Compte'), findsWidgets);
    });
    testWidgets("ouverture welcome page index 1", (WidgetTester tester) async {
      await tester.pumpWidget(WelcomePage(index: 1));
      expect(find.text('Factures'), findsWidgets);
    });
    testWidgets("ouverture welcome page index 2", (WidgetTester tester) async {
      await tester.pumpWidget(WelcomePage(index: 2));
      expect(find.text('Transferts'), findsWidgets);
    });
  });
  /*
  testWidgets("ouverture facture", (WidgetTester tester) async {
    await tester.pumpWidget(AffichageFacturePage());
    expect(find.byKey(Key("back")), findsWidgets);
    await tester.press(find.byKey(Key("back")));
    await tester.pump();
  });*/

  MockFirebaseAuth _auth = MockFirebaseAuth();
  BehaviorSubject<MockFirebaseUser> _user = BehaviorSubject<MockFirebaseUser>();
  when(_auth.onAuthStateChanged).thenAnswer((_) {
    return _user;
  });
/*
  testWidgets("ouverture mot de passe oublie", (WidgetTester tester) async {
    when(
      _auth.sendPasswordResetEmail(email: "schloesslin.lucas@gmail.com"),
    ).thenAnswer((realInvocation) => null);

    await tester.pumpWidget(ForgotPass());
    await tester.enterText(
        find.byKey(Key("email")), 'schloesslin.lucas@gmail.com');
    await tester.tap(find.byKey(Key("sendpass")));
    await tester.pump();
    expect(find.text("Un email a été envoyé"), findsWidgets);
  });
*/
  testWidgets("ouverture mot de passe oublie", (WidgetTester tester) async {
    when(
      _auth.sendPasswordResetEmail(email: "schloesslin.lucas@gmail.com"),
    ).thenAnswer((realInvocation) => null);

    await tester.pumpWidget(ForgotPass());
    expect(find.text("Forgot password"), findsWidgets);
    expect(find.byKey(Key('email')), findsWidgets);

    await tester.enterText(
        find.byKey(Key("email")), 'schloesslin.lucas@gmail.com');
    await tester.tap(find.byKey(Key("sendpass")));
    await tester.pump();

    expect(find.text("Un email a été envoyé"), findsWidgets);
  });

  test("convert datetime", () {
    DateTime dateTime = DateTime(2020, 9, 7, 17, 30);
    DateManage.getDateString(dateTime);
    expect(DateManage.getDateString(dateTime), "7/9/2020 - 17h30");
  });

  test("get publish transfert programme", () {
    DatabasePusher.pushTransfert("email", 1, "authmail", "authName", "destName",
        "question", "response", "value", "date");
  });

  Controller _repo = Controller.instance(auth: _auth);
  group('user repository test', () {
    when(_auth.signInWithEmailAndPassword(email: "email", password: "password"))
        .thenAnswer((_) async {
      _user.add(MockFirebaseUser());
      return MockAuthResult();
    });
    when(_auth.signInWithEmailAndPassword(email: "mail", password: "pass"))
        .thenThrow(() {
      return null;
    });

    test("sign in with email and password", () async {
      bool signedIn = await _repo.signIn("email", "password");
      expect(signedIn, true);
      expect(_repo.status, Status.Authenticated);
    });

    test("sing in fails with incorrect email and password", () async {
      bool signedIn = await _repo.signIn("mail", "pass");
      expect(signedIn, false);
      expect(_repo.status, Status.Unauthenticated);
    });

    test('sign out', () async {
      await _repo.signOut();
      expect(_repo.status, Status.Unauthenticated);
    });
  });
  test("create account", () async {
    when(
      _auth.createUserWithEmailAndPassword(
          email: "tadas@gmail.com", password: "123456"),
    ).thenAnswer((realInvocation) => null);

    expect(
        await _repo.createAccount(email: "tadas@gmail.com", password: "123456"),
        "Success");
  });

  test("create user firebase", () {
    _repo.createUser("email", "pass", "firstName", "lastName");
    _repo.createUserFirestore("uid", "email", "firstName", "lastName");
  });
}
