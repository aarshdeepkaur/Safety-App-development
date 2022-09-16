import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:safe_app/constats.dart';
import 'package:safe_app/screens/common/themedFrame.dart';
import 'package:safe_app/screens/common/themedHooks.dart';
import 'package:safe_app/services/authentication/auth.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  // form key to validate form field
  final _formKey = GlobalKey<FormState>();

  // Authentication service with Firebase
  final AuthService _auth = AuthService();

  // Error message
  String error = "";

  // input field controllers
  TextEditingController _emailFieldController = TextEditingController();

  // equal space for all fields
  final _space = Padding(padding: EdgeInsets.only(bottom: 20));

  /// Back to login page
  ///
  void onBackIconClick() {
    setState(() {
      Navigator.popAndPushNamed(context, ROOT_ROUTE);
    });
  }

  /// reset password button clicked?
  /// check if email input is validate
  /// call resetPassword()
  /// show error if there's one
  void resetPassword() async{
    if(_formKey.currentState!.validate()){
      String email = _emailFieldController.text;
      await _auth.resetPassword(email).then((value) {
        // get error value
        if (value is String ) {
          setState(() {
            error = "Email is badly formatted or there's no user record corresponding to this identifier";
          });
        }
        else {
          setState(() {
            error = "Email is sent, please check and reset your password";
          });
        }
      });
    }
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
                    padding: EdgeInsets.only(right: (Platform.isAndroid)? 120:90),
                    child: Text(
                      "Reset Password ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  )
                ], //create an account
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 60),
                child: Text(
                  "Receive an email to reset your password.",
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
                      /// Email
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

              // signup button
              SimpleButton(
                height: 55,
                width: 167,
                onPressed: resetPassword,
                textColor: Colors.black,
                label: "RESET PASSWORD",
                color: Color.fromARGB(255, 147, 207, 187),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
