// ignore_for_file: prefer_const_constructors

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './locationNotifier.dart';

//final gMapsProvider = StateNotifierProvider<GmapsNotifier, GoogleMapController>(
//    (ref) => GmapsNotifier());

class GmapsNotifier extends StateNotifier<GoogleMapController> {
  late Reader read;
  GmapsNotifier(GoogleMapController controller) : super(controller);

  void init(double lat, double long) {
    state.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, long), // should get current position
          zoom: 15,
        ),
      ),
    );
  }
}

