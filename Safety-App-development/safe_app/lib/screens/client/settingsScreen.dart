// ignore_for_file: prefer_const_constructors

/// settings screen dart
///
///
/// Contains the UI components of the settings
/// application and account settings
///
/// author @musabisimwa @diri0060
///

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:safe_app/constats.dart';
import 'package:safe_app/screens/common/themedFrame.dart';
import 'package:safe_app/screens/common/themedHooks.dart';
import 'package:safe_app/services/authentication/auth.dart';
import 'package:safe_app/services/database/localdb.dart';
import 'package:safe_app/services/models/auth_model.dart';
import 'package:safe_app/services/providers/main_screen_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _auth = AuthService();
  final _addressController = TextEditingController();
  late List<AutocompletePrediction> predictions;
  late GooglePlace googleplace;
  String? _homeAddress;
  bool homeIset = false;
  late Timer _timer;

  _SettingsScreenState() {
    googleplace = GooglePlace(G_API_KEY);
    predictions = <AutocompletePrediction>[];
  }

  void onBackIconClick() {
    setState(() {
      Navigator.pop(context);
    });
  }

// show google place suggestions for a home address
  void onHomeAddressFieldChange(String val) {}

  //add address to db
  void onAddressAddButtonPressed() async {
    print("add pressed");
    String _home = predictions[0].description ?? 'none';
    await LocalStorageService.setAddress(_home);
    setState(() {
      homeIset = true;
    });
    
  }

//disable if db empty

  void onAddressDeleteButtonPressed() async {
    print("delete pressed");
    await LocalStorageService.removeAddress();
    homeIset = false;
  }

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {});
      if (_addressController.value.text.isNotEmpty) {
        predictions = await autoCompleteSearch(
            search: _addressController.value.text, googleplace: googleplace);
      }
    });
    initLocalDb();
    super.initState();
  }

// start the services by getting the home address if available
  Future initLocalDb() async {
    _homeAddress = await LocalStorageService.getAddress();
    if (_homeAddress != null && _homeAddress != 'none') {
      homeIset = true;
    }
    print(_homeAddress);
  }

  @override
  void dispose() {
    _timer.cancel();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    const _space = Padding(padding: EdgeInsets.only(top: 10));
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
                    //android ==200       ios ==?
                    padding: EdgeInsets.only(
                        right: (Platform.isAndroid) ? MediaQuery.of(context).size.height*0.2 : 170),
                    child: Text(
                      "Settings",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  )
                ], //create an account
              ),
              //padding separator
              HorizontalDivider(opacity: 0.3),
              _space,
              //home address
              Container(
                height: MediaQuery.of(context).size.height * 0.27,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Default home address',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      homeIset
                          ? Column(
                            children: const[
                              Icon(
                              Icons.done_rounded,
                              size: 60,
                              color: Colors.greenAccent,
                            ),
                            Text(
                        'home is set',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color.fromARGB(255, 149, 236, 198),
                        ),)
                            ],
                          )
                          : Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 8.0),
                              child: Stack(

                                  //overflow

                                  children: [
                                    TextFormField(
                                      controller: _addressController,
                                      decoration: textInputDecoration.copyWith(
                                          hintText: 'home address',
                                          errorStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              fontSize: 14)),
                                      cursorColor: Colors.red,
                                      style: TextStyle(color: Colors.white),
                                      validator: (val) => val!.isEmpty
                                          ? 'Enter home address'
                                          : null,
                                      onChanged: onHomeAddressFieldChange,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 50),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: (predictions.length > 3)
                                            ? 1
                                            : predictions.length,
                                        itemBuilder: ((context, index) {
                                          return ListTile(
                                            onTap: onAddressAddButtonPressed,
                                            title: Text(
                                              predictions[index]
                                                  .description
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ])),
                      //buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          homeIset
                              ? SizedBox()
                              : TextButton.icon(
                                  onPressed: onAddressAddButtonPressed,
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  label: Text('Add')),
                          homeIset
                              ? TextButton.icon(
                                  onPressed: onAddressDeleteButtonPressed,
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red.shade700,
                                  ),
                                  label: Text('Remove'))
                              : SizedBox(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              _space,
              //add contact manual
              SettingsTile(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.9,
                  onTap: () {
                    setState(() {
                      Navigator.popAndPushNamed(
                          context, CLIENT_ADD_CONTACT_ROUTE);
                    });
                  },
                  label: "Add contact manually",
                  color: Color.fromARGB(103, 155, 153, 152)),
              _space,
              // add contact from phone
              SettingsTile(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.9,
                  onTap: () {
                    setState(() {
                      Navigator.popAndPushNamed(
                          context, CLIENT_ADD_CONTACT_PHONE_ROUTE);
                    });
                  },
                  label: "Add contact from phone contacts",
                  color: Color.fromARGB(103, 152, 153, 152)),
              Padding(padding: EdgeInsets.only(top: 10)),
              //logout
              SettingsTile(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.9,
                onTap: () async {
                  await _auth.signOut();
                  setState(() =>
                      Navigator.popAndPushNamed(context, CLIENT_LOGIN_ROUTE));
                },
                label: "Logout",
                color: Color.fromARGB(161, 128, 12, 12),
              ),
              _space,
              Container(
                height: MediaQuery.of(context).size.height * 0.22,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      APP_NAME,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'version $APP_VERSION',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: Color.fromARGB(136, 255, 255, 255),
                      ),
                    ),
                    Text(
                      APP_PERMISSION_STR,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: Color.fromARGB(228, 155, 209, 186),
                      ),
                    ),
                    Text(
                      APP_DEVELOPERS,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: Color.fromARGB(188, 238, 238, 238),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
//
