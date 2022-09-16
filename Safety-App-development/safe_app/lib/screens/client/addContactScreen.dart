import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:safe_app/constats.dart';
import 'package:safe_app/screens/client/wrapper.dart';
import 'package:safe_app/screens/common/themedFrame.dart';
import 'package:safe_app/screens/common/themedHooks.dart';
import 'package:safe_app/services/database/database.dart';
import 'package:safe_app/services/models/auth_model.dart';
import 'package:safe_app/services/models/contact_model.dart';
import 'package:uuid/uuid.dart';

class AddContactScreen extends StatefulWidget {
  //final AppUser? appUser;
  final String? _uid;
  const AddContactScreen(this._uid, {Key? key}) : super(key: key);

  @override
  _AddContactScreenState createState() => _AddContactScreenState(_uid);
}

class _AddContactScreenState extends State<AddContactScreen> {
  AppUser? _appUser;
  String? _uid;
  List<AppContact>? appContacts = [];
  // form key to validate form field
  final _formKey = GlobalKey<FormState>();

  // Authentication service with Firebase
  //final AuthService _auth = AuthService();

  // Error message
  String error = "";

  // input field controllers
  TextEditingController _nameFieldController = TextEditingController();

  TextEditingController _phoneNumFieldController = TextEditingController();


  // equal space for all fields
  final _space = Padding(padding: EdgeInsets.only(bottom: 20));

  _AddContactScreenState(String? uid){
    _uid = uid;
    _appUser = AppUser(id: _uid!, isAdmin: false);
  }




  /// signup button clicked?
  /// get all text field and call registerWithEmailAndPassword()
  /// show error if there's one
  /// back to login page if register successfully
  void AddContactButtonClick() async {
    // SINK here
    //acton to navigator if  entity
    if(_formKey.currentState!.validate()){
      String name = _nameFieldController.text;
      String phoneNumber = _phoneNumFieldController.text;
      var uuid = Uuid();
      var contact = AppContact(id: uuid.v1().hashCode, phoneNumber: phoneNumber, name: name, priority: null);
      await DatabaseService(uid: _appUser!.id).addContactManual(contact).then((value) {
        setState(() {
          appContacts!.add(contact);
          error = "Added sucessfully";
          _nameFieldController.clear();
          _phoneNumFieldController.clear();
          streamController.add(true);
        });
      });
    }
  }


  void removeContactDB(AppContact contact) async{
    await DatabaseService(uid: _appUser!.id).removeContact(contact);
    streamController.add(true);
  }

  // void addContactDB(Contact contact) async{
  //   await DatabaseService(uid: _uid).addContact(contact);
  // }



  /// Back to Setting page
  ///
  void SettingButtonClick() {
    // go to log in screen
    //no sink
    //switch context to login
    setState(() {
      Navigator.popAndPushNamed(context, CLIENT_SETTING_ROUTE);
    });
  }

  /// Back to Setting page
  void onBackIconClick() {
    SettingButtonClick();
  }

  Future<void> getCurrentUser() async {
    _appUser = await DatabaseService(uid: _uid).getUserData(_appUser!);
    if(_appUser!.contacts != null && _appUser!.contacts!.length != 0){
      appContacts = _appUser!.contacts;
      //print("DONE " + appContacts!.length.toString());
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }


  @override
  Widget build(BuildContext context) {
    return ThemedFrame(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(), // push up when keyboard pops up
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery
                .of(context)
                .size
                .height,
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
                    padding: EdgeInsets.only(
                        right: (Platform.isAndroid) ? 120 : 90),
                    child: Text(
                      "Add a contact",
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
                      /// Name
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        child: TextFormField(
                          controller: _nameFieldController,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Name',
                              errorStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14)),
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.white),
                          validator: (val) =>
                          val!.isEmpty
                              ? 'Enter name'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              //email = val;
                            });
                          },
                        ),
                      ),
                      _space,

                      /// Phone number
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
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
                          validator: (val) =>
                          val!.isEmpty
                              ? 'Enter phone number'
                              : null,
                          onChanged: (val) {
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
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Text(
                  error,
                  style: TextStyle(color: Color.fromARGB(255, 192, 192, 192),
                      fontSize: 12.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              // signup button
              SimpleButton(
                height: 55,
                width: 167,
                onPressed: AddContactButtonClick,
                textColor: Colors.black,
                label: "ADD CONTACT",
                color: Color.fromARGB(255, 147, 207, 187),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Center(child: Text("Contact List", style: TextStyle(color: Colors.white, fontSize: 20.0)),),
              (appContacts!.length == 0) ? Center(child: Text(""),) :
               Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                    //itemExtent: 75, // space the contact icons
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: appContacts!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.person,color: Colors.white),
                                SizedBox(width: 15.0,),
                                Flexible(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          appContacts![index].name,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          appContacts![index].phoneNumber.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    )),
                                const Spacer(),
                                TextButton(
                                  child: Text("Remove", style: TextStyle(color: Colors.white)),
                                  onPressed: (){
                                    setState(() {
                                      removeContactDB(appContacts![index]);
                                      appContacts!.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.white54),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
