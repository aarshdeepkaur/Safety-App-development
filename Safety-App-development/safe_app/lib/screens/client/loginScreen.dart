// ignore_for_file: prefer_const_constructors

/**
 * 
 * authors @musabisimwa @diri0060
 * 
 * login screen 
 * contains the client login screen with inputs
 * for more information follow the link below
 * link: https://runtime-terror4001.atlassian.net/wiki/spaces/SA/blog/2022/03/16/753665/UI+UX+Design
 * 
 * 
 */
/// note to dev: should contain minimal business logic
///

/// note to dev: should contain minimal business logic
import 'package:flutter/material.dart';
import 'package:safe_app/constats.dart';
import 'package:safe_app/screens/common/themedFrame.dart';
import 'package:safe_app/screens/common/themedHooks.dart';
import 'package:safe_app/services/authentication/auth.dart';

import 'signUpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    //print("Init Login");
  }

  @override
  void dispose() {
    super.dispose();
    //print("Dispose Login");
  }

  // Authentication service with Firebase
  final AuthService _auth = AuthService();

  String email = "";
  String pwd = "";
  String error = "";

  // form key to validate form field
  final _formKey = GlobalKey<FormState>();

  // input field controllers

  TextEditingController _emailFieldController = TextEditingController();

  // p hasher here or in BLoc

  TextEditingController _passFieldController = TextEditingController();

// equal space for all fields
  final _space = Padding(padding: EdgeInsets.only(bottom: 20));

  /// signup button clicked?
  /// navigate to signup page
  void onSignUpButtonClick() {
    // no SINK here
    // acton to navigator if new entity
    // this just switches context to signup screen
    setState(() {
      Navigator.popAndPushNamed(context, CLIENT_SIGNUP_ROUTE);
    });
  }

  /// login button clicked?
  /// check if inputs are validate
  /// call signInWithEmailAndPassword()
  /// print out error if there's one
  /// the app will detect if there's a user signed in, and move to main page
  void onLoginButtonClick() async {
    // auth , then go to main
    if (_formKey.currentState!.validate()) {
      setState(() {});
      dynamic result =
          _auth.signInWithEmailAndPassword(email, pwd).then((value) {
        // get error value
        if (value is String) {
          setState(() {
            error = value;
          });
        }
      });
    } else {
      setState(() {
        error = "";
      });
    }
  }

  /// forgot password button clicked?
  ///
  /// navigate to forgot password page
  void onForgotPasswordButtonClick() {
    setState(() {
      Navigator.popAndPushNamed(context, CLIENT_FORGET_ROUTE);
    });
  }

  /// sign in with Google button clicked?
  /// call loginGoogle()
  void onContinueWithGoogleButtonClick() {
    // use google account for auth
    dynamic result = _auth.loginGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedFrame(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(), // push up when keyboard pops up
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 250, 60),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Color.fromARGB(214, 250, 252, 252),
                  ),
                ),
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //fields
                      //text input field here
                      /// email
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 0.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailFieldController,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Email',
                              errorStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14)),
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          validator: (val) => val!.isEmpty
                              ? 'Email field cannot be empty'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                        ),
                      ),
                      _space,

                      /// password
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 0.0),
                        child: TextFormField(
                          controller: _passFieldController,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password',
                              errorStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14)),
                          validator: (val) => val!.isEmpty
                              ? 'invalid credentials'
                              : null,
                          obscureText: true,
                          cursorColor: Color.fromARGB(255, 255, 255, 255),
                          style: TextStyle(color: Colors.white),
                          onChanged: (val) {
                            setState(() {
                              pwd = val;
                            });
                          },
                        ),
                      ),

                      /// Error message
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: Text(
                          error.replaceAll('[firebase_auth/invalid-email]', ''),
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //fields
              //text input field here
              Padding(
                padding: EdgeInsets.only(top: 40),
              ),
              // signup button
              SimpleButton(
                height: 55,
                width: 167,
                onPressed: onLoginButtonClick,
                textColor: Colors.black,
                label: "LOGIN",
                color: Color.fromARGB(255, 147, 207, 187),
              ),
              //forgot password
              Padding(
                padding: EdgeInsets.only(top: 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Forgot ',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 147, 207, 187)),
                  ),
                  TextButton(
                    onPressed: onForgotPasswordButtonClick,
                    child: Text(
                      'password ?',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 147, 207, 187),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              ),
              //continue with google
              Padding(
                padding: EdgeInsets.only(top: 0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Continue with  ',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 147, 207, 187)),
                  ),
                  TextButton(
                    onPressed: onContinueWithGoogleButtonClick,
                    child: Text(
                      'Google',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 147, 207, 187),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              ),
              //dont have an account?
              Padding(
                padding: EdgeInsets.only(top: 90),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Don\'t have an account ? ',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 147, 207, 187)),
                  ),
                  TextButton(
                    onPressed: onSignUpButtonClick,
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 147, 207, 187),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
