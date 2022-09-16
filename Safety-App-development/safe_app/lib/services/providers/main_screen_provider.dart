// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:safe_app/constats.dart';
import 'package:safe_app/screens/common/themedHooks.dart';
import 'package:safe_app/services/repositories/google_places_repository.dart';

///
/// authors @musabisimwa
///
/// mainScreen provider
/// purpose: provides data to the main screen widgets
///



Future<List<AutocompletePrediction>> autoCompleteSearch(
    {required String search, required GooglePlace googleplace}) async {
  final searchRes = await googleplace.autocomplete.get(search);
  if (searchRes != null && searchRes.predictions != null) {
    return searchRes.predictions!;
  } else {
    return Future.value(<AutocompletePrediction>[]);
  }
}

// takes the camera to the place
// from get place function in google places repo
//
//

void goToPlace(
    {required String place,
    required GoogleMapController googleMapController}) async {
  final gplace = await GooglePlacesRepository().getPlace(place);
  final lat = gplace['geometry']['location']['lat'];
  final long = gplace['geometry']['location']['lng'];
  googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, long), zoom: 13)));
  googleMapController.hideMarkerInfoWindow(MarkerId(DESTINATION_MARKER_ID));
}







