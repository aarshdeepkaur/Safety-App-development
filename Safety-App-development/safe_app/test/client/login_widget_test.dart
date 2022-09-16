// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_app/screens/client/loginScreen.dart';
import 'package:safe_app/screens/common/themedHooks.dart';

void main() {
  //needs firebase
// widget has  title and email/pass form fields

  testWidgets('widget has  title and email/pass form fields', (tester) async {
    //code here
    await Firebase.initializeApp();
    await tester.pumpWidget(const LoginScreen());

    //find the login string label
    // text widgets should be 8 with in the  flutter tree
    final titleFinder = find.text("Login"); //finds one

    //find the text fields is made of containers
    final loginFormField = find.byType(Container); //finds 4

    expect(titleFinder, findsOneWidget);
    expect(loginFormField, findsNWidgets(4));
  });

//widget has 4 buttons
  testWidgets('widget has 4 buttons', (tester) async {
    //code here
    await Firebase.initializeApp();
    await tester.pumpWidget(const LoginScreen());

    //find the login string label
    // text widgets should be 8 with in the  flutter tree
    final txtbtns = find.byType(TextButton); //finds one

    //find the text fields is made of containers
    final loginbtn = find.byWidget(
        SimpleButton(height: 55, width: 167, onPressed: () {})); //finds 4

    expect(txtbtns, findsNWidgets(3));
    expect(loginbtn, findsOneWidget);
  });

//button called login

//button called password

//button called Google

//button called sign up
}
