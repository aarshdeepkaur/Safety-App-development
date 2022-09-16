// ignore_for_file: prefer_const_constructors

/**
 * 
 * authors @musabisimwa @diri0060
 * 
 * sign up screen 
 * contains the client login screen with inputs
 * for more information follow the link below
 * link: https://runtime-terror4001.atlassian.net/wiki/spaces/SA/blog/2022/03/16/753665/UI+UX+Design
 * 
 * 
 */
/// note to dev: should contain minimal business logic
///

/// note to dev: should contain minimal business logic
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:safe_app/constats.dart';
import 'package:safe_app/screens/common/themedFrame.dart';
import 'package:safe_app/screens/common/themedHooks.dart';
import 'package:safe_app/services/authentication/auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  // form key to validate form field
  final _formKey = GlobalKey<FormState>();

  // Authentication service with Firebase
  final AuthService _auth = AuthService();

  // Error message
  String error = "";

  // input field controllers
  TextEditingController _firstNameFieldController = TextEditingController();
  TextEditingController _lastNameFieldController = TextEditingController();

  TextEditingController _emailFieldController = TextEditingController();

  TextEditingController _phoneNumFieldController = TextEditingController();

  // p hasher here or in BLoc

  TextEditingController _passFieldController = TextEditingController();

  TextEditingController _passConfFieldController = TextEditingController();
  // equal space for all fields
  final _space = Padding(padding: EdgeInsets.only(bottom: 20));

  /// signup button clicked?
  /// get all text field and call registerWithEmailAndPassword()
  /// show error if there's one
  /// back to login page if register successfully
  void onSignUpButtonClick() async {
    // SINK here
    //acton to navigator if  entity
    if(_formKey.currentState!.validate()){
      String email = _emailFieldController.text;
      String pwd = _passFieldController.text;
      String fName = _firstNameFieldController.text;
      String lName = _lastNameFieldController.text;
      String phoneNumber = _phoneNumFieldController.text;
      dynamic result = await _auth.registerWithEmailAndPassword(email, pwd, fName, lName, phoneNumber).then((value) {
        if(value is String || value == null){
          setState(() {
            error = value;
          });
        }
        else{
          Navigator.popAndPushNamed(context, ROOT_ROUTE);
        }
      });
    }
  }

  /// Back to Login page
  ///
  void onLoginButtonClick() {
    // go to log in screen
    //no sink
    //switch context to login
    setState(() {
      Navigator.popAndPushNamed(context, ROOT_ROUTE);
    });
  }

  /// Back to Login page
  void onBackIconClick() {
    onLoginButtonClick();
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: IconButton(
                          onPressed: onBackIconClick,
                          icon: Icon(
                            LineIcons.arrowLeft,
                            color: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: (Platform.isAndroid)? 100:90),
                      child: Text(
                        "Create an account",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ], //create an account
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Text(
                    "please fill in the fields",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color.fromARGB(215, 48, 114, 109),
                    ),
                  ),
                ),

                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        /// First name
                        Container(
                          margin:  EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                          child: TextFormField(
                            controller: _firstNameFieldController,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'First name',
                                errorStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14)),
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.white),
                            validator: (val) => val!.isEmpty ? 'Enter your first name' : null,
                            onChanged: (val){
                              setState(() {
                                //email = val;
                              });
                            },
                          ),
                        ),
                        _space,
                        /// Last name
                        Container(
                          margin:  EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                          child: TextFormField(
                            controller: _lastNameFieldController,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Last name',
                                errorStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14)),
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.white),
                            validator: (val) => val!.isEmpty ? 'Enter your last name' : null,
                            onChanged: (val){
                              setState(() {
                                //email = val;
                              });
                            },
                          ),
                        ),
                        _space,
                        /// Last name
                        Container(
                          margin:  EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                          child: TextFormField(
                            controller: _emailFieldController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Email address',
                                errorStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14)),
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.white),
                            validator: (val) => val!.isEmpty ? 'Enter your email address' : null,
                            onChanged: (val){
                              setState(() {
                                //email = val;
                              });
                            },
                          ),
                        ),
                        _space,
                        /// Phone number
                        Container(
                          margin:  EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                          child: TextFormField(
                            controller: _phoneNumFieldController,
                            keyboardType: TextInputType.number,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Phone number',
                                errorStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14)),
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.white),
                            validator: (val) => val!.isEmpty ? 'Enter your phone number' : null,
                            onChanged: (val){
                              setState(() {
                                //email = val;
                              });
                            },
                          ),
                        ),
                        _space,
                        /// Password
                        Container(
                          margin:  EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                          child: TextFormField(
                            controller: _passFieldController,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Password',
                                errorStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14)),
                            cursorColor: Colors.black,
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            validator: (val) => val!.length < 6 ? 'Enter a password with more than 6 characters' : null,
                            onChanged: (val){
                              setState(() {
                                //email = val;
                              });
                            },
                          ),
                        ),
                        // _space,
                        // /// Password confirm
                        // Container(
                        //   margin:  EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                        //   child: TextFormField(
                        //     controller: _passConfFieldController,
                        //     decoration: textInputDecoration.copyWith(
                        //         hintText: 'Confirm Password'
                        //     ),
                        //     cursorColor: Colors.black,
                        //     obscureText: true,
                        //     style: TextStyle(color: Colors.white),
                        //     validator: (val) => val != _passFieldController.text ? 'Password does not match' : null,
                        //     onChanged: (val){
                        //       setState(() {
                        //         //email = val;
                        //       });
                        //     },
                        //   ),
                        // ),
                        // _space,
                      ],
                    ),
                  ),
                ),
                /// Error message
                Container(
                  margin:  EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Text(
                    error,
                    style: TextStyle(color: Color.fromARGB(255, 192, 192, 192), fontSize: 12.0),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 40),
                ),
                // signup button
                SimpleButton(
                  height: 55,
                  width: 167,
                  onPressed: onSignUpButtonClick,
                  textColor: Colors.black,
                  label: "SIGN UP",
                  color: Color.fromARGB(255, 147, 207, 187),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account ? ',
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 147, 207, 187)),
                          ),
                          TextButton(
                            onPressed: onLoginButtonClick,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 147, 207, 187),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
