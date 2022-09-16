// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_app/constats.dart';
import 'package:safe_app/screens/client/addContactFromPhone.dart';
import 'package:safe_app/screens/client/addContactScreen.dart';
import 'package:safe_app/screens/client/forgotPassword.dart';
import 'package:safe_app/screens/client/loginScreen.dart';
import 'package:safe_app/screens/client/mainScreen.dart';
import 'package:safe_app/screens/client/settingsScreen.dart';
import 'package:safe_app/screens/client/signUpScreen.dart';
import 'package:safe_app/services/database/database.dart';
import 'package:safe_app/services/models/auth_model.dart';

StreamController<bool> streamController = StreamController<bool>.broadcast();
DocumentSnapshot? snapshot; //Define snapshot
class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    // verify auth
    // Return Home or Authenicate(LoginScreen) widget
    if(user == null){
      return MaterialApp(
        // turn to false to remove the debug banner
        debugShowCheckedModeBanner: true,
        home: LoginScreen(), //LoginScreen(),
        routes: <String, WidgetBuilder>{
          CLIENT_SIGNUP_ROUTE: (context) => SignUpScreen(),
          CLIENT_FORGET_ROUTE: (context) => ForgetPasswordScreen(),
        },
      );
    }
    else{
      // Wait to retrieve user data then return Main Screen
      return FutureBuilder<AppUser>(
          future: DatabaseService(uid: user.id).getUserData(user),
          builder: (context, snapshot){
            if(snapshot.hasData){
                return MaterialApp(
                  // turn to false to remove the debug banner
                  debugShowCheckedModeBanner: true,
                  home: ClientMainScreen(user.id, streamController.stream), //LoginScreen(),
                  routes: <String, WidgetBuilder>{
                    // add more routes here
                    CLIENT_SETTING_ROUTE: (context) =>
                        SettingsScreen(),
                    CLIENT_ADD_CONTACT_ROUTE: (context) =>
                        AddContactScreen(user.id),
                    CLIENT_ADD_CONTACT_PHONE_ROUTE: (context) => AddContactPhoneScreen(user.id),
                    CLIENT_MAIN_ROUTE:(context) => ClientMainScreen(user.id, streamController.stream),
                  },
                );
              }
            return Center(child: Platform.isAndroid
                ? CircularProgressIndicator()
                : CupertinoActivityIndicator(),);
          });
    }
  }
}
// route admin screens if user is admin
