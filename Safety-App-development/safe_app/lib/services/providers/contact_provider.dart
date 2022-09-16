// ignore_for_file: prefer_const_constructors

/**
 * contact provider.dart dart
 * 
 * dictates every posisible behaviour a contact widget group can perform
 *  -*adding or removing contacts
 *  -setting priority contacts
 *  
 * 
 * 
 * author @musabisimwa @diri0060
 * 
 */

import 'package:safe_app/services/models/auth_model.dart';

import '../models/contact_model.dart';

///
///

class ContactProvider {
  // array model contact
  late List<ContactWidgetGroupProvider> _contacts;
  ContactProvider() {
    // fetch contacts from phonebook
    //if empty create a new one
    _contacts = [];
  }

  ///
  ///on click set in is - !bool
}

///
///provides the required data  for the contact widget group in the main screen
class ContactWidgetGroupProvider extends AppContact {
  bool inList = false;
  String? profileUrl;
  ContactWidgetGroupProvider(
      {required int id,required String phoneNumbers, required String name, this.profileUrl})
      : super(id:id,phoneNumber: phoneNumbers,name:name);

  /// set in list status
  /// whether this contact should be shown in the widget group
  void setInList(bool b) {
    inList = b;
  }
}
