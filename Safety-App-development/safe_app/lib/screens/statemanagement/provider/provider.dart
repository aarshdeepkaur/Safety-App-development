import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_app/screens/statemanagement/notifiers/contactsNotifier.dart';
import 'package:safe_app/screens/statemanagement/notifiers/NavigationScreenNotifier.dart';
import 'package:safe_app/screens/statemanagement/notifiers/locationNotifier.dart';
import 'package:safe_app/screens/statemanagement/notifiers/sosStateNotifier.dart';

/// @musabisimwa
///
/// provider.dart contains all providers in the statemanagement system
///
///
///
//providers here
//location
final locationNotifier = StateNotifierProvider<LocationNotifier, Position>(
    (ref) => LocationNotifier());

final navigationNotifier =
    StateNotifierProvider<NavigationDetailsNotifier, NavigationDetails>(
        (ref) => NavigationDetailsNotifier());

final contactsNotifier = StateNotifierProvider<ContactsNotifier, List<Contact>>(
    (ref) => ContactsNotifier());

final sosSignalNotifier = StateNotifierProvider<SOSStateNotifier,SOSSignal>((ref) => SOSStateNotifier());

//todo: camera and mic providers
//todo: settings provider

//end of providers
