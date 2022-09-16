// ignore_for_file: prefer_const_constructors

/**
 * 
 * authors @musabisimwa @diri0060
 * 
 * login screen 
 * contains the client login screen with inputs
 * for more information follow the link below
 * link: https://runtime-terror4001.atlassian.net/wiki/spaces/SA/blog/2022/03/16/753665/UI+UX+Design
 * 
 * 
 */
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_app/constats.dart';

/// note to dev: should contain minimal business logic
///

/// note to dev: should contain minimal business logic
///

class LocationProvider {
  /// get current position if user accepts permission to use location sensors
  Future<Position> getCurrentPosition() async {
    bool serviceIsEnabled;
    LocationPermission permission;

    /// if location is already enebled
    serviceIsEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceIsEnabled) {
      // if gps service is not enabled
      //log if err
      //request user to enable gps
      Geolocator.openAppSettings();
    }

    /// if user gives or denies permission to this service
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        //when user denies once or forever return an err
        //show this to the user as a toaster|| notification
        return Future.error('location permission denied');
      }
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
  }

  

//returns a nullable position
  Future<Position?> getLastknownLocation() async {
    return await Geolocator.getLastKnownPosition();
  }

  ///
  /// get live location 2 times a second
  /// os dependent
  /// keeps location alive in background
  Stream<Position> getContinousLocation() {
    late LocationSettings settings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      settings = AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 50,
        forceLocationManager: true,
        foregroundNotificationConfig: ForegroundNotificationConfig(
          notificationTitle: APP_NAME,
          notificationText: '${APP_NAME}is still receiving your location ',
          enableWakeLock: true,
        ),
        intervalDuration: Duration(microseconds: 50), //every 50 msec
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      settings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: true,
      );
    } else {
      settings = LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 50);
    }

    return Geolocator.getPositionStream(locationSettings: settings);
  }
}

class GeocodingProvider {
  late List<Placemark> placement;

  GeocodingProvider() {
    placement = <Placemark>[];
  }

  // get an adress fromlat long

// gets an address and converts it to Location
  /// gets the current position as location
  Future<Map<String, Location>> AddressToCordnates(
      {required Position start,
      required String destination,
      required String localeIdentifier}) async {
    Map<String, Location> coordinates = {};
    final startLoc = Location(
        latitude: start.latitude,
        longitude: start.longitude,
        timestamp: start.timestamp ?? DateTime.now());
    List<Location> destinationLoc = await locationFromAddress(destination,
        localeIdentifier: localeIdentifier);

    coordinates['start'] = startLoc;
    coordinates['destination'] = destinationLoc[0];

    return Future.value(coordinates);
  }
}
