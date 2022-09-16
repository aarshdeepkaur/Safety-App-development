// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

import 'contact_model.dart';

/// @author @musabisimwa
///
/// user_models.dart contains the models that are 
/// weakly linked to the data layer (web data:firebase)
///


class AppUser extends Equatable {
  final String id;
  bool isAdmin;
  String? emailAdress;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  List<AppContact>? contacts;

  AppUser(
      {required this.id,
      required this.isAdmin,
      this.emailAdress,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.contacts});

  @override
  List<Object?> get props =>
      [id, emailAdress, contacts, firstName, lastName, phoneNumber];

  /// Update information locally for AppUser
  ///
  /// Return nothing
  void updateInfo(bool? isAdmin, String? email, String? firstName, String? lastName, String? phoneNumber, List? contactList){
    if(isAdmin != null){
      this.isAdmin = isAdmin;
    }
    if(firstName != null){
      this.firstName = firstName;
    }

    if(lastName != null){
      this.lastName = lastName;
    }

    if(email != null){
      this.emailAdress = email;
    }

    if(phoneNumber != null){
      this.phoneNumber = phoneNumber;
    }

    if(contactList != null){
      contacts = List.from(contactList.map(
              (e) => AppContact(id: int.parse(e["id"]), name: e['name'], phoneNumber: e['phoneNumber'], priority: null,)));
    }
    //debug?
    // print("UPDATED\n");
    // print(this.firstName! + " " + this.lastName! + " " + this.emailAdress! + " " + this.phoneNumber!);
  }
}

//2.0

