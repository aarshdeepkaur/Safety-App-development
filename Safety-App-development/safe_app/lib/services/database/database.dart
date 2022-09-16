import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_app/services/models/auth_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:safe_app/services/models/contact_model.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {

  final String? uid;

  DatabaseService({ this.uid});

  // collection reference
  final CollectionReference userDataCollection = FirebaseFirestore.instance.collection('User');
  final CollectionReference alertDataCollection = FirebaseFirestore.instance.collection('Alerts');
  /// Update user information in database
  ///
  /// Return nothing
  Future setUserData(String fName, String lName, String email, String phoneNumber) async {
    return await userDataCollection.doc(uid).set({
      'firstName' : fName,
      'lastName'  : lName,
      'email'     : email,
      'phoneNumber': phoneNumber,
      'isAdmin'   : false,
      'contactList': null,
    });
  }

  /// Get user information from database
  ///
  /// Return nothing
  Future<AppUser> getUserData(AppUser user) async { //use a Async-
    // await function to get the data
    await FirebaseFirestore.instance.collection("User").doc(uid).get().then((value) {
        var result = value.data() as Map<String, dynamic>;
        // Get the information to AppUser
        //user.updateInfo(result['isAdmin'], result['email'], result['firstName'], result['lastName'], result['phoneNumber'], result['contactList']);
        user.updateInfo(result['isAdmin'], result['email'], result['firstName'], result['lastName'], result['phoneNumber'], result['contactList']);
    }); //get the data
    return user;
  }

  /// Check if the instance of an user exists in database
  ///
  /// Return True if yes, False for no
  Future<bool> checkExist() async {
    bool exist = false;
    try {
      await FirebaseFirestore.instance.collection("User").doc(uid).get().then((doc) {
        exist = doc.exists;
      });
      return exist;
    } catch (e) {
      // If any error
      return false;
    }
  }

  void addAlert(String message, AppContact contact, Position? location, String? postalCode, String? address, String? city, String? country) async{
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return await alertDataCollection.doc(uid! + formattedDate).set({
      'userID' : uid,
      'time'  : formattedDate,
      'contact' : contact.toMap(),
      'message' : message,
      'locationJson': location!.toJson(),
      'postalCode' : postalCode,
      'address' : address,
      'city' : city,
      'country' : country
    });
  }


  Future<void> addContactList(List<Contact>? contacts) async{
    final contactList = contacts!.map((c) => {
      "id": c.id,
      "name": c.name.first.toString(),
      "number": c.phones.first.number.toString(),
      "priority": "Unknown"
    }).toList();

    return await userDataCollection.doc(uid).update({
      'contactList' : contactList,
    });
  }

  

  Future<void> addContactManual(AppContact contact) async {
  
    dynamic contactDB = {
      'id' : contact.id.toString(),
      'name': contact.name,
      'phoneNumber' : contact.phoneNumber,
      'priority' : null
    };
    return userDataCollection.doc(uid).update({
      'contactList' : FieldValue.arrayUnion([contactDB]),
    });
  }

  Future<void> removeContact(AppContact contact) async{
    dynamic contactDB = {
      'id' : contact.id.toString(),
      'name': contact.name,
      'phoneNumber' : contact.phoneNumber,
      'priority' : null
    };
    return userDataCollection.doc(uid).update({
      'contactList' : FieldValue.arrayRemove([contactDB]),
    });
  }

}