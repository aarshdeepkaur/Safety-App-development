/// @musabisimwa
// navigation notifier
// placemarks
// polylines
//gmaps controller

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:safe_app/constats.dart';
import 'package:safe_app/services/repositories/google_places_repository.dart';

///
///contains navigation objects that need to update when an action is called for
///dependecies
/// placemarks,polylines,marks :Google map API,google places
/// positionDetails  geocoding and gps
/// autocomplete predictions : google places
class NavigationDetails {
  late List<Placemark> placemarks;
  late Map<String, String> positionDetails;
  late Set<Polyline> polylines;
  late Set<Marker> marks;
  late List<AutocompletePrediction> autocompletePrediction;
  late bool inNavigationMode;
  GoogleMapController? googleMapController;
  NavigationDetails(
      {required this.placemarks,
      required this.positionDetails,
      required this.polylines,
      required this.marks,
      required this.autocompletePrediction,
      required this.inNavigationMode,
      this.googleMapController});

  void addTo(
      {List<Placemark>? placemark,
      Map<String, String>? positionDetail,
      Polyline? polyline,
      Marker? mark,
      List<AutocompletePrediction>? completion,
      GoogleMapController? googlemapcontroller,
      bool? innavigationMode}) {
    if (placemark != null) {
      placemarks = [...placemarks, ...placemark];
    }
    if (positionDetail != null) {
      positionDetails.addAll(positionDetail);
    }
    if (polyline != null) {
      polylines.add(polyline);
    }
    if (mark != null) {
      marks.add(mark);
    }
    if (completion != null) {
      autocompletePrediction = completion;
    }
    if (googlemapcontroller != null) {
      googleMapController = googlemapcontroller;
    }
    if (innavigationMode != null) {
      inNavigationMode = inNavigationMode;
    }
  }
}

/// listens and controll the state of the navigation screen context
/// creates and places placemarks,polylines,pinpoints and predictions in
/// the navigation context
class NavigationDetailsNotifier extends StateNotifier<NavigationDetails> {
  NavigationDetailsNotifier()
      : super(NavigationDetails(
          placemarks: const [],
          autocompletePrediction: [],
          positionDetails: {},
          polylines: {},
          marks: {},
          inNavigationMode: false,
        ));
  //

  // set marker on a map
  void setMarker(LatLng location, String? id) {
    if (id == HOME_MARKER_ID) {
      state.addTo(
          mark: Marker(
              markerId: MarkerId(HOME_MARKER_ID),
              infoWindow: InfoWindow(title: 'home'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure),
              position: location));
    } else {
      state.addTo(
          mark: Marker(
              markerId: MarkerId(DESTINATION_MARKER_ID),
              infoWindow: InfoWindow(title: 'destination'),
              icon: BitmapDescriptor.defaultMarker,
              position: location));
    }
  }

  //draw polylines
  void drawPolylines(List<PointLatLng> points) {
    state.addTo(
        polyline: Polyline(
      polylineId: PolylineId('polyline'),
      width: 3,
      color: Colors.blueAccent,
      points: points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
    ));
  }

  void getAddress({required Position position}) async {
    Map<String, String> _positionDetails = {};
    final placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    _positionDetails['postalCode'] = placemarks[0].postalCode!;
    _positionDetails['address'] = placemarks[0].street!;
    _positionDetails['city'] = placemarks[0].locality!;
    _positionDetails['country'] = placemarks[0].country!;
    state.addTo(placemark: placemarks, positionDetail: _positionDetails);
  }

  void goToPlace(
      {required String place,
      required GoogleMapController googleMapController}) async {
    final gplace = await GooglePlacesRepository().getPlace(place);
    final lat = gplace['geometry']['location']['lat'];
    final long = gplace['geometry']['location']['lng'];
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 13)));
    googleMapController.hideMarkerInfoWindow(MarkerId(DESTINATION_MARKER_ID));
    state.addTo(googlemapcontroller: googleMapController);
  }

  void autoCompleteSearch(
      {required String search, required GooglePlace googleplace}) async {
    final searchRes = await googleplace.autocomplete.get(search);
    if (searchRes != null && searchRes.predictions != null) {
      state.addTo(completion: searchRes.predictions!);
    }
  }

  void setNavigationMode(bool mode) {
    state.addTo(innavigationMode: mode);
  }

  void onMapsCreated(
      {required double lat,
      required double long,
      required GoogleMapController gmapController}) {
    state.addTo(googlemapcontroller: gmapController);
    state.googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, long), // should get current position
          zoom: 15,
        ),
      ),
    );
  }
}
