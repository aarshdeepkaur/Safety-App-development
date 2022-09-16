/// contacts notifier.dart  
///  authors @musabisimwa @diri0060
/// 
/// contains all methods that can be evoked by a user in the front end 
/// 

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactsNotifier extends StateNotifier<List<Contact>> {
  ContactsNotifier() : super([]);

  //todo: read contacts from local db contacts repo

  //todo: write/update contacts db on contacts change

  //get contacts from phone
  //contacts
  void getPhoneData() async {
    //need to ask user permisiion to access contacts
    if (await FlutterContacts.requestPermission()) {
      state = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);

    }
  }
}
