import 'dart:io';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:safe_app/constats.dart';
import 'package:safe_app/screens/client/wrapper.dart';
import 'package:safe_app/screens/common/themedFrame.dart';
import 'package:safe_app/services/database/database.dart';
import 'package:safe_app/services/models/auth_model.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:safe_app/services/models/contact_model.dart';
import 'package:provider/provider.dart' as stream_provider;


class AddContactPhoneScreen extends StatefulWidget {
  final String? uid;

  const AddContactPhoneScreen(this.uid, {Key? key}) : super(key: key);

  @override
  _AddContactPhoneScreenState createState() => _AddContactPhoneScreenState(uid);
}

class _AddContactPhoneScreenState extends State<AddContactPhoneScreen> {

  AppUser? _appUser;
  String? _uid;
  List<Contact>? contacts;
  List<AppContact>? appContacts;

  Color contactColorbg = Colors.white.withOpacity(0.3);

  Color contactChoseColorbg = Colors.blue.withOpacity(0.3);

  _AddContactPhoneScreenState(String? uid){
    _uid = uid;
    _appUser = AppUser(id: _uid!, isAdmin: false);
  }



  void getPhoneContact() async{
    //need to ask user permisiion to access contacts
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true).whenComplete(() {
        setState(() {});
      });
      appContacts = contacts!.map((e) {
        String phone = e.phones.first.number.replaceAll(RegExp(r'[^0-9]'),'');
        AppContact a = AppContact(id: e.id.hashCode, phoneNumber: phone, name: e.name.first);
        if(_appUser!.contacts != null && _appUser!.contacts!.any((element) => element.name == a.name && element.phoneNumber == a.phoneNumber)){
          a.addToDb = true;
          //print("ADDED " + a.name);
        }
        return a;
      }).toList();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser().then((value) async {
      getPhoneContact();
    });
  }

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

  void addContactDB(AppContact contact) async{
    await DatabaseService(uid: _appUser!.id).addContactManual(contact);
    streamController.add(true);
  }

  void removeContactDB(AppContact contact) async{
    await DatabaseService(uid: _appUser!.id).removeContact(contact);
    streamController.add(true);
  }


  Future<void> getCurrentUser() async {
    _appUser = await DatabaseService(uid: _uid).getUserData(_appUser!);
  }


  @override
  Widget build(BuildContext context) {
    final user = stream_provider.Provider.of<AppUser?>(context);
    return ThemedFrame(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // push up when keyboard pops up
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
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: IconButton(
                        onPressed: onBackIconClick,
                        icon: const Icon(
                          LineIcons.arrowLeft,
                          color: Colors.white,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: (Platform.isAndroid) ? 120 : 90),
                    child: const Text(
                      "List of contacts",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  )
                ], //create an account
              ),
              const SizedBox(height: 20.0,),
              (appContacts == null)
                  ? const Center(child: CircularProgressIndicator())
                  : (appContacts!.length == 0)
                  ? const Center(
                child: Text(
                  'No contact found',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),)
                  : Expanded(
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
                                        SizedBox(height: 10.0,),
                                        Text(
                                          appContacts![index].phoneNumber.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        )
                                      ],
                                    )),
                                Spacer(),
                                Theme(
                                  data: ThemeData(
                                    primarySwatch: Colors.blue,
                                    unselectedWidgetColor: Colors.white, // Your color
                                  ),
                                  child: Checkbox(
                                    value: appContacts![index].addToDb,
                                    onChanged: (bool? value) {
                                      setState(()  {
                                        if(value!){
                                          addContactDB(appContacts![index]);
                                        }
                                        else{
                                          removeContactDB(appContacts![index]);
                                        }
                                        appContacts![index].addToDb = value;
                                      });
                                    },
                                  ),
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
